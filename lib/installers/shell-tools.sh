#!/bin/bash
# PY_Code Flutter CLI - Installer: shell-tools

cmd_install() {
    print_header "Installing Shell Tools Bundle"
    echo -e "${DIM}Auto-suggestions, command correction, fuzzy finder${NC}"
    echo ""
    
    require_termux
    local tools=("fish" "fzf" "zsh")
    local installed=0
    
    for tool in "${tools[@]}"; do
        print_step "Installing ${tool}..."
        if pkg install "$tool" -y >/dev/null 2>&1; then
            print_success "${tool} installed"
            ((installed++))
        else
            print_warning "Could not install ${tool}"
        fi
    done
    
    # Install thefuck
    print_step "Installing thefuck..."
    if pkg install python -y >/dev/null 2>&1; then
        pip install thefuck >/dev/null 2>&1 && print_success "thefuck installed" || print_warning "thefuck failed"
    fi
    
    # Execute Oh-My-Zsh installer
    print_step "Installing Oh-My-Zsh with plugins..."
    if [[ -f "${LIB_DIR}/installers/oh-my-zsh.sh" ]]; then
        source "${LIB_DIR}/installers/oh-my-zsh.sh"
        cmd_install
    fi

    print_success "Shell tools installed! (${installed}/${#tools[@]})"
    echo ""
    echo -e "${BOLD}Recommended: Switch to Fish shell${NC}"
    echo "  Run: chsh -s fish"
    echo ""
    echo -e "${DIM}Powered by PY_Code${NC}"
    echo ""
}