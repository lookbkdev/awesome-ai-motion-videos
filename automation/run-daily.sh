#!/bin/bash
# Runs the daily collection with Claude Code. Installed by automation/install.sh.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p automation/logs automation/tmp
log="automation/logs/$(date +%F).log"
{
  echo "== $(date)"
  git pull --ff-only --quiet
  "${CLAUDE_BIN:-claude}" -p "$(cat automation/daily.md)" --model sonnet \
    --allowedTools "WebSearch" "WebFetch" "Read" "Write" "Edit" "Glob" "Grep" \
      "Bash(curl -s https://api.fxtwitter.com/*)" "Bash(node scripts/add.mjs:*)" "Bash(node scripts/build.mjs)" \
      "Bash(git add:*)" "Bash(git commit:*)" "Bash(git push)" "Bash(git status)" "Bash(git diff:*)" \
      "Bash(gh issue list:*)" "Bash(gh issue view:*)" "Bash(gh issue close:*)" "Bash(gh issue comment:*)"
} >>"$log" 2>&1
