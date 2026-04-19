#!/bin/bash
# PY_Code Flutter CLI - Installer: oh-my-zsh

cmd_install() {
    print_header "Installing Complete Zsh Setup"
    echo -e "${DIM}Zsh + Oh My Zsh + Powerlevel10k + All Plugins${NC}"
    echo ""
    
    require_termux
    
    # Step 1: Install Zsh
    print_step "[1/7] Installing Zsh..."
    pkg install zsh git curl -y >/dev/null 2>&1
    print_success "Zsh installed"
    
    # Step 2: Install Oh My Zsh
    print_step "[2/7] Installing Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
    print_success "Oh My Zsh installed"
    
    local ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
    
    # Step 3: Powerlevel10k
    print_step "[3/7] Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k" 2>/dev/null || true
    print_success "Powerlevel10k installed"
    
    # Step 4: zsh-autosuggestions
    print_step "[4/7] Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" 2>/dev/null || true
    print_success "zsh-autosuggestions installed"
    
    # Step 5: zsh-syntax-highlighting
    print_step "[5/7] Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" 2>/dev/null || true
    print_success "zsh-syntax-highlighting installed"
    
    # Step 6: zsh-completions
    print_step "[6/7] Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions" 2>/dev/null || true
    print_success "zsh-completions installed"
    
    # Step 7: Configure .zshrc
    print_step "[7/7] Configuring Zsh..."
    local ZSHRC="${HOME}/.zshrc"
    cp "$ZSHRC" "${ZSHRC}.backup" 2>/dev/null || true
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC" 2>/dev/null || true
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions sudo history copydir copyfile web-search python npm node extract)/' "$ZSHRC" 2>/dev/null || true
    chsh -s zsh 2>/dev/null || true
    print_success "Zsh configured & set as default"
    
    print_done "Complete Zsh Setup"
    echo -e "${BOLD}Installed:${NC}"
    echo "  ✓ Zsh + Oh My Zsh"
    echo "  ✓ Powerlevel10k theme"
    echo "  ✓ zsh-autosuggestions"
    echo "  ✓ zsh-syntax-highlighting"
    echo "  ✓ zsh-completions"
    echo "  ✓ 10+ standard plugins"
    echo ""
    echo -e "${BOLD}To activate:${NC}"
    echo "  Restart Termux or type: zsh"
    echo ""
}