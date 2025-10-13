# GNU Stow Guide for This Dotfiles Repo

## What is Stow?

GNU Stow is a symlink farm manager that makes managing dotfiles dead simple. Instead of manually creating symlinks, stow automatically creates them based on your directory structure.

## How It Works

### Directory Structure

Stow uses "packages" - directories that mirror your home directory structure:

```
~/.dotfiles/
├── zsh/                    # Package name
│   ├── .zshrc             # Will symlink to ~/.zshrc
│   └── .config/
│       └── zsh/           # Will symlink to ~/.config/zsh/
│           ├── load-aliases.zsh
│           └── aliases/
│               ├── general.zsh
│               ├── git.zsh
│               └── navigation.zsh
```

When you run `stow zsh` from `~/.dotfiles/`, it creates:
- `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- `~/.config/zsh/` → `~/.dotfiles/zsh/.config/zsh/`

## Basic Commands

### Install a Package
```bash
cd ~/.dotfiles
stow zsh              # Creates all symlinks for the zsh package
```

### Remove a Package
```bash
cd ~/.dotfiles
stow -D zsh           # Removes all symlinks (but keeps files in .dotfiles)
```

### Reinstall (Update Symlinks)
```bash
cd ~/.dotfiles
stow -R zsh           # Removes old symlinks and creates new ones
```

### Dry Run (Preview)
```bash
cd ~/.dotfiles
stow -n -v zsh        # Shows what would happen without doing it
```

### Verbose Output
```bash
cd ~/.dotfiles
stow -v zsh           # Shows what it's doing
```

## Adding New Files

### Option 1: Create in Dotfiles First
```bash
# Create file in the package
echo "alias myalias='echo hi'" > ~/.dotfiles/zsh/.config/zsh/aliases/custom.zsh

# Restow to update symlinks (usually not needed, directory is already linked)
cd ~/.dotfiles && stow -R zsh
```

### Option 2: Move Existing Files
```bash
# You have an existing config file you want to manage
mv ~/.gitconfig ~/.dotfiles/git/.gitconfig

# Stow it
cd ~/.dotfiles && stow git
```

## Creating New Packages

Each package is a separate directory in `~/.dotfiles/`:

```bash
cd ~/.dotfiles

# Create a vim package
mkdir -p vim/.vim
echo "syntax on" > vim/.vimrc

# Stow it
stow vim

# Now ~/.vimrc and ~/.vim/ are symlinked!
```

### Example Packages You Might Create

```
~/.dotfiles/
├── zsh/              # Zsh configuration (already set up)
├── git/              # Git configuration
│   └── .gitconfig
├── vim/              # Vim configuration
│   ├── .vimrc
│   └── .vim/
├── tmux/             # Tmux configuration
│   └── .tmux.conf
├── alacritty/        # Alacritty terminal
│   └── .config/
│       └── alacritty/
└── vscode/           # VS Code settings
    └── .config/
        └── Code/
            └── User/
                └── settings.json
```

## Why Stow Is Better Than Manual Symlinks

### Before (Manual):
```bash
ln -sf ~/.dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/config/alacritty ~/.config/alacritty
# ... repeat for every file
# ... have to remember to remove old symlinks when restructuring
```

### After (Stow):
```bash
cd ~/.dotfiles && stow zsh alacritty
# Done! All symlinks created automatically
```

## Current Setup

This repository is now using stow! Current packages:

- **zsh** - Zsh configuration with dynamic alias loading

To install on a new machine:
```bash
git clone <your-repo> ~/.dotfiles
cd ~/.dotfiles
brew install stow
stow zsh
```

## Tips

### 1. One Package vs Many Packages

**Option A: One big package (simpler)**
```
~/.dotfiles/
└── home/
    ├── .zshrc
    ├── .gitconfig
    ├── .vimrc
    └── .config/
        └── alacritty/
```
`stow home` installs everything at once.

**Option B: Multiple packages (more flexible)** ✅ RECOMMENDED
```
~/.dotfiles/
├── zsh/
├── git/
├── vim/
└── alacritty/
```
`stow zsh git` installs only what you want.

### 2. Conflicts

If a file already exists and isn't a symlink, stow will error:
```bash
WARNING! stowing zsh would cause conflicts:
  * existing target is not a symlink: .zshrc
```

Solution:
```bash
# Back up the existing file
mv ~/.zshrc ~/.zshrc.backup

# Then stow
stow zsh
```

### 3. Unstow Before Restructuring

If you reorganize your dotfiles structure:
```bash
# Remove old symlinks
stow -D zsh

# Reorganize files
mv ~/.dotfiles/zsh/something ~/.dotfiles/zsh/somewhere-else

# Re-create symlinks
stow zsh
```

### 4. Check What's Stowed

Stow doesn't track what's installed, but you can check symlinks:
```bash
# See all symlinks in home pointing to dotfiles
find ~ -maxdepth 1 -type l -ls | grep dotfiles

# See all stowed files recursively
find ~ -type l -ls | grep dotfiles
```

## Integration with Git

Your `.gitignore` already has good rules. When you add new files:

```bash
cd ~/.dotfiles
git add zsh/
git commit -m "Add zsh configuration with dynamic aliases"
git push
```

On another machine:
```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
stow zsh
```

Done! All your configs are live.

## Troubleshooting

### "WARNING! stowing would cause conflicts"
A non-symlink file exists at the target location. Back it up and try again.

### Symlinks point to wrong location
Stow must be run from `~/.dotfiles/` (or use `-d` flag):
```bash
cd ~/.dotfiles && stow zsh  # Correct
stow -d ~/.dotfiles zsh     # Also correct
```

### Changes not reflected
If you stowed a directory (like `.config/zsh/`), new files inside are automatically visible through the symlink. No need to restow unless you add/remove top-level items.

### Want to see what stow will do?
```bash
stow -n -v zsh  # Dry run with verbose output
```

## Learn More

- Official docs: `man stow`
- Website: https://www.gnu.org/software/stow/
- Common patterns: Search "dotfiles stow" for inspiration

---

**Remember:** Stow is just a smart symlink creator. Your files stay in `~/.dotfiles/`, and symlinks point to them from `~/`.
