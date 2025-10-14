# Dotfiles (chezmoi + Homebrew Bundle)

Modern, sophisticated dotfiles management using [chezmoi](https://www.chezmoi.io/) with automated workflows, encrypted secrets, and dynamic configuration loading.

## Features

### Core Infrastructure
- 🏗️ **chezmoi** - Intelligent dotfiles manager with templating, secrets, and cross-platform support
- 📦 **Homebrew Bundle** - Declarative package management via Brewfile
- 🔄 **Auto-Install Packages** - Packages automatically install/update when Brewfile changes
- 🚀 **One-Command Bootstrap** - Full system setup with single curl command
- 🔐 **Encrypted Secrets** - age encryption for SSH keys, API tokens, and credentials

### Dynamic Configuration
- ⚡ **Auto-Reload Aliases** - Aliases reload automatically before each prompt
- 🔄 **Auto-Reload Environment** - Environment variables reload when files change (mtime tracking)
- 📂 **Modular Structure** - Organized aliases, environment variables, and PATH configuration
- 🎯 **Load Order Control** - Numeric prefixes for explicit loading order (00-path.zsh, etc.)

### Git Workflow Automation
- 🪝 **Pre-commit Hooks** - Automatically initialized in every new repository
- 🧹 **Auto-Cleanup** - Post-checkout hook cleans build artifacts when switching branches
- 📝 **Minimal Config Generation** - Auto-creates basic `.pre-commit-config.yaml` if missing
- 🔧 **Git Template Directory** - Hooks automatically applied to new/cloned repos

### Developer Experience
- 🎨 **Tokyo Night Theme** - Consistent styling across terminal, prompt, and editors
- 🚄 **Modern CLI Tools** - Rust-based replacements (ripgrep, fd, bat, eza, zoxide, dust, etc.)
- 🌟 **Starship Prompt** - Fast, customizable prompt with git integration
- ⚙️ **Zsh Enhancements** - Autosuggestions, syntax highlighting, and completions
- 📱 **GPU Terminal** - Alacritty with Nerd Fonts and custom themes

## Quick Start

### Automated Installation (Recommended)

Bootstrap your entire setup with a single command:

```bash
curl -LsSf https://raw.githubusercontent.com/bradleyfay/dotfiles/main/install.sh | sh
```

**What this does:**
- ✅ Detects your platform (macOS/Linux)
- ✅ Installs Homebrew (if not present)
- ✅ Installs chezmoi
- ✅ Clones and applies your dotfiles
- ✅ Installs all packages from Brewfile
- ✅ Sets up age encryption (optional)
- ✅ Prompts for machine type (personal/work)

**Want to review the script first?**
```bash
curl -LsSf https://raw.githubusercontent.com/bradleyfay/dotfiles/main/install.sh | less
```

**Environment variables (optional):**
```bash
# Use HTTPS instead of SSH
export DOTFILES_REPO=https://github.com/bradleyfay/dotfiles.git

# Specify machine type without prompting
export MACHINE_TYPE=work

# Run installation
curl -LsSf https://raw.githubusercontent.com/bradleyfay/dotfiles/main/install.sh | sh
```

### Manual Installation (Alternative)

If you prefer manual installation:

```bash
# 1. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and initialize dotfiles
brew install chezmoi
chezmoi init --apply git@github.com:bradleyfay/dotfiles.git

# That's it! Your dotfiles and packages are now installed.
```

What happens:
1. chezmoi clones your dotfiles repository
2. Applies all configuration files (`.zshrc`, `.config/zsh/`, etc.)
3. Automatically runs `brew bundle install` from your Brewfile
4. All your tools (zoxide, fzf, dust, etc.) are installed
5. Git hooks are set up for all future repositories

## Architecture

### Modular Configuration Structure

```
~/.config/zsh/
├── aliases/              # Alias definitions (auto-reload)
│   ├── chezmoi.zsh      # Chezmoi shortcuts
│   ├── eza.zsh          # Modern ls aliases
│   ├── general.zsh      # General utilities
│   ├── git.zsh          # Git shortcuts
│   ├── navigation.zsh   # Directory navigation
│   ├── trash.zsh        # Safe deletion
│   └── vscode.zsh       # VS Code integration
├── env/                  # Environment variables (auto-reload with mtime tracking)
│   ├── 00-path.zsh      # PATH configuration (loads first)
│   ├── chezmoi.zsh      # Chezmoi variables
│   ├── colors.zsh       # Color settings
│   ├── editor.zsh       # Editor configuration
│   ├── eza.zsh          # Eza settings
│   ├── git.zsh          # Git environment
│   ├── history.zsh      # History configuration
│   ├── navigation.zsh   # Navigation tools (zoxide)
│   ├── prompt.zsh       # Starship initialization
│   ├── python.zsh       # Python settings
│   ├── secrets.zsh      # Encrypted secrets (age)
│   ├── tools.zsh        # Tool-specific settings
│   └── zsh-plugins.zsh  # Plugin configuration
├── load-aliases.zsh      # Dynamic alias loader (precmd hook)
└── load-env.zsh          # Dynamic environment loader (mtime tracking)
```

### Load Order and Auto-Reload

**Aliases:**
- Loaded before every prompt via `precmd` hook
- Instant updates without shell restart
- Use `reload-aliases` for manual reload

**Environment Variables:**
- Auto-reload when file modification time changes
- PATH uses deduplication (safe to reload)
- Numeric prefixes control load order (00-, 01-, etc.)
- Use `reload-env` for manual reload

**PATH Configuration:**
- Loaded first via `00-path.zsh` prefix
- Prevents duplicates with `path_prepend()` helper
- Personal bins override system commands

### Git Hooks System

Git template directory at `~/.git-template/` provides automatic hooks:

**Post-Checkout Hook:**
1. Cleans build artifacts when switching branches:
   - Python: `__pycache__`, `*.pyc`, `.pytest_cache`, `.mypy_cache`
   - Node: `.next`, `dist`, `build` (excludes `node_modules`)
   - General: `.cache` directories
2. Auto-creates minimal `.pre-commit-config.yaml` if missing

**Pre-Commit Hook:**
- Runs pre-commit checks if configured
- Falls back gracefully if pre-commit not installed
- Uses Homebrew Python or system Python

**Apply to Existing Repos:**
```bash
git-init-existing        # Apply hooks to all repos in current directory
git-init-existing ~/code # Apply hooks to all repos in ~/code
```

## What's Included

### Managed Files

**Shell Configuration:**
- `.zshrc` - Main shell configuration with plugin loading
- `.config/zsh/` - Modular zsh configs (aliases, env, loaders)

**Terminal & Prompt:**
- `.config/alacritty/alacritty.toml` - GPU-accelerated terminal (Tokyo Night)
- `.config/starship.toml` - Modern prompt (Tokyo Night, custom modules)
- `.config/eza/theme.yml` - Modern ls with custom icons

**Git:**
- `.config/git/config` - Git global configuration
- `.git-template/hooks/` - Automatic hook installation

**Tools:**
- `.Brewfile` - All packages and applications
- `.local/bin/` - Helper scripts (git-init-existing, etc.)

### Installed Packages (via Brewfile)

**Modern CLI Tools:**
- `ripgrep` (rg) - Better grep
- `fd` - Better find
- `bat` - Better cat with syntax highlighting
- `eza` - Better ls with icons
- `zoxide` (z) - Smart cd that learns your habits
- `fzf` - Fuzzy finder
- `dust` - Better du (disk usage)
- `bottom` (btm) - Better top
- `procs` - Better ps
- `sd` - Better sed
- `hyperfine` - Benchmarking
- `tokei` - Code statistics

**Development Tools:**
- `git`, `jq`, `yq` - Core tools
- `gh` - GitHub CLI
- `git-delta` - Better git diffs
- `pre-commit` - Git pre-commit framework
- `age` - Modern file encryption
- `uv` - Fast Python package installer
- `trash` - Safe rm alternative

**Shell & Terminal:**
- `starship` - Modern cross-shell prompt
- `alacritty` - GPU-accelerated terminal
- `font-fira-code-nerd-font` - Programming font with ligatures and icons
- `zsh-autosuggestions` - Fish-like command suggestions (gray text)
- `zsh-syntax-highlighting` - Command syntax highlighting (green/red)
- `zsh-completions` - Enhanced tab completions

## Daily Usage

### Basic Operations

```bash
# Update dotfiles from remote
chezmoi update

# Edit a managed file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# See all managed files
chezmoi managed
```

### Managing Packages

```bash
# Edit Brewfile
chezmoi edit ~/.Brewfile

# Apply changes (will auto-run brew bundle)
chezmoi apply
```

### Git Workflow

```bash
# Make changes in source directory
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit
```

### Helper Commands

**Alias Management:**
```bash
reload-aliases           # Manually reload all aliases
```

**Environment Variables:**
```bash
reload-env               # Manually reload environment variables
```

**Git Hooks:**
```bash
git-init-existing        # Apply git hooks to existing repos
git-init-existing ~/code # Apply to specific directory
```

## Terminal Setup

### Alacritty + Starship + Eza

**Alacritty** - GPU-accelerated terminal emulator
- Tokyo Night color scheme
- Fira Code Nerd Font (11pt)
- Optimized for performance
- Configuration: `~/.config/alacritty/alacritty.toml`

**Starship** - Modern, customizable prompt
- Tokyo Night theme with colored segments
- Git branch, status, and commit hash display
- Language version detection (Python, Node.js, etc.)
- Cloud/infrastructure context (Terraform, AWS)
- Battery status with color-coded indicators
- Smart directory truncation (up to 16 levels)
- Configuration: `~/.config/starship.toml`

**Eza** - Modern ls replacement with icons
- Custom theme with chezmoi-specific icons
- macOS-compatible (auto-symlinked)
- Git integration showing file status
- Tree view support
- Comprehensive aliases: `ls`, `ll`, `la`, `l`, `tree`, `lg`
- Configuration: `~/.config/eza/theme.yml`

**Zsh Plugins** - Enhanced shell experience
- **zsh-autosuggestions**: Fish-like suggestions as you type
- **zsh-syntax-highlighting**: Green for valid, red for invalid
- **zsh-completions**: Enhanced tab completions

### Customizing the Terminal

**Change Alacritty settings:**
```bash
chezmoi edit ~/.config/alacritty/alacritty.toml
chezmoi apply
```

**Customize Starship prompt:**
```bash
chezmoi edit ~/.config/starship.toml
chezmoi apply
```

**Modify eza theme:**
```bash
chezmoi edit ~/.config/eza/theme.yml
chezmoi apply
# Changes take effect immediately
```

## Customization

### Adding Aliases

Create or edit files in `.config/zsh/aliases/`:

```bash
# Edit existing alias files
chezmoi edit ~/.config/zsh/aliases/git.zsh

# Create new alias file
touch ~/.config/zsh/aliases/custom.zsh
# Add your aliases - they'll auto-load before next prompt!

# Apply changes
chezmoi apply
```

**Aliases reload automatically** before each prompt - no shell restart needed!

### Adding Environment Variables

Create or edit files in `.config/zsh/env/`:

```bash
# Edit existing env files
chezmoi edit ~/.config/zsh/env/tools.zsh

# Create new env file
touch ~/.config/zsh/env/custom.zsh
# Add your variables

# Apply changes
chezmoi apply
```

**Environment variables auto-reload** when files change (mtime tracking).

**Control load order** with numeric prefixes:
- `00-first.zsh` - Loads first
- `colors.zsh` - Loads alphabetically
- `99-last.zsh` - Loads last

### PATH Configuration

Modify `~/.config/zsh/env/00-path.zsh`:

```bash
chezmoi edit ~/.config/zsh/env/00-path.zsh

# Add new paths with deduplication:
path_prepend "$HOME/my-tools/bin"

chezmoi apply
```

The `path_prepend()` function prevents duplicates when env reloads.

### Machine-Specific Configs

**Option 1: .zshrc.local (untracked)**
```bash
# Create ~/.zshrc.local (not managed by chezmoi)
export WORK_API_KEY="secret-key"
export CUSTOM_PATH="/path/to/something"
```

**Option 2: chezmoi templates (tracked)**
```bash
# In any .zsh.tmpl file:
{{- if eq .machine_type "work" }}
export WORK_SPECIFIC="value"
{{- end }}
```

## Secrets Management

This setup uses **age encryption** for managing secrets (API keys, SSH keys, tokens).

### Quick Start

```bash
# Edit your secrets file (auto-encrypted)
chezmoi edit ~/.config/zsh/env/secrets.zsh

# Add your secrets (uncomment examples)
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."

# Apply changes (file encrypted automatically)
chezmoi apply
```

### What's Included

- ✅ age encryption pre-configured
- ✅ Age key: `~/.config/age/key.txt`
- ✅ Secrets template: `~/.config/zsh/env/secrets.zsh`
- ✅ Auto-loaded as environment variables
- ✅ Safety rules in `.chezmoiignore`

### Common Use Cases

**Encrypt SSH keys:**
```bash
chezmoi add --encrypt ~/.ssh/id_ed25519
chezmoi add ~/.ssh/id_ed25519.pub  # Public keys unencrypted
```

**Edit encrypted files:**
```bash
chezmoi edit ~/.ssh/config
chezmoi edit ~/.aws/credentials
```

**View decrypted content:**
```bash
chezmoi cat ~/.config/zsh/env/secrets.zsh
```

**⚠️ Important:** Backup `~/.config/age/key.txt` to your password manager!

### Full Documentation

See [SECRETS.md](SECRETS.md) for complete guide including:
- age key backup strategies
- Password manager integration (1Password, Bitwarden)
- Key rotation procedures
- Multi-machine setup
- Troubleshooting

## Git Hooks

### Automatic Hook Installation

All new and cloned repositories automatically get:

**Pre-commit Hook:**
- Runs pre-commit validation if `.pre-commit-config.yaml` exists
- Prevents commits to main/master by default
- Checks for large files, trailing whitespace, merge conflicts, etc.

**Post-checkout Hook:**
- Auto-cleans build artifacts when switching branches
- Auto-creates minimal `.pre-commit-config.yaml` if missing

### Configuration

Hooks are stored in `.git-template/hooks/` and automatically applied via:
```toml
# ~/.config/git/config
[init]
    templateDir = ~/.git-template
```

### Applying to Existing Repos

```bash
# Apply to all repos in current directory
git-init-existing

# Apply to specific directory
git-init-existing ~/code

# Apply to single repo
cd my-repo && cp ~/.git-template/hooks/* .git/hooks/
```

### Customizing Hooks

```bash
chezmoi edit ~/.git-template/hooks/post-checkout
chezmoi edit ~/.git-template/hooks/pre-commit
chezmoi apply

# Re-apply to existing repos
git-init-existing
```

## Advanced Features

### Templates

Use chezmoi templates for machine-specific configs:

```bash
# In any .tmpl file:
{{- if eq .machine_type "work" }}
export WORK_MODE=true
{{- else }}
export PERSONAL_MODE=true
{{- end }}

# Hostname-based:
{{- if eq .chezmoi.hostname "laptop" }}
export IS_LAPTOP=true
{{- end }}
```

### Scripts

Run scripts on specific events:
- `run_once_*.sh` - Run once ever
- `run_onchange_*.sh` - Run when file changes
- `run_before_*.sh` - Run before applying
- `run_after_*.sh` - Run after applying

Example: `run_onchange_before_install-packages.sh` auto-installs Brewfile packages.

### Adding More Packages

```bash
chezmoi edit ~/.Brewfile

# Add packages in appropriate sections:
# CLI tools
brew "neovim"

# GUI applications
cask "visual-studio-code"

# Mac App Store (requires mas)
mas "Xcode", id: 497799835

# Apply (auto-runs brew bundle)
chezmoi apply
```

## Useful Commands

```bash
# Status and inspection
chezmoi status           # Show changes
chezmoi managed          # List managed files
chezmoi diff             # Preview changes
chezmoi verify           # Verify state

# Editing
chezmoi edit <file>      # Edit managed file
chezmoi cd               # Go to source directory

# Applying changes
chezmoi apply            # Apply all changes
chezmoi apply --force    # Force re-apply
chezmoi update           # Pull and apply from git

# Helper commands
reload-aliases           # Reload aliases manually
reload-env               # Reload environment manually
git-init-existing        # Apply git hooks to existing repos
```

## Troubleshooting

### Aliases not updating
```bash
# Check if load-aliases.zsh is working
cat ~/.config/zsh/load-aliases.zsh

# Manually reload
reload-aliases

# Verify precmd hook
typeset -f precmd
```

### Environment variables not reloading
```bash
# Check if load-env.zsh is working
cat ~/.config/zsh/load-env.zsh

# Manually reload
reload-env

# Check mtime tracking
typeset -p _env_mtimes
```

### Git hooks not working
```bash
# Check template directory
ls -la ~/.git-template/hooks/

# Check git config
git config --global init.templateDir

# Re-apply to repo
git-init-existing
```

### Brewfile not installing packages
```bash
# Manually run brew bundle
cd ~ && brew bundle install

# Check for errors
brew doctor
```

### Config not applying
```bash
# See what would change
chezmoi diff

# Force re-apply
chezmoi apply --force
```

### Reset everything
```bash
# Remove chezmoi
rm -rf ~/.local/share/chezmoi

# Start fresh
chezmoi init --apply git@github.com:bradleyfay/dotfiles.git
```

## Why This Setup?

### Why chezmoi?
- **Templates** - Different configs for work vs personal machines
- **Secrets** - Encrypted secrets in your dotfiles
- **Scripts** - Automatic setup and updates
- **Cross-platform** - Works on macOS, Linux, Windows
- **State tracking** - Knows what's been applied
- **Industry standard** - Used by thousands of developers

### Why Homebrew Bundle?
- **Declarative** - All packages in one Brewfile
- **Comprehensive** - CLI tools, GUI apps, Mac App Store
- **Standard** - Industry standard for macOS
- **Automated** - Auto-installs on `chezmoi apply`

### What Makes This Special?
- **Auto-reload** - Aliases and environment variables update automatically
- **Git hooks** - Automatic pre-commit and post-checkout workflows
- **Modular** - Organized, numbered, and easy to extend
- **Encrypted** - Secrets management with age
- **Bootstrap** - One command to set up a new machine
- **Developer-focused** - Modern tools and thoughtful defaults

## Learn More

- [chezmoi documentation](https://www.chezmoi.io/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [Starship prompt](https://starship.rs/)
- [age encryption](https://github.com/FiloSottile/age)
- [My dotfiles on GitHub](https://github.com/bradleyfay/dotfiles)

## License

Free to use and modify. Your dotfiles, your rules.
