# Global Claude Code Instructions

This file contains **global rules and context** that apply to all projects when using Claude Code. These are loaded automatically at the start of each session.

Think of this as your personal `.cursorrules` for Claude Code that follows you across all projects.

---

## Core Development Principles

### Code Quality Standards

- **Clarity over cleverness**: Write code that's easy to understand and maintain
- **Explicit over implicit**: Make intentions clear through naming and structure
- **Progressive enhancement**: Start simple, add complexity only when needed
- **Test-driven thinking**: Consider testability even if not writing tests immediately

### Communication Style

- **Be concise**: Get to the point quickly, provide details when asked
- **Show, don't just tell**: Provide code examples and concrete implementations
- **Explain trade-offs**: When multiple approaches exist, explain the pros/cons
- **Ask clarifying questions**: If requirements are ambiguous, ask before implementing

### Technical Preferences

#### Language & Framework Preferences

- **Python**: Use type hints, prefer `pathlib` over `os.path`, use f-strings
- **TypeScript**: Prefer strict mode, use explicit types, avoid `any`
- **JavaScript**: Modern ES6+, prefer `const` over `let`, avoid `var`
- **Bash**: Use `set -euo pipefail`, quote variables, check command existence
- **Git**: Conventional commits, clear commit messages, small focused commits

#### Tool Preferences

- **Package Managers**:
  - Python: `uv` (preferred), then `pip`, avoid system Python
  - Node: `pnpm` (preferred), then `npm`, rarely `yarn`
  - macOS: `brew` for system packages

- **Formatters & Linters**:
  - Python: `ruff` for both linting and formatting
  - TypeScript/JavaScript: `eslint` + `prettier`
  - Markdown: `markdownlint`

- **Testing**:
  - Python: `pytest`
  - TypeScript/JavaScript: `vitest` or `jest`

#### Code Style

- **Line length**: 88 characters for Python (Black standard), 100 for others
- **Indentation**: 2 spaces for JS/TS/JSON/YAML, 4 spaces for Python
- **Imports**: Group and sort (standard lib, third-party, local)
- **Documentation**: Docstrings for public APIs, inline comments for complex logic

---

## File & Directory Patterns

### What to Create

- Always create `.gitignore` for new projects
- Include `README.md` with setup instructions
- Add `CLAUDE.md` for project-specific context (you can help me write this)
- Include `.editorconfig` for consistent formatting

### What to Avoid

- Don't commit `node_modules/`, `venv/`, `__pycache__/`
- Don't commit secrets, API keys, or credentials
- Don't commit IDE-specific files (`.vscode/`, `.idea/`) unless team-agreed
- Don't commit build artifacts (`dist/`, `build/`, `*.pyc`)

### Project Structure Preferences

```
project/
├── src/              # Source code
├── tests/            # Test files
├── docs/             # Documentation
├── scripts/          # Utility scripts
├── .github/          # GitHub workflows
├── README.md
├── CLAUDE.md         # Project context for Claude Code
├── .gitignore
└── pyproject.toml    # or package.json, etc.
```

---

## Git & Version Control

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add OAuth2 login flow
fix(api): handle timeout errors gracefully
docs(readme): update installation instructions
refactor(utils): simplify error handling
```

### Branch Naming

- `main` or `master`: Production-ready code
- `feature/feature-name`: New features
- `fix/bug-description`: Bug fixes
- `refactor/component-name`: Refactoring work
- `docs/topic`: Documentation updates

---

## Security & Privacy

### Secret Management

- **Never** commit secrets to git
- Use environment variables for sensitive data
- Prefer `.env` files (gitignored) over hardcoded values
- Use secret management tools (1Password, age encryption) when needed
- Check for secrets before commits (pre-commit hooks)

### Permissions

- Request minimal permissions needed
- Explain why specific permissions are needed
- Respect file access boundaries
- Don't access files outside project without asking

---

## Communication & Workflow

### When Starting New Tasks

1. **Understand**: Ask clarifying questions if needed
2. **Plan**: Outline approach before coding
3. **Implement**: Write code with clear structure
4. **Verify**: Test or explain how to test
5. **Document**: Update relevant docs

### When Working on Existing Code

1. **Read first**: Understand existing patterns
2. **Match style**: Follow established conventions
3. **Preserve intent**: Don't change working code unnecessarily
4. **Test changes**: Verify nothing breaks
5. **Explain changes**: Document why, not just what

### When Things Go Wrong

- **Acknowledge**: Admit mistakes clearly
- **Explain**: What went wrong and why
- **Fix**: Provide corrected solution
- **Learn**: Avoid repeating the same error

---

## Special Contexts

### When Working in This Dotfiles Repo

- Use `chezmoi add` to manage new files
- Test changes before committing
- Document settings in READMEs
- Consider cross-platform compatibility
- Keep secrets encrypted with age

### When Working with AI/ML Projects

- Pin dependency versions
- Document model versions and training data
- Include reproducibility instructions
- Track experiments and metrics
- Consider compute costs in recommendations

### When Working with Web Projects

- Mobile-first responsive design
- Accessibility (WCAG AA minimum)
- Performance optimization (Core Web Vitals)
- Security headers and CSP
- Error handling and loading states

---

## Tool-Specific Guidance

### Claude Code Workflows

- **Use CLAUDE.md**: For project-specific context
- **Use slash commands**: When available (e.g., `/search`, `/explain`)
- **Leverage memory**: Reference previous context when relevant
- **Show diffs**: For file edits, show what changed and why
- **Commit often**: Small, focused commits are better

### Development Tools

- **VS Code**: Assume as default editor
- **Terminal**: Prefer zsh with modern tools (bat, eza, fzf)
- **Git**: Use semantic commits and clear messages
- **Package managers**: Follow user's installed tools

---

## Learning & Adaptation

### When I Don't Specify Something

- **Use your judgment**: Based on common best practices
- **Explain your choices**: Why you chose a specific approach
- **Ask if uncertain**: Better to clarify than assume

### When I Correct You

- **Update context**: Remember the correction for this project
- **Apply broadly**: If it's a general preference
- **Document**: Suggest adding to CLAUDE.md if project-specific

### Continuous Improvement

- Suggest better patterns when you see opportunities
- Point out potential issues proactively
- Share relevant best practices when appropriate
- Help me learn, don't just do the work

---

## Current Machine Context

**Platform**: macOS (Apple Silicon)
**Shell**: zsh with custom configuration
**Package Managers**: Homebrew, uv (Python), pnpm (Node)
**Editor**: VS Code
**Dotfiles**: Managed by chezmoi (this repo)

**Key Tools Available**:
- `bat` (better cat)
- `eza` (better ls)
- `fzf` (fuzzy finder)
- `ripgrep` (better grep)
- `fd` (better find)
- `delta` (better git diff)
- `zoxide` (better cd)
- `starship` (prompt)
- `gh` (GitHub CLI)

---

## Final Notes

This is a **living document**. As we work together:
- Suggest updates when patterns change
- Help me refine these rules
- Point out conflicts or ambiguities
- Adapt to project-specific needs

**Remember**: These are guidelines, not rigid rules. Use judgment, ask questions, and optimize for clarity and maintainability.
