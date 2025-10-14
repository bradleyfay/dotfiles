# Claude Code Configuration

This directory contains your global Claude Code settings and rules that are synced across machines.

## What's Managed by Dotfiles

**Shared Settings** (synced across machines):
- `settings.json` - Active settings (auto-generated from settings.jsonc)
- `settings.jsonc` - Settings with comments (EDIT THIS, not settings.json)
- `generate-settings.sh` - Script to generate settings.json from .jsonc
- `CLAUDE.md` - Global rules and context (like Cursor's .cursorrules)
- `commands/global/` - Global slash commands (available in ALL projects)
  - `/global/explain` - Explain code or concepts
  - `/global/review` - Code review
  - `/global/commit` - Generate conventional commits
  - `/global/debug` - Debugging help
  - `/global/refactor` - Refactoring suggestions
  - `/global/test` - Generate tests
  - `/global/optimize` - Performance optimizations
- `statuslines/` - Custom status line scripts
  - `comprehensive.sh` - Model, directory, tokens, context %, cost
  - `developer.sh` - Developer-focused info
  - `basic.sh` - Simple status line
  - `minimalist.sh` - Minimal info
  - Others as you create them

## What's NOT Managed (local only)

**Machine-Specific Settings** (stays local, not synced):
- `settings.local.json` - Per-machine permissions and preferences
  - Permissions (which tools Claude can use)
  - Output styles
  - Other machine-specific overrides

**Runtime Data** (never synced):
- `history.jsonl` - Conversation history
- `debug/` - Debug logs
- `downloads/` - Downloaded files
- `file-history/` - File access history
- `ide/` - IDE integration data
- `plugins/` - Plugin cache
- `projects/` - Project-specific data
- `shell-snapshots/` - Shell state snapshots
- `statsig/` - Analytics data
- `todos/` - Session todos

## Settings Hierarchy

Claude Code applies settings in this order (later overrides earlier):

1. **Managed/Enterprise settings** (system-wide policies)
2. **User settings** (`settings.json`) ← **Synced via dotfiles**
3. **Project settings** (`.claude/settings.json` in project)
4. **Local settings** (`settings.local.json`) ← **Not synced**
5. **Command-line arguments**

## Managing Settings

### Edit Settings (Recommended Method)

**Step 1: Edit the commented version**
```bash
# Edit settings.jsonc (has all options with comments)
chezmoi edit ~/.claude/settings.jsonc

# This file contains:
# - All available settings documented
# - Comments explaining each option
# - Commented-out examples
```

**Step 2: Generate settings.json**
```bash
# Generate the actual settings.json (strips comments)
cd ~/.claude
./generate-settings.sh

# Or manually:
# jq '.' settings.jsonc > settings.json
```

**Step 3: Apply and commit**
```bash
# Apply to your system
chezmoi apply

# Commit to dotfiles
cd ~/.local/share/chezmoi
git add dot_claude/settings.jsonc dot_claude/settings.json
git commit -m "Update Claude Code settings"
git push
```

### Quick Edit (Direct Method)
```bash
# Edit the active settings file directly
chezmoi edit ~/.claude/settings.json

# Apply changes
chezmoi apply
```

**Note:** Direct edits to settings.json will be overwritten if you regenerate from settings.jsonc

### Add/Edit Machine-Specific Settings
```bash
# Edit directly (not managed by chezmoi)
code ~/.claude/settings.local.json
```

### Add a New Slash Command
```bash
# Create the command in the global/ subdirectory
vim ~/.claude/commands/global/mycommand.md

# Add frontmatter and prompt:
# ---
# description: What this command does
# ---
#
# Your prompt here. Use $ARGUMENTS for user input.

# Add it to chezmoi
chezmoi add ~/.claude/commands/global/mycommand.md

# Apply
chezmoi apply

# Test it in any project
# /global/mycommand your arguments here
```

### Add a New Status Line Script
```bash
# Create the script
vim ~/.claude/statuslines/my-custom.sh

# Add it to chezmoi
chezmoi add ~/.claude/statuslines/my-custom.sh

# Update settings.json to use it
chezmoi edit ~/.claude/settings.json
# Set: "statusLine": { "command": "bash ~/.claude/statuslines/my-custom.sh" }

# Apply
chezmoi apply
```

## Current Configuration

**Active Status Line:** `comprehensive.sh`
- Shows: Model, directory, token count, context %, estimated cost

**Always Thinking:** Enabled
- Claude will use thinking tags for better reasoning

## Global Rules (CLAUDE.md)

The `CLAUDE.md` file in this directory contains **global rules and context** that apply to ALL projects when using Claude Code. It's like Cursor's `.cursorrules` but global.

**What to put in global CLAUDE.md:**
- Your coding style preferences
- Preferred tools and libraries
- Communication preferences
- Security and privacy guidelines
- General development principles

**What to put in project CLAUDE.md:**
- Project-specific context
- Architecture decisions
- API documentation
- Workflow instructions
- Team conventions

**Example workflow:**
```bash
# Edit global rules
chezmoi edit ~/.claude/CLAUDE.md

# Apply changes
chezmoi apply

# Now all new Claude Code sessions will have your rules loaded!
```

## Example Files

### settings.jsonc (with comments)
```jsonc
{
  // Model configuration
  "model": "claude-sonnet-4",  // Options: opus-4, sonnet-4, haiku-4

  // Enable extended thinking
  "alwaysThinkingEnabled": true,

  // Status line
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statuslines/comprehensive.sh"
  },

  // Output style
  // "outputStyle": "Concise",  // Options: Concise, Explanatory, Code-focused

  // Permissions (commented out - will prompt by default)
  // "permissions": {
  //   "allow": [
  //     "WebSearch",
  //     "Bash(git:*)"
  //   ]
  // }
}
```

### settings.json (auto-generated, no comments)
```json
{
  "model": "claude-sonnet-4",
  "alwaysThinkingEnabled": true,
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statuslines/comprehensive.sh"
  }
}
```

## Example settings.local.json

```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "Bash(brew:*)",
      "Bash(git:*)",
      "WebFetch(domain:docs.anthropic.com)"
    ],
    "deny": []
  },
  "outputStyle": "Explanatory"
}
```

## Tips

### Status Line Best Practices
- Keep output concise (< 100 chars ideally)
- Use `jq` to parse the input JSON
- Test with: `claude statusline` (if available)
- Make scripts executable: `chmod +x ~/.claude/statuslines/*.sh`

### Common Settings
```json
{
  // Model selection
  "model": "claude-sonnet-4",

  // Thinking mode
  "alwaysThinkingEnabled": true,

  // Output preferences
  "outputStyle": "Concise",  // or "Explanatory", "Code-focused"

  // Status line
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statuslines/comprehensive.sh"
  },

  // Hooks (optional)
  "hooks": {
    "onPromptSubmit": "echo 'Thinking...'",
    "onToolUse": "echo 'Using tool: $TOOL'"
  }
}
```

## Troubleshooting

### Status line not updating
```bash
# Check if script is executable
ls -la ~/.claude/statuslines/

# Make executable
chmod +x ~/.claude/statuslines/*.sh

# Test manually
echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/"}}' | \
  bash ~/.claude/statuslines/comprehensive.sh
```

### Settings not applying
```bash
# Check what chezmoi will do
chezmoi diff

# Apply changes
chezmoi apply -v

# Verify settings file
cat ~/.claude/settings.json
```

### Settings conflict
If both `settings.json` and `settings.local.json` have the same key, the local settings win.

## Resources

- [Claude Code Settings Documentation](https://docs.claude.com/en/docs/claude-code/settings)
- [Status Line Guide](https://docs.claude.com/en/docs/claude-code/status-line)
- [Permissions Reference](https://docs.claude.com/en/docs/claude-code/permissions)
