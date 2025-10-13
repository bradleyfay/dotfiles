# Python and uv configuration

# UV_PYTHON_PREFERENCE - Controls which Python installations to use
# Options: only-managed | managed | system | only-system
# - managed: Prefer uv-managed Python, fallback to system (recommended)
# - only-managed: Only use uv-managed Python installations
export UV_PYTHON_PREFERENCE="managed"

# UV_CACHE_DIR - Where uv stores cached data
# Default: ~/.cache/uv
# export UV_CACHE_DIR="$HOME/.cache/uv"

# UV_TOOL_DIR - Where uv installs tools (uvx, etc.)
# Default: ~/.local/share/uv/tools
# export UV_TOOL_DIR="$HOME/.local/share/uv/tools"

# UV_TOOL_BIN_DIR - Where uv creates tool symlinks
# Default: ~/.local/bin
# export UV_TOOL_BIN_DIR="$HOME/.local/bin"

# Load uv shell completion (only in interactive shells)
if [[ $- == *i* ]]; then
    eval "$(uv generate-shell-completion zsh)"
fi
