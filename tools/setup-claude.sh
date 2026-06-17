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

COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"
ln -sf "$SCRIPT_DIR/../.claude/commands/sync-ai-config.md" "$COMMANDS_DIR/sync-ai-config.md"
echo "Installed /sync-ai-config → $COMMANDS_DIR/sync-ai-config.md"
