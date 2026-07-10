def latest: sort_by(.at) | last;

def conventional_title:
  test("^(feat|fix|docs|refactor|perf|test|build|ci|chore|revert)(\\([^)]+\\))?!?: .+");

def is_command($viewer):
  .author == $viewer
  and (.body // "" | test("(^|[\\r\\n])[[:space:]]*@codex[[:space:]]+(review|address)\\b"; "i"));

def is_quota($bot):
  .author == $bot
  and (.body // "" | test("usage limits?.*code reviews?|code-review usage limits?"; "i"));

. as $input
| ($input.head.sha) as $head
| ($input.head.committedAt) as $head_at
| ($input.viewer) as $viewer
| ($input.codexBot) as $bot
| ([
    $input.comments[]?
    | select(is_command($viewer) and .createdAt > $head_at)
    | { id, at: .createdAt, author, body }
  ] | latest) as $command
| ($command.at // $head_at) as $cutoff
| ([
    ($input.reviews[]?
      | select(.author == $bot and .head == $head and .submittedAt > $cutoff)
      | {
          kind: "review",
          id,
          at: .submittedAt,
          favorable: (.body // "" | test("no (major )?issues|no issues found"; "i"))
        }),
    ($input.reactions[]?
      | select(.author == $bot and .content == "+1" and .createdAt > $cutoff)
      | { kind: "thumbs_up", id, at: .createdAt, favorable: true }),
    ($input.comments[]?
      | select(is_quota($bot) and .createdAt > $cutoff)
      | { kind: "quota", id, at: .createdAt, favorable: false })
  ] | latest) as $terminal
| (if $terminal.kind == "quota" then "unavailable"
   elif $terminal.kind == "review" or $terminal.kind == "thumbs_up" then "reviewed"
   elif $command != null then "pending"
   else "missing"
   end) as $lane
| (($input.fallback // null) as $fallback
   | ($fallback != null
      and $fallback.observable == true
      and $fallback.head == $head
      and $fallback.createdAt > $cutoff) as $fresh
   | {
       value: $fallback,
       fresh: $fresh,
       admissible: ($fresh and ($lane == "unavailable" or ($lane == "missing" and $input.policy.comments == "disabled")))
     }) as $fallback
| ([$input.checks[]? | (.bucket // "unknown" | ascii_downcase)]) as $buckets
| (if ($buckets | length) == 0 then "missing"
   elif any($buckets[]; . == "fail" or . == "cancel") then "failed"
   elif any($buckets[]; . == "pending") then "pending"
   elif all($buckets[]; . == "pass" or . == "skipping") then "passed"
   else "unknown"
   end) as $checks_state
| ([$input.threads[]? | select((.isResolved | not) and (.isOutdated | not))] | length) as $unresolved
| ($input.author == $viewer) as $authored
| ($input.expectedHead == $head and $input.collection.headAfter == $head) as $head_stable
| ($input.title | conventional_title) as $title_valid
| (if $terminal.favorable == true then
     { source: (if $terminal.kind == "thumbs_up" then "codex-thumbs-up" else "codex-review" end), verdict: "no-major-issues", at: $terminal.at, admissible: true }
   elif $terminal.kind == "review" then
     { source: "codex-review", verdict: "needs-fix", at: $terminal.at, admissible: false }
   elif $fallback.admissible then
     { source: "fallback", verdict: ($fallback.value.verdict // "inconclusive"), at: $fallback.value.createdAt, admissible: ($fallback.value.verdict == "no-major-issues") }
   else
     { source: "none", verdict: "none", at: null, admissible: false }
   end) as $review
| ([$input.checks[]? | select((.bucket // "unknown" | ascii_downcase) == "fail" or (.bucket // "unknown" | ascii_downcase) == "cancel") | .name]) as $failed_checks
| ([$input.checks[]? | select((.bucket // "unknown" | ascii_downcase) == "pending") | .name]) as $pending_checks
| ([
    if ($authored | not) then "not-authored" else empty end,
    if ($head_stable | not) then "head-changed" else empty end,
    if ($title_valid | not) then "invalid-title" else empty end,
    if $unresolved > 0 then "unresolved-review-threads" else empty end,
    if $input.mergeState != "CLEAN" then ("merge-state-" + ($input.mergeState | ascii_downcase)) else empty end,
    if $checks_state != "passed" then ("checks-" + $checks_state) else empty end,
    if ($review.admissible | not) then
      (if $lane == "pending" then "codex-review-pending"
       elif $lane == "unavailable" then "fallback-review-required"
       elif $lane == "missing" then "review-missing"
       elif $review.verdict == "needs-fix" then "review-needs-fix"
       else "review-not-favorable"
       end)
    else empty end
  ]) as $blockers
| (if ($authored | not) then "ignore"
   elif ($head_stable | not) then "head-changed"
   elif $unresolved > 0 then "fix-feedback"
   elif ($title_valid | not) then "fix-title"
   elif $input.mergeState == "DIRTY" or $input.mergeState == "BEHIND" then "refresh-branch"
   elif $checks_state == "failed" then "repair-checks"
   elif $checks_state != "passed" then "wait-checks"
   elif $input.mergeState != "CLEAN" then "wait-merge-state"
   elif $review.verdict == "needs-fix" then (if $review.source == "fallback" then "fix-fallback" else "wait-review" end)
   elif $lane == "pending" then "wait-review"
   elif ($review.admissible | not) and $lane == "missing" and $input.policy.comments == "allowed" then "request-review"
   elif ($review.admissible | not) and ($lane == "unavailable" or $lane == "missing") then "fallback-review"
   elif ($review.admissible | not) then "wait-review"
   elif $input.draft then "mark-ready"
   elif $input.policy.merge == "allowed" then "merge"
   else "ready-for-human-review"
   end) as $action
| {
    schema: 1,
    repository: $input.repository,
    number: $input.number,
    title: $input.title,
    head: $head,
    expectedHead: $input.expectedHead,
    observedAt: $input.collection.finishedAt,
    headStable: $head_stable,
    authored: $authored,
    draft: $input.draft,
    titleValid: $title_valid,
    mergeState: $input.mergeState,
    policy: $input.policy,
    checks: {
      state: $checks_state,
      total: ($buckets | length),
      failed: $failed_checks,
      pending: $pending_checks
    },
    reviewThreads: { unresolved: $unresolved },
    codexLane: {
      state: $lane,
      command: $command,
      terminal: $terminal
    },
    fallback: {
      present: ($fallback.value != null),
      fresh: $fallback.fresh,
      admissible: $fallback.admissible,
      verdict: ($fallback.value.verdict // null),
      head: ($fallback.value.head // null),
      createdAt: ($fallback.value.createdAt // null),
      observable: ($fallback.value.observable // false)
    },
    reviewEvidence: $review,
    blockers: $blockers,
    ready: ($action == "merge" or $action == "ready-for-human-review"),
    action: $action
  }
