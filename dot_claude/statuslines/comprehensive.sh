#!/bin/bash
# Comprehensive status line: Model, directory, token count, context usage, and estimated cost

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Calculate token count and context percentage
if [ -f "$transcript_path" ]; then
    tokens=$(wc -w < "$transcript_path" 2>/dev/null || echo "0")
    context_pct=$(echo "scale=1; $tokens / 2000 * 100" | bc 2>/dev/null || echo "0.0")
else
    tokens="0"
    context_pct="0.0"
fi

# Estimate cost (rough approximation: $0.003 per 1000 input tokens for Sonnet)
cost=$(echo "scale=4; $tokens * 0.003 / 1000" | bc 2>/dev/null || echo "0.0000")

printf "%s | %s | %s tokens (%.1f%%) | ~$%.4f" \
    "$model" \
    "$(basename "$cwd")" \
    "$tokens" \
    "$context_pct" \
    "$cost"
