# Eza (modern ls replacement) environment variables

# EZA_ICON_SPACING - Space between icon and filename (default: 1)
export EZA_ICON_SPACING=2

# EZA_GRID_ROWS - Number of rows in grid view
# export EZA_GRID_ROWS=10

# Theme Configuration
# Eza looks for theme.yml in:
# 1. $EZA_CONFIG_DIR/theme.yml (if set)
# 2. $XDG_CONFIG_HOME/eza/theme.yml (default, using ~/.config/eza/)
# Our theme.yml is at ~/.config/eza/theme.yml
#
# Note: LS_COLORS and EZA_COLORS take precedence over theme.yml
# We keep these unset to allow theme.yml to work
# export EZA_COLORS="reset"  # Don't set this - let theme.yml work

# Note: Default command options are defined directly in aliases
# (see dot_config/zsh/aliases/eza.zsh)
# Using environment variables for multi-option strings doesn't work well with alias expansion
