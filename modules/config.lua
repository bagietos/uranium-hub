--[[
    ☢️ Uranium Hub - Configuration Module
    
    Central configuration file for all hub features.
    Modify settings here to customize behavior across the entire hub.
]]

local Config = {}

-- ============================================================================
-- UI SETTINGS
-- ============================================================================

Config.UI = {
    Enabled = true,
    Theme = "dark",                    -- "dark" or "light"
    WindowSize = {X = 500, Y = 600},
    WindowPosition = {X = 50, Y = 50},
    Draggable = true,
    Resizable = true,
    CornerRadius = 12,
    TextSize = 14,
    FontFace = Enum.Font.GothamBold,
    
    -- Colors
    Colors = {
        Primary = Color3.fromRGB(255, 193, 7),      -- Uranium Yellow
        Secondary = Color3.fromRGB(45, 45, 45),     -- Dark background
        Accent = Color3.fromRGB(76, 175, 80),       -- Green
        Text = Color3.fromRGB(255, 255, 255),       -- White
        Danger = Color3.fromRGB(244, 67, 54),       -- Red
    },
}

-- ============================================================================
-- UNIVERSAL FEATURES SETTINGS
-- ============================================================================

Config.Features = {
    
    -- Fly System
    Fly = {
        Enabled = false,
        Speed = 50,
        Acceleration = 5,
        MaxSpeed = 200,
        Keybind = Enum.KeyCode.F,
        ShowNotification = true,
    },
    
    -- Noclip Mode
    Noclip = {
        Enabled = false,
        Speed = 25,
        Keybind = Enum.KeyCode.X,
        ShowNotification = true,
    },
    
    -- Walk Speed Enhancement
    WalkSpeed = {
        Enabled = false,
        Speed = 100,
        Default = 16,
        MaxSpeed = 300,
        Keybind = Enum.KeyCode.W,
        ShowNotification = true,
    },
    
    -- Jump Power Enhancement
    JumpPower = {
        Enabled = false,
        Power = 100,
        Default = 50,
        MaxPower = 300,
        Keybind = Enum.KeyCode.J,
        ShowNotification = true,
    },
    
    -- God Mode (Anti-Damage)
    GodMode = {
        Enabled = false,
        Keybind = Enum.KeyCode.Z,
        ShowNotification = true,
    },
    
    -- Infinite Stamina
    InfiniteStamina = {
        Enabled = false,
        Keybind = Enum.KeyCode.S,
        ShowNotification = true,
    },
    
    -- Teleport System
    Teleport = {
        Enabled = false,
        Speed = 50,
        ShowNotification = true,
    },
}

-- ============================================================================
-- ESP SETTINGS
-- ============================================================================

Config.ESP = {
    Enabled = false,
    Keybind = Enum.KeyCode.E,
    UpdateRate = 0.1,                  -- Update every 0.1 seconds
    
    -- ESP Features
    ShowBox = true,
    ShowTracer = true,
    ShowNames = true,
    ShowDistance = true,
    ShowHealthBar = true,
    ShowTeamColor = true,
    
    -- Rendering
    BoxThickness = 2,
    TracerThickness = 1,
    HealthBarHeight = 3,
    HealthBarWidth = 40,
    MaxDistance = 1000,                -- Don't render beyond 1000 studs
    
    -- Colors
    Colors = {
        Enemy = Color3.fromRGB(255, 0, 0),         -- Red
        Ally = Color3.fromRGB(0, 255, 0),          -- Green
        Neutral = Color3.fromRGB(255, 255, 255),   -- White
        HealthFull = Color3.fromRGB(0, 255, 0),    -- Green
        HealthLow = Color3.fromRGB(255, 0, 0),     -- Red
    },
}

-- ============================================================================
-- MISC SETTINGS
-- ============================================================================

Config.Misc = {
    -- Coordinate Display
    CoordinateDisplay = {
        Enabled = false,
        UpdateRate = 0.5,
        Position = {X = 10, Y = 10},
        ShowNotification = true,
    },
    
    -- Performance Stats
    PerformanceStats = {
        Enabled = false,
        UpdateRate = 1.0,
        ShowFPS = true,
        ShowMemory = true,
        ShowPlayers = true,
    },
}

-- ============================================================================
-- NOTIFICATION SETTINGS
-- ============================================================================

Config.Notifications = {
    Enabled = true,
    Duration = 3,
    Position = "top-right",            -- "top-left", "top-right", "bottom-left", "bottom-right"
    MaxNotifications = 5,
}

-- ============================================================================
-- KEYBIND SETTINGS
-- ============================================================================

Config.Keybinds = {
    Unload = Enum.KeyCode.Delete,      -- Unload entire hub
    ToggleUI = Enum.KeyCode.Home,      -- Toggle UI visibility
}

-- ============================================================================
-- PERFORMANCE SETTINGS
-- ============================================================================

Config.Performance = {
    MaxFPS = 60,
    RenderDistance = 500,
    OptimizeESP = true,                -- Disable ESP rendering far objects
    BatchRenderUpdates = true,         -- Batch render updates for performance
}

-- ============================================================================
-- LOGGING SETTINGS
-- ============================================================================

Config.Logging = {
    Enabled = true,
    LogLevel = "INFO",                 -- "DEBUG", "INFO", "WARNING", "ERROR"
    LogToConsole = true,
    MaxLogSize = 1000,                 -- Max console logs to keep
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--[[
    Gets a setting value with fallback to default
    
    @param path string - Dot notation path (e.g., "Features.Fly.Speed")
    @param default any - Default value if not found
    @return any - The setting value
]]
function Config:Get(path, default)
    local parts = string.split(path, ".")
    local current = self
    
    for _, part in ipairs(parts) do
        if type(current) == "table" and current[part] then
            current = current[part]
        else
            return default
        end
    end
    
    return current
end

--[[
    Sets a setting value
    
    @param path string - Dot notation path (e.g., "Features.Fly.Speed")
    @param value any - New value
]]
function Config:Set(path, value)
    local parts = string.split(path, ".")
    local current = self
    
    for i = 1, #parts - 1 do
        local part = parts[i]
        if not current[part] then
            current[part] = {}
        end
        current = current[part]
    end
    
    current[parts[#parts]] = value
end

--[[
    Resets all settings to defaults
]]
function Config:Reset()
    -- This would be called with a backup of defaults
    warn("Config reset not yet implemented")
end

return Config
