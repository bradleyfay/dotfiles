# VS Code Configuration

VS Code settings are managed by chezmoi and stored in `~/Library/Application Support/Code/User/`.

## Quick Setup on New Machine

```bash
# Install global extensions
~/.config/vscode/install-extensions.sh

# Or install manually:
code --install-extension enkia.tokyo-night
code --install-extension eamodio.gitlens
# ... (see install-extensions.sh for full list)
```

## Extensions

### Global Extensions (install everywhere)

**Core Development:**
- `anthropic.claude-code` - Claude Code AI assistant
- `eamodio.gitlens` - Git supercharged

**Theme & Appearance:**
- `enkia.tokyo-night` - Tokyo Night theme matching terminal
- `pkief.material-icon-theme` - Material icons for files/folders
- `johnpapa.vscode-peacock` - Color workspace tabs (essential for multi-window workflow)

**Infrastructure as Code:**
- `hashicorp.terraform` - Terraform support (personal + work)

**Documentation & Writing:**
- `yzhang.markdown-all-in-one` - Markdown support
- `bierner.markdown-mermaid` - Mermaid diagrams in markdown preview

**Configuration Files:**
- `tamasfe.even-better-toml` - TOML language support

**AI Conversation Tracking:**
- `specstory.specstory-vscode` - SpecStory (saves AI conversations locally)
  - Requires CLI tool: `brew install specstoryai/tap/specstory`
  - Auto-saves conversations to `.specstory/` folder in projects

### Project-Specific Extensions

**Python Projects:**
- `ms-python.python` - Python language support
- `ms-python.vscode-pylance` - Python language server
- `ms-python.debugpy` - Python debugger
- `ms-python.mypy-type-checker` - Type checking
- `ms-python.vscode-python-envs` - Virtual environment management
- `charliermarsh.ruff` - Ruff linter/formatter (fast!)

**DevOps/Containers (when needed):**
- `ms-vscode-remote.remote-containers` - Dev Containers
- `ms-azuretools.vscode-containers` - Docker support
- `github.vscode-github-actions` - GitHub Actions

### Excluded Extensions

- `DavidAnson.vscode-markdownlint` - Too strict for LLM-generated markdown

## Terminal Configuration

The integrated terminal is configured to match Alacritty:
- **Font**: FiraCode Nerd Font, 11pt
- **Theme**: Tokyo Night colors (exact match)
- **Cursor**: Block style with blinking
- **Behavior**: Copy on selection, right-click to paste
- **Shell**: zsh (default)
- **Scrollback**: 10,000 lines

## Key Settings

- **Tokyo Night** color scheme across terminal and editor
- **Peacock** colors for multi-window identification
- **Word wrap** enabled for markdown (no strict linting)
- **Fira Code Nerd Font** with ligatures
- **Material Icon Theme** with custom associations for common project files

## Managing Configuration

### Edit Settings
```bash
# Edit settings through chezmoi
cme ~/Library/Application\ Support/Code/User/settings.json

# Edit and immediately apply
cmea ~/Library/Application\ Support/Code/User/settings.json

# Edit extensions recommendations
cme ~/Library/Application\ Support/Code/User/extensions.json
```

### Privacy Note
VS Code settings use `private_` prefix in chezmoi (restrictive permissions), but this is overridden in `.chezmoiattributes` to allow normal permissions. To make truly private again, remove the override line in `.chezmoiattributes`.
