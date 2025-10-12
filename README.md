# Dotfiles

A modular, script-based dotfiles management system following software engineering best practices: **Single Responsibility Principle**, **Composability**, and **Testability**.

## Features

- **Modular Scripts** - Small, single-responsibility scripts that do one thing well
- **Composable Architecture** - Scripts orchestrated by a main command
- **Machine-Specific Configs** - Different themes/configs for work vs personal
- **Modern Tools** - Alacritty terminal, Zellij multiplexer, Rust-based CLI tools
- **Shell Configuration** - Modular zsh/bash configs with clear separation of concerns
- **Git Sync** - Automated synchronization across machines
- **Package Management** - Declarative package lists via Brewfile
- **Idempotent** - Safe to run multiple times
- **Testable** - Each script can be tested independently

## Philosophy

> **"Small scripts, single responsibility, orchestrated by a main script"**

Each script in this repo does ONE thing. The main `dotfiles` command composes them together to create powerful workflows.

## Quick Start

### First-Time Setup (New Machine)

```bash
# Clone your dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install (interactive - will prompt for machine type)
./bin/dotfiles install
```

This will:
1. Detect machine type (work or personal)
2. Install Homebrew packages (Alacritty, Zellij, modern CLI tools)
3. Set up configs with appropriate theme
4. Create shell symlinks
5. You're ready to go!

### Daily Sync (Keep Machines in Sync)

```bash
cd ~/.dotfiles
./bin/dotfiles sync
```

This will:
1. Pull latest changes from git
2. Apply any config updates
3. Commit your local changes
4. Push to remote (with confirmation)

### Update Packages

```bash
./bin/dotfiles update
```

### Run Tests

```bash
./bin/dotfiles test
```

---

## Architecture

### Directory Structure

```
~/.dotfiles/
├── README.md                       # This file
├── REFERENCE.md                    # Quick reference guide
│
├── bin/                            # Entry point scripts (orchestrators)
│   ├── dotfiles                   # Main command (install, sync, update, test)
│   ├── detect-machine             # Detect work vs personal
│   ├── install-packages           # Install Homebrew packages
│   ├── setup-configs              # Setup config files
│   ├── sync-git                   # Git sync operations
│   └── test-dotfiles              # Test runner
│
├── scripts/                        # Implementation scripts
│   ├── packages/                  # Package definitions (Brewfile format)
│   │   ├── common.txt             # Common packages (all machines)
│   │   ├── work.txt               # Work-specific packages
│   │   └── personal.txt           # Personal-specific packages
│   │
│   ├── config/                    # Config management scripts
│   │   ├── backup-existing.sh     # Backup existing configs
│   │   ├── apply-templates.sh     # Apply machine-specific templates
│   │   └── link-configs.sh        # Create symlinks
│   │
│   ├── git/                       # Git operations
│   │   ├── pull-changes.sh        # Pull from remote
│   │   ├── commit-changes.sh      # Commit local changes
│   │   └── push-changes.sh        # Push to remote
│   │
│   └── lib/                       # Shared libraries
│       ├── colors.sh              # Color output functions
│       ├── logging.sh             # Logging utilities
│       └── checks.sh              # Prerequisite checks
│
├── shell/                          # Shell configuration
│   ├── .zshrc                     # Zsh entry point
│   ├── .bashrc                    # Bash entry point
│   ├── loader.sh                  # Modular config loader
│   ├── env/                       # Environment variables
│   ├── aliases/                   # Shell aliases
│   ├── functions/                 # Shell functions
│   └── config/                    # Tool-specific configs (fzf, zoxide, etc.)
│
└── config/                         # Application configs
    ├── alacritty/
    │   └── alacritty.toml.tmpl    # Templated (work vs personal themes)
    └── zellij/
        └── config.kdl              # Zellij multiplexer config
```

### Design Principles

1. **Single Responsibility** - Each script does ONE thing
2. **Composability** - Scripts are composed by orchestrators
3. **Testability** - Each script can be tested independently
4. **Idempotency** - Safe to run multiple times
5. **Discoverability** - Clear naming, good documentation

---

## Commands

### Main Command: `bin/dotfiles`

```bash
dotfiles install    # First-time setup on new machine
dotfiles sync       # Daily sync across machines
dotfiles update     # Update packages
dotfiles test       # Run all tests
```

### Individual Scripts (if needed)

```bash
bin/detect-machine       # Detect/show machine type
bin/install-packages     # Install packages only
bin/setup-configs        # Setup configs only
bin/sync-git [action]    # Git operations (pull, commit, push)
bin/test-dotfiles        # Run tests
```

---

## What Gets Installed

### Common Packages (All Machines)

**Terminal & Multiplexer:**
- Alacritty - Fast, GPU-accelerated terminal
- Zellij - Modern terminal multiplexer

**Modern CLI Tools (Rust-based):**
- eza - Better `ls`
- bat - Better `cat` with syntax highlighting
- ripgrep - Better `grep`
- fd - Better `find`
- zoxide - Smart `cd` that learns your habits
- fzf - Fuzzy finder
- dust - Better `du`
- bottom - Better `top`
- procs - Better `ps`

**Zsh Enhancements:**
- zsh-autosuggestions - Fish-like autosuggestions
- zsh-syntax-highlighting - Syntax highlighting as you type
- zsh-completions - Additional completions

**Development Tools:**
- git, jq, yq, tokei, hyperfine, direnv

