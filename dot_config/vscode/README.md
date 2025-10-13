# VS Code Configuration

VS Code settings are managed by chezmoi and stored in `~/Library/Application Support/Code/User/`.

## Required Extensions

To fully utilize the configuration, install these extensions:

### Theme & Appearance
- **Tokyo Night** (`enkia.tokyo-night`) - Tokyo Night color theme matching terminal
  ```bash
  code --install-extension enkia.tokyo-night
  ```

### Currently Installed Extensions (from settings)
- **Material Icon Theme** (`PKief.material-icon-theme`) - File/folder icons
- **Markdown Lint** (`DavidAnson.vscode-markdownlint`) - Markdown formatting

## Terminal Configuration

The integrated terminal is configured to match Alacritty:
- **Font**: FiraCode Nerd Font, 11pt
- **Theme**: Tokyo Night colors
- **Cursor**: Block style with blinking
- **Behavior**: Copy on selection, right-click to paste
- **Shell**: zsh (default)

## Editing Configuration

To edit VS Code settings through chezmoi:
```bash
# Edit settings
cme ~/Library/Application\ Support/Code/User/settings.json

# Or edit and apply
cmea ~/Library/Application\ Support/Code/User/settings.json
```

## Key Features

- **Tokyo Night** color scheme across terminal and editor
- **Copy on selection** in terminal (like Alacritty)
- **Right-click paste** in terminal
- **Fira Code Nerd Font** with ligatures
- **10,000 line scrollback** in terminal
- **Blinking block cursor** in terminal
