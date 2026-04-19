#!/bin/bash
# PY_Code Flutter CLI - Install Flutter SDK

# Path to flutter.deb on device
FLUTTER_DEB_PATH="/storage/emulated/0/packages/flutter.deb"

cmd_install_flutter() {
    print_header "Install Flutter SDK"

    # Check if Flutter is already installed
    if is_flutter_installed; then
        local current_version
        current_version=$(get_flutter_version)
        print_success "Flutter is already installed!"
        echo "  Version: ${current_version}"
        echo ""

        if ask_yes_no "Do you want to reinstall/update Flutter?"; then
            print_info "Proceeding with reinstall..."
        else
            print_info "Keeping existing installation"
            exit 0
        fi
    fi

    # Check internet connection
    print_step "Checking internet connection..."
    if ! check_internet; then
        die "No internet connection. Please check your network."
    fi
    print_success "Internet connection OK"

    # Detect platform
    if is_termux; then
        print_info "Detected Termux environment"
        install_flutter_termux
    else
        case "$(uname -s)" in
            Linux*)
                print_info "Detected Linux"
                install_flutter_linux
                ;;
            Darwin*)
                print_info "Detected macOS"
                install_flutter_macos
                ;;
            *)
                die "Unsupported platform: $(uname -s)"
                ;;
        esac
    fi
}

install_flutter_termux() {
    print_header "Installing Flutter SDK"
    echo -e "${DIM}via PY_Code Flutter Package${NC}"
    echo ""

    # Update packages first
    print_step "Updating Termux packages..."
    pkg update -y >/dev/null 2>&1 || true
    print_success "Packages updated"

    # Install required dependencies
    print_step "Installing dependencies..."
    pkg install -y curl wget >/dev/null 2>&1 || true
    print_success "Dependencies ready"

    # Check if flutter.deb exists locally
    if [[ -f "$FLUTTER_DEB_PATH" ]]; then
        print_step "Found local flutter.deb package..."
        if dpkg -i "$FLUTTER_DEB_PATH" 2>/dev/null || apt install -f -y "$FLUTTER_DEB_PATH" 2>/dev/null; then
            verify_flutter_termux
            return 0
        fi
        print_warning "Local install failed, trying alternative methods..."
    fi

    # Try tur-repo
    print_step "Installing via tur-repo..."
    if pkg install tur-repo -y 2>/dev/null; then
        pkg update -y 2>/dev/null || true
        if pkg install flutter -y 2>/dev/null; then
            verify_flutter_termux
            return 0
        fi
    fi

    # If all fails
    print_error "Automatic installation failed"
    echo ""
    echo "Please try manually:"
    echo "  pkg install tur-repo"
    echo "  pkg update"
    echo "  pkg install flutter"
    exit 1
}

verify_flutter_termux() {
    print_step "Verifying installation..."

    if command -v flutter &>/dev/null; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✓${NC} ${BOLD}Flutter installed successfully!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        flutter --version
        echo ""
        echo "Next steps:"
        echo "  1. Run: flutter doctor"
        echo "  2. Create app: flutter create myapp"
        echo "  3. Build: pycode flutter build apk --release"
        echo ""
        echo -e "${DIM}Powered by PY_Code${NC}"
        return 0
    else
        print_warning "Flutter command not found. Try restarting terminal."
        return 1
    fi
}

install_flutter_linux() {
    print_header "Installing Flutter SDK"

    ensure_dir "${PYCODE_HOME}"

    local flutter_tar="${PYCODE_HOME}/flutter.tar.xz"
    local flutter_url="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.3-stable.tar.xz"

    rm -rf "${FLUTTER_HOME}" 2>/dev/null || true

    print_step "Downloading Flutter SDK..."
    if ! download_file "$flutter_url" "$flutter_tar"; then
        die "Failed to download Flutter SDK"
    fi

    print_step "Extracting Flutter SDK..."
    cd "${PYCODE_HOME}"
    tar -xf "$flutter_tar"
    rm -f "$flutter_tar" 2>/dev/null || true

    setup_flutter_path
    verify_flutter_install
}

install_flutter_macos() {
    print_header "Installing Flutter SDK"

    ensure_dir "${PYCODE_HOME}"

    local flutter_zip="${PYCODE_HOME}/flutter.zip"
    local flutter_url="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.3-stable.zip"

    rm -rf "${FLUTTER_HOME}" 2>/dev/null || true

    print_step "Downloading Flutter SDK..."
    if ! download_file "$flutter_url" "$flutter_zip"; then
        die "Failed to download Flutter SDK"
    fi

    print_step "Extracting Flutter SDK..."
    cd "${PYCODE_HOME}"
    unzip -q "$flutter_zip"
    rm -f "$flutter_zip" 2>/dev/null || true

    setup_flutter_path
    verify_flutter_install
}

setup_flutter_path() {
    print_step "Configuring PATH..."

    local flutter_bin="${FLUTTER_HOME}/bin"
    local shell_rc=""

    if [[ -n "$BASH_VERSION" ]]; then
        shell_rc="${HOME}/.bashrc"
    elif [[ -n "$ZSH_VERSION" ]]; then
        shell_rc="${HOME}/.zshrc"
    else
        shell_rc="${HOME}/.profile"
    fi

    if grep -q "flutter/bin" "$shell_rc" 2>/dev/null; then
        print_info "PATH already configured"
        return
    fi

    echo "" >>"$shell_rc"
    echo "# Flutter SDK (PY_Code)" >>"$shell_rc"
    echo "export PATH=\"${flutter_bin}:\$PATH\"" >>"$shell_rc"

    export PATH="${flutter_bin}:$PATH"

    print_success "PATH configured in ${shell_rc}"
    print_warning "Run 'source ${shell_rc}' or restart terminal"
}

verify_flutter_install() {
    print_step "Verifying installation..."

    if command -v flutter &>/dev/null || [[ -f "${FLUTTER_HOME}/bin/flutter" ]]; then
        print_success "Flutter installed successfully!"
        echo ""
        flutter --version 2>/dev/null || "${FLUTTER_HOME}/bin/flutter" --version
        echo ""
        print_info "Run 'flutter doctor' to check your setup"
    else
        die "Flutter installation failed. Please try again."
    fi
}