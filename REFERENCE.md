# Quick Reference

## Essential Commands

### Daily Workflow
```bash
# Update from remote
chezmoi update

# Edit a file
chezmoi edit ~/.zshrc

# See changes
chezmoi diff

# Apply changes
chezmoi apply

# Status
chezmoi status
```

### Managing Files
```bash
# Add file to chezmoi
chezmoi add ~/.gitconfig

# Add directory
chezmoi add ~/.config/nvim -r

# Edit managed file
chezmoi edit ~/.zshrc

# Remove from management
chezmoi forget ~/.zshrc
```

### Git Operations
```bash
# Go to source directory
chezmoi cd

# Commit changes
git add .
git commit -m "Update"
git push

# Return
exit
```

### Package Management
```bash
# Edit Brewfile
chezmoi edit ~/.Brewfile

# Apply (auto-installs packages)
chezmoi apply

# Manual install
brew bundle install --global
```

## File Locations

- **chezmoi source:** `~/.local/share/chezmoi/`
- **Applied files:** `~/` (home directory)
- **Brewfile:** `~/.Brewfile`
- **zsh config:** `~/.zshrc` and `~/.config/zsh/`
- **starship config:** `~/.config/starship.toml`
- **eza config:** `~/.config/eza/theme.yml`
- **alacritty config:** `~/.config/alacritty/alacritty.toml`

## Naming Convention

chezmoi uses special prefixes:

- `dot_` → `.` (dotfiles)
- `private_` → no read permission for others
- `executable_` → executable permission
- `symlink_` → symbolic link
- `.tmpl` → template (processed)

Examples:
- `dot_zshrc` → `~/.zshrc`
- `dot_config/zsh/` → `~/.config/zsh/`
- `private_dot_ssh/` → `~/.ssh/` (private)
- `run_once_install.sh` → runs once

## Troubleshooting

### Check what would change
```bash
chezmoi diff
```

### Re-apply everything
```bash
chezmoi apply --force
```

### Verify configuration
```bash
chezmoi verify
```

### Debug
```bash
chezmoi apply --verbose --dry-run
```

### Reset
```bash
rm -rf ~/.local/share/chezmoi
chezmoi init --apply git@github.com:bradleyfay/dotfiles.git
```

## Zsh Plugins

Installed and configured via Homebrew:

### zsh-autosuggestions
- Fish-like autosuggestions based on history
- Gray suggestions appear as you type
- Accept with → (right arrow)
- Configuration: `~/.config/zsh/env/zsh-plugins.zsh`

### zsh-syntax-highlighting
- Highlights commands in real-time
- Green = valid command
- Red = invalid command
- Must be sourced last in `.zshrc`

### zsh-completions
- Additional completion definitions for many tools
- Added to fpath before compinit
- Enhances tab completion

## Useful Aliases

From `.config/zsh/aliases/`:

### Navigation
- `..` → `cd ..`
- `...` → `cd ../..`
- `....` → `cd ../../..`
- `~` → `cd ~`

### File Operations (eza)
- `ls` → `eza --icons` (with icons)
- `ll` → `eza -l` (long format)
- `la` → `eza -la` (long with hidden)
- `l` → `eza -lah` (most common)
- `lt` → `eza -l --sort=modified` (sort by time)
- `lS` → `eza -l --sort=size` (sort by size)
- `tree` → `eza --tree` (tree view)
- `lg` → `eza -l --git` (with git status)

### Git
- `gs` → `git status`
- `ga` → `git add`
- `gc` → `git commit`
- `gp` → `git push`
- `gl` → `git log --oneline --graph --all`

### Chezmoi
- `cm` → `chezmoi`
- `cma` → `chezmoi apply`
- `cmd` → `chezmoi diff`
- `cme` → `chezmoi edit`
- `cms` → `chezmoi status`
- `cmu` → `chezmoi update`
- `cmcd` → `chezmoi cd`

### VS Code
- `c` → `code .`
- `co` → `code .`

### Trash (safe rm)
- `trash` → Safe delete command
- `trash-list` → List trashed files
- `trash-restore` → Restore from trash
- `trash-empty` → Empty trash

## Scripts

### Run on Brewfile change
- `run_onchange_before_install-packages.sh.tmpl`
  - Auto-installs packages when Brewfile changes
  - Runs `brew bundle install --global`

### macOS-specific setup
- `run_onchange_after_setup-eza-theme-macos.sh.tmpl`
  - Creates symlink for eza theme on macOS
  - Links `~/.config/eza/theme.yml` → `~/Library/Application Support/eza/theme.yml`

## Tips

1. **Use templates** for machine-specific configs
2. **Use secrets** for API keys and tokens
3. **Use scripts** for automated setup
4. **Commit often** to track changes
5. **Test on a fresh machine** to verify setup works
6. **Use `chezmoi edit`** instead of editing files directly
7. **Always run `chezmoi apply`** after making changes in the source directory
8. **Check `chezmoi diff`** before applying to see what will change
9. **Use `.zshrc.local`** for machine-specific settings not tracked in git
10. **Aliases auto-reload** before each prompt (or manually with `reload-aliases`)

## Learn More

- Docs: https://www.chezmoi.io/
- User guide: https://www.chezmoi.io/user-guide/
- Reference: https://www.chezmoi.io/reference/
