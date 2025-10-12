# .zshrc - Minimal Zsh configuration

# Set up basic path
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Basic aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

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
