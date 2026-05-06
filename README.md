# ☢️ Uranium Hub

> **A professional, modular, and feature-rich Universal Roblox Script Hub for 2026**

![Uranium Hub](https://img.shields.io/badge/Uranium%20Hub-v1.0.0-yellow)
![Roblox](https://img.shields.io/badge/Roblox-Script%20Hub-red)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Active%20Development-brightgreen)

---

## 🎯 About

Uranium Hub is a **universal Roblox script hub** designed with a professional, clean architecture in mind. It provides essential gameplay features across all games with a sleek **Obsidian UI** interface and expandable modular system.

Perfect for developers and power users who want a **solid foundation** for Roblox scripting.

---

## 📦 Features

### ✨ Current Features

- **🎨 Professional UI** - Obsidian UI with multiple tabs
- **👻 Universal Features**
  - Flight System (Fly)
  - Noclip Mode
  - Walk Speed Control
  - Jump Power Enhancement
  - God Mode (Anti-Damage)
  - Infinite Stamina
  
- **👁️ Advanced ESP System**
  - Box ESP (enemy boundaries)
  - Tracer Lines (enemy tracking)
  - Player Names & Distance Display
  - Health Bar Visualization
  - Customizable Colors & Toggles
  - Performance Optimized

- **⚙️ Misc Features**
  - Teleport System
  - Coordinate Display
  - Performance Stats

- **🔧 Full Customization**
  - Per-feature settings
  - Color customization
  - Keybind configuration

---

## 🚀 Quick Start

### Installation

**Copy and paste this in Roblox executor:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/uranium-hub/main/main.lua"))()
```

### First Time Setup

1. **Inject the script** using your executor
2. **View the UI** - Clean loading screen appears
3. **Customize** in Settings tab
4. **Enjoy!** - All features ready to use

---

## 📖 Usage Guide

### Tabs Overview

| Tab | Features |
|-----|----------|
| **Home** | Hub information & status |
| **Universal** | Fly, Noclip, Speed, Jump, God Mode, Stamina |
| **ESP** | Player detection & visualization |
| **Misc** | Teleport, Coordinates, Stats |
| **Settings** | UI theme, keybinds, feature toggles |

### Default Keybinds

- `F` - Toggle Fly
- `X` - Toggle Noclip
- `Z` - Toggle God Mode
- `E` - Toggle ESP
- `Shift+M` - Toggle Misc features
- `Delete` - Unload Hub

---

## 🏗️ Project Structure

```
uranium-hub/
├── README.md                 # Documentation
├── LICENSE                   # MIT License
├── .gitignore               # Git ignore rules
├── main.lua                 # Main loader & entry point
│
├── modules/
│   ├── config.lua           # Configuration & defaults
│   ├── utilities.lua        # Helper functions
│   ├── ui.lua               # Obsidian UI interface
│   ├── universal.lua        # Universal features
│   └── esp.lua              # ESP system
│
└── lib/
    └── (external libraries)
```

---

## 📋 Requirements

- ✅ Roblox Executor (Synapse, Fluxus, Delta, etc.)
- ✅ Roblox Account
- ✅ Lua 5.1+ Support
- ✅ Game with Humanoid characters

---

## 🔧 Configuration

Edit `modules/config.lua` to customize:

```lua
Config.Features.Fly.Enabled = true
Config.Features.Fly.Speed = 50
Config.Features.ESP.Enabled = true
Config.UI.Theme = "dark"
```

All settings sync across features in real-time.

---

## 💡 Advanced Usage

### Adding Custom Features

1. Create new module in `modules/`
2. Import in `main.lua`
3. Add UI element in `ui.lua`
4. Register in `config.lua`

### Custom Game Support

- Create `games/[GameID]/` folder
- Override universal features
- Add game-specific scripts

---

## 📝 Code Quality

- ✅ **100% Modular** - Easy to extend
- ✅ **Well Commented** - Every function documented
- ✅ **Performance Optimized** - Minimal lag
- ✅ **Error Handling** - Graceful failures
- ✅ **Clean Syntax** - Professional Lua style

---

## 🐛 Known Issues

- None currently reported

---

## 📅 Roadmap

- [ ] Game-specific modules
- [ ] Advanced admin panel
- [ ] Anti-cheat bypass detection
- [ ] Custom skin system
- [ ] Cloud-based settings sync
- [ ] Plugin system for user scripts
- [ ] Mobile UI support

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## ⚖️ License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

Uranium Hub is for **educational purposes** and **private use only**. Users assume full responsibility for compliance with Roblox ToS. The creators are not liable for bans or account issues.

---

## 📞 Support

- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Use GitHub Discussions for questions
- **Discord**: Join our community server (link)

---

## 🙏 Credits

- **Obsidian UI** - Amazing UI library
- **Roblox Community** - Inspiration & support
- **Contributors** - Thank you for improvements

---

**Made with ☢️ by the Uranium Team**

*Last Updated: 2026*
