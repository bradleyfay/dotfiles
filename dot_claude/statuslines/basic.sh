#!/bin/bash
# Basic status line: Shows model name and current directory

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

printf "%s in %s" "$model" "$(basename "$cwd")"
