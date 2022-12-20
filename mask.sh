#!/usr/bin/env bash

set -euo pipefail

SECRET=${SECRET:-$(</dev/stdin)}

function format() {
    STDIN="$(</dev/stdin)"
    jq <<<"$STDIN" >/dev/null 2>&1 && echo JSON && exit 0
    yq <<<"$STDIN" >/dev/null 2>&1 && echo YAML && exit 0
    echo
}

[ -z "${SECRET}" ] && (echo "ERROR - No secret provided" && exit 1)

FORMAT=$(format <<<"$SECRET")

(
if [ "${FORMAT}" == "JSON" ]; then
    jq
elif [ "${FORMAT}" == "YAML" ]; then
    yq -o=json
fi
)  <<<"$SECRET" | jq -r '..|select(type == "string")'\
    | while read L; do
        echo "::add-mask::$L"
        echo "::add-mask::$(base64 <<<$L)"
    done
