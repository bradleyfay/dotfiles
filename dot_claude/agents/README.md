# Global Claude Code Agents

This directory contains **global sub-agents** that are available in ALL Claude Code projects and sync across machines.

## What are Sub-Agents?

Sub-agents are specialized AI assistants that Claude can delegate tasks to. They have specific expertise, tool access, and instructions optimized for particular types of work.

**Benefits:**
- **Expertise**: Each agent is specialized for specific tasks
- **Consistency**: Same approach every time
- **Tool scoping**: Agents only access tools they need
- **Reusability**: Available across all projects

## Available Agents

### Development & Code Quality

**code-reviewer** - Expert code review specialist
- **Use when**: Reviewing code changes, PRs, or new implementations
- **Expertise**: Quality, security, best practices, bugs, performance
- **Tools**: Read, Grep, Glob, Bash
- **Example**: "Use the code-reviewer agent to review my authentication module"

**refactorer** - Code refactoring specialist
- **Use when**: Improving code structure without changing behavior
- **Expertise**: Extract methods, simplify, remove duplication, improve naming
- **Tools**: Read, Grep, Glob, Edit, Bash
- **Example**: "Have the refactorer agent improve my utils.py file"

**performance-optimizer** - Performance analysis and optimization
- **Use when**: Investigating slowness or optimizing for speed/efficiency
- **Expertise**: Profiling, algorithmic complexity, caching, database queries
- **Tools**: Read, Grep, Glob, Bash, WebSearch
- **Example**: "Use the performance-optimizer to analyze my data processing pipeline"

### Testing & Debugging

**test-generator** - Comprehensive test suite specialist
- **Use when**: Creating tests for functions, modules, or components
- **Expertise**: Unit tests, edge cases, integration tests, test frameworks
- **Tools**: Read, Grep, Glob, Write, Edit, Bash
- **Example**: "Have the test-generator create tests for my API endpoints"

**debugger** - Systematic debugging specialist
- **Use when**: Troubleshooting errors, investigating bugs, diagnosing issues
- **Expertise**: Root cause analysis, systematic investigation, error diagnosis
- **Tools**: Read, Grep, Glob, Bash, WebSearch
- **Example**: "Use the debugger agent to help me fix this memory leak"

### Documentation & Security

**docs-writer** - Technical documentation specialist
- **Use when**: Creating READMEs, API docs, guides, improving documentation
- **Expertise**: Clear writing, API documentation, tutorials, code comments
- **Tools**: Read, Grep, Glob, Write, Edit, Bash
- **Example**: "Have the docs-writer create API documentation for my library"

**security-auditor** - Security review and vulnerability detection
- **Use when**: Security audits, threat analysis, compliance reviews
- **Expertise**: Injection attacks, authentication, secrets, dependencies, OWASP
- **Tools**: Read, Grep, Glob, Bash, WebSearch
- **Example**: "Use the security-auditor to review my authentication code"

## How to Use Agents

### Automatic Delegation

Claude automatically delegates tasks based on your request:
```
"Review this code for security issues"
→ Claude may automatically use the security-auditor agent
```

### Explicit Invocation

You can explicitly request a specific agent:
```
"Use the code-reviewer agent to review src/auth.ts"
"Have the debugger agent help me troubleshoot this error"
"Ask the performance-optimizer to analyze this function"
```

### Task-Based Invocation

Describe what you want, and Claude will pick the right agent:
```
"I need tests for my new feature" → test-generator
"This code is slow" → performance-optimizer
"Help me fix this bug" → debugger
```

## Agent File Format

Agents are Markdown files with YAML frontmatter:

```markdown
---
name: agent-name
description: When this agent should be invoked (natural language)
tools: Read, Write, Bash  # Optional: limit tool access
model: sonnet  # Optional: opus, sonnet, haiku, or inherit
---

System prompt describing the agent's role, expertise, and approach.
```

**Key fields:**
- `name`: Lowercase, hyphen-separated identifier
- `description`: Natural language explanation of when to use this agent
- `tools`: Comma-separated list (limits what tools agent can use)
- `model`: Which model to use (sonnet recommended for most tasks)

## Creating New Agents

### Add a New Agent

1. Create the agent file:
```bash
vim ~/.claude/agents/my-agent.md
```

