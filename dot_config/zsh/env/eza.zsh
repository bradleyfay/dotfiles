# Eza (modern ls replacement) environment variables

# EZA_COLORS - Custom color configuration
# Uses same format as LS_COLORS
# See: https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md
# export EZA_COLORS="reset"

# EZA_ICON_SPACING - Space between icon and filename (default: 1)
export EZA_ICON_SPACING=2

# EZA_GRID_ROWS - Number of rows in grid view
# export EZA_GRID_ROWS=10

# Default eza options (applied to all eza commands)
# --icons: Show file type icons (requires Nerd Font)
# --group-directories-first: List directories before files
# --color=always: Always use colors
export EZA_DEFAULT_OPTIONS="--icons --group-directories-first --color=always"
