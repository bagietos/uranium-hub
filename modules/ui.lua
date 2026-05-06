--[[
    ☢️ Uranium Hub - UI Module
    
    Handles all UI rendering using Obsidian UI library.
    Manages tabs, buttons, toggles, and visual elements.
]]

local UI = {}
local Config = require(script.Parent:WaitForChild("config"))
local Utilities = require(script.Parent:WaitForChild("utilities"))

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

--[[
    Initializes the UI module and loads Obsidian UI library
    
    @return boolean - True if successful
]]
function UI:Init()
    self:Log("Initializing Uranium Hub UI...", "INFO")
    
    -- Load Obsidian UI from GitHub
    local success, ObsidianUI = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/deified-user/Obsidian/main/ObsidianUI.lua"))()
    end)
    
    if not success then
        self:Log("Failed to load Obsidian UI library", "ERROR")
        return false
    end
    
    self.ObsidianUI = ObsidianUI
    self:Log("Obsidian UI loaded successfully", "DEBUG")
    
    -- Create main window
    self:CreateWindow()
    self:CreateTabs()
    self:Log("UI initialized successfully", "INFO")
    
    return true
end

-- ============================================================================
-- WINDOW CREATION
-- ============================================================================

--[[
    Creates the main window
]]
function UI:CreateWindow()
    self:Log("Creating main window...", "DEBUG")
    
    local WindowConfig = {
        Name = "☢️ Uranium Hub",
        Size = {X = Config.UI.WindowSize.X, Y = Config.UI.WindowSize.Y},
        Position = {X = Config.UI.WindowPosition.X, Y = Config.UI.WindowPosition.Y},
        Draggable = Config.UI.Draggable,
        Resizable = Config.UI.Resizable,
        ShowTopBar = true,
        TopBarColor = Config.UI.Colors.Primary,
    }
    
    self.Window = self.ObsidianUI:CreateWindow(WindowConfig)
    self:Log("Main window created", "DEBUG")
end

-- ============================================================================
-- TAB CREATION
-- ============================================================================

--[[
    Creates all UI tabs
]]
function UI:CreateTabs()
    self:Log("Creating tabs...", "DEBUG")
    
    -- Home Tab
    self.Tabs = {}
    self.Tabs.Home = self.Window:AddTab({
        Name = "Home",
        Icon = "rbxassetid://7072718975"
    })
    
    -- Universal Tab
    self.Tabs.Universal = self.Window:AddTab({
        Name = "Universal",
        Icon = "rbxassetid://7072720675"
    })
    
    -- ESP Tab
    self.Tabs.ESP = self.Window:AddTab({
        Name = "ESP",
        Icon = "rbxassetid://7072722330"
    })
    
    -- Misc Tab
    self.Tabs.Misc = self.Window:AddTab({
        Name = "Misc",
        Icon = "rbxassetid://7072724385"
    })
    
    -- Settings Tab
    self.Tabs.Settings = self.Window:AddTab({
        Name = "Settings",
        Icon = "rbxassetid://7072725988"
    })
    
    -- Populate tabs
    self:PopulateHomePage()
    self:PopulateUniversalTab()
    self:PopulateESPTab()
    self:PopulateMiscTab()
    self:PopulateSettingsTab()
    
    self:Log("All tabs created successfully", "DEBUG")
end

-- ============================================================================
-- HOME TAB
-- ============================================================================

--[[
    Populates the Home tab with hub information
]]
function UI:PopulateHomePage()
    local tab = self.Tabs.Home
    
    -- Title
    tab:AddLabel({
        Text = "☢️ Uranium Hub v1.0.0"
    })
    
    -- Description
    tab:AddLabel({
        Text = "Professional Universal Script Hub for Roblox",
        Size = 12
    })
    
    -- Divider
    tab:AddDivider()
    
    -- Status Section
    tab:AddLabel({
        Text = "Status",
        Bold = true
    })
    
    tab:AddLabel({
        Text = "• Loaded: " .. os.date("%H:%M:%S"),
        Size = 11
    })
    
    tab:AddLabel({
        Text = "• Players: " .. #game:GetService("Players"):GetPlayers(),
        Size = 11
    })
    
    -- Features Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Features",
        Bold = true
    })
    
    tab:AddLabel({
        Text = "✓ Universal Features (Fly, Noclip, Speed)",
        Size = 11
    })
    
    tab:AddLabel({
        Text = "✓ Advanced ESP System",
        Size = 11
    })
    
    tab:AddLabel({
        Text = "✓ Customizable Settings",
        Size = 11
    })
    
    tab:AddLabel({
        Text = "✓ Performance Optimized",
        Size = 11
    })
    
    -- Links Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Quick Links",
        Bold = true
    })
    
    tab:AddButton({
        Name = "GitHub Repository",
        Callback = function()
            setclipboard("https://github.com/YourUsername/uranium-hub")
            Utilities:Notify("Link Copied", "Repository link copied to clipboard")
        end
    })
    
    tab:AddButton({
        Name = "Report a Bug",
        Callback = function()
            setclipboard("https://github.com/YourUsername/uranium-hub/issues")
            Utilities:Notify("Link Copied", "Issue tracker copied to clipboard")
        end
    })
