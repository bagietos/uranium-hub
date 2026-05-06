--[[
    URANIUM HUB - UI Tabs Module
    Handles creation of all UI tabs
]]

local Config = require(script.Parent.Parent.utils.config)
local FeatureManager = require(script.Parent.Parent.modules.feature_manager)

local UITabs = {}

-- ============================================================================
-- CREATE HOME TAB
-- ============================================================================

--[[
    CreateHomeTab: Create the home information tab
    @param window: The UI window object
]]
function UITabs:CreateHomeTab(window)
    local HomeTab = window:CreateTab({
        Name = "Home",
        Icon = Config.Icons.Home
    })
    
    HomeTab:CreateLabel({
        Text = "Uranium Hub - Universal Script"
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Version: " .. Config.UI.Version
    })
    
    HomeTab:CreateLabel({
        Text = "A professional, lightweight universal script hub with essential movement features and a clean, minimalistic interface."
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Core Features:"
    })
    
    HomeTab:CreateLabel({
        Text = "- Noclip: Walk through walls and solid objects"
    })
    
    HomeTab:CreateLabel({
        Text = "- Fly: Smooth flight movement with customizable speed"
    })
    
    HomeTab:CreateLabel({
        Text = "- Settings: Fine-tune your experience"
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Controls:"
    })
    
    HomeTab:CreateLabel({
        Text = "Toggle Menu: Press Right Shift"
    })
    
    HomeTab:CreateLabel({
        Text = "Fly Controls: WASD to move, Space/Ctrl for vertical movement"
    })
    
    return HomeTab
end

-- ============================================================================
-- CREATE MOVEMENT TAB
-- ============================================================================

--[[
    CreateMovementTab: Create the movement features tab
    @param window: The UI window object
]]
function UITabs:CreateMovementTab(window)
    local MovementTab = window:CreateTab({
        Name = "Movement",
        Icon = Config.Icons.Movement
    })
    
    -- NOCLIP TOGGLE
    local NoclipToggle = MovementTab:CreateToggle({
        Name = "Noclip",
        Default = Config.Features.Noclip.DefaultEnabled,
        Callback = function(Value)
            if Value then
                FeatureManager:ToggleNoclip()
            else
                FeatureManager:ToggleNoclip()
            end
        end
    })
    
    MovementTab:CreateLabel({
        Text = Config.Features.Noclip.Description
    })
    
    MovementTab:CreateDivider()
    
    -- FLY TOGGLE
    local FlyToggle = MovementTab:CreateToggle({
        Name = "Fly",
        Default = Config.Features.Fly.DefaultEnabled,
        Callback = function(Value)
            if Value then
                FeatureManager:ToggleFly()
            else
                FeatureManager:ToggleFly()
            end
        end
    })
    
    MovementTab:CreateLabel({
        Text = Config.Features.Fly.Description
    })
    
    -- FLY SPEED SLIDER
    local FlySpeedSlider = MovementTab:CreateSlider({
        Name = "Fly Speed",
        Min = Config.Features.Fly.MinSpeed,
        Max = Config.Features.Fly.MaxSpeed,
        Default = Config.Features.Fly.DefaultSpeed,
        Rounded = 1,
        Callback = function(Value)
            FeatureManager:SetFlySpeed(Value)
        end
    })
    
    return {
        Tab = MovementTab,
        NoclipToggle = NoclipToggle,
        FlyToggle = FlyToggle,
        FlySpeedSlider = FlySpeedSlider
    }
end

-- ============================================================================
-- CREATE SETTINGS TAB
-- ============================================================================

--[[
    CreateSettingsTab: Create the settings tab
    @param window: The UI window object
    @param toggles: Table containing UI toggles for updating
]]
function UITabs:CreateSettingsTab(window, toggles)
    local SettingsTab = window:CreateTab({
        Name = "Settings",
        Icon = Config.Icons.Settings
    })
    
    SettingsTab:CreateLabel({
        Text = "User Interface Settings"
    })
    
    SettingsTab:CreateDivider()
    
    SettingsTab:CreateLabel({
        Text = "Manage all active features and reset the hub state."
    })
    
    SettingsTab:CreateDivider()
    
    -- DISABLE ALL BUTTON
    local DisableAllButton = SettingsTab:CreateButton({
        Name = "Disable All Features",
        Callback = function()
            FeatureManager:DisableAll()
            if toggles.NoclipToggle then
                toggles.NoclipToggle:Set(false)
            end
            if toggles.FlyToggle then
                toggles.FlyToggle:Set(false)
            end
        end
    })
    
    SettingsTab:CreateLabel({
        Text = "Disables all active features and resets to default state"
    })
    
    return SettingsTab
end

return UITabs
