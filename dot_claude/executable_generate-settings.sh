#!/usr/bin/env bash
# Generate settings.json from settings.jsonc (JSON with Comments)
# This strips comments and creates the actual settings.json file

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="${SCRIPT_DIR}/settings.jsonc"
OUTPUT="${SCRIPT_DIR}/settings.json"
BACKUP="${SCRIPT_DIR}/settings.json.backup"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Generating settings.json from settings.jsonc..."

# Check if input exists
if [[ ! -f "$INPUT" ]]; then
    echo "Error: settings.jsonc not found at $INPUT"
    exit 1
fi

# Backup existing settings.json
if [[ -f "$OUTPUT" ]]; then
    cp "$OUTPUT" "$BACKUP"
    echo -e "${YELLOW}Backed up existing settings.json to settings.json.backup${NC}"
fi

# Method 1: Try using jq (cleanest method)
if command -v jq &> /dev/null; then
    jq '.' "$INPUT" > "$OUTPUT" 2>/dev/null && {
        echo -e "${GREEN}✓ Generated settings.json using jq${NC}"
        exit 0
    }
fi

# Method 2: Strip comments manually (if jq not available)
echo "jq not found, using manual comment stripping..."

# Remove:
# - // comments (but not in strings)
# - /* */ block comments
# - Trailing commas before }
sed -e 's|//.*$||' \
    -e '/\/\*/,/\*\//d' \
    -e 's/,\s*\([}\]]\)/\1/g' \
    "$INPUT" | \
    # Remove empty lines
    grep -v '^[[:space:]]*$' > "$OUTPUT"

echo -e "${GREEN}✓ Generated settings.json${NC}"
echo ""
echo "Next steps:"
echo "  1. Review: cat $OUTPUT"
echo "  2. Apply: chezmoi apply"
echo "  3. Commit: cd ~/.local/share/chezmoi && git add -A && git commit"
