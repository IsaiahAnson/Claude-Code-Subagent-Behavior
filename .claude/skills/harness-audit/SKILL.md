---
name: harness-audit
description: Prune or fold subagents, skills, and CLAUDE.md lines that the current model no longer needs. Use when the user asks to audit, slim, or clean up their agent harness, or after a model upgrade.
---

# Harness audit

Goal: shrink the harness as the model improves, keeping only what measurably helps.

## Subagents: fold one at a time

1. **Pick candidates.** Start with subagents that chain on each other's output, touch the same data, or get called together. Skip any that exist for restricted tools/permissions or isolation; those stay.
2. **Baseline.** Write ~10 varied prompts that should trigger the subagent. Run each twice in fresh sessions. Record: was the right subagent invoked, and did the output pass.
3. **Fold.** Create `.claude/skills/<name>/SKILL.md`: the subagent's system prompt becomes the body; rewrite `description` as what it does + when to use it.
4. **Move the old agent file aside** (e.g. `.claude/agents-disabled/`), don't delete.
5. **Re-run** the same prompts twice each in fresh sessions. Record: right skill invoked, pass rate.
6. **Decide.** Keep the subagent only if the folded version scores worse. Otherwise delete the moved-aside file.

Report a table: agent, baseline invoke/pass, folded invoke/pass, decision.

## Skills

- Run `/skill-doctor` to find skills that never fire; propose removing them.
- Flag steps written as mandatory ("always run X") that would be overkill on small changes; rewrite as conditional.

## CLAUDE.md / AGENTS.md

For each line ask: would the current model do this anyway without being told? If yes, propose cutting it. Keep lines that encode project facts or preferences the model can't infer.

## Guardrails (shims)

For hooks or rules added to correct a model behavior, check whether they still fire (hook logs, transcripts). Propose removing ones that haven't fired recently.

## Caveats to state in the report

- Trimming doesn't guarantee lower cost: stable skill/CLAUDE.md text is mostly read from prompt cache.
- Outside coding, models may still need guardrails; don't cut those without eval evidence.
- Two runs per prompt is a minimum; one-off passes or failures are noise.
