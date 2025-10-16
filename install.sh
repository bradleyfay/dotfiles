#!/bin/bash
# Dotfiles Bootstrap Installation Script
# Inspired by UV's installer: https://astral.sh/uv/install.sh
#
# Usage:
#   # Run from within the dotfiles repo (auto-detects repo URL)
#   bash install.sh
#
#   # Or via curl (auto-detects from git remote or prompts)
#   curl -LsSf https://raw.githubusercontent.com/USERNAME/dotfiles/main/install.sh | sh
#
#   # Or inspect first:
#   curl -LsSf https://raw.githubusercontent.com/USERNAME/dotfiles/main/install.sh | less
#
# Environment Variables:
#   DOTFILES_REPO    - Override the git repository URL (default: auto-detected)
#   DOTFILES_BRANCH  - Override the branch to use (default: main)
#   MACHINE_TYPE     - Set machine type without prompting (personal/work)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_REPO="${DOTFILES_REPO:-}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
MACHINE_TYPE="${MACHINE_TYPE:-}"

# Logging functions
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            PLATFORM="macos"
            ;;
        Linux*)
            PLATFORM="linux"
            ;;
        *)
            error "Unsupported platform: $(uname -s)"
            ;;
    esac
    success "Detected platform: $PLATFORM"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Safely read from user input, with fallback for non-interactive environments
safe_read() {
    local prompt="$1"
    local varname="$2"
    local default="${3:-}"

    # Try to read from /dev/tty if available (interactive terminal)
    if [[ -t 0 ]] || [[ -c /dev/tty ]]; then
        read -p "$prompt" "$varname" < /dev/tty 2>/dev/null && return 0
    fi

    # Fallback: if not interactive and default is 'N' or empty, use default
    if [[ -z "$default" ]] || [[ "$default" == "N" ]] || [[ "$default" == "n" ]]; then
        eval "$varname='$default'"
        warn "Non-interactive mode: using default response"
        return 0
    fi

    # If we get here, we can't read input and have no safe default
    error "Cannot read input in non-interactive environment"
}

# Install Homebrew (macOS)
install_homebrew() {
    if [[ "$PLATFORM" != "macos" ]]; then
        return
    fi

    if command_exists brew; then
        success "Homebrew already installed"
        return
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    success "Homebrew installed"
}

# Install chezmoi
install_chezmoi() {
    if command_exists chezmoi; then
        success "chezmoi already installed"
        return
    fi

    info "Installing chezmoi..."

    if [[ "$PLATFORM" == "macos" ]]; then
        brew install chezmoi
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Use chezmoi's install script
        sh -c "$(curl -fsLS get.chezmoi.io)"
    fi

    success "chezmoi installed"
}

# Detect GitHub repository URL
detect_repo_url() {
    if [[ -n "$DOTFILES_REPO" ]]; then
        info "Using provided repository: $DOTFILES_REPO"
        return
    fi

    # Try to detect from current git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local detected_repo
        detected_repo=$(git remote get-url origin 2>/dev/null)
        if [[ -n "$detected_repo" ]]; then
            DOTFILES_REPO="$detected_repo"
            success "Auto-detected repository: $DOTFILES_REPO"
            return
        fi
    fi

    # Try to detect from chezmoi source path if available
    if command_exists chezmoi; then
        local chezmoi_source
        if chezmoi_source=$(chezmoi source-path 2>/dev/null); then
            if [[ -d "$chezmoi_source/.git" ]]; then
                (
                    cd "$chezmoi_source"
                    local chezmoi_repo
                    if chezmoi_repo=$(git remote get-url origin 2>/dev/null); then
                        if [[ -n "$chezmoi_repo" ]]; then
                            DOTFILES_REPO="$chezmoi_repo"
                            success "Auto-detected repository from chezmoi: $DOTFILES_REPO"
                            return
                        fi
                    fi
                )
            fi
        fi
    fi

    # Fallback: prompt for it
    warn "Could not auto-detect repository"
    echo ""
    echo "Please set your dotfiles repository URL:"
    echo "  export DOTFILES_REPO=git@github.com:USERNAME/dotfiles.git"
    echo "  # or"
    echo "  export DOTFILES_REPO=https://github.com/USERNAME/dotfiles.git"
    echo ""
    safe_read "Enter your dotfiles repository URL: " DOTFILES_REPO

    if [[ -z "$DOTFILES_REPO" ]]; then
        error "Repository URL is required"
    fi
}

