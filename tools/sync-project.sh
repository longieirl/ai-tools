#!/usr/bin/env bash
# Sync AI config from longieirl/ai-tools into the current project.
# Pulls directly from GitHub — no local AITools clone required.
#
# Usage (from project root):
#   bash tools/sync-project.sh
#
# Or run remotely without cloning:
#   curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/tools/sync-project.sh | bash

set -euo pipefail

BASE="https://raw.githubusercontent.com/longieirl/ai-tools/main"

# 1. Fetch and write .agent/global-claude.md
mkdir -p .agent
curl -fsSL "$BASE/.agent/global-claude.md" -o .agent/global-claude.md
echo "Updated .agent/global-claude.md"

# 2. Fetch and write AGENTS.md
curl -fsSL "$BASE/AGENTS.md" -o AGENTS.md
echo "Updated AGENTS.md"

# 3. Handle CLAUDE.md
if [ ! -f CLAUDE.md ]; then
  printf '@.agent/global-claude.md\n' > CLAUDE.md
  echo "Created CLAUDE.md"
elif grep -q '@.agent/global-claude.md' CLAUDE.md; then
  echo "CLAUDE.md unchanged"
elif grep -q '@~/.claude/global-claude.md' CLAUDE.md; then
  sed -i.bak 's|@~/.claude/global-claude.md|@.agent/global-claude.md|g' CLAUDE.md && rm -f CLAUDE.md.bak
  echo "Updated CLAUDE.md import"
else
  tmp=$(mktemp)
  printf '@.agent/global-claude.md\n\n---\n\n' > "$tmp"
  cat CLAUDE.md >> "$tmp"
  mv "$tmp" CLAUDE.md
  echo "Prepended import to CLAUDE.md"
fi

# 4. Commit if inside a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
  git add .agent/global-claude.md AGENTS.md CLAUDE.md 2>/dev/null || true
  if git diff --cached --quiet; then
    echo "Already up to date — nothing to commit."
  else
    git commit -m "chore: sync AI config from longieirl/ai-tools"
    echo "Committed."
  fi
fi
