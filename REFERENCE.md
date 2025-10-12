# Dotfiles Reference

Quick reference for understanding the dotfiles structure.

## Directory Structure

```
.dotfiles/
├── bin/                    # Executable commands
├── scripts/
│   ├── lib/               # Shared utilities
│   ├── config/            # Config management scripts
│   ├── git/               # Git sync scripts
│   └── packages/          # Brewfile package lists
├── config/                # Application configs
│   ├── alacritty/
│   └── zellij/
└── shell/                 # Shell configuration
    ├── env/               # Environment variables
    ├── aliases/           # Command aliases
    ├── functions/         # Shell functions
    ├── config/            # Tool configs
    └── completions/       # Tab completions
```

## Main Commands (bin/)

| Command | Purpose |
|---------|---------|
| `dotfiles install` | First-time setup: detect machine, install packages, setup configs |
| `dotfiles sync` | Daily sync: pull → setup → commit → push |
| `dotfiles update` | Update all packages via Homebrew |
| `dotfiles test` | Run validation tests (24 tests) |
| `detect-machine` | Detect work vs personal (interactive first time) |
| `install-packages` | Install Homebrew packages from lists |
| `setup-configs` | Backup → template → symlink configs |
| `sync-git` | Git operations (pull/commit/push) |
| `test-dotfiles` | Comprehensive validation suite |

## Library Scripts (scripts/lib/)

Shared utilities used by all scripts:

- **colors.sh** - Color output functions (`print_info`, `print_success`, `print_error`)
- **logging.sh** - File + console logging (`log_info`, `log_success`)
- **checks.sh** - Validation functions (`command_exists`, `check_homebrew`)

## Config Scripts (scripts/config/)

Called by `bin/setup-configs`:

- **backup-existing.sh** - Backs up existing configs to `~/.dotfiles_backups/`
- **apply-templates.sh** - Replaces `{{MACHINE_TYPE}}` and theme colors in templates
- **link-configs.sh** - Creates symlinks: `config/* → ~/.config/*`

## Git Scripts (scripts/git/)

Called by `bin/sync-git`:

- **pull-changes.sh** - Pull from remote with rebase
- **commit-changes.sh** - Auto-commit with timestamp + file list
- **push-changes.sh** - Push to remote (interactive confirmation)

## Package Lists (scripts/packages/)

Brewfile format for declarative package management:

- **common.txt** - Installed on all machines (terminal, CLI tools, zsh plugins)
- **work.txt** - Work-specific packages only
- **personal.txt** - Personal-specific packages only

## Configurations (config/)

### Alacritty (Terminal)

- **alacritty.toml.tmpl** - Template with placeholders
  - `{{MACHINE_TYPE}}` → "work" or "personal"
  - `#1e1e2e` → Work theme (Catppuccin Mocha)
  - `#1a1b26` → Personal theme (Tokyo Night)
- **alacritty.toml** - Generated output (symlinked to `~/.config/alacritty/`)

### Zellij (Multiplexer)

- **config.kdl** - Static config (no templating needed)
  - Vim-like keybindings (hjkl)
  - Mouse support, copy on select
  - Catppuccin theme

## Shell System (shell/)

Modular shell configuration loaded by `shell/loader.sh`:

1. **env/** - Environment variables (PATH, EDITOR, XDG dirs)
2. **functions/** - Reusable shell functions
3. **aliases/** - Command shortcuts (ls → eza, cat → bat)
4. **config/** - Tool-specific configs (fzf, zoxide)
5. **completions/** - Tab completion scripts

**Entry points:**
- `shell/.zshrc` → symlinked to `~/.zshrc`
- `shell/.bashrc` → symlinked to `~/.bashrc`
- Both source `loader.sh` then `~/.{zsh,bash}rc.local`

## Generated Files (gitignored)

- `.machine_type` - Stores "work" or "personal" (cached detection result)
- `.dotfiles.log` - Timestamped log of all operations
- `.dotfiles_backups/` - Timestamped config backups

## Common Workflows

### First Time Setup
```bash
./bootstrap.sh          # Check prereqs, create symlinks
dotfiles install        # Detect machine, install packages, setup configs
```

### Daily Sync
```bash
dotfiles sync           # Pull → setup → commit → push
```

### Add Packages
Edit `scripts/packages/common.txt` (or work/personal), then:
```bash
dotfiles update
```

### Change Machine Type
```bash
rm .machine_type
dotfiles install
```

### Customize Configs
- Edit templates: `config/alacritty/alacritty.toml.tmpl`
- Apply changes: `bin/setup-configs`

### Machine-Specific Settings
Add to `~/.zshrc.local` (not tracked in git):
```bash
export SECRET_KEY="..."
alias work-vpn="..."
```

## Architecture Principles

1. **Single Responsibility** - Each script does one thing
2. **Composability** - Scripts orchestrated by higher-level commands
3. **Idempotency** - Safe to run multiple times
4. **Machine-Specific** - Work vs personal themes/packages
5. **Git-Centric** - Git is source of truth, syncs across machines

## File Naming Conventions

- `bin/*` - No extension, executable commands
- `scripts/**/*.sh` - Implementation scripts (not run directly)
- `*.tmpl` - Template files (processed by `apply-templates.sh`)
- `*.txt` - Brewfile package lists
- `.*rc` - Shell runtime configs
