# Claude Code Status Line Configurations

This directory contains various status line configurations for Claude Code. Each script provides a different level of information and visual style.

## Available Configurations

### 1. Basic (`basic.sh`)
Shows model name and current directory.
- **Example output**: `Claude 3.5 Sonnet in rallycal`
- **Use case**: Simple, clean status line

### 2. Comprehensive (`comprehensive.sh`)
Full-featured status line with cost tracking.
- **Example output**: `Claude 3.5 Sonnet | rallycal | 1247 tokens (62.4%) | ~$0.0037`
- **Features**:
  - Model name
  - Directory name
  - Token count and context usage percentage
  - Estimated cost based on token usage
- **Use case**: Detailed monitoring of usage and costs

### 3. Developer (`developer.sh`)
Git-focused status line with repository information.
- **Example output**: `rallycal [main*+?] | Claude 3.5 Sonnet`
- **Features**:
  - Directory name
  - Git branch with status indicators:
    - `*` = modified files
    - `+` = staged files
    - `?` = untracked files
    - `↑3 ↓1` = ahead/behind origin
  - Model name
- **Use case**: Development work with git repositories

### 4. Minimalist (`minimalist.sh`)
Ultra-simple status line showing only directory name.
- **Example output**: `rallycal`
- **Use case**: Clean, distraction-free interface

## How to Use

### Option 1: Direct command reference
Update your `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statuslines/basic.sh"
  }
}
```

### Option 2: Make scripts executable and use directly
```bash
chmod +x ~/.claude/statuslines/*.sh
```

Then reference without `bash`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statuslines/developer.sh"
  }
}
```

## Switching Between Configurations

To switch status lines, simply update the `command` field in your settings:

- **Basic**: `"command": "bash ~/.claude/statuslines/basic.sh"`
- **Comprehensive**: `"command": "bash ~/.claude/statuslines/comprehensive.sh"`
- **Developer**: `"command": "bash ~/.claude/statuslines/developer.sh"`
- **Minimalist**: `"command": "bash ~/.claude/statuslines/minimalist.sh"`

## Requirements

- `jq` - JSON processor (usually pre-installed on macOS)
- `bc` - Calculator (for comprehensive cost calculations)
- `git` - For developer status line features

## Customization

Feel free to modify these scripts or create your own. The input JSON structure provides:

- `session_id` - Unique session identifier
- `transcript_path` - Path to conversation transcript
- `cwd` - Current working directory
- `model.id` - Model identifier
- `model.display_name` - Human-readable model name
- `workspace.current_dir` - Current working directory path
- `workspace.project_dir` - Project root directory path
- `version` - Claude Code version
- `output_style.name` - Current output style

## Troubleshooting

If a status line isn't working:
1. Check that the script is executable: `ls -la ~/.claude/statuslines/`
2. Test the script manually: `echo '{"workspace":{"current_dir":"'$(pwd)'"},"model":{"display_name":"Test"}}' | bash ~/.claude/statuslines/basic.sh`
3. Check Claude Code logs for error messages
