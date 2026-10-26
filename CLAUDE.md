# Subagent operating rules

Default to one agent. Spawn a subagent only when one of the three conditions below is true and you can name it. Rationale and sources: `docs/subagent-playbook.md`.

## The gate: spawn only for one of these

1. **Context protection.** The side task will produce lots of output (logs, test runs, broad search, doc fetches; roughly >1k tokens) that the main thread will not reference again. Only the conclusion comes back.
2. **True parallelism.** Two or more subtasks are independent: no shared state, no ordering, no back-and-forth. Launch them in one message.
3. **Blackbox verification.** A checker that needs only the output plus explicit success criteria, not the implementation history.

If none applies, do it inline. Specifically, do NOT delegate:
- A lookup whose target you already know (a known file, symbol, or URL). Use Read/Grep directly.
- Anything you could finish in a handful of tool calls.
- Sequential or tightly coupled work: plan, implement, test of the same feature stays in one thread.
- Work split by role (writer / tester / reviewer). Split by context boundary, never by job title.
- "Thoroughness" fan-out on a task one agent can do sequentially. It re-buys context for no gain.

## Cost model to keep in mind

- Subagents start cold: no conversation history, no parent prompt cache. Every file they read is paid for again.
- Multi-agent runs typically cost 3-10x the tokens of single-agent for the same task (Anthropic). Agent teams in plan mode about 7x.
- Every returned summary lands in main context. Ask for compact results.

## Writing the brief (the subagent knows only this)

Every delegation prompt states:
- **Objective** and why it matters.
- **Scope boundaries**: what is in, what is out, what you already ruled out.
- **Where to look**: specific paths, docs, or tools.
- **Output format and size**: e.g. "return file:line refs and a 5-bullet conclusion, under 300 words".
- **Done criteria**: when to stop searching.
- **Rules that must carry over** (style, constraints). Subagents don't inherit output style or memory, and Explore/Plan skip CLAUDE.md.

If you can't write a clear brief, you don't understand the task well enough to delegate it.

## Sizing (effort scaling)

| Task shape | Agents |
|---|---|
| Fact lookup, single-file change, known target | 0 (inline) |
| Broad read-only search across unfamiliar code | 1 Explore, set breadth explicitly |
| Comparing 2-4 independent areas | 2-4 parallel, one per area |
| Large independent research, more than one context window | 3-5 parallel max per wave; separate sessions beyond that |

## Picking the agent and model

- Read-only sweep -> `Explore`. Planning research -> `Plan`. Both are one-shot; use general-purpose if you need to resume.
- Needs edits plus exploration -> general-purpose.
- Grunt work (search, log triage, doc fetch) -> pass a cheaper model (`haiku` or `sonnet`). Reserve the parent's model for reasoning-heavy subtasks.
- Continuing earlier subagent work -> resume it (SendMessage), don't start a fresh one.

## Verification subagents

- Give concrete pass criteria (run the full suite, specific commands, expected outputs) plus negative tests.
- Tell it explicitly not to pass after minimal checking ("early victory" is the main failure mode).
- Give it the artifact and criteria, not your conclusion. An agent handed your hypothesis tends to confirm it.

## Handling results

- Treat returned findings as claims. Spot-check anything you will act on.
- Don't re-run work you delegated; wait for the result.
- Stop when results are sufficient. Don't spawn another wave to be safe.

## Before reaching for subagents, try the single-agent fixes

- Context getting long: `/compact` with focus instructions, or `/clear` between unrelated tasks.
- Too many tools: rely on deferred tool search; disable unused MCP servers.
- Domain knowledge: put it in a skill (loads on demand), not in this file.
- Verbose command output: filter with a hook or pipe through grep/head instead of delegating.
