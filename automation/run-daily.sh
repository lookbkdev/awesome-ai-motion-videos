#!/bin/bash
# Runs the daily collection with Claude Code. Installed by automation/install.sh.
#
# If the Claude run fails there is no second engine for this job: it needs web search, git push and gh issue under a
# per-command allowlist. The failure is written as one line to ../logs/llm-fallback.log (override: LOOKBK_FALLBACK_LOG)
# so it gets noticed, and the script exits non-zero as before.
#   LOOKBK_CLAUDE_BIN (or the older CLAUDE_BIN) picks the claude binary; default: claude.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p automation/logs automation/tmp
log="automation/logs/$(date +%F).log"
claude_bin="${LOOKBK_CLAUDE_BIN:-${CLAUDE_BIN:-claude}}"
fallback_log="${LOOKBK_FALLBACK_LOG:-$(pwd)/../logs/llm-fallback.log}"

# One line: <UTC time> | awesome/daily | claude -> no fallback | reason: <first 120 chars, single line>
note_no_fallback() {
  local reason
  reason=$(printf '%s' "$1" | tr '\r\n\t' '   ' | sed -e 's/  */ /g' -e 's/^ //' -e 's/ $//' | cut -c1-120)
  mkdir -p "$(dirname "$fallback_log")" || return 0
  printf '%s | awesome/daily | claude -> no fallback | reason: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${reason:-(no reason given)}" >>"$fallback_log" || true
}

run_out="automation/tmp/claude-run.$$.out"
status=0
{
  echo "== $(date)"
  git pull --ff-only --quiet
  set +e
  "$claude_bin" -p "$(cat automation/daily.md)" --model sonnet \
    --allowedTools "WebSearch" "WebFetch" "Read" "Write" "Edit" "Glob" "Grep" \
      "Bash(curl -s https://api.fxtwitter.com/*)" "Bash(node scripts/add.mjs:*)" "Bash(node scripts/build.mjs)" \
      "Bash(git add:*)" "Bash(git commit:*)" "Bash(git push)" "Bash(git status)" "Bash(git diff:*)" \
      "Bash(gh issue list:*)" "Bash(gh issue view:*)" "Bash(gh issue close:*)" "Bash(gh issue comment:*)" 2>&1 | tee "$run_out"
  status=${PIPESTATUS[0]}
  set -e
  if [ "$status" -ne 0 ]; then
    said=$(tail -c 400 "$run_out")
    note_no_fallback "exit $status: ${said:-(claude printed nothing)}"
    echo "claude failed (exit $status); no fallback for this job, noted in $fallback_log"
  elif [ ! -s "$run_out" ]; then
    status=1
    note_no_fallback "exit 0 but claude printed nothing"
    echo "claude printed nothing; treated as failed, noted in $fallback_log"
  fi
  rm -f "$run_out"
} >>"$log" 2>&1
exit "$status"
