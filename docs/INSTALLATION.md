# Installation Guide - Uranium Hub

## System Requirements

- Windows, macOS, or Linux
- Roblox game installed and running
- A script executor with HttpGet support:
  - Synapse X
  - Script-Ware
  - Ev3nt Hub
  - Similar modern executors

## Installation Steps

### Option 1: Direct Script Execution

1. **Open your script executor**
2. **Paste the main entry point:**
   ```lua
   loadstring(game:HttpGet("https://your-hosting-url/src/main.lua"))()
   ```
3. **Execute** (Ctrl+Enter or your executor's execute button)
4. **Press Right Shift** to open the menu

### Option 2: Local File Installation

1. **Clone or download** the repository
2. **Place files** in your script executor's directory
3. **Execute main.lua:**
   ```lua
   loadstring(readfile("path/to/src/main.lua"))()
   ```

### Option 3: Manual Copy-Paste

If your executor doesn't support HttpGet:

1. Open `src/main.lua`
2. Copy the entire content
3. Paste into your script executor
4. Execute

## First Run

After executing for the first time:

1. The Obsidian UI library will automatically load
2. A window titled "Uranium Hub" will appear
3. You should see three tabs: Home, Movement, Settings
4. Press Right Shift to toggle menu visibility

## Troubleshooting Installation

### Error: "HttpGet is not supported"
- Use Option 2 or 3 above
- Contact your executor developer for updates

### Error: "Failed to load Obsidian UI library"
- Check your internet connection
- Ensure you're not blocked from GitHub
- Try executing again in a few moments

### Window doesn't appear
- Press Right Shift to toggle visibility
- Check if your executor supports Obsidian UI
- Restart the game and executor

### Script errors after execution
- Verify all files are present and correctly named
- Check that your executor supports the required functions
- Ensure you're in a valid Roblox game

## Post-Installation Setup

### Customize Configuration

Edit `src/utils/config.lua` to customize:

```lua
-- Change toggle key
Config.Keybinds.ToggleMenu = Enum.KeyCode.Insert

-- Adjust window size
Config.UI.WindowSize = UDim2.new(0, 600, 0, 450)

-- Set default fly speed
Config.Features.Fly.DefaultSpeed = 75
```

### Test Features

1. **Test Noclip:**
   - Go to Movement tab
   - Toggle "Noclip"
   - Try walking through a wall
   - Toggle off

2. **Test Fly:**
   - Go to Movement tab
   - Toggle "Fly"
   - Press WASD to move
   - Use Space/Ctrl for vertical movement
   - Adjust speed slider
   - Toggle off

## Uninstallation

To remove Uranium Hub:

1. Simply close the script or restart your game
2. All features will automatically disable
3. No permanent changes are made to your account
4. No files remain after script termination

## Getting Help

If you encounter issues:

1. Check this guide for common problems
2. Review the main README.md
3. Check the Architecture documentation
4. Ask in community forums or support channels

## Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- Check [CONTRIBUTING.md](CONTRIBUTING.md) if interested in development
- Explore the code in `src/` directory

---

**Uranium Hub v1.0** | Installation Complete
