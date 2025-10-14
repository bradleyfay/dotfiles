# Global Slash Commands

This directory contains **global slash commands** that are available in ALL Claude Code projects.

## Available Commands

### Development
- `/explain` - Explain code, concepts, or files in detail
- `/review` - Code review with quality and best practices focus
- `/refactor` - Suggest refactoring improvements
- `/optimize` - Suggest performance optimizations
- `/test` - Generate comprehensive tests

### Git & Workflow
- `/commit` - Generate conventional commit messages for staged changes
- `/debug` - Systematic debugging help

## Using Slash Commands

In any Claude Code session, type:
```
/explain the authentication flow
/review src/auth.ts
/commit
/test this function
```

## Creating New Commands

1. Create a new `.md` file in this directory:
```bash
vim ~/.claude/commands/mycommand.md
```

2. Add frontmatter and prompt:
```markdown
---
description: Brief description of what this command does
---

Your command prompt here.

Use $ARGUMENTS to reference user input.
Use $1, $2, etc. for positional arguments.
```

3. Add to chezmoi:
```bash
chezmoi add ~/.claude/commands/mycommand.md
chezmoi apply
cd ~/.local/share/chezmoi && git add -A && git commit && git push
```

## Command Format

### Basic Command
```markdown
---
description: Do something useful
---

Perform action on: $ARGUMENTS
```

### Command with Bash Integration
```markdown
---
description: Run a bash command and analyze output
---

```bash
git log --oneline -n 10
```
\`\`\`

Analyze the git history above and: $ARGUMENTS
```

### Namespaced Commands (subdirectories)
Create subdirectories for organization:
```
commands/
├── git/
│   ├── commit.md     (/git/commit)
│   └── review.md     (/git/review)
└── code/
    ├── review.md     (/code/review)
    └── refactor.md   (/code/refactor)
```

## Tips

1. **Keep commands focused**: One clear purpose per command
2. **Use descriptive names**: Make it obvious what the command does
3. **Include context**: Provide guidelines in the prompt
4. **Test before committing**: Try the command in different projects
5. **Document arguments**: Explain what $ARGUMENTS should contain

## Project-Specific vs Global

**Global commands** (`~/.claude/commands/`):
- Available in ALL projects
- Synced across machines via dotfiles
- General-purpose utilities

**Project commands** (`.claude/commands/` in project):
- Only available in that project
- Team-shared (committed to project repo)
- Project-specific workflows

## Examples from This Collection

### Explain Command
```
/explain how zoxide initialization works in navigation.zsh
```

### Review Command
```
/review src/components/Header.tsx
```

### Commit Command
```
# After staging changes:
git add src/auth.ts
/commit added OAuth2 support
```

### Debug Command
```
/debug TypeError: Cannot read property 'map' of undefined in UserList component
```

## Syncing with Dotfiles

This directory is managed by chezmoi and synced across machines:

```bash
# Edit a command
chezmoi edit ~/.claude/commands/explain.md

# Add a new command
vim ~/.claude/commands/newcmd.md
chezmoi add ~/.claude/commands/newcmd.md

# Apply changes
chezmoi apply

# Commit and push
cd ~/.local/share/chezmoi
git add dot_claude/commands/
git commit -m "Add new slash command"
git push
```

## Resources

- [Claude Code Slash Commands Documentation](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Command Examples](https://github.com/anthropics/claude-code-examples)
