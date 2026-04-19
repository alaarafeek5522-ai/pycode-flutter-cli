#!/bin/bash
# PY_Code Flutter CLI - Init Command

cmd_init() {
    print_header "Initialize PY_Code Flutter"
    
    # Check if in Flutter project
    if ! is_flutter_project; then
        die "Not a Flutter project. Please run this in a Flutter project directory."
    fi
    print_success "Flutter project detected"
    
    # Check if git repo
    if ! is_git_repo; then
        print_warning "Not a git repository"
        if ask_yes_no "Initialize git repository?"; then
            git init
            print_success "Git repository initialized"
        else
            die "Git repository required for cloud builds"
        fi
    fi
    print_success "Git repository detected"
    
    # Check remote
    local remote_url
    remote_url=$(get_remote_url)
    if [[ -z "$remote_url" ]]; then
        print_warning "No GitHub remote configured"
        echo ""
        echo "Please add a GitHub remote:"
        echo "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
        echo ""
        die "GitHub remote required for cloud builds"
    fi
    
    # Verify it's a GitHub URL
    if [[ "$remote_url" != *"github.com"* ]]; then
        print_warning "Remote doesn't appear to be GitHub: ${remote_url}"
        echo "PY_Code Flutter CLI currently only supports GitHub for cloud builds"
        if ! ask_yes_no "Continue anyway?"; then
            exit 1
        fi
    fi
    print_success "GitHub remote: ${remote_url}"
    
    # Create workflow directory
    print_step "Setting up GitHub Actions workflow..."
    ensure_dir ".github/workflows"
    
    # Get project name from pubspec
    local app_name
    app_name=$(grep "^name:" pubspec.yaml 2>/dev/null | sed 's/name:[[:space:]]*//' | tr -d '"' | tr -d "'")
    if [[ -z "$app_name" ]]; then
        app_name="app"
    fi
    
    # Check for existing workflow file and remove it
    local workflow_file=".github/workflows/pycode-build.yml"
    if [[ -f "$workflow_file" ]]; then
        print_warning "Existing workflow found - updating..."
        rm -f "$workflow_file"
    fi
    
    # Copy workflow from template directory
    local template_file="${PYCODE_HOME}/workflows/pycode-flutter-build.yml"
    
    if [[ -f "$template_file" ]]; then
        cp "$template_file" "$workflow_file"
        print_success "Copied workflow from template"
    else
        print_step "Downloading latest workflow..."
        curl -fsSL "https://raw.githubusercontent.com/alaarafeek5522-ai/pycode-flutter-cli/main/workflows/pycode-flutter-build.yml" -o "$workflow_file" 2>/dev/null
        
        if [[ ! -f "$workflow_file" || ! -s "$workflow_file" ]]; then
            print_error "Failed to download workflow template"
            exit 1
        fi
        print_success "Downloaded latest workflow"
    fi
    
    print_success "Created .github/workflows/pycode-build.yml"
    
    # Create config file
    print_step "Creating configuration file..."
    
    cat > ".pycode.yaml" << CONFIG_EOF
# PY_Code Flutter CLI configuration v${VERSION}
project:
  name: ${app_name}
  type: flutter

build:
  default_type: debug
  output_path: build/app/outputs/flutter-apk

cloud:
  provider: github
  workflow: pycode-build.yml
  poll_interval: 8
CONFIG_EOF
    
    print_success "Created .pycode.yaml"
    
    # Add to .gitignore if not present
    if [[ -f ".gitignore" ]]; then
        if ! grep -q "# PY_Code" .gitignore 2>/dev/null; then
            echo "" >> .gitignore
            echo "# PY_Code Flutter CLI" >> .gitignore
            echo ".pycode-cache/" >> .gitignore
        fi
    fi
    
    # Summary
    echo ""
    print_header "Initialization Complete"
    echo ""
    echo "Created/Updated files:"
    echo "  • .github/workflows/pycode-build.yml"
    echo "  • .pycode.yaml"
    echo ""
    echo "Next steps:"
    echo "  1. Commit and push:"
    echo "     git add . && git commit -m 'Add PY_Code cloud build' && git push"
    echo ""
    echo "  2. Build commands:"
    echo "     pycode flutter build apk --debug"
    echo "     pycode flutter build apk --release"
    echo "     pycode flutter build apk --release --split-per-abi"
    echo "     pycode flutter build appbundle --release"
    echo "     pycode flutter build apk --release --install"
    echo ""
    echo -e "${GREEN}💡 Pro tips:${NC}"
    echo "  • Use --split-per-abi for ~60% smaller APKs"
    echo "  • Use --install to auto-install after build"
    echo ""
}