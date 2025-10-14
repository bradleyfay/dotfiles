#!/bin/bash
# Developer status line: Git branch, status, model, and directory with visual indicators

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Change to working directory for git operations
cd "$cwd" 2>/dev/null || cd "$(echo "$input" | jq -r '.cwd')"

# Get git information
branch=$(git branch --show-current 2>/dev/null)
git_status=""

if [ -n "$branch" ]; then
    # Check for uncommitted changes
    if ! git diff --quiet HEAD 2>/dev/null; then
        git_status="*"  # Modified files
    fi

    # Check for staged changes
    if ! git diff --cached --quiet 2>/dev/null; then
        git_status="${git_status}+"  # Staged files
    fi

    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
        git_status="${git_status}?"  # Untracked files
    fi

    # Get ahead/behind info
    ahead_behind=$(git rev-list --left-right --count origin/"$branch"..."$branch" 2>/dev/null)
    if [ -n "$ahead_behind" ]; then
        behind=$(echo "$ahead_behind" | cut -f1)
        ahead=$(echo "$ahead_behind" | cut -f2)
        if [ "$ahead" -gt 0 ] || [ "$behind" -gt 0 ]; then
            git_status="${git_status} ↑$ahead ↓$behind"
        fi
    fi

    printf "%s [%s%s] | %s" \
        "$(basename "$(pwd)")" \
        "$branch" \
        "$git_status" \
        "$model"
else
    printf "%s | %s" \
        "$(basename "$(pwd)")" \
        "$model"
fi