2. Add frontmatter and instructions:
```markdown
---
name: my-agent
description: Specialist in X. Use when doing Y.
tools: Read, Write
model: sonnet
---

You are an expert in X who helps with Y.

Your role:
1. Do this
2. Then that

Approach:
- Be specific
- Provide examples
```

3. Add to chezmoi and sync:
```bash
chezmoi add ~/.claude/agents/my-agent.md
chezmoi apply
cd ~/.local/share/chezmoi && git add -A && git commit && git push
```

4. Use it in any project:
```
"Use the my-agent to help me with X"
```

### Best Practices for Creating Agents

**Do:**
- Create focused, single-purpose agents
- Write detailed system prompts (explain methodology)
- Limit tool access to what's needed
- Include examples in the instructions
- Test the agent before committing
- Document when to use the agent

**Don't:**
- Make agents too general (defeats the purpose)
- Give agents unnecessary tool access
- Forget to update the description
- Create duplicate agents for similar tasks

## Agent Organization

**Global vs Project Agents:**

**Global agents** (`~/.claude/agents/`):
- Available in ALL projects
- Synced across machines via dotfiles
- General-purpose utilities
- Examples: code-reviewer, test-generator

**Project agents** (`.claude/agents/` in project):
- Only available in that project
- Team-shared (committed to project repo)
- Project-specific workflows
- Examples: deploy-agent, migration-runner

**Priority:** Project agents override global agents with the same name.

**Subdirectories:** Not currently supported by Claude Code. Use flat structure with descriptive names.

## Examples from This Collection

### Code Review
```bash
# Review specific file
"Use the code-reviewer to review src/auth/oauth.ts"

# Review recent changes
git diff main | pbcopy
"Code-reviewer: review these changes from my clipboard"
```

### Generate Tests
```bash
# Generate tests for a module
"Test-generator: create comprehensive tests for src/utils/parser.py"

# Add missing test cases
"Use test-generator to add edge case tests for my validation function"
```

### Debug Issues
```bash
# Investigate error
"Debugger: help me fix this TypeError in my API handler"

# Performance issue
"Performance-optimizer: why is this database query so slow?"
```

### Documentation
```bash
# Create README
"Docs-writer: create a README for this project"

# API documentation
"Use docs-writer to document my public API functions"
```

### Security Review
```bash
# Audit code
"Security-auditor: review my authentication implementation"

# Check for secrets
"Use security-auditor to scan for hardcoded credentials"
```

## Syncing with Dotfiles

This directory is managed by chezmoi and syncs across machines:

```bash
# Edit an agent
chezmoi edit ~/.claude/agents/code-reviewer.md

# Add a new agent
vim ~/.claude/agents/new-agent.md
chezmoi add ~/.claude/agents/new-agent.md

# Apply changes
chezmoi apply

# Commit and push
cd ~/.local/share/chezmoi
git add dot_claude/agents/
git commit -m "feat(claude): add new custom agent"
git push

# On another machine
chezmoi update  # Pull and apply changes
```

## Tips

### Effective Agent Use
- **Be specific** in your request so Claude picks the right agent
- **Provide context** - what are you trying to accomplish?
- **Review agent work** - agents can make mistakes too
- **Refine agents** - update based on experience

### Agent Naming
- Use descriptive names that indicate purpose
- Stick to lowercase with hyphens
- Make it obvious when to use the agent

### Performance
- Limit tool access to what's needed (faster execution)
- Use `sonnet` for most tasks (good balance)
- Use `opus` only for very complex analysis
- Use `haiku` for simple, fast tasks

## Troubleshooting

### Agent not being used
```bash
# Check agent file exists
ls ~/.claude/agents/

# Verify proper frontmatter
cat ~/.claude/agents/agent-name.md

# Try explicit invocation
"Use the agent-name agent to do X"
```

### Agent errors
- Check YAML frontmatter is valid (use `---` delimiters)
- Ensure `name` matches filename (without .md)
- Verify `tools` list uses correct tool names
- Check for typos in `model` field

## Resources

- [Claude Code Sub-Agents Documentation](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Agent SDK Reference](https://docs.claude.com/en/docs/claude-code/sdk/subagents)
- [Available Tools Reference](https://docs.claude.com/en/docs/claude-code/tools)
