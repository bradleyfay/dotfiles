#!/usr/bin/env zsh
# Dynamic alias loader for zsh
# This file handles loading all alias files from ~/.config/zsh/aliases/

# Directory containing alias files
ALIAS_DIR="${HOME}/.config/zsh/aliases"

# Function to load all alias files
load_aliases() {
    # Unset all existing aliases to allow removal/updates
    # (Optional: comment out if you want aliases to accumulate)
    unalias -m '*' 2>/dev/null

    # Load all .zsh files from the aliases directory
    if [[ -d "${ALIAS_DIR}" ]]; then
        for alias_file in "${ALIAS_DIR}"/*.zsh(N); do
            source "${alias_file}"
        done
    fi
}

# --- Choose your loading strategy below ---

# OPTION 1: Load aliases before EVERY command (immediate updates, performance cost)
# Uncomment to enable:
# preexec() {
#     load_aliases
# }

# OPTION 2: Load aliases before EVERY prompt (good balance) - RECOMMENDED
# Using add-zsh-hook to avoid conflicts with other precmd functions
autoload -Uz add-zsh-hook
add-zsh-hook precmd load_aliases

# OPTION 3: Manual reload with a command (best performance)
# This is always available regardless of which option above you choose
reload-aliases() {
    load_aliases
    echo "✓ Aliases reloaded from ${ALIAS_DIR}"
}

# Initial load when shell starts
load_aliases
