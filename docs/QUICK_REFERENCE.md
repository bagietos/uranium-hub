# Quick Reference - Uranium Hub

Fast reference guide for users and developers.

## For Users

### Installation (30 seconds)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/bagietos/uranium-hub/main/uranium-hub.lua"))()
```

Press **Right Shift** to toggle menu.

### Controls

| Action | Key |
|--------|-----|
| Toggle Menu | Right Shift |
| Move (Flying) | WASD |
| Ascend (Flying) | Space |
| Descend (Flying) | Left Ctrl |

### Features

**Noclip**
- Toggle in Movement tab
- Walk through walls
- No detection

**Fly**
- Toggle in Movement tab
- Adjust speed 10-200
- Smooth physics-based movement

### Troubleshooting

| Problem | Solution |
|---------|----------|
| Menu doesn't appear | Press Right Shift |
| UI fails to load | Check internet connection |
| Script won't execute | Use compatible executor |
| Fly not working | Respawn character |

## For Developers

### File Structure

```
src/
├── main.lua              # Start here
├── modules/              # Feature logic
├── ui/                   # UI components
└── utils/                # Config & helpers
```

### Adding a Feature

1. Create `src/modules/feature.lua`
2. Implement `Enable()`, `Disable()`, `Toggle()`
3. Register in `feature_manager.lua`
4. Add config in `config.lua`
5. Add UI in `tabs.lua`

### Key Files to Edit

| Task | File |
|------|------|
| Change UI appearance | config.lua |
| Add feature | modules/feature.lua |
| Add UI component | ui/tabs.lua |
| Change keybind | config.lua |

### Important Functions

```lua
-- Enable/disable features
FeatureManager:ToggleNoclip()
FeatureManager:ToggleFly()
FeatureManager:DisableAll()

-- Get feature state
FeatureManager:IsNoclipEnabled()
FeatureManager:IsFlyEnabled()

-- Adjust settings
FeatureManager:SetFlySpeed(speed)
FeatureManager:GetFlySpeed()
```

### Testing Locally

```lua
-- In your script executor
loadstring(readfile("path/to/src/main.lua"))()
```

### Building for Distribution

1. All modules are pre-built in `uranium-hub.lua`
2. Update version in `config.lua`
3. Test thoroughly
4. Push to repository
5. Share link

## Architecture Overview

```
User Script Execution
    ↓
Load Obsidian UI Library
    ↓
Initialize Features
    ↓
Create UI Windows/Tabs
    ↓
Listen for User Input
    ↓
Execute Feature Logic
    ↓
Update Game World
```

## Module Relationships

```
main.lua (Orchestrator)
    ↓
feature_manager.lua (Controller)
    ├→ noclip.lua
    └→ fly.lua
    
ui/tabs.lua (UI)
    ↓ Commands
FeatureManager
```

## Configuration Quick Reference

```lua
-- Key settings in config.lua

Config.Keybinds.ToggleMenu           -- Menu toggle key
Config.Features.Fly.DefaultSpeed     -- Fly speed (10-200)
Config.Features.Fly.MaxSpeed         -- Fly speed maximum
Config.UI.WindowSize                 -- Window dimensions
Config.ObsidianUI.Repository         -- UI library URL
```

## Common Tasks

### Change Keybind

Edit `src/utils/config.lua`:
```lua
Config.Keybinds.ToggleMenu = Enum.KeyCode.Insert
```

### Change Fly Speed Range

Edit `src/utils/config.lua`:
```lua
Config.Features.Fly.MinSpeed = 20
Config.Features.Fly.MaxSpeed = 300
```

### Disable a Feature at Startup

Edit `src/utils/config.lua`:
```lua
Config.Features.Noclip.DefaultEnabled = false
Config.Features.Fly.DefaultEnabled = false
```

### Change Window Size

Edit `src/utils/config.lua`:
```lua
Config.UI.WindowSize = UDim2.new(0, 600, 0, 500)
```

## Performance Tips

- Close UI when not in use
- Disable features you're not using
- Clear error logs regularly
- Test in isolated games first

## Debugging

### Enable Console Output

All modules print debug messages:
```
[Noclip] Enabled
[Fly] Disabled
[Uranium Hub] Ready to use
```

### Check for Errors

Open executor console and look for:
- Red error messages
- Load failures
- Connection issues

### Debug a Feature

Add to affected module:
```lua
print("[DEBUG] Variable value: " .. tostring(variable))
```

## Resources

- **Main Docs**: docs/README.md
- **Architecture**: docs/ARCHITECTURE.md
- **Installation**: docs/INSTALLATION.md
- **Contributing**: docs/CONTRIBUTING.md
- **Build Guide**: docs/BUILD.md

## Support Links

- GitHub Issues: Report bugs
- Documentation: Check docs/ folder
- Community Forums: Ask questions
- Discord: Join community (if available)

## Version Info

- **Current Version**: 1.0
- **Status**: Production Ready
- **License**: MIT
- **UI Library**: Obsidian UI v2.x

## Useful Commands

```lua
-- Check if feature is enabled
if FeatureManager:IsNoclipEnabled() then
    -- Feature is on
end

-- Get current fly speed
local speed = FeatureManager:GetFlySpeed()

-- Disable all features
FeatureManager:DisableAll()

-- Initialize on new character
FeatureManager:Initialize(character)

-- Cleanup
FeatureManager:Cleanup()
```

## Common Issues & Fixes

### Issue: "HttpGet not supported"
**Fix**: Use local file loading or compatible executor

### Issue: "Obsidian UI failed to load"
**Fix**: Check internet, wait, try again

### Issue: "Fly feels choppy"
**Fix**: Reduce complexity, restart executor

### Issue: "Noclip not working"
**Fix**: Check game permissions, respawn

## File Sizes

| File | Size |
|------|------|
| uranium-hub.lua | ~35 KB |
| src/main.lua | ~3 KB |
| src/modules/*.lua | ~25 KB |
| src/ui/*.lua | ~12 KB |
| docs/ | ~100 KB |

## Compatibility

- ✓ Windows
- ✓ macOS (untested)
- ✓ Linux (untested)
- ✓ Synapse X
- ✓ Script-Ware
- ✓ Similar executors

## Git Commands

```bash
# Clone repository
git clone https://github.com/bagietos/uranium-hub

# Create feature branch
git checkout -b feature/my-feature

# Commit changes
git commit -m "Add feature X"

# Push to GitHub
git push origin feature/my-feature

# Create pull request via GitHub web interface
```

## Next Steps

1. **Users**: Execute script, press Right Shift
2. **Developers**: Read docs/ARCHITECTURE.md, explore src/
3. **Contributors**: See docs/CONTRIBUTING.md

---

**Uranium Hub v1.0** | Quick Reference Guide
