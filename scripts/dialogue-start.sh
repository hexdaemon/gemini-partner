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
INIT_PROMPT="${1:-You are my thinking partner. I am Hex, an AI running on Claude Sonnet. Help me think through problems by offering alternative perspectives. Keep responses concise.}"

tmux new-session -d -s "$TMUX_SESSION" -n "$TMUX_WINDOW"
# Write prompt to file to avoid shell quoting issues
echo "$INIT_PROMPT" > "$SESSION_DIR/init_prompt.txt"
tmux send-keys -t "$TMUX_SESSION:$TMUX_WINDOW" "cd $SESSION_DIR && gemini -y -i \"\$(cat init_prompt.txt)\"" Enter

# Wait for Gemini to be ready (look for the input prompt)
echo "Waiting for Gemini to start..."
for i in $(seq 1 60); do
    sleep 1
    if tmux capture-pane -p -t "$TMUX_SESSION:$TMUX_WINDOW" 2>/dev/null | grep -q "Type your message"; then
        echo "Gemini ready."
        break
    fi
done

# Mark session as active
echo "$(date -Iseconds)" > "$SESSION_DIR/active"
echo "$TMUX_SESSION:$TMUX_WINDOW" > "$SESSION_DIR/tmux-target"
echo "# Dialogue started $(date)" > "$SESSION_DIR/context.txt"
echo "" >> "$SESSION_DIR/context.txt"
echo "INIT: $INIT_PROMPT" >> "$SESSION_DIR/context.txt"

echo "Started Gemini dialogue session."
echo "Target: $TMUX_SESSION:$TMUX_WINDOW"
echo "Use dialogue-send.sh to converse."
