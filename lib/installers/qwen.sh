#!/bin/bash
# PY_Code Flutter CLI - Installer: qwen

cmd_install() {
    print_header "Installing Qwen Code CLI"
    echo -e "${DIM}AI-powered code assistant by Alibaba Cloud${NC}"
    echo ""
    
    require_termux

    # Step 1: Install npm
    print_step "[1/3] Installing npm..."
    if ! is_command_available npm; then
        if pkg install npm -y 2>/dev/null; then
            print_success "npm installed"
        else
            die "Failed to install npm. Try: pkg update && pkg install npm"
        fi
    else
        print_success "npm already installed"
    fi

    # Step 2: Install ripgrep
    print_step "[2/3] Installing ripgrep..."
    if ! is_command_available rg; then
        if pkg install ripgrep -y 2>/dev/null; then
            print_success "ripgrep installed"
        else
            print_warning "ripgrep not found, some features may not work"
        fi
    else
        print_success "ripgrep already installed"
    fi

    # Step 3: Install Qwen
    print_step "[3/3] Installing Qwen Code CLI..."
    if npm install -g @qwen-code/qwen-code@latest 2>/dev/null; then
        print_done "Qwen Code CLI"
        echo -e "${BOLD}Usage:${NC}"
        echo "  qwen              Start Qwen AI assistant"
        echo "  qwen \"fix this\"  Ask Qwen to help with code"
        echo ""
        echo -e "${BOLD}Update anytime:${NC}"
        echo "  pycode install qwen"
        echo ""
    else
        print_error "Failed to install Qwen Code CLI"
        echo ""
        echo "Try manually:"
        echo "  npm install -g @qwen-code/qwen-code@latest"
        exit 1
    fi
}