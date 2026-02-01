#!/bin/bash
# Perspective - alternative viewpoint on a situation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [[ $# -eq 0 ]]; then
    echo "Usage: perspective.sh <context>"
    echo "Example: perspective.sh 'User wants to join an AI theology project'"
    exit 1
fi

CONTEXT="$*"

PROMPT="You are a perspective generator. Given this context, provide 2-3 different ways to think about it. Consider different angles, stakeholders, or framings. Be concise (200 words max).

Context: $CONTEXT

Alternative perspectives:"

call_gemini "$PROMPT"
