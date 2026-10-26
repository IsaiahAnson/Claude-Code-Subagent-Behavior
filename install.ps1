# Installs the subagent rules, harness-audit skill, and verifier agent into ~/.claude.
# Existing files are backed up, never overwritten silently. Safe to re-run.
# Works on Windows PowerShell 5.1 and PowerShell 7+.
$ErrorActionPreference = 'Stop'

$src = $PSScriptRoot
$dest = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE '.claude' }
$stamp = Get-Date -Format 'yyyyMMddHHmmss'
$markerStart = '<!-- subagent-rules:start -->'
$markerEnd = '<!-- subagent-rules:end -->'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

New-Item -ItemType Directory -Force -Path (Join-Path $dest 'agents'), (Join-Path $dest 'skills') | Out-Null

# Backups go outside agents\ and skills\ so Claude Code doesn't load them as duplicates.
$backupDir = Join-Path $dest "backups\subagent-rules-$stamp"
function Backup-Item([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return }
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    Copy-Item -LiteralPath $path -Destination $backupDir -Recurse -Force
    Write-Host "backed up $path to $backupDir"
}

# CLAUDE.md: replace our block if present, otherwise append it. Other content is untouched.
$playbook = Join-Path $src 'docs\subagent-playbook.md'
$rules = [IO.File]::ReadAllText((Join-Path $src 'CLAUDE.md')).Replace('`docs/subagent-playbook.md`', "``$playbook``")
$block = "$markerStart`n$($rules.TrimEnd())`n$markerEnd"

$claudeMd = Join-Path $dest 'CLAUDE.md'
if (Test-Path -LiteralPath $claudeMd) {
    Backup-Item $claudeMd
    $existing = [IO.File]::ReadAllText($claudeMd)
    $start = $existing.IndexOf($markerStart)
    $end = $existing.IndexOf($markerEnd)
    if ($start -ge 0 -and $end -gt $start) {
        $new = $existing.Substring(0, $start) + $block + $existing.Substring($end + $markerEnd.Length)
    } else {
        $new = $existing.TrimEnd() + "`n`n" + $block + "`n"
    }
} else {
    $new = $block + "`n"
}
[IO.File]::WriteAllText($claudeMd, $new, $utf8NoBom)
Write-Host "installed rules into $claudeMd"

$agent = Join-Path $dest 'agents\verifier.md'
Backup-Item $agent
Copy-Item -LiteralPath (Join-Path $src '.claude\agents\verifier.md') -Destination $agent -Force

$skill = Join-Path $dest 'skills\harness-audit'
Backup-Item $skill
if (Test-Path -LiteralPath $skill) { Remove-Item -LiteralPath $skill -Recurse -Force }
Copy-Item -LiteralPath (Join-Path $src '.claude\skills\harness-audit') -Destination $skill -Recurse

Write-Host "installed verifier agent and harness-audit skill into $dest"
