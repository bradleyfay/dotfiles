#!/bin/bash
# Install recommended VS Code extensions
# Run this script after setting up VS Code on a new machine

set -e

echo "Installing VS Code extensions..."

# Core Development
code --install-extension anthropic.claude-code
code --install-extension eamodio.gitlens

# Theme & Appearance
code --install-extension enkia.tokyo-night
code --install-extension pkief.material-icon-theme
code --install-extension johnpapa.vscode-peacock

# Infrastructure as Code
code --install-extension hashicorp.terraform

# Documentation & Writing
code --install-extension yzhang.markdown-all-in-one
code --install-extension bierner.markdown-mermaid

# Configuration Files
code --install-extension tamasfe.even-better-toml

# AI Conversation Tracking
code --install-extension specstory.specstory-vscode

echo "✓ All global extensions installed!"
echo ""
echo "Note: Python extensions are project-specific."
echo "Install them manually when working on Python projects:"
echo "  code --install-extension ms-python.python"
echo "  code --install-extension charliermarsh.ruff"
