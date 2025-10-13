# Dynamic Alias System

## Overview
Aliases are automatically reloaded before each prompt. Edit any `.zsh` file in this directory and your changes will be live after the next command completes.

## How It Works
- All `.zsh` files in this directory are sourced automatically
- The `precmd` hook reloads aliases before each prompt
- Changes appear after your next command finishes (not immediately during typing)

## Usage

### Add New Aliases
1. Create a new `.zsh` file or edit an existing one:
   ```bash
   echo "alias myalias='echo hello'" >> ~/.config/zsh/aliases/custom.zsh
   ```
2. Run any command - aliases will auto-reload before the next prompt
3. Alternatively, run `reload-aliases` to reload immediately

### Organize by Category
- `general.zsh` - Common system aliases (ll, la, etc.)
- `git.zsh` - Git shortcuts
- `navigation.zsh` - Directory navigation
- Create your own: `docker.zsh`, `python.zsh`, `work.zsh`, etc.

### Manual Reload
If you want immediate feedback:
```bash
reload-aliases
```

## Performance Modes

Edit `~/.config/zsh/load-aliases.zsh` to change behavior:

### Current: Option 2 - precmd (RECOMMENDED)
- Reloads before each prompt
- Good balance of convenience and performance
- ~1-2ms overhead per prompt

### Alternative: Option 1 - preexec
- Reloads before EVERY command
- Instant updates but ~2-5ms per command
- Uncomment `preexec()` and comment out `precmd()`

### Alternative: Option 3 - Manual only
- Zero overhead
- Must run `reload-aliases` manually
- Comment out both `preexec()` and `precmd()`

## Tips

1. **Keep files focused**: One category per file makes management easier
2. **Test before committing**: Bad syntax in an alias file will show errors on every prompt
3. **Use comments**: Document complex aliases
4. **Backup**: Consider adding `~/.config/zsh/aliases/` to your dotfiles repo

## Troubleshooting

### Aliases not updating?
```bash
reload-aliases  # Force immediate reload
```

### Error on every prompt?
Check for syntax errors:
```bash
for f in ~/.config/zsh/aliases/*.zsh; do zsh -n "$f" && echo "✓ $f" || echo "✗ $f"; done
```

### Want to see what's loaded?
```bash
alias | less  # Show all aliases
```
