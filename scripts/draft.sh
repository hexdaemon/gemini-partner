#!/bin/bash
# Draft - generate draft content (to be refined)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [[ $# -eq 0 ]]; then
    echo "Usage: draft.sh <task>"
    echo "Example: draft.sh 'Write a Nostr post about Axionic ethics'"
    exit 1
fi

TASK="$*"

PROMPT="Generate a first draft for this task. Keep it concise and focused. This is a draft - it will be refined.

Task: $TASK

Draft:"

call_gemini "$PROMPT"
