#!/bin/bash
# Install Claude config by symlinking to ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Claude config from: $SCRIPT_DIR"

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Backup existing CLAUDE.md if it exists and is not a symlink
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    BACKUP="$CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing CLAUDE.md to: $BACKUP"
    mv "$CLAUDE_DIR/CLAUDE.md" "$BACKUP"
fi

# Remove existing symlink if present
[ -L "$CLAUDE_DIR/CLAUDE.md" ] && rm "$CLAUDE_DIR/CLAUDE.md"

# Create symlink
ln -sf "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "Linked: CLAUDE.md -> $SCRIPT_DIR/CLAUDE.md"

echo "Done."
