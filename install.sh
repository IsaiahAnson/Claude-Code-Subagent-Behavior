#!/usr/bin/env bash
# Installs the subagent rules, harness-audit skill, and verifier agent into ~/.claude.
# Existing files are backed up, never overwritten silently. Safe to re-run.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
stamp="$(date +%Y%m%d%H%M%S)"
marker_start="<!-- subagent-rules:start -->"
marker_end="<!-- subagent-rules:end -->"

mkdir -p "$dest/agents" "$dest/skills"

# Backups go outside agents/ and skills/ so Claude Code doesn't load them as duplicates.
backup_dir="$dest/backups/subagent-rules-$stamp"
backup() {
  [ -e "$1" ] || return 0
  mkdir -p "$backup_dir"
  cp -R "$1" "$backup_dir/" && echo "backed up $1 to $backup_dir"
}

# CLAUDE.md: replace our block if present, otherwise append it. Other content is untouched.
claude_md="$dest/CLAUDE.md"
block="$(printf '%s\n%s\n%s\n' "$marker_start" "$(cat "$src/CLAUDE.md")" "$marker_end")"
if [ -f "$claude_md" ]; then
  backup "$claude_md"
  if grep -qF "$marker_start" "$claude_md"; then
    BLOCK="$block" awk -v s="$marker_start" -v e="$marker_end" '
      $0==s {print ENVIRON["BLOCK"]; skip=1; next}
      $0==e {skip=0; next}
      !skip {print}' "$claude_md" > "$claude_md.tmp" && mv "$claude_md.tmp" "$claude_md"
  else
    printf '\n%s\n' "$block" >> "$claude_md"
  fi
else
  printf '%s\n' "$block" > "$claude_md"
fi
echo "installed rules into $claude_md"

# The playbook path in CLAUDE.md is repo-relative; point it at this checkout.
sed -i.tmp "s#\`docs/subagent-playbook.md\`#\`$src/docs/subagent-playbook.md\`#" "$claude_md" && rm -f "$claude_md.tmp"

backup "$dest/agents/verifier.md"
cp "$src/.claude/agents/verifier.md" "$dest/agents/verifier.md"

backup "$dest/skills/harness-audit"
rm -rf "$dest/skills/harness-audit"
cp -R "$src/.claude/skills/harness-audit" "$dest/skills/harness-audit"

echo "installed verifier agent and harness-audit skill into $dest"
