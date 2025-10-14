#!/usr/bin/env zsh
# PATH configuration
# Loaded first (00- prefix) to ensure PATH is set before other env files

# Helper function to add to PATH only if not already present
# This prevents duplicates when env files are reloaded
path_prepend() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Personal bin directories (highest priority - override system commands)
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# Development tools paths
# Add common development tool paths here

# Go
path_prepend "$HOME/go/bin"

# Rust (Cargo)
path_prepend "$HOME/.cargo/bin"

# Python (pipx)
path_prepend "$HOME/.local/pipx/bin"

# Note: Homebrew PATH is set in .zshrc via 'brew shellenv' before this file loads
