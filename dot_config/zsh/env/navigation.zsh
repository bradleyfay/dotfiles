# Navigation configuration

# Zoxide - A smarter cd command that learns your habits
# Usage:
#   cd <query>  - Smart jump to frequently/recently used directories
#   cd <path>   - Falls back to regular cd if path exists
#   cdi         - Interactive directory picker with fzf
#
# Examples:
#   cd proj     - Jump to ~/projects or ~/work/project
#   cdi         - Browse all directories interactively
#   \cd         - Use original cd (escape hatch)

# Configure fzf options for zoxide interactive mode
export _ZO_FZF_OPTS="--height=40% --layout=reverse --border --preview='ls -la {2..}' --preview-window=right:50%"

# Initialize zoxide and override cd command
eval "$(zoxide init zsh --cmd cd)"
