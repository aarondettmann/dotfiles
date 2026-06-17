#!/usr/bin/env bash
set -euo pipefail

# ==> General notes
# gfm : "github flavoured markdown"

# ==> Other options
# --table-of-contents : create toc
# --number-sections   : number section headings
# --verbose           : useful for debugging
# --fail-if-warnings

# ==> Other fonts
#   - XCharter
#   - lmodern
#   - cmbright

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

pandoc --from markdown+smart --to latex \
       --variable papersize=a4 \
       --variable documentclass="article" \
       --variable fontfamily="lmodern" \
       --variable fontsize=11pt \
       --standalone \
       --output="$output_file" \
       "$input_file"
