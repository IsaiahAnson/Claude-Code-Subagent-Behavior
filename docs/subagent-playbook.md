# Subagent playbook: rationale and sources

`CLAUDE.md` holds the operative rules, kept deliberately short. `.claude/skills/harness-audit/` holds the fold/prune procedure, loaded only when needed. This file explains where both come from.

## Primary input: Switch Dimension video (YouTube `KwmrSON2n-g`)

Rob (Switch Dimension) on Anthropic Applied AI's Oct 22, 2026 guidance. Summary of claims:

- **Fold subagents into one agent with skills.** Anthropic saw one agent plus skills frequently beat both a giant prompt and a subagent team on quality, cost, and speed. One customer's single loop ran about 2x faster than its multi-agent setup.
- **Why subagent sprawl happens.** Teams build agent rosters that copy the org chart (Conway's law). Every handoff loses detail, and every added agent bloats the system prompt (the "Franken-prompt").
- **The fix is progressive disclosure.** Expose short descriptions and load the full skill or tool on demand. This is a large part of how Claude Code's system prompt was cut by more than 80% for stronger models. It applies to stronger models only.
- **Why now.** Much of the scaffolding was built for models from about 6 months ago. Add complexity only when it demonstrably improves outcomes. From Jediah Katz's "flywheel": log every temporary guardrail ("shim"), then delete shims that stop firing. A subagent is one kind of shim.
- **How to fold.**
  - Start with subagents that chain on each other's output or touch the same data.
  - Keep subagents that exist because of restricted tools.
  - Baseline with 10 prompts run twice each. The subagent prompt becomes a SKILL.md body. Move the old file aside and re-run.
  - Keep the subagent only if the folded version scores worse.
- **Where subagents still earn their place.**
  - Context bloat.
  - One agent keeps picking the wrong tools. Split by context, not org chart.
  - Parallel research. Anthropic's research system beat single-agent Opus by about 90% on internal evals, at much higher token cost.
  - Codebase search, noisy side tasks such as logs, and read-only reviewers.
- **Where they don't.** Building interdependent pieces. Cognition example: parallel agents built a background and a bird that didn't match. Also dependent steps and back-and-forth with the user.
- **Cull the harness too.**
  - Every skill description and CLAUDE.md/AGENTS.md line costs context every turn.
  - Skills can turn checklists into mandatory busywork. Cited Microsoft Research paper: "always run the full suite" fires even on one-line changes.
  - Use `/skill-doctor` to find skills that never fire.
  - For each CLAUDE.md line, ask whether the current model would do it anyway.
- **Counterpoints.**
  - Harnesses outside coding (e.g. Grokbot's coordinator and workers) are adding guardrails back.
  - Cited July paper: cutting skills by up to 54% didn't reliably lower cost per task, because cached text is cheap.
  - Anthropic's guidance has no pass rates or sample sizes, so test on your own setup.

Verification status: the Oct 22 article, the 2x runtime figure, and the 80% prompt cut match the Anthropic article directly. The Microsoft Research paper, the July paper, and the Katz talk are cited by the video and were not independently checked.

## How the repo applies it

| Video / Anthropic point | Applied as |
|---|---|
| One agent + skills by default | CLAUDE.md opening line; spawn only for 3 reasons |
| Keep subagents for isolation / restricted tools | Third spawn reason; `verifier` kept (read-only tools, unanchored review) |
| Don't parallelize interdependent building | Explicit "never split" rule |
| Cull CLAUDE.md lines the model would follow anyway | CLAUDE.md cut from ~75 lines to ~20; generic delegation advice removed |
| Progressive disclosure | Fold/prune procedure lives in a skill, not CLAUDE.md |
| Skills cause busywork when mandatory | Rule: write steps as conditional, scale to change size |
| Fold procedure, shims, `/skill-doctor` | `harness-audit` skill |
| Trimming may not cut cost | Stated as a caveat in the audit report |

## Supporting Anthropic sources

- **Jun 2025, multi-agent research system.** About 15x the tokens of chat. Poor fit for coding work that needs shared context.
- **Jan 2026, "When to use multi-agent systems".** Three cases: context protection, parallelism, specialization. 3-10x tokens. Anti-patterns: role splits, the telephone game.
- **Oct 22, 2026, "When to fold subagents into your main agent loop".** The article the video covers.
- **Claude Code docs.** Subagents don't inherit conversation history, output style, or memory, and Explore/Plan skip CLAUDE.md. Pass cheaper models for grunt work.

Links:
- https://www.youtube.com/watch?v=KwmrSON2n-g
- https://claude.com/resources/articles/building-agents-when-to-fold-subagents-into-your-main-agent-loop
- https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them
- https://www.anthropic.com/engineering/multi-agent-research-system
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/costs
