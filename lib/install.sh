#!/bin/bash
# PY_Code Flutter CLI - Install Command Dispatcher
# Auto-discovers installers from lib/installers/*.sh

cmd_install_package() {
    local package="$1"

    if [[ -z "$package" ]]; then
        print_error "No package specified"
        echo "Usage: pycode install <package>"
        echo ""
        echo "Available packages:"
        echo "  flutter      Flutter SDK"
        echo "  qwen         Qwen Code CLI"
        echo "  oh-my-zsh    Zsh + Oh My Zsh"
        echo "  shell-tools  Shell tools bundle"
        echo "  neovim       Modern Vim"
        echo "  micro        Simple editor"
        echo "  fish         Fish shell"
        echo "  zsh          Z shell"
        echo "  thefuck      Command correction"
        exit 1
    fi

    # Alias mappings
    case "$package" in
        ohmyzsh|oh-my-zsh) package="oh-my-zsh" ;;
        fuck|tf)           package="thefuck" ;;
        shell|shell-tools) package="shell-tools" ;;
        nvim)              package="neovim" ;;
    esac

    # Auto-discover installer
    local installer_file="${LIB_DIR}/installers/${package}.sh"

    if [[ -f "$installer_file" ]]; then
        source "${LIB_DIR}/installers/_base.sh"
        source "$installer_file"
        cmd_install
        return
    fi

    # Fallback: generic pkg install for Termux
    print_header "Installing ${package}"

    if ! is_termux; then
        print_warning "This command is designed for Termux"
        echo "On other systems, use your package manager directly"
        exit 1
    fi

    print_step "Installing ${package}..."
    if pkg install "$package" -y 2>/dev/null; then
        echo ""
        print_success "${package} installed successfully!"
        echo ""
        echo -e "${DIM}Powered by PY_Code${NC}"
        echo ""
    else
        print_error "Failed to install ${package}"
        echo ""
        echo "Try updating packages first:"
        echo "  pkg update && pkg upgrade"
        exit 1
    fi
}