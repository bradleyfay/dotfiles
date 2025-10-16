#!/bin/bash
# Fix zsh completion directory permissions to prevent compinit security warnings
# This script runs once after chezmoi applies dotfiles

set -euo pipefail

echo "Fixing zsh completion directory permissions..."

# Fix Homebrew zsh directories (if they exist)
if [ -d "/opt/homebrew/share/zsh" ]; then
    echo "  - Fixing /opt/homebrew/share/zsh permissions"
    chmod -R go-w /opt/homebrew/share/zsh
fi

if [ -d "/usr/local/share/zsh" ]; then
    echo "  - Fixing /usr/local/share/zsh permissions"
    chmod -R go-w /usr/local/share/zsh
fi

# Fix user zsh directory (if it exists)
if [ -d "$HOME/.zsh" ]; then
    echo "  - Fixing $HOME/.zsh permissions"
    chmod -R go-w "$HOME/.zsh"
fi

echo "✓ zsh permissions fixed"
