# Claude-Code-Subagent-Management

Subagent operating rules for Claude Code, based on Anthropic's published guidance.

- `CLAUDE.md`: the rules Claude follows in this repo. Copy to `~/.claude/CLAUDE.md` to apply them everywhere.
- `docs/subagent-playbook.md`: rationale and sources.
- `.claude/agents/verifier.md`: read-only verification subagent (kept for isolation and restricted tools).
- `.claude/skills/harness-audit/`: procedure to fold subagents into skills and prune the harness.

## Install globally

Windows (PowerShell):

```powershell
git clone https://github.com/IsaiahAnson/Claude-Code-Subagent-Management $HOME\src\Claude-Code-Subagent-Management
powershell -ExecutionPolicy Bypass -File $HOME\src\Claude-Code-Subagent-Management\install.ps1
```

macOS / Linux:

```bash
git clone https://github.com/IsaiahAnson/Claude-Code-Subagent-Management ~/src/Claude-Code-Subagent-Management
~/src/Claude-Code-Subagent-Management/install.sh
```

Appends the rules to `~/.claude/CLAUDE.md` inside marker comments (re-running replaces only that block) and installs the skill and agent. Prior versions go to `~/.claude/backups/subagent-rules-<timestamp>/`.
