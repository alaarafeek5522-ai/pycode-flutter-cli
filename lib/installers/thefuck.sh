#!/bin/bash
# PY_Code Flutter CLI - Installer: thefuck

cmd_install() {
    print_header "Installing TheFuck"
    echo -e "${DIM}Magnificent app that corrects your commands${NC}"
    echo ""
    
    require_termux
    
    print_step "[1/2] Installing python..."
    pkg install python -y >/dev/null 2>&1
    
    print_step "[2/2] Installing thefuck via pip..."
    if pip install thefuck 2>/dev/null; then
        print_done "TheFuck"
        echo -e "${BOLD}Setup:${NC}"
        echo "  Add to ~/.bashrc or ~/.zshrc:"
        echo "  eval \$(thefuck --alias)"
        echo ""
        echo -e "${BOLD}Usage:${NC}"
        echo "  1. Type a wrong command: gti status"
        echo "  2. Type: fuck"
        echo "  3. It fixes: git status"
        echo ""
    else
        print_error "TheFuck installation failed"
        exit 1
    fi
}