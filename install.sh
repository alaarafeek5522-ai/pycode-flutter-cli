
---

### الملف رقم 3: `install.sh`

```bash
#!/bin/bash
# PY_Code Flutter CLI - Installation Script
# GitHub: https://github.com/alaarafeek5522-ai/pycode-flutter-cli

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_step() { echo -e "${CYAN}→${NC} $1"; }
print_header() { echo ""; echo -e "${BOLD}${CYAN}$1${NC}"; echo "─────────────────────────────────────"; }

PYCODE_HOME="${HOME}/.pycode"
REPO_URL="https://github.com/alaarafeek5522-ai/pycode-flutter-cli.git"
BRANCH="main"

print_header "🚀 PY_Code Flutter CLI Installer"
echo -e "${DIM}The Ultimate CLI for Mobile Developers on Termux${NC}"
echo ""

# Check if running in Termux
if [[ -z "$PREFIX" ]] || [[ "$PREFIX" != *"com.termux"* ]]; then
    print_error "This installer is designed for Termux on Android"
    echo "For other platforms, please install manually"
    exit 1
fi
print_success "Termux environment detected"

# Install dependencies
print_step "Installing dependencies..."
pkg update -y >/dev/null 2>&1 || true
pkg install -y git curl gh >/dev/null 2>&1 || true
print_success "Dependencies installed"

# Clone repository
print_step "Downloading PY_Code Flutter CLI..."
rm -rf "$PYCODE_HOME" 2>/dev/null || true
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$PYCODE_HOME" 2>/dev/null || {
    print_error "Failed to download repository"
    echo "Please check your internet connection"
    exit 1
}
print_success "Downloaded to ${PYCODE_HOME}"

# Make scripts executable
chmod +x "$PYCODE_HOME/bin/pycode" 2>/dev/null
find "$PYCODE_HOME/lib" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Add to PATH
print_step "Configuring PATH..."
SHELL_RC=""
if [[ -n "$BASH_VERSION" ]]; then
    SHELL_RC="${HOME}/.bashrc"
elif [[ -n "$ZSH_VERSION" ]]; then
    SHELL_RC="${HOME}/.zshrc"
else
    SHELL_RC="${HOME}/.profile"
fi

if ! grep -q ".pycode/bin" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# PY_Code Flutter CLI" >> "$SHELL_RC"
    echo "export PATH=\"${PYCODE_HOME}/bin:\$PATH\"" >> "$SHELL_RC"
    print_success "PATH configured in ${SHELL_RC}"
else
    print_success "PATH already configured"
fi

# Create symlink for immediate use
export PATH="${PYCODE_HOME}/bin:$PATH"

echo ""
print_header "✨ Installation Complete!"
echo ""
echo -e "${GREEN}PY_Code Flutter CLI is ready!${NC}"
echo ""
echo "Quick Start:"
echo "  pycode --help              Show all commands"
echo "  pycode install flutter     Install Flutter SDK"
echo "  pycode flutter doctor      Check your setup"
echo ""
echo -e "${YELLOW}⚠️  Restart your terminal or run:${NC}"
echo "  source ~/.bashrc"
echo ""
echo -e "${DIM}Made with ❤️ by PY_Code${NC}"
echo ""