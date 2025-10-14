# Claude Code Configuration

This directory contains your global Claude Code settings that are synced across machines.

## What's Managed by Dotfiles

**Shared Settings** (synced across machines):
- `settings.json` - Global Claude Code preferences
  - Status line configuration
  - Always thinking mode
  - Other global preferences
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

### Add/Edit Global Settings
```bash
# Edit the synced settings file
chezmoi edit ~/.claude/settings.json

# Apply changes
chezmoi apply
```

### Add/Edit Machine-Specific Settings
```bash
# Edit directly (not managed by chezmoi)
code ~/.claude/settings.local.json
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

## Example settings.json

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statuslines/comprehensive.sh"
  },
  "alwaysThinkingEnabled": true,
  "model": "claude-sonnet-4",
  "outputStyle": "Concise"
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
