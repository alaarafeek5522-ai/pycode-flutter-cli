#!/bin/bash
# PY_Code Flutter CLI - Installer: fish

cmd_install() {
    print_header "Installing Fish Shell"
    echo -e "${DIM}The Friendly Interactive SHell${NC}"
    echo ""
    
    require_termux
    
    print_step "Installing fish..."
    if pkg install fish -y 2>/dev/null; then
        print_done "Fish Shell"
        echo -e "${BOLD}Features:${NC}"
        echo "  • Auto-suggestions as you type"
        echo "  • Syntax highlighting"
        echo "  • Tab completion for everything"
        echo ""
        echo -e "${BOLD}To use Fish:${NC}"
        echo "  Temporary: fish"
        echo "  Permanent: chsh -s fish"
        echo ""
    else
        print_error "Failed to install fish"
        exit 1
    fi
}