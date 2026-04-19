

```markdown
# 🚀 PY_Code Flutter CLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/alaarafeek5522-ai/pycode-flutter-cli)

**The Ultimate CLI for Mobile Developers on Termux - Powered by PY_Code**

📱 **Build Flutter APKs in the cloud, install packages with one command, and develop apps right from your phone!**

---

## 🎯 Key Features

| Feature | Description |
| :--- | :--- |
| ☁️ **Cloud Builds** | Build Flutter APKs/AABs using GitHub Actions |
| 📦 **Package Manager** | Install Flutter, editors, and tools with one command |
| 🔄 **Auto Updates** | Keep **PY_Code CLI** up-to-date automatically |
| 📱 **Termux Native** | Built specifically for Termux on Android |
| 🎨 **Beautiful UI** | Colorful, informative terminal output |

---

## 📥 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/alaarafeek5522-ai/pycode-flutter-cli/main/install.sh | bash
```

After installation, restart your terminal or run:

```bash
source ~/.bashrc
```

Requirements

· Termux (from F-Droid)
· Internet connection
· GitHub account (for cloud builds)

---

🚀 Quick Start

Install Flutter

```bash
pycode install flutter
```

Build APK in Cloud

```bash
# Initialize your project
cd your-flutter-project
pycode flutter init

# Build release APK
pycode flutter build apk --release
```

---

📖 Usage

Global Commands

Command Description
pycode --help Show help
pycode --version Show version
pycode update Update pycode to latest

Install Commands

```bash
# Install Flutter SDK
pycode install flutter

# Install AI Tools
pycode install qwen

# Install Shell enhancements
pycode install oh-my-zsh
pycode install shell-tools

# Install editors
pycode install neovim
pycode install micro

# Install any Termux package as fallback
pycode install <package-name>
```

Flutter Commands

```bash
# Initialize cloud builds in your project
pycode flutter init

# Check system setup
pycode flutter doctor

# Build APK (cloud)
pycode flutter build apk --release
pycode flutter build apk --debug
pycode flutter build apk --split-per-abi

# Build App Bundle
pycode flutter build appbundle --release

# Run web server locally
pycode flutter run web
```

Build Options

Flag Description
--release Release build (optimized)
--debug Debug build (default)
--split-per-abi Split APK by architecture
--target-platform Build for specific ABI
--install Install APK after download

---

🔧 How Cloud Builds Work

1. Initialize - pycode flutter init creates a GitHub Actions workflow
2. Commit - Push your code to GitHub
3. Build - pycode flutter build apk triggers the workflow
4. Download - APK is automatically downloaded when ready

```
Your Phone (Termux)          GitHub Actions
      │                            │
      ├── pycode flutter init ────►│ Creates workflow
      │                            │
      ├── git push ───────────────►│ Code uploaded
      │                            │
      ├── pycode flutter build ───►│ Triggers build
      │                            │
      │◄── APK downloaded ─────────┤ Build complete
```

---

📁 Project Structure

```
~/.pycode/
├── bin/
│   └── pycode           # Main CLI entry point
├── lib/
│   ├── core.sh          # Core utilities
│   ├── update.sh        # Auto-update
│   ├── install.sh       # Auto-discovery plugin dispatcher
│   ├── installers/      # 📦 PLUGINS: Drop a .sh file here to add a tool!
│   │   ├── qwen.sh
│   │   ├── flutter.sh
│   │   └── ...
│   └── flutter/         # Dedicated flutter core logic
│       ├── init.sh
│       └── build.sh
└── workflows/
    └── pycode-flutter-build.yml
```

---

📦 Available Packages

Package Description
flutter Flutter SDK for Android development
qwen Qwen Code CLI - AI-powered coding assistant
oh-my-zsh Zsh + Oh My Zsh + Powerlevel10k + Plugins
shell-tools Fish, FZF, Zsh, TheFuck bundle
neovim Modern Vim text editor
micro Simple, intuitive terminal editor
fish Friendly Interactive SHell
zsh Z Shell
thefuck Command correction tool

---

🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (git checkout -b feature/amazing)
3. Commit your changes (git commit -m 'Add amazing feature')
4. Push to the branch (git push origin feature/amazing)
5. Open a Pull Request

---

📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

made by PY_Code»» Alaa rafeek 

· Flutter - UI toolkit
· GitHub Actions - Cloud CI/CD
· Made with ❤️ by PY_Code

---

⭐ Star this repo • 🐛 Report Bug • 💡 Request Feature

---

📞 Support

· GitHub Issues: Report a bug
· Email: alaarafeek5522@gmail.com
  Telegram:  https://t.me/PX_Code
---

Happy Coding! 🚀📱

```

---

