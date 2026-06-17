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

# 1. .agent/global-claude.md — always overwrite (pure upstream content)
mkdir -p .agent
curl -fsSL "$BASE/.agent/global-claude.md" -o .agent/global-claude.md
echo "Updated .agent/global-claude.md"

# 2. AGENTS.md — marker-based merge
#    Replaces content between <!-- sync:start --> and <!-- sync:end --> markers.
#    Everything outside the markers is preserved.
AGENTS_TMP=$(mktemp)
curl -fsSL "$BASE/AGENTS.md" -o "$AGENTS_TMP"

if [ ! -f AGENTS.md ]; then
  cp "$AGENTS_TMP" AGENTS.md
  echo "Created AGENTS.md"
elif ! grep -q '<!-- sync:start' AGENTS.md; then
  # No markers — prepend the full upstream block to existing content
  MERGED=$(mktemp)
  cat "$AGENTS_TMP" > "$MERGED"
  printf '\n' >> "$MERGED"
  cat AGENTS.md >> "$MERGED"
  mv "$MERGED" AGENTS.md
  echo "Updated AGENTS.md (prepended sync block — no prior markers found)"
else
  # Replace sync block, preserve content outside markers
  BEFORE=$(awk '/<!-- sync:start/{exit} {print}' AGENTS.md)
  AFTER=$(awk 'found{print} /<!-- sync:end/{found=1}' AGENTS.md)
  MERGED=$(mktemp)
  [ -n "$BEFORE" ] && printf '%s\n' "$BEFORE" >> "$MERGED"
  cat "$AGENTS_TMP" >> "$MERGED"
  [ -n "$AFTER" ] && printf '\n%s\n' "$AFTER" >> "$MERGED"
  mv "$MERGED" AGENTS.md
  echo "Updated AGENTS.md (merged sync block)"
fi
rm -f "$AGENTS_TMP"

# 3. CLAUDE.md — surgical import update, existing content preserved
if [ ! -f CLAUDE.md ]; then
  printf '@.agent/global-claude.md\n' > CLAUDE.md
  echo "Created CLAUDE.md"
elif grep -q '@.agent/global-claude.md' CLAUDE.md; then
  echo "CLAUDE.md unchanged"
elif grep -q '@~/.claude/global-claude.md' CLAUDE.md; then
  sed -i.bak 's|@~/.claude/global-claude.md|@.agent/global-claude.md|g' CLAUDE.md && rm -f CLAUDE.md.bak
  echo "Updated CLAUDE.md import"
else
  MERGED=$(mktemp)
  printf '@.agent/global-claude.md\n\n---\n\n' > "$MERGED"
  cat CLAUDE.md >> "$MERGED"
  mv "$MERGED" CLAUDE.md
  echo "Prepended import to CLAUDE.md"
fi

# 4. Install global Claude Code commands into ~/.claude/commands/
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"
for cmd in sync-ai-config update-global-config; do
  curl -fsSL "$BASE/.claude/commands/${cmd}.md" -o "$COMMANDS_DIR/${cmd}.md"
  echo "Installed /${cmd} → $COMMANDS_DIR/${cmd}.md"
done

# 5. Wire up ~/.claude/global-claude.md and add to ~/.claude/CLAUDE.md
curl -fsSL "$BASE/.agent/global-claude.md" -o "$HOME/.claude/global-claude.md"
echo "Updated ~/.claude/global-claude.md"

GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"
if [ ! -f "$GLOBAL_CLAUDE" ]; then
  printf '@global-claude.md\n' > "$GLOBAL_CLAUDE"
  echo "Created $GLOBAL_CLAUDE with @global-claude.md"
elif ! grep -q '@global-claude.md' "$GLOBAL_CLAUDE"; then
  printf '\n@global-claude.md\n' >> "$GLOBAL_CLAUDE"
  echo "Added @global-claude.md to $GLOBAL_CLAUDE"
else
  echo "$GLOBAL_CLAUDE already includes @global-claude.md"
fi

# 6. Commit if inside a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
  git add .agent/global-claude.md AGENTS.md CLAUDE.md 2>/dev/null || true
  if git diff --cached --quiet; then
    echo "Already up to date — nothing to commit."
  else
    git commit -m "chore: sync AI config from longieirl/ai-tools"
    echo "Committed."
  fi
fi
