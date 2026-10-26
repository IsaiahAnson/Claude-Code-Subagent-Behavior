# Subagent playbook: rationale and sources

`CLAUDE.md` holds the operative rules. This file explains where they come from so they can be revised when Anthropic's guidance changes.

## Source status

The originating request was to learn from YouTube video `KwmrSON2n-g`. Its transcript could not be retrieved: the build environment's network policy blocks youtube.com. The rules here are built from Anthropic's own published material instead (listed below). Once the transcript is available, diff its claims against this file and update `CLAUDE.md` where they differ.

## The direction of travel (late 2026)

Anthropic's guidance has moved toward **fewer subagents, not more**:

- **Jun 2025, multi-agent research system.** Multi-agent beat single-agent by 90.2% on breadth-first research, at ~15x the tokens of chat (single agents ~4x). Token spend explained ~80% of performance variance. Explicitly called a poor fit for most coding work, where agents need shared context.
- **Jan 2026, "When to use multi-agent systems (and when not to)".** Three winning cases only: context protection, parallelization, specialization. Multi-agent typically costs 3-10x tokens. Anti-patterns: splitting by role, the "telephone game", splitting coupled work, premature complexity. Endorses blackbox verification subagents.
- **Oct 2026, "When to fold subagents into your main agent loop".** Enterprise agents performed better, cheaper and faster after folding subagents back into one loop with progressive disclosure (skills, deferred tool search). One customer saw ~2x faster runtime. Keep subagents only for measured context bloat, parallel work with discardable context, or tool-selection/prompt-conflict problems. Split by context, not by team.

Net: subagents are a context-management and parallelism tool, not an organizational pattern.

## How each rule maps to a source

| Rule in CLAUDE.md | Source |
|---|---|
| Default to one agent; three-condition gate | Jan 2026 blog; Oct 2026 article |
| Don't split by role / coupled work | Jan 2026 blog (anti-patterns) |
| Subagents start cold, cost multipliers | Claude Code costs docs; Jan 2026 blog |
| Brief must include objective, format, tools, boundaries | Jun 2025 research system post |
| Effort scaling table | Jun 2025 research system post (1 agent / 2-4 / 10+); capped at 3-5 per wave for Claude Code because of shared usage limits |
| Cheaper model for grunt work | Claude Code sub-agents and costs docs |
| Verifier with concrete criteria, avoid early victory | Jan 2026 blog |
| Restate rules in the brief | Sub-agents docs: subagents don't inherit output style or memory; Explore/Plan skip CLAUDE.md |
| Try compaction, skills, tool search, hooks first | Costs docs; Jan 2026 blog; Oct 2026 article |

## Mechanics worth remembering

- Built-ins: Explore (read-only, one-shot, skips CLAUDE.md), Plan (read-only, one-shot), general-purpose (all tools, resumable).
- Model resolution: per-call `model` > definition `model` > `CLAUDE_CODE_SUBAGENT_MODEL` > parent model.
- Limits: nesting depth 3, 20 concurrent by default.
- `/usage` on subscription plans attributes usage to subagents; check it if spend climbs.
- Keep custom agent `description` fields short; they are always in context. Detail goes in the body.

## Sources

- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/costs
- https://www.anthropic.com/engineering/multi-agent-research-system
- https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them
- https://claude.com/resources/articles/building-agents-when-to-fold-subagents-into-your-main-agent-loop
