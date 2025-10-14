#!/bin/bash
# Dotfiles Bootstrap Installation Script
# Inspired by UV's installer: https://astral.sh/uv/install.sh
#
# Usage:
#   curl -LsSf https://raw.githubusercontent.com/USERNAME/dotfiles/main/install.sh | sh
#
# Or inspect first:
#   curl -LsSf https://raw.githubusercontent.com/USERNAME/dotfiles/main/install.sh | less
#
# Environment Variables:
#   DOTFILES_REPO    - Override the git repository URL (default: auto-detected from GitHub)
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

    # Try to detect from the script URL if running via curl
    # This is a placeholder - you'll need to update with your actual repo
    warn "DOTFILES_REPO not set"
    echo ""
    echo "Please set your dotfiles repository URL:"
    echo "  export DOTFILES_REPO=git@github.com:USERNAME/dotfiles.git"
    echo "  # or"
    echo "  export DOTFILES_REPO=https://github.com/USERNAME/dotfiles.git"
    echo ""
    read -p "Enter your dotfiles repository URL: " repo_url

    if [[ -z "$repo_url" ]]; then
        error "Repository URL is required"
    fi

    DOTFILES_REPO="$repo_url"
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
    read -p "Select machine type [1]: " choice

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
        read -p "Reinitialize? This will backup existing config. [y/N]: " confirm
        if [[ "$confirm" != "y" ]]; then
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

# Apply chezmoi configuration
apply_chezmoi() {
    info "Applying dotfiles configuration..."

    # Set machine type if provided
    if [[ -n "$MACHINE_TYPE" ]]; then
        chezmoi state set --data "machine_type=$MACHINE_TYPE"
    fi

    # Apply dotfiles
    chezmoi apply

    success "Dotfiles applied"
}

# Install packages via Homebrew Bundle
install_packages() {
    if [[ "$PLATFORM" != "macos" ]]; then
        warn "Package installation via Homebrew Bundle is only supported on macOS"
        return
    fi

    info "Installing packages from Brewfile..."

    # Run brew bundle from the chezmoi source directory
    cd "$(chezmoi source-path)"

    if [[ ! -f "dot_Brewfile" ]]; then
        warn "Brewfile not found, skipping package installation"
        return
    fi

    # Create temporary Brewfile (remove 'dot_' prefix)
    cp dot_Brewfile /tmp/Brewfile

    # Install packages
    brew bundle install --file=/tmp/Brewfile

    # Cleanup
    rm /tmp/Brewfile

    success "Packages installed"
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
        read -p "Setup age encryption? [y/N]: " setup_age

        if [[ "$setup_age" == "y" ]]; then
            mkdir -p "$HOME/.config/age"
            chmod 700 "$HOME/.config/age"

            echo ""
            echo "Age Key Setup:"
            echo "  1) Generate new key (for first-time setup)"
            echo "  2) Restore existing key from backup"
            echo ""
            read -p "Select option [1]: " key_option

            case "$key_option" in
                2)
                    info "Please restore your age key to: ~/.config/age/key.txt"
                    read -p "Press Enter when done..."
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
                        read -p "Press Enter to continue..."
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

    echo "Useful commands:"
    echo "  chezmoi edit <file>    - Edit a managed file"
    echo "  chezmoi apply          - Apply changes"
    echo "  chezmoi update         - Pull and apply latest changes"
    echo "  reload-aliases         - Reload shell aliases"
    echo "  reload-env             - Reload environment variables"
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
