#!/bin/bash
# Send a message to the persistent Gemini dialogue session
set -euo pipefail

SESSION_DIR="${HOME}/.gemini-partner"
TIMEOUT="${GEMINI_TIMEOUT:-90}"

if [[ $# -eq 0 ]]; then
    echo "Usage: dialogue-send.sh <message>"
    exit 1
fi

MESSAGE="$*"

# Check if session is active
if [[ ! -f "$SESSION_DIR/active" ]]; then
    echo "No active dialogue. Run dialogue-start.sh first."
    exit 1
fi

TARGET=$(cat "$SESSION_DIR/tmux-target")

# Capture pane state before sending
BEFORE_LINES=$(tmux capture-pane -p -t "$TARGET" -S -500 | wc -l)

# Send the message
tmux send-keys -t "$TARGET" "$MESSAGE" Enter

# Log to context
echo "" >> "$SESSION_DIR/context.txt"
echo "ME: $MESSAGE" >> "$SESSION_DIR/context.txt"

# Wait for response (poll until output stabilizes or timeout)
STABLE_COUNT=0
LAST_LINES=0

for i in $(seq 1 $TIMEOUT); do
    sleep 1
    CURRENT_LINES=$(tmux capture-pane -p -t "$TARGET" -S -500 | wc -l)
    
    if [[ "$CURRENT_LINES" -eq "$LAST_LINES" && "$CURRENT_LINES" -gt "$BEFORE_LINES" ]]; then
        ((STABLE_COUNT++))
        if [[ $STABLE_COUNT -ge 3 ]]; then
            break
        fi
    else
        STABLE_COUNT=0
    fi
    LAST_LINES=$CURRENT_LINES
done

# Capture the response (last portion of pane)
RESPONSE=$(tmux capture-pane -p -J -t "$TARGET" -S -100 | \
    grep -v "^>" | \
    grep -v "^│" | \
    grep -v "^╭" | \
    grep -v "^╰" | \
    grep -v "YOLO mode" | \
    grep -v "Type your message" | \
    tail -50)

# Log response
echo "" >> "$SESSION_DIR/context.txt"
echo "GEMINI: $RESPONSE" >> "$SESSION_DIR/context.txt"

echo "$RESPONSE"
