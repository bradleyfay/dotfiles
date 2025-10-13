# Eza aliases - Modern ls replacement with muscle memory protection

# Default options for all eza commands:
# --icons=always: Show file type icons (requires Nerd Font)
# --group-directories-first: List directories before files
# --color=always: Always use colors

# Core ls replacement
# These map directly to common ls usage patterns
alias ls='eza --icons=always --group-directories-first --color=always'
alias ll='eza --icons=always --group-directories-first --color=always -l'                    # Long format
alias la='eza --icons=always --group-directories-first --color=always -la'                   # Long format, all files
alias l='eza --icons=always --group-directories-first --color=always -lah'                   # Long format, all files, human-readable (most common)
alias lh='eza --icons=always --group-directories-first --color=always -lh'                   # Long format, human-readable

# Sorting variations
alias lt='eza --icons=always --group-directories-first --color=always -l --sort=modified'    # Sort by time (newest first)
alias ltr='eza --icons=always --group-directories-first --color=always -l --sort=modified --reverse'  # Sort by time (oldest first)
alias lS='eza --icons=always --group-directories-first --color=always -l --sort=size'        # Sort by size (capital S to avoid conflict)

# Tree views
alias tree='eza --icons=always --group-directories-first --color=always --tree'              # Tree view
alias tree2='eza --icons=always --group-directories-first --color=always --tree --level=2'   # Tree view, 2 levels deep
alias tree3='eza --icons=always --group-directories-first --color=always --tree --level=3'   # Tree view, 3 levels deep

# Git-aware listing (shows git status in listing)
alias lg='eza --icons=always --group-directories-first --color=always -l --git'              # Long format with git status
alias lga='eza --icons=always --group-directories-first --color=always -la --git'            # Long format, all files, git status

# Specialized views
alias lsd='eza --icons=always --group-directories-first --color=always -lD'                  # List only directories
alias lsf='eza --icons=always --group-directories-first --color=always -lf'                  # List only files
alias lx='eza --icons=always --group-directories-first --color=always -lbhHigUmuSa'          # Extended listing (all metadata)

# Recursive
alias lr='eza --icons=always --group-directories-first --color=always -R'                    # Recursive
alias lra='eza --icons=always --group-directories-first --color=always -Ra'                  # Recursive, all files

# Note: To use actual 'ls' command (escape the alias):
# - \ls          (bypass alias)
# - /bin/ls      (absolute path)
# - command ls   (use builtin)
