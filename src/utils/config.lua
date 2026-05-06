--[[
    URANIUM HUB - Configuration Module
    Central configuration for the entire hub system
]]

local Config = {}

-- ============================================================================
-- UI CONFIGURATION
-- ============================================================================

Config.UI = {
    Name = "Uranium Hub",
    Version = "1.0",
    WindowSize = UDim2.new(0, 550, 0, 400),
    HasClosing = true,
    HasMinimizing = true,
    Draggable = true,
    FadeSpeed = 0.3,
}

-- ============================================================================
-- KEYBINDS
-- ============================================================================

Config.Keybinds = {
    ToggleMenu = Enum.KeyCode.RightShift,
    -- Additional keybinds can be added here
}

-- ============================================================================
-- FEATURES CONFIGURATION
-- ============================================================================

Config.Features = {
    Noclip = {
        Name = "Noclip",
        Description = "Walk through walls and solid objects",
        DefaultEnabled = false,
    },
    Fly = {
        Name = "Fly",
        Description = "Smooth flight movement - Use WASD to move, Space/Ctrl to ascend/descend",
        DefaultEnabled = false,
        DefaultSpeed = 50,
        MinSpeed = 10,
        MaxSpeed = 200,
    },
}

-- ============================================================================
-- RAYFIELD UI SETTINGS
-- ============================================================================

Config.Rayfield = {
    Repository = "https://sirius.menu/rayfield",
    Theme = "Default",
}

-- ============================================================================
-- ICONS (Roblox Asset IDs)
-- ============================================================================

Config.Icons = {
    Home = "rbxassetid://7734073543",
    Movement = "rbxassetid://7734067945",
    Settings = "rbxassetid://7734068149",
}

-- ============================================================================
-- MESSAGES
-- ============================================================================

Config.Messages = {
    LoadingUI = "[Uranium Hub] Loading Rayfield UI Library...",
    UILoaded = "[Uranium Hub] UI Loaded Successfully",
    UIFailed = "[Uranium Hub] Failed to load UI library",
    Initialized = "[Uranium Hub] Initialization complete",
    Ready = "[Uranium Hub] Ready to use. Press Right Shift to toggle menu.",
    CharacterRespawned = "[Uranium Hub] Character respawned, features reset",
    FeatureEnabled = "[Uranium Hub] %s enabled",
    FeatureDisabled = "[Uranium Hub] %s disabled",
}

return Config