end

-- ============================================================================
-- UNIVERSAL TAB
-- ============================================================================

--[[
    Populates the Universal tab with common features
]]
function UI:PopulateUniversalTab()
    local tab = self.Tabs.Universal
    
    -- Fly Section
    tab:AddLabel({
        Text = "Flight System",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Enable Fly",
        Default = Config.Features.Fly.Enabled,
        Callback = function(value)
            Config.Features.Fly.Enabled = value
            if value then
                Utilities:Notify("Fly", "Enabled - Press F to activate")
            else
                Utilities:Notify("Fly", "Disabled")
            end
        end
    })
    
    tab:AddSlider({
        Name = "Fly Speed",
        Min = 10,
        Max = 200,
        Default = Config.Features.Fly.Speed,
        Callback = function(value)
            Config.Features.Fly.Speed = value
        end
    })
    
    -- Noclip Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Noclip Mode",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Enable Noclip",
        Default = Config.Features.Noclip.Enabled,
        Callback = function(value)
            Config.Features.Noclip.Enabled = value
            if value then
                Utilities:Notify("Noclip", "Enabled - Press X to activate")
            else
                Utilities:Notify("Noclip", "Disabled")
            end
        end
    })
    
    tab:AddSlider({
        Name = "Noclip Speed",
        Min = 5,
        Max = 100,
        Default = Config.Features.Noclip.Speed,
        Callback = function(value)
            Config.Features.Noclip.Speed = value
        end
    })
    
    -- Walk Speed Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Speed Enhancements",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Infinite Walk Speed",
        Default = Config.Features.WalkSpeed.Enabled,
        Callback = function(value)
            Config.Features.WalkSpeed.Enabled = value
            if value then
                Utilities:Notify("Walk Speed", "Enabled")
            else
                Utilities:Notify("Walk Speed", "Disabled")
            end
        end
    })
    
    tab:AddSlider({
        Name = "Walk Speed Value",
        Min = 16,
        Max = 300,
        Default = Config.Features.WalkSpeed.Speed,
        Callback = function(value)
            Config.Features.WalkSpeed.Speed = value
        end
    })
    
    -- Jump Power Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Jump Enhancement",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Infinite Jump Power",
        Default = Config.Features.JumpPower.Enabled,
        Callback = function(value)
            Config.Features.JumpPower.Enabled = value
            if value then
                Utilities:Notify("Jump Power", "Enabled")
            else
                Utilities:Notify("Jump Power", "Disabled")
            end
        end
    })
    
    tab:AddSlider({
        Name = "Jump Power Value",
        Min = 50,
        Max = 300,
        Default = Config.Features.JumpPower.Power,
        Callback = function(value)
            Config.Features.JumpPower.Power = value
        end
    })
    
    -- Invincibility Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Invincibility",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "God Mode",
        Default = Config.Features.GodMode.Enabled,
        Callback = function(value)
            Config.Features.GodMode.Enabled = value
            if value then
                Utilities:Notify("God Mode", "Enabled - Press Z to toggle")
            else
                Utilities:Notify("God Mode", "Disabled")
            end
        end
    })
    
    tab:AddToggle({
        Name = "Infinite Stamina",
        Default = Config.Features.InfiniteStamina.Enabled,
        Callback = function(value)
            Config.Features.InfiniteStamina.Enabled = value
            if value then
                Utilities:Notify("Infinite Stamina", "Enabled")
            else
                Utilities:Notify("Infinite Stamina", "Disabled")
            end
        end
    })
end

-- ============================================================================
-- ESP TAB
-- ============================================================================

