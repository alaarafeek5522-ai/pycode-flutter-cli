# Contributing to PY_Code Flutter CLI

We love your input! We want to make contributing to this project as easy and transparent as possible.

## Development Process

1. Fork the repo and create your branch from `main`
2. Make your changes
3. Test your changes in Termux
4. Submit a pull request

## Adding New Installers

To add a new package installer:

1. Create a new file in `lib/installers/` named `<package>.sh`
2. Define a `cmd_install()` function
3. Source `_base.sh` for helper functions
4. Use `print_done "<Package Name>"` at the end

Example:
```bash
#!/bin/bash
# PY_Code Flutter CLI - Installer: example

cmd_install() {
    print_header "Installing Example Tool"
    require_termux
    pkg install example -y
    print_done "Example Tool"
}