#!/usr/bin/env bash
# One-time machine setup: symlinks AITools config into ~/.claude/
# Run once per machine. Installs:
#   - @~/.claude/global-claude.md  (behavioral guidelines, auto-syncs on git pull)
#   - /sync-ai-config command       (updates any project's AI config from this repo)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE="$SCRIPT_DIR/../.agent/global-claude.md"
TARGET="$HOME/.claude/global-claude.md"
ln -sf "$SOURCE" "$TARGET"
echo "Linked $TARGET → $SOURCE"

# Wire up global-claude.md in ~/.claude/CLAUDE.md if not already present
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

COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"
ln -sf "$SCRIPT_DIR/../.claude/commands/sync-ai-config.md" "$COMMANDS_DIR/sync-ai-config.md"
echo "Installed /sync-ai-config → $COMMANDS_DIR/sync-ai-config.md"
ln -sf "$SCRIPT_DIR/../.claude/commands/update-global-config.md" "$COMMANDS_DIR/update-global-config.md"
echo "Installed /update-global-config → $COMMANDS_DIR/update-global-config.md"
