#!/usr/bin/env zsh
# Dynamic environment variable loader for zsh
# This file handles loading all environment variable files from ~/.config/zsh/env/

# Directory containing environment variable files
ENV_DIR="${HOME}/.config/zsh/env"

# Track last modification times
typeset -gA _env_mtimes

# Function to check if env files have changed
env_files_changed() {
    local changed=0
    if [[ -d "${ENV_DIR}" ]]; then
        for env_file in "${ENV_DIR}"/*.zsh(N); do
            local current_mtime=$(stat -f %m "$env_file" 2>/dev/null)
            local last_mtime="${_env_mtimes[$env_file]}"

            if [[ "$current_mtime" != "$last_mtime" ]]; then
                changed=1
                _env_mtimes[$env_file]=$current_mtime
            fi
        done
    fi
    return $((1 - changed))  # Return 0 if changed, 1 if not
}

# Function to load all environment variable files
load_env() {
    # Load all .zsh files from the env directory
    if [[ -d "${ENV_DIR}" ]]; then
        for env_file in "${ENV_DIR}"/*.zsh(N); do
            source "${env_file}"
            # Track modification time
            _env_mtimes[$env_file]=$(stat -f %m "$env_file" 2>/dev/null)
        done
    fi
}

# --- Choose your loading strategy below ---

# OPTION 1: Auto-reload before EVERY prompt if files changed (RECOMMENDED)
# NOTE: PATH additions use deduplication, so reloading is safe
# Using add-zsh-hook to avoid conflicts with other precmd functions
autoload -Uz add-zsh-hook
_auto_reload_env() {
    if env_files_changed; then
        load_env
    fi
}
add-zsh-hook precmd _auto_reload_env

# OPTION 2: Manual reload with a command (default, best performance)
# This is always available
reload-env() {
    load_env
    echo "✓ Environment variables reloaded from ${ENV_DIR}"
}

# Initial load when shell starts
load_env
