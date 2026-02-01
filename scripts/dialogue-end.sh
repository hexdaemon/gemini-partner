#!/bin/bash
# End the Gemini dialogue session and save summary
set -euo pipefail

SESSION_DIR="${HOME}/.gemini-partner"
ARCHIVE_DIR="${SESSION_DIR}/archive"

mkdir -p "$ARCHIVE_DIR"

if [[ ! -f "$SESSION_DIR/active" ]]; then
    echo "No active dialogue session."
    exit 0
fi

TARGET=$(cat "$SESSION_DIR/tmux-target" 2>/dev/null || echo "")

# Archive the context
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
if [[ -f "$SESSION_DIR/context.txt" ]]; then
    cp "$SESSION_DIR/context.txt" "$ARCHIVE_DIR/dialogue_$TIMESTAMP.txt"
    echo "Archived to: $ARCHIVE_DIR/dialogue_$TIMESTAMP.txt"
fi

# Kill the tmux session
if [[ -n "$TARGET" ]]; then
    SESSION_NAME="${TARGET%%:*}"
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
fi

# Clean up
rm -f "$SESSION_DIR/active" "$SESSION_DIR/tmux-target"

echo "Dialogue session ended."
