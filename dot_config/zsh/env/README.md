# Environment Variables

This directory contains modular environment variable configurations for zsh.

## Load Order

Files are loaded **alphabetically** by `load-env.zsh`. Use numeric prefixes to control order:
- `00-path.zsh` loads first
- `colors.zsh`, `editor.zsh`, etc. load alphabetically
- `zsh-plugins.zsh` loads last

## Files

### Core Configuration (Ordered)

- **`00-path.zsh`** - PATH configuration (loads first)
  - Personal bin directories: `~/.local/bin`, `~/bin`
  - Development tools: Go, Rust, Python (pipx)
  - Note: Homebrew PATH set in `.zshrc` via `brew shellenv`

### Environment Configuration (Alphabetical)

- `chezmoi.zsh` - Chezmoi-specific environment variables
- `colors.zsh` - Color-related environment variables (CLICOLOR, LSCOLORS)
- `editor.zsh` - Editor settings (EDITOR, VISUAL, PAGER)
- `eza.zsh` - Eza (modern ls) configuration
- `git.zsh` - Git-specific environment variables
- `history.zsh` - History configuration (HISTFILE, HISTSIZE, SAVEHIST, setopt commands)
- `navigation.zsh` - Navigation tools (zoxide configuration)
- `prompt.zsh` - Prompt initialization (Starship)
- `python.zsh` - Python-specific environment variables
- **`secrets.zsh`** - Encrypted secrets (API keys, tokens) - See [SECRETS.md](../../../SECRETS.md)
- `tools.zsh` - Tool-specific settings (XDG dirs, Homebrew, tool paths)
- `zsh-plugins.zsh` - Zsh plugin configuration (autosuggestions, etc.)

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

## Secrets Management

For sensitive information like API keys, tokens, and credentials:

- Use `secrets.zsh` for encrypted secrets management
- This file is managed via chezmoi with age encryption
- See [SECRETS.md](../../../SECRETS.md) for full documentation
- Example secrets are provided in the template (commented out)

To add encrypted secrets:
```bash
# Edit the secrets file
chezmoi edit ~/.config/zsh/env/secrets.zsh

# Add your secrets (will be auto-encrypted)
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."

# Apply changes
chezmoi apply
```

## Note

- Environment files are auto-reloaded when modified (checked before each prompt)
- For machine-specific variables, use `~/.zshrc.local` (not tracked in git)
- PATH additions use deduplication, so reloading is safe
