# Agent operating rules

One agent with skills is the default. Rationale: `docs/subagent-playbook.md`.

## Spawn a subagent only for
- **Context bloat**: noisy side work (logs, broad code search, doc fetches) whose raw output the main thread won't reuse.
- **Parallel, independent reading/research**: launch the batch in one message.
- **Isolation or restricted permissions**: e.g. a read-only reviewer that must not see my reasoning or have edit tools.

Never split building work that has to fit together (UI plus assets, API plus caller) across parallel agents. Same for steps that depend on each other or need back-and-forth with the user.

## When delegating
- Restate any rule the subagent needs. It doesn't inherit this file's context, my memory, or the user's style preferences.
- Pass `model: haiku` or `sonnet` for search and triage. Keep the parent model for reasoning-heavy subtasks.
- Ask for a compact result (refs plus conclusions), not dumps.

## Harness hygiene
- When a recurring specialty would otherwise become a new subagent, write a skill instead, unless one of the three reasons above applies.
- Write skill and instruction steps as conditional ("run the full suite when the change touches X"), not "always". Scale checks to the size of the change.
- To prune agents, skills, or this file, use the `harness-audit` skill.
