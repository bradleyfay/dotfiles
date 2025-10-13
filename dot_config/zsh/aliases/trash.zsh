# Trash aliases - safe rm alternative

# Safety aliases: redirect rm commands to trash
# Files go to macOS Trash and are recoverable via Finder
alias rm='trash'

# Trash utility aliases
alias tl='trash -l'       # List items in trash
alias te='trash -e'       # Empty trash (asks for confirmation)
alias ts='trash -s'       # Secure empty trash (asks for confirmation)

# Note: To permanently delete without trash, use one of these escape hatches:
# - \rm file          (bypass alias)
# - /bin/rm file      (absolute path)
# - command rm file   (use builtin)
