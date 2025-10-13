#!/usr/bin/env zsh
# Dynamic environment variable loader for zsh
# This file handles loading all environment variable files from ~/.config/zsh/env/

# Directory containing environment variable files
ENV_DIR="${HOME}/.config/zsh/env"

# Function to load all environment variable files
load_env() {
    # Load all .zsh files from the env directory
    if [[ -d "${ENV_DIR}" ]]; then
        for env_file in "${ENV_DIR}"/*.zsh(N); do
            source "${env_file}"
        done
    fi
}

# Load environment variables when shell starts
load_env
