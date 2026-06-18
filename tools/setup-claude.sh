#!/usr/bin/env bash
# One-time machine setup: installs AI tools config and commands into ~/.claude/
# No git clone required.
#
# Run remotely:
#   curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/tools/setup-claude.sh | bash
#
# Or locally if you have the repo:
#   bash tools/setup-claude.sh

set -euo pipefail

BASE="https://raw.githubusercontent.com/longieirl/ai-tools/main"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
mkdir -p "$COMMANDS_DIR"

# Install global commands
for cmd in sync-ai-config update-global-config github-repo-lockdown setup-dead-weight-audit; do
  curl -fsSL "$BASE/.claude/commands/${cmd}.md" -o "$COMMANDS_DIR/${cmd}.md"
  echo "Installed /${cmd} → $COMMANDS_DIR/${cmd}.md"
done

# Install global-claude.md
curl -fsSL "$BASE/.agent/global-claude.md" -o "$CLAUDE_DIR/global-claude.md"
echo "Installed ~/.claude/global-claude.md"

# Wire global-claude.md into ~/.claude/CLAUDE.md if not already present
GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
if [ ! -f "$GLOBAL_CLAUDE" ]; then
  printf '@global-claude.md\n' > "$GLOBAL_CLAUDE"
  echo "Created $GLOBAL_CLAUDE with @global-claude.md"
elif ! grep -q '@global-claude.md' "$GLOBAL_CLAUDE"; then
  printf '\n@global-claude.md\n' >> "$GLOBAL_CLAUDE"
  echo "Added @global-claude.md to $GLOBAL_CLAUDE"
else
  echo "$GLOBAL_CLAUDE already includes @global-claude.md"
fi

echo ""
echo "Done. Commands available in any Claude Code project:"
echo "  /sync-ai-config           — sync project AI config from longieirl/ai-tools"
echo "  /update-global-config     — update global behavioral guidelines"
echo "  /github-repo-lockdown     — lock down a public GitHub repo"
echo "  /setup-dead-weight-audit  — audit Claude setup files for dead-weight"
