# .zshrc - Minimal Zsh configuration

# Set up PATH with Homebrew and common development paths
# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Personal bin directory
export PATH="$HOME/bin:$PATH"

# Dynamic alias loading
# Aliases are now stored in ~/.config/zsh/aliases/*.zsh
# They auto-reload before each prompt (or manually with 'reload-aliases')
source "$HOME/.config/zsh/load-aliases.zsh"

# Enable colors
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Basic completion
autoload -Uz compinit
compinit

# Local machine-specific overrides (not tracked in git)
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
