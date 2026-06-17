#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <input-markdown-file>" >&2
    exit 2
fi

input_file="$1"
if [[ ! -f "$input_file" ]]; then
    echo "Error: input file does not exist: $input_file" >&2
    exit 1
fi

output_file="${input_file%.*}.pdf"
if [[ "$output_file" == "$input_file" ]]; then
    output_file="${input_file}.pdf"
fi

pandoc --from markdown+smart --to beamer \
       --standalone \
       --output="$output_file" \
       "$input_file"
