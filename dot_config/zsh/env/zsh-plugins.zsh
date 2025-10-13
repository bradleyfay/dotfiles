# Zsh plugins configuration
# Plugins installed via Homebrew

# === zsh-completions ===
# Additional completion definitions
# Must be added to fpath BEFORE compinit runs (in .zshrc)
# This is just a note - the actual fpath configuration is in .zshrc

# === zsh-autosuggestions ===
# Fish-like autosuggestions based on history
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # Configuration
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"  # Subtle gray suggestions
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Suggest from history and completions
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20  # Don't suggest for long commands
fi

# === zsh-syntax-highlighting ===
# Syntax highlighting for commands (green=valid, red=invalid)
# MUST be sourced LAST (after all other plugins)
# This is sourced at the end of .zshrc, not here
