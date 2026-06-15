#!/bin/bash

export_dir="."
input_file="$1"
output_file="$export_dir/${1/.*/.pdf}"

mkdir -p "$export_dir"

pandoc --from markdown+smart --to beamer \
       --standalone \
       --output="$output_file" \
                "$input_file"
