---
description: Generate a conventional commit message for staged changes
---

Generate a conventional commit message for the current staged changes.

Steps:
1. Run: `git diff --cached --stat` to see what's staged
2. Run: `git diff --cached` to see the actual changes
3. Analyze the changes and generate a commit message following conventional commits format

Format:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert

Consider:
$ARGUMENTS

Output only the commit message, ready to use.
