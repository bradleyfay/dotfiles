# Chezmoi aliases for convenient dotfiles management

# Basic shortcuts
alias cm='chezmoi'
alias cma='chezmoi apply'
alias cms='chezmoi status'
alias cmd='chezmoi diff'
alias cme='chezmoi edit'
alias cmcd='chezmoi cd'
alias cmr='chezmoi re-add'

# Common workflows
alias cmea='chezmoi_edit_and_apply'  # Edit then apply
alias cmgit='chezmoi_git'            # Git operations in chezmoi dir

# Edit and apply in one command
# Usage: cmea ~/.zshrc
chezmoi_edit_and_apply() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cmea <file>"
        echo "Example: cmea ~/.zshrc"
        return 1
    fi

    chezmoi edit "$@" && chezmoi apply "$@"
}

# Run git commands in the chezmoi source directory
# Usage: cmgit status, cmgit commit -m "message", etc.
chezmoi_git() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cmgit <git-command>"
        echo "Example: cmgit status"
        return 1
    fi

    (cd "$CHEZMOI_SOURCE_DIR" && git "$@")
}

# Quick add and apply
# Usage: cmadd ~/.config/foo/bar
alias cmadd='chezmoi_add_and_apply'
chezmoi_add_and_apply() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cmadd <file>"
        echo "Example: cmadd ~/.config/nvim/init.vim"
        return 1
    fi

    chezmoi add "$@" && chezmoi apply "$@"
}
