#!/bin/bash
# Start a persistent Gemini dialogue session in tmux
set -euo pipefail

SESSION_DIR="${HOME}/.gemini-partner"
TMUX_SESSION="gemini-dialogue"
TMUX_WINDOW="dialogue"

mkdir -p "$SESSION_DIR"

# Check if session already exists
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    echo "Session already running. Use dialogue-send.sh to continue."
    echo "Or dialogue-end.sh to close it first."
    exit 0
fi

# Create new tmux session with Gemini
INIT_PROMPT="${1:-You are my thinking partner. I'm Hex, an AI running on Claude Sonnet. Help me think through problems by offering alternative perspectives. Keep responses concise.}"

tmux new-session -d -s "$TMUX_SESSION" -n "$TMUX_WINDOW"
tmux send-keys -t "$TMUX_SESSION:$TMUX_WINDOW" "cd $SESSION_DIR && gemini -y -i \"$INIT_PROMPT\"" Enter

# Mark session as active
echo "$(date -Iseconds)" > "$SESSION_DIR/active"
echo "$TMUX_SESSION:$TMUX_WINDOW" > "$SESSION_DIR/tmux-target"
echo "# Dialogue started $(date)" > "$SESSION_DIR/context.txt"
echo "" >> "$SESSION_DIR/context.txt"
echo "INIT: $INIT_PROMPT" >> "$SESSION_DIR/context.txt"

echo "Started Gemini dialogue session."
echo "Target: $TMUX_SESSION:$TMUX_WINDOW"
echo "Use dialogue-send.sh to converse."
