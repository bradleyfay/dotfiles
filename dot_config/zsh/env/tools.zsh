# Tool-specific environment configuration

# XDG Base Directory Specification
# Standardizes config/data/cache locations for cleaner home directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Homebrew Configuration
export HOMEBREW_NO_ANALYTICS=1        # Disable analytics for privacy
export HOMEBREW_NO_AUTO_UPDATE=1      # Manual updates only (via brew update)
export HOMEBREW_NO_ENV_HINTS=1        # Reduce hint messages

# Homebrew trash - use the better version instead of macOS built-in
# This version supports more features and silently accepts rm flags
export PATH="/opt/homebrew/opt/trash/bin:$PATH"
