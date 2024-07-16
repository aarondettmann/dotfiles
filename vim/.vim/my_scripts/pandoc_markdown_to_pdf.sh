#!/bin/bash

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

export_dir="."
input_file="$1"
output_file="$export_dir/${1/.*/.pdf}"

mkdir -p "$export_dir"

pandoc --from markdown --to latex \
       --variable papersize=a4 \
       --variable documentclass="article" \
       --variable fontfamily="lmodern" \
       --variable fontsize=11pt \
       --standalone \
       --smart \
       --output="$output_file" \
                "$input_file"

