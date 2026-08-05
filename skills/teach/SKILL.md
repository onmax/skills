---
name: teach
description: Builds a stateful teaching workspace with short lessons, trusted sources, retrieval practice, and durable learning records. Use only when the user explicitly asks to learn or be taught a topic over multiple sessions.
disable-model-invocation: true
argument-hint: "What would you like to learn, and why does it matter to you?"
---

# Teach

Treat the current directory as a stateful course. Ground every lesson in the user's mission, current knowledge, and a concrete skill they can practice.

## Workspace

- `MISSION.md` records why the topic matters; use [MISSION-FORMAT.md](MISSION-FORMAT.md).
- `RESOURCES.md` tracks high-trust sources; use [RESOURCES-FORMAT.md](RESOURCES-FORMAT.md).
- `learning-records/NNNN-topic.md` captures durable insights and mission changes; use [LEARNING-RECORD-FORMAT.md](LEARNING-RECORD-FORMAT.md).
- `lessons/NNNN-topic.html` contains one short, self-contained lesson.
- `reference/*.html` contains compact material worth revisiting.
- `assets/` contains reusable styles and interactive components.
- `NOTES.md` records teaching preferences and working notes.

## Loop

1. Read the mission, resources, records, notes, and existing assets. If the mission is missing, ask why the user wants this skill before writing a lesson.
2. Choose one outcome in the user's zone of proximal development: useful now, slightly difficult, and small enough for one session.
3. Ground factual claims in current, high-trust sources. Update `RESOURCES.md`; do not rely on parametric memory for contested or changing facts.
4. Write one brief HTML lesson that teaches only the knowledge needed for the skill, then exercises it through retrieval or real practice with immediate feedback.
5. Reuse shared assets. Add a component only when a second lesson could use it.
6. Update the learning record with demonstrated understanding, misconceptions, and the next useful challenge. Confirm before changing the mission.

Use spacing, retrieval practice, and interleaving to build retention. Keep answer choices structurally neutral so formatting does not reveal the answer. Recommend real communities or practitioners only when lived feedback would materially improve learning and the user is open to it.

Return the lesson path, the skill practiced, the evidence of learning captured, and the next suggested lesson.
