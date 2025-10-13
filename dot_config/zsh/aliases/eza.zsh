# Eza aliases - Modern ls replacement with muscle memory protection

# Core ls replacement
# These map directly to common ls usage patterns
alias ls='eza $EZA_DEFAULT_OPTIONS'
alias ll='eza $EZA_DEFAULT_OPTIONS -l'                    # Long format
alias la='eza $EZA_DEFAULT_OPTIONS -la'                   # Long format, all files
alias l='eza $EZA_DEFAULT_OPTIONS -lah'                   # Long format, all files, human-readable (most common)
alias lh='eza $EZA_DEFAULT_OPTIONS -lh'                   # Long format, human-readable

# Sorting variations
alias lt='eza $EZA_DEFAULT_OPTIONS -l --sort=modified'    # Sort by time (newest first)
alias ltr='eza $EZA_DEFAULT_OPTIONS -l --sort=modified --reverse'  # Sort by time (oldest first)
alias lS='eza $EZA_DEFAULT_OPTIONS -l --sort=size'        # Sort by size (capital S to avoid conflict)

# Tree views
alias tree='eza $EZA_DEFAULT_OPTIONS --tree'              # Tree view
alias tree2='eza $EZA_DEFAULT_OPTIONS --tree --level=2'   # Tree view, 2 levels deep
alias tree3='eza $EZA_DEFAULT_OPTIONS --tree --level=3'   # Tree view, 3 levels deep

# Git-aware listing (shows git status in listing)
alias lg='eza $EZA_DEFAULT_OPTIONS -l --git'              # Long format with git status
alias lga='eza $EZA_DEFAULT_OPTIONS -la --git'            # Long format, all files, git status

# Specialized views
alias lsd='eza $EZA_DEFAULT_OPTIONS -lD'                  # List only directories
alias lsf='eza $EZA_DEFAULT_OPTIONS -lf'                  # List only files
alias lx='eza $EZA_DEFAULT_OPTIONS -lbhHigUmuSa'          # Extended listing (all metadata)

# Recursive
alias lr='eza $EZA_DEFAULT_OPTIONS -R'                    # Recursive
alias lra='eza $EZA_DEFAULT_OPTIONS -Ra'                  # Recursive, all files

# Note: To use actual 'ls' command (escape the alias):
# - \ls          (bypass alias)
# - /bin/ls      (absolute path)
# - command ls   (use builtin)
