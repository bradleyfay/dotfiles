#!/bin/bash
# Minimalist status line: Just directory name

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

printf "%s" "$(basename "$cwd")"
