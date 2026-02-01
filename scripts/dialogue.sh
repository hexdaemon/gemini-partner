#!/bin/bash
# dialogue.sh - Multi-turn conversation with Gemini
#
# Usage:
#   dialogue.sh "initial prompt"              # Start new conversation
#   dialogue.sh --continue "follow-up"        # Continue latest conversation
#   dialogue.sh --reset                       # Clear conversation history
#
# Uses Gemini's --resume feature for persistent context across turns.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Max response length (words)
MAX_WORDS=200

# Timeout for API calls
TIMEOUT=60

# Session marker file
SESSION_DIR="${HOME}/.cache/gemini-sessions"
mkdir -p "$SESSION_DIR"
ACTIVE_SESSION="$SESSION_DIR/active-conversation"

show_usage() {
    echo "Usage:"
    echo "  dialogue.sh \"initial prompt\"              # Start new conversation"
    echo "  dialogue.sh --continue \"follow-up\"        # Continue latest conversation"
    echo "  dialogue.sh --reset                       # Clear conversation history"
    echo ""
    echo "Options:"
    echo "  --words N    Max response length (default: $MAX_WORDS)"
    echo "  --timeout N  API timeout in seconds (default: $TIMEOUT)"
}

# Parse options
CONTINUE=false
RESET=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --continue)
            CONTINUE=true
            shift
            ;;
        --reset)
            RESET=true
            shift
            ;;
        --words)
            MAX_WORDS="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

# Handle reset
if [ "$RESET" = true ]; then
    rm -f "$ACTIVE_SESSION"
    echo "✓ Conversation history cleared"
    exit 0
fi

# Get prompt
if [ $# -eq 0 ]; then
    echo "Error: prompt required" >&2
    show_usage
    exit 1
fi

PROMPT="$1"

# Build Gemini command
CMD="gemini -y"

# Add resume if continuing
if [ "$CONTINUE" = true ]; then
    if [ ! -f "$ACTIVE_SESSION" ]; then
        echo "Warning: No active conversation found. Starting new one." >&2
    else
        CMD="$CMD --resume latest"
    fi
fi

# Add word limit and prompt
CMD="$CMD -p \"${PROMPT} (respond in max ${MAX_WORDS} words)\""

# Mark session as active
touch "$ACTIVE_SESSION"

# Execute with retry logic
MAX_RETRIES=2
RETRY=0
while [ $RETRY -le $MAX_RETRIES ]; do
    if [ $RETRY -gt 0 ]; then
        WAIT=$((RETRY * 10))
        echo "Retry $RETRY/$MAX_RETRIES after ${WAIT}s..." >&2
        sleep $WAIT
    fi
    
    # Run command with timeout
    if OUTPUT=$(cd ~/.config/hex && timeout $TIMEOUT bash -c "$CMD" 2>&1); then
        # Success - print output and exit
        echo "$OUTPUT" | grep -v "^YOLO mode" | grep -v "^Loaded cached" | grep -v "^Hook registry"
        exit 0
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 124 ]; then
            echo "Error: Gemini API timeout after ${TIMEOUT}s" >&2
        else
            echo "Error: Gemini failed (exit $EXIT_CODE)" >&2
        fi
        RETRY=$((RETRY + 1))
    fi
done

echo "Error: Failed after $MAX_RETRIES retries" >&2
rm -f "$ACTIVE_SESSION"  # Clear failed session
exit 1
