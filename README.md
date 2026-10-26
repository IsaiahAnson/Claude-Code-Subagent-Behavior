# Claude-Code-Subagent-Management

Subagent operating rules for Claude Code, based on Anthropic's published guidance.

- `CLAUDE.md`: the rules Claude follows in this repo. Copy to `~/.claude/CLAUDE.md` to apply them everywhere.
- `docs/subagent-playbook.md`: rationale and sources.
- `.claude/agents/verifier.md`: read-only verification subagent (kept for isolation and restricted tools).
- `.claude/skills/harness-audit/`: procedure to fold subagents into skills and prune the harness.
