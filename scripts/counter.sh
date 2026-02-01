#!/bin/bash
# Counter - devil's advocate against a position

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [[ $# -eq 0 ]]; then
    echo "Usage: counter.sh <position>"
    echo "Example: counter.sh 'We should delegate all homestead reports to Gemini'"
    exit 1
fi

POSITION="$*"

PROMPT="You are a devil's advocate. Argue AGAINST this position - find weaknesses, risks, counterarguments. Be direct and critical (200 words max).

Position: $POSITION

Counterarguments:"

call_gemini "$PROMPT"
