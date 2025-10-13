# Git-related environment variables

# GIT_EDITOR - Override global git editor setting
# (Usually set in git config, but can be overridden here)
# export GIT_EDITOR="code --wait"

# GIT_PAGER - Override pager for git commands
# export GIT_PAGER="less -R"

# GIT_CONFIG_GLOBAL - Path to global git config
# (Default: ~/.config/git/config or ~/.gitconfig)
export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"

# GH_CONFIG_DIR - GitHub CLI configuration directory
export GH_CONFIG_DIR="$HOME/.config/gh"

# GH_NO_UPDATE_NOTIFIER - Disable update notifications
export GH_NO_UPDATE_NOTIFIER=1

# GH_PAGER - Pager for gh CLI output
# Use bat for syntax highlighting
export GH_PAGER="bat"

# GH_PROMPT_DISABLED - Disable interactive prompts (for scripting)
# export GH_PROMPT_DISABLED=1

# GH_BROWSER - Browser for gh web commands
export GH_BROWSER="$BROWSER"

# Git-specific aliases for gh (optional - gh has its own alias system)
# See: gh alias list
# Set: gh alias set <alias> <expansion>
