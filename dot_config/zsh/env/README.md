# Environment Variables

This directory contains modular environment variable configurations for zsh.

## Structure

- `colors.zsh` - Color-related environment variables (CLICOLOR, LSCOLORS)
- `history.zsh` - History configuration (HISTFILE, HISTSIZE, SAVEHIST, setopt commands)

## How It Works

The `load-env.zsh` file automatically sources all `.zsh` files in this directory when your shell starts.

## Adding New Environment Variables

1. Create a new `.zsh` file in this directory (e.g., `custom.zsh`)
2. Add your environment variables:
   ```bash
   export MY_VARIABLE="value"
   export ANOTHER_VAR="another value"
   ```
3. Source your zshrc or start a new terminal

The variables will be automatically loaded!

## Example Categories

You might want to create files like:

- `development.zsh` - Development-related variables (EDITOR, VISUAL, etc.)
- `tools.zsh` - Tool-specific configurations
- `api-keys.zsh` - API keys (consider using chezmoi templates for secrets)
- `custom.zsh` - Personal environment variables

## Note

- These files are loaded once at shell startup (not dynamically like aliases)
- For machine-specific variables, use `~/.zshrc.local` which is not tracked in git
- For secrets, consider using chezmoi's secrets management features