# Prompt for machine type
prompt_machine_type() {
    if [[ -n "$MACHINE_TYPE" ]]; then
        info "Using provided machine type: $MACHINE_TYPE"
        return
    fi

    echo ""
    echo "Machine Type:"
    echo "  1) personal (default)"
    echo "  2) work"
    echo ""
    safe_read "Select machine type [1]: " choice "1"

    case "$choice" in
        2)
            MACHINE_TYPE="work"
            ;;
        *)
            MACHINE_TYPE="personal"
            ;;
    esac

    success "Machine type: $MACHINE_TYPE"
}

# Initialize chezmoi with dotfiles
init_chezmoi() {
    info "Initializing chezmoi with dotfiles..."

    # Check if chezmoi is already initialized
    if [[ -d "$HOME/.local/share/chezmoi/.git" ]]; then
        warn "chezmoi already initialized"
        safe_read "Reinitialize? This will backup existing config. [y/N]: " confirm "N"
        if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
            info "Skipping initialization"
            return
        fi
        # Backup existing
        mv "$HOME/.local/share/chezmoi" "$HOME/.local/share/chezmoi.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Initialize with the repository
    chezmoi init "$DOTFILES_REPO" --branch="$DOTFILES_BRANCH"

    success "chezmoi initialized"
}

# Verify that key configurations were applied
verify_application() {
    local issues=0

    echo ""
    info "Verifying application..."

    # Check .claude folder
    if [[ -d "$HOME/.claude" ]]; then
        success ".claude directory created"

        # Check for key subdirectories
        if [[ -d "$HOME/.claude/agents" ]]; then
            success ".claude/agents created"
        else
            warn ".claude/agents not found"
            ((issues++))
        fi

        if [[ -d "$HOME/.claude/commands" ]]; then
            success ".claude/commands created"
        else
            warn ".claude/commands not found"
            ((issues++))
        fi

        if [[ -d "$HOME/.claude/statuslines" ]]; then
            success ".claude/statuslines created"
        else
            warn ".claude/statuslines not found"
            ((issues++))
        fi

        if [[ -f "$HOME/.claude/settings.json" ]]; then
            success ".claude/settings.json created"
        else
            warn ".claude/settings.json not found"
            ((issues++))
        fi
    else
        warn ".claude directory not found!"
        ((issues++))
    fi

    echo ""
    if [[ $issues -gt 0 ]]; then
        warn "Found $issues potential issues during verification"
        echo ""
        echo "Troubleshooting:"
        echo "  1. Check chezmoi status: chezmoi status"
        echo "  2. Check what would be applied: chezmoi diff"
        echo "  3. Try applying again: chezmoi apply"
        echo "  4. Review: ~/.local/share/chezmoi/dot_claude"
    else
        success "All verifications passed!"
    fi
}

# Apply chezmoi configuration
apply_chezmoi() {
    info "Applying dotfiles configuration..."

    # Set machine type if provided
    if [[ -n "$MACHINE_TYPE" ]]; then
        chezmoi state set --bucket "install" --key "machine_type" --value "$MACHINE_TYPE"
    fi

    # Apply dotfiles with appropriate flags for interactive/non-interactive mode
    local apply_flags=""

    # In interactive mode, use verbose output; in non-interactive use quiet mode with TTY flags
    if [[ -t 0 ]] || [[ -c /dev/tty ]]; then
        apply_flags="-v"
    else
        # Non-interactive (piped) mode - suppress interactive features and auto-overwrite conflicts
        apply_flags="--no-pager --no-tty"
    fi

    # For idempotency, always allow overwriting managed files (they may have been edited externally)
    apply_flags="$apply_flags --force"

    if ! chezmoi apply $apply_flags; then
        error "Failed to apply dotfiles"
    fi

    success "Dotfiles applied"

    # Verify key directories were created
    verify_application
}

# Install packages via Homebrew Bundle
install_packages() {
    if [[ "$PLATFORM" != "macos" ]]; then
        warn "Package installation via Homebrew Bundle is only supported on macOS"
        return
    fi

    info "Installing packages from Brewfile..."

    # Brewfile should have been applied by chezmoi to ~/.Brewfile
    # But as fallback, also check the chezmoi source
    local brewfile_home="$HOME/.Brewfile"
    local brewfile_source

    if [[ ! -f "$brewfile_home" ]]; then
        # Try to find it in chezmoi source as fallback
        if source_path=$(chezmoi source-path 2>/dev/null); then
            brewfile_source="$source_path/dot_Brewfile"
            if [[ -f "$brewfile_source" ]]; then
                info "Found Brewfile in chezmoi source, copying to home..."
                cp "$brewfile_source" "$brewfile_home"
            else
                warn "Brewfile not found in either location, skipping package installation"
                return
            fi
        else
            warn "Could not locate Brewfile, skipping package installation"
            return
        fi
    fi

    # Run brew bundle from home directory with explicit file path
    # This ensures it processes all packages, taps, and casks correctly
    if (cd "$HOME" && brew bundle install --file="$brewfile_home"); then
        success "Packages installed successfully"
    else
        warn "Brew bundle installation had some issues"
        info "You can retry manually: brew bundle install --file=$brewfile_home"
    fi
}

