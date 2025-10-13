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
- `.config/zsh/` - Modular zsh configs with dynamic alias loading
  - `aliases/` - Organized aliases (general, git, navigation)
  - `load-aliases.zsh` - Auto-reload alias system
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

**Shell Enhancements:**
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

### Machine-Specific Configs

Use `.zshrc.local` for machine-specific settings (not tracked in git):

```bash
# In ~/.zshrc.local
export WORK_API_KEY="secret-key"
export OPENAI_API_KEY="sk-..."
```

Or use chezmoi templates for tracked machine-specific configs:
```bash
chezmoi edit --config
```

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
