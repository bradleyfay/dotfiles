# Editor and pager configuration

# EDITOR - Default editor for command-line programs
# Used by: git commit, crontab -e, sudoedit, fc, etc.
export EDITOR="code --wait"

# VISUAL - Visual/full-screen editor
# Some programs check VISUAL before EDITOR
export VISUAL="code --wait"

# PAGER - Default pager for viewing long output
# bat provides syntax highlighting and line numbers
export PAGER="bat"

# MANPAGER - Pager for man pages with syntax highlighting
# This configures bat to properly display man pages with colors
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# BAT_THEME - Color scheme for bat
# Use a dark theme that matches Tokyo Night terminal
export BAT_THEME="TwoDark"

# BAT_STYLE - Configure bat display style
# Options: full, auto, plain, changes, header, grid, rule, numbers, snip
export BAT_STYLE="numbers,changes,header,grid"

# LESS - Options for less pager (fallback and used by bat internally)
# -R: Allow ANSI color codes
# -F: Quit if output fits on one screen
# -X: Don't clear screen on exit
# -i: Case-insensitive search (unless uppercase used)
export LESS="-R -F -X -i"

# BROWSER - Default browser for opening URLs
# Used by various CLI tools that need to open web pages
export BROWSER="open -a 'Google Chrome'"

# Note: To use vim/neovim in the future, just change EDITOR/VISUAL to:
# export EDITOR="nvim"
# export VISUAL="nvim"
