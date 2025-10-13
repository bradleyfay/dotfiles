#!/bin/bash
# Setup VS Code extension recommendations for a project
# Run this in a project directory to add .vscode/extensions.json

set -e

SCRIPT_DIR="$HOME/.config/vscode/templates"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}VS Code Project Extension Setup${NC}"
echo ""
echo "This will create .vscode/extensions.json in the current directory."
echo "Current directory: $(pwd)"
echo ""

# Check if .vscode/extensions.json already exists
if [ -f ".vscode/extensions.json" ]; then
    echo -e "${YELLOW}Warning: .vscode/extensions.json already exists!${NC}"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Prompt for project type
echo "Select project type:"
echo "  1) Python"
echo "  2) DevOps/Containers"
echo "  3) Both (Python + DevOps)"
echo "  4) Custom (choose specific extensions)"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        # Python project
        mkdir -p .vscode
        cp "$SCRIPT_DIR/python-extensions.json" .vscode/extensions.json
        echo -e "${GREEN}✓${NC} Created .vscode/extensions.json with Python extensions"
        ;;
    2)
        # DevOps project
        mkdir -p .vscode
        cp "$SCRIPT_DIR/devops-extensions.json" .vscode/extensions.json
        echo -e "${GREEN}✓${NC} Created .vscode/extensions.json with DevOps extensions"
        ;;
    3)
        # Both Python and DevOps
        mkdir -p .vscode
        cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.debugpy",
    "ms-python.mypy-type-checker",
    "ms-python.vscode-python-envs",
    "charliermarsh.ruff",
    "ms-vscode-remote.remote-containers",
    "ms-azuretools.vscode-containers",
    "github.vscode-github-actions"
  ]
}
EOF
        echo -e "${GREEN}✓${NC} Created .vscode/extensions.json with Python + DevOps extensions"
        ;;
    4)
        # Custom selection
        mkdir -p .vscode
        echo ""
        echo "Select extensions to include (y/n for each):"

        EXTENSIONS=()

        # Python extensions
        read -p "Python language support? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("ms-python.python" "ms-python.vscode-pylance" "ms-python.debugpy")
        fi

        read -p "Python type checking (mypy)? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("ms-python.mypy-type-checker")
        fi

        read -p "Python virtual env management? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("ms-python.vscode-python-envs")
        fi

        read -p "Ruff (Python linter/formatter)? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("charliermarsh.ruff")
        fi

        # DevOps extensions
        read -p "Dev Containers? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("ms-vscode-remote.remote-containers")
        fi

        read -p "Docker support? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("ms-azuretools.vscode-containers")
        fi

        read -p "GitHub Actions? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            EXTENSIONS+=("github.vscode-github-actions")
        fi

        # Build JSON file
        if [ ${#EXTENSIONS[@]} -eq 0 ]; then
            echo -e "${YELLOW}No extensions selected. Cancelled.${NC}"
            exit 0
        fi

        echo "{" > .vscode/extensions.json
        echo '  "recommendations": [' >> .vscode/extensions.json

        for i in "${!EXTENSIONS[@]}"; do
            if [ $i -eq $((${#EXTENSIONS[@]} - 1)) ]; then
                # Last item, no comma
                echo "    \"${EXTENSIONS[$i]}\"" >> .vscode/extensions.json
            else
                echo "    \"${EXTENSIONS[$i]}\"," >> .vscode/extensions.json
            fi
        done

        echo "  ]" >> .vscode/extensions.json
        echo "}" >> .vscode/extensions.json

        echo -e "${GREEN}✓${NC} Created .vscode/extensions.json with custom extensions"
        ;;
    *)
        echo "Invalid choice. Cancelled."
        exit 1
        ;;
esac

echo ""
echo "Extensions added:"
cat .vscode/extensions.json | grep '"' | grep -v recommendations | sed 's/.*"\(.*\)".*/  - \1/'
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Open this project in VS Code"
echo "2. VS Code will prompt: 'Install recommended extensions?'"
echo "3. Click 'Install All' to get set up quickly"
echo ""
echo "Or install manually: code --install-extension <extension-id>"
