#!/bin/bash
# PY_Code Flutter CLI - Base helpers for all installers

require_termux() {
    if ! is_termux; then
        die "This installer is designed for Termux only"
    fi
}

require_pkg() {
    local pkg="$1"
    if ! is_command_available "$pkg"; then
        print_step "Installing dependency: ${pkg}..."
        if pkg install "$pkg" -y 2>/dev/null; then
            print_success "${pkg} ready"
        else
            die "Could not install dependency: ${pkg}"
        fi
    fi
}

install_from_void_repo() {
    local pkg="$1"
    setup_void_repo_silent
    print_step "Installing ${pkg}..."
    if pkg install "$pkg" -y 2>/dev/null; then
        print_success "${pkg} installed"
        return 0
    else
        die "Failed to install ${pkg} from repository"
    fi
}

setup_void_repo_silent() {
    if [[ -f "${PREFIX}/etc/apt/sources.list.d/termuxvoid.list" ]]; then
        return 0
    fi
    print_step "Setting up package repository..."
    curl -sL https://termuxvoid.github.io/repo/install.sh 2>/dev/null | bash >/dev/null 2>&1
    pkg update -y >/dev/null 2>&1 || true
    print_success "Repository configured"
}

print_done() {
    local tool="$1"
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓${NC} ${BOLD}${tool} installed successfully!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${DIM}Powered by PY_Code • https://github.com/alaarafeek5522-ai/pycode-flutter-cli${NC}"
    echo ""
}