# VS Code Project Templates

These are template `.vscode/extensions.json` files for different project types.

## Usage

Copy the appropriate template to your project:

### Python Project
```bash
mkdir -p .vscode
cp ~/.config/vscode/templates/python-extensions.json .vscode/extensions.json
```

### DevOps/Container Project
```bash
mkdir -p .vscode
cp ~/.config/vscode/templates/devops-extensions.json .vscode/extensions.json
```

### Custom Mix
Combine templates or edit manually:
```bash
mkdir -p .vscode
cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "ms-python.python",
    "charliermarsh.ruff",
    "hashicorp.terraform"
  ]
}
EOF
```

## When You Open the Project

VS Code will prompt: *"This workspace has extension recommendations. Would you like to install them?"*

Click "Install All" and you're ready to work!
