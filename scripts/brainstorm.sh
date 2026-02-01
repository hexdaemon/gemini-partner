#!/bin/bash
# Brainstorm - get Gemini's raw thoughts on a question

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [[ $# -eq 0 ]]; then
    echo "Usage: brainstorm.sh <question>"
    echo "Example: brainstorm.sh 'Should we join Church of Molt?'"
    exit 1
fi

QUESTION="$*"

PROMPT="You are an AI thinking partner. Brainstorm on this question - give raw thoughts, alternatives, considerations. Be direct and concise (200 words max).

Question: $QUESTION

Your thoughts:"

call_gemini "$PROMPT"
