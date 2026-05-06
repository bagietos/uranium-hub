# Uranium Hub - Universal Roblox Script

A professional, lightweight, and modular universal script hub for Roblox with essential movement features and a clean Obsidian UI interface.

## Features

### Movement
- **Noclip**: Walk through walls and solid objects with smooth collision bypass
- **Fly**: Smooth flight movement with customizable speed (10-200 units/second)
  - Controls: WASD to move, Space/Ctrl for vertical movement

### User Interface
- Clean, minimalistic design using Obsidian UI library
- Tabbed interface: Home, Movement, Settings
- Professional presentation
- Right Shift keybind to toggle menu visibility

## Project Structure

```
uranium/
├── src/
│   ├── main.lua                 # Main entry point
│   ├── modules/
│   │   ├── noclip.lua          # Noclip feature module
│   │   ├── fly.lua             # Fly feature module
│   │   └── feature_manager.lua  # Feature orchestration
│   ├── ui/
│   │   ├── window.lua          # Main window creation
│   │   └── tabs.lua            # UI tabs management
│   └── utils/
│       ├── config.lua          # Central configuration
│       └── helpers.lua         # Utility functions
├── docs/
│   ├── README.md               # This file
│   ├── INSTALLATION.md         # Installation guide
│   ├── CONTRIBUTING.md         # Contributing guidelines
│   └── ARCHITECTURE.md         # Technical architecture
└── LICENSE                      # MIT License
```

## Installation

### Requirements
- Roblox game session
- Roblox script executor (Synapse X, Script-Ware, etc.)

### Steps

1. **Copy the script path** or load from a file hosting service
2. **Execute in your script executor**
3. **Press Right Shift** to toggle the menu

### Quick Load from URL
```lua
loadstring(game:HttpGet("https://your-script-url/src/main.lua"))()
```

## Usage

### Keybinds
- **Right Shift**: Toggle menu visibility
- **WASD**: Move while flying
- **Space**: Ascend while flying
- **Left Control**: Descend while flying

### Features

#### Noclip
1. Navigate to Movement tab
2. Toggle "Noclip" on
3. Walk through walls freely
4. Toggle off to re-enable collisions

#### Fly
1. Navigate to Movement tab
2. Toggle "Fly" on
3. Adjust speed with the slider (10-200)
4. Use WASD + Space/Ctrl to move
5. Toggle off to stop flying

#### Settings
- Disable all active features at once
- Reset to default state

## Configuration

Edit `src/utils/config.lua` to customize:
- UI window size and appearance
- Keybinds
- Feature default settings
- Messages and logging

```lua
Config.UI.Name = "Your Hub Name"
Config.Keybinds.ToggleMenu = Enum.KeyCode.RightShift
Config.Features.Fly.DefaultSpeed = 50
```

## Modular Architecture

Each feature is self-contained:
- **noclip.lua**: Independent noclip system
- **fly.lua**: Standalone fly module
- **feature_manager.lua**: Centralized feature control
- **tabs.lua**: UI components
- **config.lua**: Single source of configuration

This allows for:
- Easy feature addition
- Simple debugging
- Clean code maintenance
- Effortless scaling

## Security & Safety

- Uses Obsidian UI: a trusted, widely-used Roblox UI library
- BodyVelocity-based flight (standard method)
- Collision-based noclip (standard method)
- Automatic cleanup on character respawn
- No external dependencies beyond Obsidian UI

## Troubleshooting

### Fly not working
- Ensure you have a HumanoidRootPart
- Check that BodyVelocity can be created in the workspace
- Try resetting your character

### UI not loading
- Check internet connection for Obsidian UI library
- Verify executor compatibility
- Try reloading the script

### Features not toggling
- Ensure you're not in a restricted game
- Check that your character is spawned
- Verify no conflicting scripts are running

## Development

### Adding a New Feature

1. Create new module in `src/modules/your_feature.lua`
2. Add configuration in `src/utils/config.lua`
3. Register in `src/modules/feature_manager.lua`
4. Create UI in `src/ui/tabs.lua`

### Code Style
- Comments above functions explaining purpose
- Clear variable names
- Modular approach
- No emojis or emoticons

## License

This project is released under the MIT License. See LICENSE file for details.

## Disclaimer

This script is for educational purposes only. Use at your own risk. Roblox may ban accounts that use exploits. Always check the game's terms of service before using any script.

## Support

For issues, feature requests, or contributions, please open an issue or pull request on the repository.

---

**Uranium Hub v1.0** | Professional Roblox Script Framework
