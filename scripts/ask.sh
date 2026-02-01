#!/bin/bash
# Ask - quick Q&A with Gemini

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [[ $# -eq 0 ]]; then
    echo "Usage: ask.sh <question>"
    echo "Example: ask.sh 'What is the difference between Sonnet and Opus?'"
    exit 1
fi

QUESTION="$*"

PROMPT="Answer this question directly and concisely (150 words max).

Question: $QUESTION

Answer:"

call_gemini "$PROMPT"
