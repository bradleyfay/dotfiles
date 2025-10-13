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

## Useful Aliases

From `.config/zsh/aliases/`:

### Navigation
- `..` → `cd ..`
- `...` → `cd ../..`
- `....` → `cd ../../..`

### File Operations
- `ll` → `ls -alh`
- `la` → `ls -A`
- `l` → `ls -CF`

### Git
- `gs` → `git status`
- `ga` → `git add`
- `gc` → `git commit`
- `gp` → `git push`
- `gl` → `git log --oneline --graph --all`

### Modern Tools
- `cat` → `bat` (if installed)
- `ls` → `eza` (if installed)
- `find` → `fd` (if installed)
- `cd` → `z` (zoxide, if installed)

## Scripts

### Run on Brewfile change
- `run_onchange_before_install-packages.sh.tmpl`
  - Auto-installs packages when Brewfile changes
  - Runs `brew bundle install --global`

## Tips

1. **Use templates** for machine-specific configs
2. **Use secrets** for API keys and tokens
3. **Use scripts** for automated setup
4. **Commit often** to track changes
5. **Test on a fresh machine** to verify setup works

## Learn More

- Docs: https://www.chezmoi.io/
- User guide: https://www.chezmoi.io/user-guide/
- Reference: https://www.chezmoi.io/reference/
