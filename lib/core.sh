#!/bin/bash
# PY_Code Flutter CLI - Core Library
# Shared utilities for all tools

# Version
VERSION="1.0.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Paths
PYCODE_HOME="${HOME}/.pycode"
FLUTTER_HOME="${PYCODE_HOME}/sdk/flutter"
CONFIG_FILE=".pycode.yaml"

# ============ Logging Functions ============

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_step() {
    echo -e "${CYAN}→${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}$1${NC}"
    echo "─────────────────────────────────────"
}

# ============ Check Functions ============

is_termux() {
    [[ -n "$PREFIX" && "$PREFIX" == *"com.termux"* ]]
}

is_command_available() {
    command -v "$1" &> /dev/null
}

is_flutter_installed() {
    if [[ -f "${FLUTTER_HOME}/bin/flutter" ]]; then
        return 0
    fi
    if is_command_available flutter; then
        return 0
    fi
    return 1
}

get_flutter_version() {
    if [[ -f "${FLUTTER_HOME}/bin/flutter" ]]; then
        "${FLUTTER_HOME}/bin/flutter" --version 2>/dev/null | head -1
    elif is_command_available flutter; then
        flutter --version 2>/dev/null | head -1
    else
        echo "Not installed"
    fi
}

# ============ Config Functions ============

read_config() {
    local key="$1"
    local file="${2:-.pycode.yaml}"
    
    if [[ -f "$file" ]]; then
        grep "^[[:space:]]*${key}:" "$file" 2>/dev/null | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
    fi
}

config_exists() {
    [[ -f ".pycode.yaml" ]]
}

# ============ Git Functions ============

is_git_repo() {
    git rev-parse --git-dir &> /dev/null
}

has_uncommitted_changes() {
    ! git diff-index --quiet HEAD -- 2>/dev/null
}

get_remote_url() {
    git remote get-url origin 2>/dev/null
}

get_repo_name() {
    local url
    url=$(get_remote_url)
    if [[ -n "$url" ]]; then
        basename -s .git "$url"
    fi
}

get_repo_owner() {
    local url
    url=$(get_remote_url)
    if [[ -n "$url" ]]; then
        echo "$url" | sed -E 's|.*[:/]([^/]+)/[^/]+\.git$|\1|' | sed -E 's|.*[:/]([^/]+)/[^/]+$|\1|'
    fi
}

# ============ Flutter Project Functions ============

is_flutter_project() {
    [[ -f "pubspec.yaml" ]] && grep -q "flutter:" pubspec.yaml 2>/dev/null
}

has_workflow_file() {
    [[ -f ".github/workflows/pycode-build.yml" ]]
}

# ============ Network Functions ============

check_internet() {
    curl -s --head --connect-timeout 5 https://github.com &> /dev/null
}

download_file() {
    local url="$1"
    local output="$2"
    
    if is_command_available curl; then
        curl -fsSL --progress-bar -o "$output" "$url"
    elif is_command_available wget; then
        wget -q --show-progress -O "$output" "$url"
    else
        print_error "Neither curl nor wget found"
        return 1
    fi
}

# ============ Helper Functions ============

ensure_dir() {
    mkdir -p "$1" 2>/dev/null
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        read -r -p "$prompt [Y/n]: " response
        [[ -z "$response" || "$response" =~ ^[Yy] ]]
    else
        read -r -p "$prompt [y/N]: " response
        [[ "$response" =~ ^[Yy] ]]
    fi
}

die() {
    print_error "$1"
    exit 1
}