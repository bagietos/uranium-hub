# Architecture - Uranium Hub

Technical documentation of Uranium Hub's modular design and architecture.

## System Design

```
┌─────────────────────────────────────────────────────────┐
│                   URANIUM HUB SYSTEM                     │
├─────────────────────────────────────────────────────────┤
│                    src/main.lua                          │
│              (Orchestration & Startup)                   │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────┐  ┌──────────────────────────────┐  │
│  │   UI System      │  │   Feature System             │  │
│  ├──────────────────┤  ├──────────────────────────────┤  │
│  │ - window.lua     │  │ - feature_manager.lua        │  │
│  │ - tabs.lua       │  │   - noclip.lua               │  │
│  │                  │  │   - fly.lua                  │  │
│  └──────────────────┘  └──────────────────────────────┘  │
│                                                           │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              Utilities & Configuration               │ │
│  ├──────────────────────────────────────────────────────┤ │
│  │ - config.lua (Central configuration)                │ │
│  │ - helpers.lua (Utility functions)                   │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Module Breakdown

### src/main.lua - Entry Point

**Responsibilities:**
- Load Obsidian UI library
- Initialize all modules
- Create the main UI interface
- Handle character respawn events
- Manage cleanup

**Initialization Flow:**
1. Load Config and Helpers
2. Load FeatureManager
3. Load UI modules
4. Create main interface
5. Setup event handlers
6. Print ready message

### src/modules/ - Feature Modules

#### noclip.lua
**Purpose:** Handles collision bypass for walking through walls

**Key Methods:**
- `Enable()` - Activate noclip, disable collisions
- `Disable()` - Deactivate noclip, re-enable collisions
- `Toggle()` - Switch noclip state
- `SetCharacter()` - Update character reference
- `Cleanup()` - Clean up resources

**Implementation:**
- Uses `RunService.Stepped` for continuous updates
- Sets `part.CanCollide = false` on all character parts
- Re-enables collision on disable

#### fly.lua
**Purpose:** Smooth flight movement system

**Key Methods:**
- `Enable()` - Start flight mode
- `Disable()` - Stop flight mode
- `Toggle()` - Switch flight state
- `SetSpeed()` - Configure flight speed
- `SetCharacter()` - Update character reference

**Implementation:**
- Creates `BodyVelocity` object in HumanoidRootPart
- Uses `RenderStepped` for smooth 60 FPS movement
- Handles WASD input with `UserInputService`
- Space/Ctrl for vertical movement
- Velocity direction decays for smooth handling

#### feature_manager.lua
**Purpose:** Centralized feature orchestration

**Key Methods:**
- `Initialize()` - Setup all features
- `ToggleNoclip()` - Toggle noclip
- `ToggleFly()` - Toggle fly
- `SetFlySpeed()` - Set fly speed
- `DisableAll()` - Disable all active features
- `Cleanup()` - Clean up all features

**Pattern:** Facade pattern - provides unified interface to all features

### src/ui/ - User Interface Modules

#### window.lua
**Purpose:** Main window creation and management

**Responsibilities:**
- Create Obsidian UI window
- Apply configuration from Config
- Return window object to tabs module

#### tabs.lua
**Purpose:** Tab creation and UI components

**Key Functions:**
- `CreateHomeTab()` - Information tab
- `CreateMovementTab()` - Features tab
- `CreateSettingsTab()` - Settings and controls tab

**Integration:**
- Uses FeatureManager for feature control
- Returns toggle objects for state management
- All UI configuration from Config module

### src/utils/ - Utilities & Configuration

#### config.lua
**Purpose:** Single source of truth for all configuration

**Sections:**
- UI settings (name, version, window size)
- Keybinds configuration
- Feature defaults
- Icons (Roblox asset IDs)
- Messages and logging text

**Usage Pattern:**
```lua
local Config = require(script.Parent.utils.config)
Config.UI.Name -- Access configuration
```

#### helpers.lua
**Purpose:** Reusable utility functions

**Functions:**
- `LoadFromUrl()` - Safe HTTP request and code loading
- `Merge()` - Merge two tables
- `Clamp()` - Clamp value between min/max
- `Log()` - Formatted logging
- `Warn()` - Formatted warnings

**Error Handling:**
- Wraps HTTP requests in pcall
- Validates HTTP status codes
- Safe code execution with error handling

## Data Flow

### Feature Toggle Flow
```
UI Toggle Button
    ↓
Callback function
    ↓
FeatureManager:ToggleFeature()
    ↓
Feature Module:Enable() / Disable()
    ↓
RunService connection / BodyVelocity update
    ↓
Visible effect in-game
```

### Character Respawn Flow
```
Player.CharacterAdded event
    ↓
New character reference
    ↓
FeatureManager:Initialize(newCharacter)
    ↓
All modules update character reference
    ↓
Features disabled (automatic cleanup)
```

### Initialization Flow
```
main.lua executes
    ↓
Load Obsidian UI Library
    ↓
FeatureManager:Initialize(Character)
    ↓
CreateMainInterface()
    ↓
UIWindow:Create()
    ↓
UITabs:CreateHomeTab()
UITabs:CreateMovementTab()
UITabs:CreateSettingsTab()
    ↓
UI Ready, print ready message
```

## Key Design Patterns

### 1. Modular Architecture
- Each feature is self-contained
- Modules can be added/removed independently
- Clear separation of concerns

### 2. Facade Pattern
- FeatureManager provides unified interface
- Hides internal feature complexity
- Simplifies UI integration

### 3. Single Responsibility
- Each module has one clear purpose
- Main.lua orchestrates, doesn't implement
- Config centralizes settings

### 4. Dependency Injection
- Features receive character reference via SetCharacter()
- UI receives FeatureManager for control
- Loose coupling between modules

### 5. Configuration Management
- All settings in Config module
- No magic strings/numbers
- Easy to modify without code changes

## Service Integration

**RunService:**
- `Stepped` - Noclip collision updates
- `RenderStepped` - Fly movement (60 FPS)

**UserInputService:**
- `InputBegan` - Fly controls input

**Players:**
- Character spawning/respawning
- LocalPlayer reference

## Performance Considerations

### Noclip
- Uses efficient Stepped connection
- Only runs when enabled
- Minimal CPU impact

### Fly
- Uses RenderStepped for smooth visuals
- BodyVelocity is optimized physics
- Input handling minimal overhead

### UI
- Obsidian UI is lightweight
- Modular tab system
- No continuous rendering unless visible

## Extension Points

### Adding a New Feature

1. Create `src/modules/your_feature.lua`
   - Follow same structure as noclip.lua/fly.lua
   - Implement Enable/Disable/Toggle/SetCharacter

2. Update `src/modules/feature_manager.lua`
   - Add require statement
   - Add toggle method
   - Add to DisableAll()

3. Update `src/utils/config.lua`
   - Add feature configuration

4. Update `src/ui/tabs.lua`
   - Create toggle/controls in appropriate tab
   - Connect to FeatureManager

5. Done! Feature is integrated

## Security & Safety

- HttpGet used with error handling
- No code evaluation without verification
- Automatic cleanup on respawn
- No permanent game modifications
- Collision is re-enabled on disable

---

**Uranium Hub v1.0** | Technical Architecture
