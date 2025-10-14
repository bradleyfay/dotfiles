# FZF (Fuzzy Finder) Configuration

# FZF_DEFAULT_COMMAND - Default command for generating file list
# Use fd instead of find for better performance and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# FZF_DEFAULT_OPTS - Default options for all fzf invocations
export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border=rounded
  --inline-info
  --preview="bat --color=always --style=numbers --line-range=:500 {}"
  --preview-window=right:60%:wrap
  --bind="ctrl-/:toggle-preview"
  --bind="ctrl-u:preview-half-page-up"
  --bind="ctrl-d:preview-half-page-down"
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#1f2335,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
'

# FZF_CTRL_T_COMMAND - Command for CTRL-T (find files)
# Same as default command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF_CTRL_T_OPTS - Options for CTRL-T
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --preview-window=right:60%
"

# FZF_ALT_C_COMMAND - Command for ALT-C (change directory)
# Use fd to find directories
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# FZF_ALT_C_OPTS - Options for ALT-C
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always --icons {} | head -200'
  --preview-window=right:60%
"

# FZF_COMPLETION_OPTS - Options for tab completion
export FZF_COMPLETION_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --preview-window=right:60%
"

# Initialize fzf key bindings and completion
# This enables:
#   CTRL-T: Paste selected files/directories
#   CTRL-R: Paste selected command from history
#   ALT-C:  cd into selected directory
if [[ $- == *i* ]]; then
  # Source fzf key bindings if available
  if [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
  fi

  # Source fzf completion if available
  if [[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ]]; then
    source "/opt/homebrew/opt/fzf/shell/completion.zsh"
  fi
fi

# Custom fzf functions

# fzf-git-branch - Interactive git branch selector
fzf-git-branch() {
  local branch
  branch=$(git branch --all | grep -v HEAD |
    sed 's/^[* ] //' | sed 's#remotes/origin/##' |
    sort -u | fzf --height=40% --reverse --preview 'git log --color=always --oneline {1}')
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}
alias gb='fzf-git-branch'

# fzf-git-log - Interactive git log viewer
fzf-git-log() {
  git log --oneline --color=always |
    fzf --ansi --preview 'git show --color=always {1}' \
        --preview-window=right:60%:wrap
}
alias gl='fzf-git-log'
