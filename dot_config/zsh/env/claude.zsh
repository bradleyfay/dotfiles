#!/usr/bin/env zsh
# Claude Code configuration

# Disable Claude Code auto-updater
# Claude Code's auto-updater installs to ~/.local/bin/claude instead of Homebrew's location
# Use 'brew upgrade --cask claude-code' to update instead
export DISABLE_AUTOUPDATER=1