See [scripts/packages/common.txt](scripts/packages/common.txt) for full list.

### Machine-Specific Packages

Add work or personal specific packages to:
- `scripts/packages/work.txt` - Work-specific tools
- `scripts/packages/personal.txt` - Personal-specific tools

---

## Machine-Specific Configs

### Work vs Personal Themes

**Alacritty** gets different color schemes:
- **Work:** Professional dark blue theme (#1e1e2e - Catppuccin)
- **Personal:** Fun purple theme (#1a1b26 - Tokyo Night)

**Zellij** uses the same config (keybindings are universal)

### How It Works

1. Run `bin/detect-machine` (once, interactive)
2. Stores machine type in `.machine_type` (gitignored)
3. Templates apply appropriate theme based on machine type
4. Configs synced via git, but each machine gets correct theme

---

## Shell Configuration

The shell configuration is already excellent and modular - kept as-is!

### Features

- **Shell-agnostic** - Works with both zsh and bash
- **Modular loader** - Automatically sources all configs
- **Conditional loading** - Only loads configs for installed tools
- **Local overrides** - `.zshrc.local` for machine-specific secrets

### Entry Points

- Zsh: `~/.zshrc` → symlinks to `~/.dotfiles/shell/.zshrc`
- Bash: `~/.bashrc` → symlinks to `~/.dotfiles/shell/.bashrc`

Both load the modular `shell/loader.sh` which sources:
1. Environment variables (`env/`)
2. Shell functions (`functions/`)
3. Aliases (`aliases/`)
4. Tool configs (`config/`)
5. Completions (`completions/`)

### Local Overrides

Create `~/.zshrc.local` for machine-specific settings:
```bash
# API keys, tokens, work-specific configs
export GITHUB_TOKEN="your-token"
export OPENAI_API_KEY="your-key"
```

This file is never committed (in `.gitignore`).

---

## Adding Your Own Scripts

### Example: Add a Custom Utility

1. Create script in `bin/` or `scripts/`:
   ```bash
   #!/usr/bin/env bash
   # my-script - Does something useful

   set -e
   DOTFILES_DIR="${HOME}/.dotfiles"
   source "${DOTFILES_DIR}/scripts/lib/colors.sh"

   print_info "Doing something..."
   # Your logic here
   print_success "Done!"
   ```

2. Make it executable:
   ```bash
   chmod +x bin/my-script
   ```

3. Use it:
   ```bash
   bin/my-script
   ```

---

## Testing

Each script can be tested independently:

```bash
# Test syntax
bash -n bin/script-name

# Debug execution
bash -x bin/script-name

# Run specific test
bin/test-dotfiles
```

---

## Customization

### Add Packages

Edit package lists in `scripts/packages/`:

```bash
# Common packages (all machines)
vim scripts/packages/common.txt

# Work-specific
vim scripts/packages/work.txt

# Personal-specific
vim scripts/packages/personal.txt
```

Then run: `bin/dotfiles update`

### Add Aliases

Add to appropriate file in `shell/aliases/`:

```bash
# Add to shell/aliases/custom.sh
alias myalias='echo "Hello"'
```

Reload shell: `source ~/.zshrc`

### Add Functions

Create in `shell/functions/`:

```bash
# shell/functions/myfunction.sh
myfunction() {
    echo "My function"
}
```

### Modify Configs

Edit configs in `config/`:
- `config/alacritty/alacritty.toml.tmpl` - Alacritty config
- `config/zellij/config.kdl` - Zellij config

Run `bin/dotfiles sync` to apply changes.

---

## Troubleshooting

### Homebrew Not Installed

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Script Not Executable

```bash
chmod +x bin/script-name
```

### Check Logs

```bash
tail ~/.dotfiles/.dotfiles.log
```

### Debug Mode

```bash
DOTFILES_DEBUG=1 bin/dotfiles install
```

### Test Individual Components

```bash
# Test machine detection
bin/detect-machine

# Test package installation
bin/install-packages

# Test shell loader
DOTFILES_DEBUG=1 source shell/loader.sh
```

---

## Tools Included

### Terminal Stack
- **Alacritty** - GPU-accelerated terminal emulator
- **Zellij** - Modern terminal multiplexer with on-screen hints
- **Zsh** - Shell with excellent plugins and completions

### Modern CLI Tools
All Rust-based, fast, with better UX than traditional Unix tools:
- `eza` (ls), `bat` (cat), `ripgrep` (grep), `fd` (find)
- `zoxide` (smart cd), `fzf` (fuzzy finder), `dust` (du)
- `bottom` (top), `procs` (ps), `sd` (sed)

### Development Tools
- Git, jq, yq, tokei, hyperfine, direnv

---

## Philosophy & Design

This project follows these principles:

1. **Simplicity** - Bash scripts over complex tools
2. **Modularity** - Small, focused scripts
3. **Testability** - Each component tested independently
4. **Composability** - Scripts orchestrated, not monolithic
5. **Clarity** - Obvious what each script does

**Why not Ansible/Chef/Puppet?**
- Over-engineered for managing personal laptops
- Not purpose-built for dotfiles
- Complex dependencies and learning curves
- Simple bash scripts are more maintainable

---

## Learn More

- **[REFERENCE.md](REFERENCE.md)** - Quick reference for all commands, scripts, and file locations

---

## License

Free to use and modify. This is YOUR dotfiles system.
