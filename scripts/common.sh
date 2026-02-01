#!/bin/bash
# Common functions for Gemini Partner scripts

GEMINI_TIMEOUT=60

# Call Gemini with a prompt and handle timeout/errors
call_gemini() {
    local prompt="$1"
    local result
    
    # Use timeout and capture both stdout and stderr status
    result=$(timeout $GEMINI_TIMEOUT gemini -y -p "$prompt" --output-format text 2>/dev/null)
    local exit_code=$?
    
    if [[ $exit_code -eq 124 ]]; then
        echo "[Gemini timed out after ${GEMINI_TIMEOUT}s]"
        return 1
    elif [[ $exit_code -ne 0 ]]; then
        echo "[Gemini error: exit code $exit_code]"
        return 1
    fi
    
    if [[ -z "$result" ]]; then
        echo "[Gemini returned empty response]"
        return 1
    fi
    
    echo "$result"
    return 0
}
