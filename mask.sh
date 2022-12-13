#!/usr/bin/env bash

set -euo pipefail

FORMAT=${FORMAT-}

function format() {
    STDIN="$(</dev/stdin)"
    jq <<<"$STDIN" >/dev/null 2>&1 && echo JSON && exit 0
    yq <<<"$STDIN" >/dev/null 2>&1 && echo YAML && exit 0
    echo
}

STDIN="$(</dev/stdin)"

[ -z "${STDIN}" ] && (echo "ERROR - Empty input" && exit 1)

FORMAT=$(format <<<"$STDIN")

if [ "${FORMAT}" == "JSON" ]; then
    jq -r '..|select(type == "string")' <<<"$STDIN" | while read L; do echo "::add-mask::$L"; done
fi

if [ "${FORMAT}" == "YAML" ]; then
    yq -o=json <<<"$STDIN" | jq -r '..|select(type == "string")' | while read L; do echo "::add-mask::$L"; done
fi