# Setup age encryption (optional)
setup_age_encryption() {
    info "Checking age encryption setup..."

    if [[ ! -d "$HOME/.config/age" ]]; then
        echo ""
        echo "Age Encryption Setup:"
        echo "  Do you want to set up age encryption for secrets?"
        echo "  This is needed for SSH keys, API tokens, etc."
        echo ""
        safe_read "Setup age encryption? [y/N]: " setup_age "N"

        if [[ "$setup_age" == "y" ]] || [[ "$setup_age" == "Y" ]]; then
            mkdir -p "$HOME/.config/age"
            chmod 700 "$HOME/.config/age"

            echo ""
            echo "Age Key Setup:"
            echo "  1) Generate new key (for first-time setup)"
            echo "  2) Restore existing key from backup"
            echo ""
            safe_read "Select option [1]: " key_option "1"

            case "$key_option" in
                2)
                    info "Please restore your age key to: ~/.config/age/key.txt"
                    safe_read "Press Enter when done..." _dummy ""
                    if [[ -f "$HOME/.config/age/key.txt" ]]; then
                        chmod 600 "$HOME/.config/age/key.txt"
                        success "Age key restored"
                    else
                        warn "Age key not found, you can set it up later"
                    fi
                    ;;
                *)
                    if command_exists age-keygen; then
                        info "Generating new age key..."
                        age-keygen -o "$HOME/.config/age/key.txt"
                        chmod 600 "$HOME/.config/age/key.txt"

                        echo ""
                        success "Age key generated!"
                        warn "IMPORTANT: Backup this key to a secure location (password manager, encrypted USB, etc.)"
                        echo ""
                        echo "Public key (save this for chezmoi configuration):"
                        grep "public key:" "$HOME/.config/age/key.txt" || true
                        echo ""
                        safe_read "Press Enter to continue..." _dummy ""
                    else
                        warn "age not installed yet, skipping key generation"
                        info "After packages are installed, run: age-keygen -o ~/.config/age/key.txt"
                    fi
                    ;;
            esac
        fi
    else
        success "Age directory already exists"
    fi
}

# Post-installation message
print_completion_message() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║  ✓ Dotfiles installation complete!                        ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Restart your shell or run: source ~/.zshrc"
    echo "  2. Verify installation: chezmoi managed"
    echo "  3. Review documentation: cat ~/.local/share/chezmoi/README.md"
    echo ""

    if [[ -d "$HOME/.config/age" ]] && [[ ! -f "$HOME/.config/age/key.txt" ]]; then
        echo -e "${YELLOW}Age Encryption:${NC}"
        echo "  - Setup age key: age-keygen -o ~/.config/age/key.txt"
        echo "  - Configure chezmoi: chezmoi edit-config"
        echo "  - See: ~/.local/share/chezmoi/SECRETS.md"
        echo ""
    fi

    echo "Claude Code Configuration:"
    echo "  ~/.claude/                 - Claude Code settings and agents"
    echo "  ~/.claude/settings.json    - Global settings for Claude Code"
    echo "  ~/.claude/agents/          - Custom AI agents for specialized tasks"
    echo "  ~/.claude/commands/        - Global slash commands"
    echo "  ~/.claude/statuslines/     - Custom status line scripts"
    echo ""

    echo "Useful commands:"
    echo "  chezmoi edit <file>    - Edit a managed file"
    echo "  chezmoi apply          - Apply changes"
    echo "  chezmoi update         - Pull and apply latest changes"
    echo "  reload-aliases         - Reload shell aliases"
    echo "  reload-env             - Reload environment variables"
    echo ""
    echo "For Claude Code configuration details:"
    echo "  cat ~/.claude/README.md"
    echo ""
}

# Main installation flow
main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║          Dotfiles Bootstrap Installation                  ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Detect platform
    detect_platform

    # Install dependencies
    install_homebrew
    install_chezmoi

    # Get repository information
    detect_repo_url

    # Get machine configuration
    prompt_machine_type

    # Initialize and apply dotfiles
    init_chezmoi
    apply_chezmoi

    # Install packages
    install_packages

    # Setup encryption (optional)
    setup_age_encryption

    # Print completion message
    print_completion_message
}

# Run main installation
main
