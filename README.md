# Dotfiles (chezmoi + Homebrew Bundle)

Modern dotfiles management using [chezmoi](https://www.chezmoi.io/) for configuration files and [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) for application management.

## Features

- **chezmoi** - Intelligent dotfiles manager with templating, secrets, and cross-platform support
- **Homebrew Bundle** - Declarative package management via Brewfile
- **Automatic Package Installation** - Packages auto-install/update when Brewfile changes
- **Version Controlled** - All configs tracked in git
- **Consistent Across Machines** - Same tools and aliases everywhere
- **Modern CLI Tools** - Fast, Rust-based alternatives (ripgrep, fd, bat, eza, zoxide, fzf, dust, etc.)

## Quick Start

### First-Time Setup (New Machine)

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

### Daily Usage

#### Update dotfiles from remote
```bash
chezmoi update
```

#### Make changes to dotfiles
```bash
# Edit a file (opens in your $EDITOR)
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

#### Add new files to dotfiles
```bash
# Add a new config file
chezmoi add ~/.gitconfig

# Add a directory recursively
chezmoi add ~/.config/nvim --recursive
```

#### Manage packages
```bash
# Edit Brewfile
chezmoi edit ~/.Brewfile

# Apply changes (will auto-run brew bundle)
chezmoi apply
```

#### Push changes to GitHub
```bash
chezmoi cd           # Go to source directory
git add .
git commit -m "Update configs"
git push
exit                 # Return to previous directory
```

## What's Included

### Managed Files

- `.zshrc` - Shell configuration
- `.config/zsh/` - Modular zsh configs
  - `aliases/` - Organized aliases (general, git, navigation)
  - `env/` - Environment variables (colors, history, prompt)
  - `load-aliases.zsh` - Auto-reload alias system
  - `load-env.zsh` - Environment variable loader
- `.config/alacritty/` - Terminal configuration (Tokyo Night theme)
- `.config/starship.toml` - Prompt configuration (Tokyo Night with custom modules)
- `.Brewfile` - All your packages and applications

### Installed Tools (via Brewfile)

**Modern CLI Tools:**
- `ripgrep` (rg) - Better grep
- `fd` - Better find
- `bat` - Better cat with syntax highlighting
- `eza` - Better ls
- `zoxide` (z) - Smart cd that learns your habits
- `fzf` - Fuzzy finder
- `dust` - Better du (disk usage)
- `bottom` (btm) - Better top
- `procs` - Better ps
- `sd` - Better sed
- `hyperfine` - Benchmarking
- `tokei` - Code statistics

**Development Tools:**
- `git`, `jq`, `yq`
- `direnv` - Environment switcher
- `trash` - Safe rm alternative

**Shell & Terminal:**
- `starship` - Modern cross-shell prompt
- `alacritty` - GPU-accelerated terminal
- `font-fira-code-nerd-font` - Programming font with ligatures and icons
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-completions`

## Adding More Packages

Edit the Brewfile:
```bash
chezmoi edit ~/.Brewfile
```

Add packages in the appropriate section:
```ruby
# CLI tools
brew "neovim"

# GUI applications
cask "visual-studio-code"
cask "alacritty"

# Mac App Store (requires `brew install mas`)
mas "Xcode", id: 497799835
```

Apply changes:
```bash
chezmoi apply
```

chezmoi will automatically run `brew bundle install` when the Brewfile changes!

## Terminal Setup

### Alacritty + Starship

This setup includes a beautiful, fast terminal experience with:

**Alacritty** - GPU-accelerated terminal emulator
- Tokyo Night color scheme
- Fira Code Nerd Font (11pt)
- Optimized for performance
- Configuration: `~/.config/alacritty/alacritty.toml`

**Starship** - Modern, customizable prompt
- Tokyo Night theme with colored segments
- Shows git status when in a repository
- Displays language versions (Python, Node, Rust, Go, PHP)
- Virtual environment detection for Python
- Battery status and current time
- Smart directory path truncation
- Configuration: `~/.config/starship.toml`

**Features:**
- 🎨 Consistent Tokyo Night theme across terminal and prompt
- 🔤 Nerd Font icons for beautiful symbols
- 🚀 Fast and responsive
- 🔋 Battery indicator (with color-coded status)
- 🐍 Python virtual environment detection
- 🌳 Git branch and status when in repos
- 📁 Smart directory navigation with icon substitutions

### Customizing the Terminal

#### Change Alacritty colors or font:
```bash
chezmoi edit ~/.config/alacritty/alacritty.toml

# Modify font size, colors, or window settings
# Then apply
chezmoi apply
```

#### Customize Starship prompt:
```bash
chezmoi edit ~/.config/starship.toml

# Add/remove modules, change colors, or modify layout
# Changes apply immediately (live reload enabled)
```

#### Add more language modules:
Uncomment modules in `starship.toml`:
```toml
[docker_context]
symbol = " "
style = "bg:#212736"
format = '[[ $symbol $context ](fg:#769ff0 bg:#212736)]($style)'
```

#### Switch to a different Starship preset:
```bash
# List available presets
starship preset --list

# Preview a preset
starship preset <name>

# Apply a preset
starship preset <name> > ~/.config/starship.toml
```

### Troubleshooting Terminal Issues

#### Font icons not showing:
- Verify Fira Code Nerd Font is installed: `ls ~/Library/Fonts/ | grep Fira`
- Make sure Alacritty is using the correct font (check `alacritty.toml`)
- Restart Alacritty after font changes

#### Prompt not loading:
```bash
# Test Starship
starship --version

# Check if prompt.zsh exists
cat ~/.config/zsh/env/prompt.zsh

# Re-source zshrc
source ~/.zshrc
```

#### Colors look wrong:
- Ensure terminal is using true color
- Check Alacritty config opacity settings
- Verify Tokyo Night colors in `alacritty.toml`

## Customization

### Adding Aliases

Aliases are in `.config/zsh/aliases/`:

```bash
# Edit existing alias files
chezmoi edit ~/.config/zsh/aliases/general.zsh
chezmoi edit ~/.config/zsh/aliases/git.zsh
chezmoi edit ~/.config/zsh/aliases/navigation.zsh

# Create a new alias file
touch ~/.config/zsh/aliases/custom.zsh
# Add your aliases, they'll auto-load!

# Apply changes
chezmoi apply
source ~/.zshrc
```

### Adding Environment Variables

Environment variables are in `.config/zsh/env/`:

```bash
# Edit existing environment files
chezmoi edit ~/.config/zsh/env/colors.zsh
chezmoi edit ~/.config/zsh/env/history.zsh
chezmoi edit ~/.config/zsh/env/prompt.zsh

# Create a new environment file
chezmoi add ~/.config/zsh/env/development.zsh

# Add your environment variables
export EDITOR="code"
export VISUAL="code"
export PAGER="less"

# Apply changes
chezmoi apply
source ~/.zshrc
```

**Example use cases:**
- `development.zsh` - Editor, pager, and development tool configs
- `tools.zsh` - Tool-specific configurations
- `api-keys.zsh` - API keys (consider using chezmoi templates for secrets)

### Machine-Specific Configs

Use `.zshrc.local` for machine-specific settings (not tracked in git):

```bash
# In ~/.zshrc.local (create this file manually, not tracked)
export WORK_API_KEY="secret-key"
export OPENAI_API_KEY="sk-..."
export CUSTOM_PATH="/path/to/something"
```

Or use chezmoi templates for tracked machine-specific configs:
```bash
chezmoi edit --config
```

**Note:** The `.zshrc.local` file is automatically sourced if it exists, making it perfect for machine-specific environment variables, aliases, or configurations that shouldn't be committed to git.

## Advanced Usage

### Secrets Management

chezmoi has built-in secrets support:
```bash
# Store a secret
chezmoi secret set github_token

# Use in a template
# ~/.gitconfig.tmpl
[github]
    token = {{ (secret "github_token") }}
```

### Templates

Make configs machine-specific:
```bash
# Detect machine type and apply different configs
{{ if eq .chezmoi.hostname "work-laptop" }}
export WORK_MODE=true
{{ end }}
```

### Scripts

Run scripts on specific events:
- `run_once_*.sh` - Run once ever
- `run_onchange_*.sh` - Run when file changes
- `run_before_*.sh` - Run before applying
- `run_after_*.sh` - Run after applying

## Useful Commands

```bash
# Status of managed files
chezmoi status

# See what's managed
chezmoi managed

# Preview what would change
chezmoi diff

# Edit config file
chezmoi edit ~/.zshrc

# Go to source directory
chezmoi cd

# Re-apply all configs
chezmoi apply

# Update from git
chezmoi update

# Verify configs
chezmoi verify
```

## Troubleshooting

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

## Migration from GNU Stow

Already completed! ✅

The old `.dotfiles` directory with stow structure has been migrated to chezmoi format.

Old structure:
```
~/.dotfiles/
└── zsh/
    ├── .zshrc
    └── .config/zsh/
```

New structure:
```
~/.local/share/chezmoi/
├── dot_zshrc
├── dot_config/zsh/
└── dot_Brewfile
```

## Why chezmoi?

- **Templates** - Different configs for work vs personal machines
- **Secrets** - Encrypted secrets in your dotfiles
- **Scripts** - Automatic setup and updates
- **Cross-platform** - Works on macOS, Linux, Windows
- **State tracking** - Knows what's been applied
- **Industry standard** - Used by thousands of developers

## Why Homebrew Bundle?

- **Declarative** - All packages in one Brewfile
- **Comprehensive** - CLI tools, GUI apps, Mac App Store
- **Standard** - Industry standard for macOS
- **Automated** - Auto-installs on `chezmoi apply`

## Learn More

- [chezmoi documentation](https://www.chezmoi.io/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [My dotfiles on GitHub](https://github.com/bradleyfay/dotfiles)

## License

Free to use and modify. Your dotfiles, your rules.
