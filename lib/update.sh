#!/bin/bash
# PY_Code Flutter CLI - Auto Update Command

check_update_background() {
    # Skip if checked recently (within 24 hours)
    local update_check_file="${PYCODE_HOME}/.last_update_check"
    if [[ -f "$update_check_file" ]]; then
        local last_check
        last_check=$(cat "$update_check_file" 2>/dev/null)
        local now
        now=$(date +%s)
        if [[ $((now - last_check)) -lt 86400 ]]; then
            return 0
        fi
    fi
    
    # Check for updates
    local latest_version
    latest_version=$(curl -fsSL "https://raw.githubusercontent.com/alaarafeek5522-ai/pycode-flutter-cli/main/lib/core.sh" 2>/dev/null | grep "^VERSION=" | cut -d'"' -f2)
    
    if [[ -n "$latest_version" && "$latest_version" != "$VERSION" ]]; then
        echo ""
        echo -e "${YELLOW}⚠${NC} ${BOLD}Update available!${NC} v$VERSION → v$latest_version"
        echo -e "   Run: ${CYAN}pycode update${NC}"
        echo ""
    fi
    
    # Update check timestamp
    date +%s > "$update_check_file"
}

cmd_update() {
    print_header "Updating PY_Code Flutter CLI"
    echo -e "${DIM}Checking for latest version...${NC}"
    echo ""
    
    local install_dir="${PYCODE_HOME}"
    local current_version="${VERSION:-unknown}"
    
    # Get latest version from GitHub
    print_step "Fetching latest version..."
    local latest_version
    latest_version=$(curl -fsSL "https://raw.githubusercontent.com/alaarafeek5522-ai/pycode-flutter-cli/main/lib/core.sh" 2>/dev/null | grep "^VERSION=" | cut -d'"' -f2)
    
    if [[ -z "$latest_version" ]]; then
        print_error "Could not fetch latest version"
        echo "Check your internet connection"
        exit 1
    fi
    
    echo "  Current: v${current_version}"
    echo "  Latest:  v${latest_version}"
    echo ""
    
    # Check if update needed
    if [[ "$current_version" == "$latest_version" ]]; then
        print_success "Already up to date! ✓"
        exit 0
    fi
    
    print_info "New version available!"
    echo ""
    
    # Download and install latest
    print_step "Downloading latest version..."
    
    local temp_dir="${PREFIX:-/tmp}/pycode-update-$$"
    mkdir -p "$temp_dir"
    
    # Download latest release
    if curl -fsSL "https://github.com/alaarafeek5522-ai/pycode-flutter-cli/archive/refs/heads/main.tar.gz" -o "$temp_dir/pycode.tar.gz" 2>/dev/null; then
        print_success "Downloaded"
        
        print_step "Installing update..."
        cd "$temp_dir"
        tar -xzf pycode.tar.gz 2>/dev/null
        
        # Copy new files
        if [[ -d "pycode-flutter-cli-main" ]]; then
            rm -rf "$install_dir"/*
            cp -r pycode-flutter-cli-main/* "$install_dir/" 2>/dev/null
            
            # Make all scripts executable
            chmod +x "$install_dir/bin/pycode" 2>/dev/null
            find "$install_dir/lib" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
            
            # Cleanup
            cd ~
            rm -rf "$temp_dir"
            
            echo ""
            print_success "Updated to v${latest_version}! 🎉"
            echo ""
            echo "Changes applied. Run 'pycode --version' to verify."
            echo ""
        else
            print_error "Update extraction failed"
            exit 1
        fi
    else
        print_error "Download failed"
        echo "Check your internet connection"
        exit 1
    fi
}