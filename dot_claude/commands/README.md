# Global Slash Commands

This directory contains **global slash commands** that are available in ALL Claude Code projects.

Commands are organized in the `global/` subdirectory to clearly differentiate them from project-specific commands.

## Available Commands

All commands are prefixed with `/global/` to distinguish them from project commands:

### Development
- `/global/explain` - Explain code, concepts, or files in detail
- `/global/review` - Code review with quality and best practices focus
- `/global/refactor` - Suggest refactoring improvements
- `/global/optimize` - Suggest performance optimizations
- `/global/test` - Generate comprehensive tests

### Git & Workflow
- `/global/commit` - Generate conventional commit messages for staged changes
- `/global/debug` - Systematic debugging help

## Using Slash Commands

In any Claude Code session, type:
```
/global/explain the authentication flow
/global/review src/auth.ts
/global/commit
/global/test this function
```

**Why `/global/` prefix?**
- Makes it immediately obvious these are global (not project-specific)
- Avoids naming conflicts with project commands
- Organized in folders for better structure

## Creating New Commands

### Add to Global Commands

1. Create a new `.md` file in the `global/` subdirectory:
```bash
vim ~/.claude/commands/global/mycommand.md
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
chezmoi add ~/.claude/commands/global/mycommand.md
chezmoi apply
cd ~/.local/share/chezmoi && git add -A && git commit && git push
```

4. Use it:
```
/global/mycommand your arguments here
```

### Create New Command Categories

You can create additional subdirectories for organization:
```bash
mkdir ~/.claude/commands/ai
vim ~/.claude/commands/ai/summarize.md    # Use as: /ai/summarize

mkdir ~/.claude/commands/devops
vim ~/.claude/commands/devops/deploy.md   # Use as: /devops/deploy
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

### Current Directory Structure
```
commands/
├── README.md
└── global/               ← All global commands here
    ├── explain.md        (/global/explain)
    ├── review.md         (/global/review)
    ├── commit.md         (/global/commit)
    ├── debug.md          (/global/debug)
    ├── refactor.md       (/global/refactor)
    ├── test.md           (/global/test)
    └── optimize.md       (/global/optimize)
```

You can add more categories as needed:
```
commands/
├── global/              ← General-purpose commands
├── ai/                  ← AI-specific commands
├── devops/              ← DevOps commands
└── git/                 ← Git-specific commands
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
/global/explain how zoxide initialization works in navigation.zsh
```

### Review Command
```
/global/review src/components/Header.tsx
```

### Commit Command
```
# After staging changes:
git add src/auth.ts
/global/commit added OAuth2 support
```

### Debug Command
```
/global/debug TypeError: Cannot read property 'map' of undefined in UserList component
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
