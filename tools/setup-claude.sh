#!/usr/bin/env bash
# One-time machine setup: symlinks AITools global-claude.md into ~/.claude/
# Run once per machine. After that, any project using @~/.claude/global-claude.md
# will pick up changes from AITools automatically.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/../configs/global-claude.md"
TARGET="$HOME/.claude/global-claude.md"

ln -sf "$SOURCE" "$TARGET"
echo "Linked $TARGET → $SOURCE"
