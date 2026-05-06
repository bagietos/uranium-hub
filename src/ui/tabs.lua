local Config = require(script.Parent.Parent.utils.config)
local FeatureManager = require(script.Parent.Parent.modules.feature_manager)

local UITabs = {}

function UITabs:CreateHomeTab(window)
    local HomeTab = window:CreateTab("Home", 7734073543)

    HomeTab:CreateSection("Uranium Hub v" .. Config.UI.Version)
    HomeTab:CreateLabel("A professional, lightweight universal script hub with essential movement features.")
    HomeTab:CreateSection("Features")
    HomeTab:CreateLabel("Noclip: Walk through walls and solid objects")
    HomeTab:CreateLabel("Fly: Smooth flight movement with customizable speed")
    HomeTab:CreateSection("Controls")
    HomeTab:CreateLabel("Toggle Menu: Press Right Shift")
    HomeTab:CreateLabel("Fly: WASD to move, Space/Ctrl for vertical movement")

    return HomeTab
end

function UITabs:CreateMovementTab(window)
    local MovementTab = window:CreateTab("Movement", 7734067945)

    MovementTab:CreateSection("Noclip")
    local NoclipToggle = MovementTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = Config.Features.Noclip.DefaultEnabled,
        Flag = "NoclipToggle",
        Callback = function(Value)
            if Value then
                FeatureManager:ToggleNoclip()
            else
                FeatureManager:ToggleNoclip()
            end
        end,
    })
    MovementTab:CreateLabel(Config.Features.Noclip.Description)

    MovementTab:CreateSection("Fly")
    local FlyToggle = MovementTab:CreateToggle({
        Name = "Fly",
        CurrentValue = Config.Features.Fly.DefaultEnabled,
        Flag = "FlyToggle",
        Callback = function(Value)
            if Value then
                FeatureManager:ToggleFly()
            else
                FeatureManager:ToggleFly()
            end
        end,
    })
    MovementTab:CreateLabel(Config.Features.Fly.Description)

    local FlySpeedSlider = MovementTab:CreateSlider({
        Name = "Fly Speed",
        Range = {Config.Features.Fly.MinSpeed, Config.Features.Fly.MaxSpeed},
        Increment = 1,
        CurrentValue = Config.Features.Fly.DefaultSpeed,
        Flag = "FlySpeed",
        Callback = function(Value)
            FeatureManager:SetFlySpeed(Value)
        end,
    })

    return {
        Tab = MovementTab,
        NoclipToggle = NoclipToggle,
        FlyToggle = FlyToggle,
        FlySpeedSlider = FlySpeedSlider,
    }
end

function UITabs:CreateSettingsTab(window, toggles)
    local SettingsTab = window:CreateTab("Settings", 7734068149)

    SettingsTab:CreateSection("Feature Management")
    SettingsTab:CreateLabel("Manage all active features and reset the hub state.")

    SettingsTab:CreateButton({
        Name = "Disable All Features",
        Callback = function()
            FeatureManager:DisableAll()
            if toggles.NoclipToggle then
                toggles.NoclipToggle:Set(false)
            end
            if toggles.FlyToggle then
                toggles.FlyToggle:Set(false)
            end
        end,
    })
    SettingsTab:CreateLabel("Disables all active features and resets to default state.")

    return SettingsTab
end

return UITabs
