# Eza Configuration

Eza is a modern replacement for `ls` with better defaults, colors, and icons.

## Muscle Memory Protection

All common `ls` commands are aliased to `eza`:

```bash
ls      # Basic listing (with icons and colors)
ll      # Long format (like ls -l)
la      # Long format, all files (like ls -la)
l       # Long format, all files, human-readable (most common)
```

## Common Usage Patterns

### Basic Listing
```bash
ls          # List files (eza with icons)
ll          # Long format
la          # Long format with hidden files
l           # Long format, all files, human-readable
```

### Sorting
```bash
lt          # Sort by time (newest first)
ltr         # Sort by time, reversed (oldest first)
lS          # Sort by size (capital S)
```

### Tree Views
```bash
tree        # Tree view of directory structure
tree2       # Tree view, 2 levels deep
tree3       # Tree view, 3 levels deep
```

### Git Integration
```bash
lg          # Long format with git status
lga         # Long format, all files, with git status
```

### Specialized
```bash
lsd         # List only directories
lsf         # List only files
lx          # Extended listing (all metadata)
lr          # Recursive listing
lra         # Recursive listing with all files
```

## Features

- **Icons**: File type icons using Nerd Fonts
- **Colors**: Color-coded by file type
- **Git Status**: Show git status inline (modified, staged, etc.)
- **Directories First**: Directories listed before files
- **Human-Readable**: File sizes shown in human-readable format
- **Tree View**: Built-in tree view (no need for separate `tree` command)

## Escape Hatches

To use the original `ls` command:

```bash
\ls              # Bypass alias
/bin/ls          # Absolute path
command ls       # Use builtin
```

## Environment Variables

- `EZA_DEFAULT_OPTIONS`: Default options applied to all eza commands
- `EZA_ICON_SPACING`: Space between icon and filename (default: 2)

## Examples

```bash
# List files in current directory
ls

# Long format with all files
l

# List with git status
lg

# Tree view, 2 levels deep
tree2

# Sort by modification time (newest first)
lt

# List only directories
lsd
```

## Comparison to ls

| Old Command | New Alias | Description |
|-------------|-----------|-------------|
| `ls` | `ls` | Basic listing (now with icons) |
| `ls -l` | `ll` | Long format |
| `ls -la` | `la` | Long format with hidden files |
| `ls -lah` | `l` | Long format, all, human-readable |
| `ls -lt` | `lt` | Sort by time |
| `ls -ltr` | `ltr` | Sort by time, reversed |
| `ls -lS` | `lS` | Sort by size |
| `tree` | `tree` | Tree view |

## Custom Icons (theme.yml) - NOT WORKING ON macOS

**⚠️ Known Issue:** Filename-based icon mapping in `theme.yml` does not work on macOS as of eza v0.23.4.

While eza supports custom icon configuration through `theme.yml` (added in v0.19.2), the feature is broken on macOS. See: https://github.com/eza-community/eza/issues/1224

We've included a `theme.yml` file for potential future compatibility or Linux systems, but currently all `dot_*` files will show default icons on macOS.

**What we tried to configure** (doesn't work yet):
- `dot_zshrc` → 󰡯 (zsh icon)
- `dot_Brewfile` → 󱁤 (Homebrew icon)
- etc.

The file is at `~/.config/eza/theme.yml` for Linux/future use.

## Dependencies

- Requires Nerd Font (FiraCode Nerd Font installed)
- Installed via Homebrew: `brew install eza`