--[[
    Populates the ESP tab with player detection features
]]
function UI:PopulateESPTab()
    local tab = self.Tabs.ESP
    
    -- Main Toggle
    tab:AddLabel({
        Text = "Player Detection",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Enable ESP",
        Default = Config.ESP.Enabled,
        Callback = function(value)
            Config.ESP.Enabled = value
            if value then
                Utilities:Notify("ESP", "Enabled - Press E to toggle")
            else
                Utilities:Notify("ESP", "Disabled")
            end
        end
    })
    
    tab:AddSlider({
        Name = "ESP Update Rate",
        Min = 0.01,
        Max = 1,
        Default = Config.ESP.UpdateRate,
        Callback = function(value)
            Config.ESP.UpdateRate = value
        end
    })
    
    -- Rendering Options
    tab:AddDivider()
    tab:AddLabel({
        Text = "Rendering",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Box ESP",
        Default = Config.ESP.ShowBox,
        Callback = function(value)
            Config.ESP.ShowBox = value
        end
    })
    
    tab:AddToggle({
        Name = "Tracer Lines",
        Default = Config.ESP.ShowTracer,
        Callback = function(value)
            Config.ESP.ShowTracer = value
        end
    })
    
    tab:AddToggle({
        Name = "Show Names",
        Default = Config.ESP.ShowNames,
        Callback = function(value)
            Config.ESP.ShowNames = value
        end
    })
    
    tab:AddToggle({
        Name = "Show Distance",
        Default = Config.ESP.ShowDistance,
        Callback = function(value)
            Config.ESP.ShowDistance = value
        end
    })
    
    tab:AddToggle({
        Name = "Health Bars",
        Default = Config.ESP.ShowHealthBar,
        Callback = function(value)
            Config.ESP.ShowHealthBar = value
        end
    })
    
    -- Advanced Settings
    tab:AddDivider()
    tab:AddLabel({
        Text = "Advanced",
        Bold = true
    })
    
    tab:AddSlider({
        Name = "Max ESP Distance",
        Min = 100,
        Max = 5000,
        Default = Config.ESP.MaxDistance,
        Callback = function(value)
            Config.ESP.MaxDistance = value
        end
    })
    
    tab:AddSlider({
        Name = "Box Thickness",
        Min = 1,
        Max = 5,
        Default = Config.ESP.BoxThickness,
        Callback = function(value)
            Config.ESP.BoxThickness = value
        end
    })
end

-- ============================================================================
-- MISC TAB
-- ============================================================================

--[[
    Populates the Misc tab with miscellaneous features
]]
function UI:PopulateMiscTab()
    local tab = self.Tabs.Misc
    
    -- Teleport Section
    tab:AddLabel({
        Text = "Teleportation",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Enable Teleport",
        Default = Config.Features.Teleport.Enabled,
        Callback = function(value)
            Config.Features.Teleport.Enabled = value
        end
    })
    
    -- Coordinates Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Display",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Show Coordinates",
        Default = Config.Misc.CoordinateDisplay.Enabled,
        Callback = function(value)
            Config.Misc.CoordinateDisplay.Enabled = value
        end
    })
    
    tab:AddToggle({
        Name = "Performance Stats",
        Default = Config.Misc.PerformanceStats.Enabled,
        Callback = function(value)
            Config.Misc.PerformanceStats.Enabled = value
        end
    })
    
    -- Utilities Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "Utilities",
        Bold = true
    })
    
    tab:AddButton({
        Name = "Copy Character Position",
        Callback = function()
            local root = Utilities:GetLocalRoot()
            if root then
                local pos = root.Position
                setclipboard(string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z))
                Utilities:Notify("Position", "Copied to clipboard")
            end
        end
    })
    
    tab:AddButton({
        Name = "Reset Character",
        Callback = function()
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.Health = 0
            end
        end
    })
end

-- ============================================================================
-- SETTINGS TAB
-- ============================================================================

--[[
    Populates the Settings tab with configuration options
]]
function UI:PopulateSettingsTab()
    local tab = self.Tabs.Settings
    
    -- UI Settings
    tab:AddLabel({
        Text = "UI Settings",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Notifications",
        Default = Config.Notifications.Enabled,
        Callback = function(value)
            Config.Notifications.Enabled = value
        end
    })
    
    tab:AddSlider({
        Name = "Notification Duration",
        Min = 1,
        Max = 10,
        Default = Config.Notifications.Duration,
        Callback = function(value)
            Config.Notifications.Duration = value
        end
    })
    
    -- Performance Settings
    tab:AddDivider()
    tab:AddLabel({
        Text = "Performance",
        Bold = true
    })
    
    tab:AddToggle({
        Name = "Optimize ESP",
        Default = Config.Performance.OptimizeESP,
        Callback = function(value)
            Config.Performance.OptimizeESP = value
        end
    })
    
    tab:AddSlider({
        Name = "Target FPS",
        Min = 30,
        Max = 240,
        Default = Config.Performance.MaxFPS,
        Callback = function(value)
            Config.Performance.MaxFPS = value
        end
    })
    
    -- About Section
    tab:AddDivider()
    tab:AddLabel({
        Text = "About",
        Bold = true
    })
    
    tab:AddLabel({
        Text = "Uranium Hub v1.0.0",
        Size = 12
    })
    
    tab:AddLabel({
        Text = "Made with ☢️ for Roblox",
        Size = 11
    })
    
    tab:AddDivider()
    tab:AddButton({
        Name = "Unload Hub",
        Callback = function()
            self:Unload()
        end
    })
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--[[
    Logs UI messages for debugging
]]
function UI:Log(message, level)
    Utilities:Log("[UI] " .. message, level)
end

--[[
    Unloads the entire hub
]]
function UI:Unload()
    self:Log("Unloading Uranium Hub...", "INFO")
    if self.Window then
        -- Cleanup will be handled by the main module
    end
    Utilities:Notify("Hub", "Unloading...")
end

return UI
