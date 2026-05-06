--[[
    URANIUM HUB - Single File Distribution Version
    
    This is an auto-generated consolidated version of Uranium Hub.
    Use this for distribution when you don't want users to manage multiple files.
    
    To generate: Use the build script in docs/BUILD.md
]]

-- ============================================================================
-- CONFIG MODULE (src/utils/config.lua)
-- ============================================================================

local Config = {}

Config.UI = {
    Name = "Uranium Hub",
    Version = "1.0",
    WindowSize = UDim2.new(0, 550, 0, 400),
    HasClosing = true,
    HasMinimizing = true,
    Draggable = true,
    FadeSpeed = 0.3,
}

Config.Keybinds = {
    ToggleMenu = Enum.KeyCode.RightShift,
}

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

Config.ObsidianUI = {
    Repository = "https://raw.githubusercontent.com/ViktorVaughn/Obsidian-UI/main/Obsidian%20UI.lua",
    Fallback = "https://pastefy.app/code/raw/raw",
    Timeout = 10,
}

Config.Icons = {
    Home = "rbxassetid://7734073543",
    Movement = "rbxassetid://7734067945",
    Settings = "rbxassetid://7734068149",
}

Config.Messages = {
    LoadingUI = "[Uranium Hub] Loading Obsidian UI Library...",
    UILoaded = "[Uranium Hub] UI Loaded Successfully",
    UIFailed = "[Uranium Hub] Failed to load UI library",
    Initialized = "[Uranium Hub] Initialization complete",
    Ready = "[Uranium Hub] Ready to use. Press Right Shift to toggle menu.",
    CharacterRespawned = "[Uranium Hub] Character respawned, features reset",
    FeatureEnabled = "[Uranium Hub] %s enabled",
    FeatureDisabled = "[Uranium Hub] %s disabled",
}

-- ============================================================================
-- HELPERS MODULE (src/utils/helpers.lua)
-- ============================================================================

local Helpers = {}

function Helpers.LoadFromUrl(url, fallbackUrl)
    local success, response = pcall(function()
        return syn.request({
            Url = url,
            Method = "GET"
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local loadSuccess, result = pcall(function()
            return loadstring(response.Body)()
        end)
        
        if loadSuccess and result then
            return result
        end
    end
    
    -- Try fallback URL if available
    if fallbackUrl then
        local fallbackSuccess, fallbackResponse = pcall(function()
            return syn.request({
                Url = fallbackUrl,
                Method = "GET"
            })
        end)
        
        if fallbackSuccess and fallbackResponse and fallbackResponse.StatusCode == 200 then
            local loadSuccess, result = pcall(function()
                return loadstring(fallbackResponse.Body)()
            end)
            
            if loadSuccess and result then
                return result
            end
        end
    end
    
    warn("Failed to load from URL: " .. url)
    return nil
end

function Helpers.Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

function Helpers.Log(message)
    print(message)
end

-- ============================================================================
-- NOCLIP MODULE (src/modules/noclip.lua)
-- ============================================================================

local RunService = game:GetService("RunService")

local Noclip = {}

Noclip.Enabled = false
Noclip.Connection = nil
Noclip.Character = nil

function Noclip:Enable()
    if self.Enabled then return end
    
    self.Enabled = true
    
    self.Connection = RunService.Stepped:Connect(function()
        if not self.Enabled or not self.Character then return end
        
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    print("[Noclip] Enabled")
end

function Noclip:Disable()
    if not self.Enabled then return end
    
    self.Enabled = false
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    if self.Character then
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    print("[Noclip] Disabled")
end

function Noclip:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Noclip:SetCharacter(character)
    self.Character = character
end

function Noclip:Cleanup()
    self:Disable()
    self.Character = nil
end

-- ============================================================================
-- FLY MODULE (src/modules/fly.lua)
-- ============================================================================

local UserInputService = game:GetService("UserInputService")

local Fly = {}

Fly.Enabled = false
Fly.Speed = 50
Fly.Character = nil
Fly.RootPart = nil
Fly.BodyVelocity = nil
Fly.VelocityDirection = Vector3.new(0, 0, 0)
Fly.InputConnection = nil
Fly.RenderConnection = nil
Fly.IsFlying = false

function Fly:Enable()
    if self.Enabled or not self.RootPart then return end
    
    self.Enabled = true
    self.IsFlying = true
    self.VelocityDirection = Vector3.new(0, 0, 0)
    
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    self.BodyVelocity.Parent = self.RootPart
    
    self.InputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not self.Enabled then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            self.VelocityDirection = self.VelocityDirection + (self.Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.S then
            self.VelocityDirection = self.VelocityDirection - (self.Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.A then
            self.VelocityDirection = self.VelocityDirection - (self.Character.PrimaryPart.CFrame.RightVector)
        elseif input.KeyCode == Enum.KeyCode.D then
            self.VelocityDirection = self.VelocityDirection + (self.Character.PrimaryPart.CFrame.RightVector)
        elseif input.KeyCode == Enum.KeyCode.Space then
            self.VelocityDirection = self.VelocityDirection + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            self.VelocityDirection = self.VelocityDirection - Vector3.new(0, 1, 0)
        end
    end)
    
    self.RenderConnection = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not self.BodyVelocity then return end
        
        if self.VelocityDirection.Magnitude > 0 then
            self.BodyVelocity.Velocity = self.VelocityDirection.Unit * self.Speed
        else
            self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        self.VelocityDirection = self.VelocityDirection * 0.9
    end)
    
    print("[Fly] Enabled - Speed: " .. self.Speed)
end

function Fly:Disable()
    if not self.Enabled then return end
    
    self.Enabled = false
    self.IsFlying = false
    
    if self.InputConnection then
        self.InputConnection:Disconnect()
        self.InputConnection = nil
    end
    
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
    
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    
    self.VelocityDirection = Vector3.new(0, 0, 0)
    
    print("[Fly] Disabled")
end

function Fly:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Fly:SetSpeed(speed)
    self.Speed = speed
    print("[Fly] Speed set to: " .. speed)
end

function Fly:SetCharacter(character)
    self.Character = character
    self.RootPart = character:WaitForChild("HumanoidRootPart")
end

function Fly:Cleanup()
    self:Disable()
    self.Character = nil
    self.RootPart = nil
end

-- ============================================================================
-- FEATURE MANAGER MODULE (src/modules/feature_manager.lua)
-- ============================================================================

local FeatureManager = {}

function FeatureManager:Initialize(character)
    Noclip:SetCharacter(character)
    Fly:SetCharacter(character)
end

function FeatureManager:ToggleNoclip()
    Noclip:Toggle()
end

function FeatureManager:ToggleFly()
    Fly:Toggle()
end

function FeatureManager:IsNoclipEnabled()
    return Noclip.Enabled
end

function FeatureManager:IsFlyEnabled()
    return Fly.Enabled
end

function FeatureManager:SetFlySpeed(speed)
    Fly:SetSpeed(speed)
end

function FeatureManager:GetFlySpeed()
    return Fly.Speed
end

function FeatureManager:DisableAll()
    if Noclip.Enabled then
        Noclip:Disable()
    end
    
    if Fly.Enabled then
        Fly:Disable()
    end
    
    print("[FeatureManager] All features disabled")
end

function FeatureManager:Cleanup()
    Noclip:Cleanup()
    Fly:Cleanup()
end

-- ============================================================================
-- UI - WINDOW MODULE (src/ui/window.lua)
-- ============================================================================

local UIWindow = {}

function UIWindow:Create(ObsidianUI)
    local Window = ObsidianUI:CreateWindow({
        Name = Config.UI.Name,
        Size = Config.UI.WindowSize,
        HasClosing = Config.UI.HasClosing,
        HasMinimizing = Config.UI.HasMinimizing,
        Draggable = Config.UI.Draggable,
        ShowHideKey = Config.Keybinds.ToggleMenu
    })
    
    return Window
end

-- ============================================================================
-- UI - TABS MODULE (src/ui/tabs.lua)
-- ============================================================================

local UITabs = {}

function UITabs:CreateHomeTab(window)
    local HomeTab = window:CreateTab({
        Name = "Home",
        Icon = Config.Icons.Home
    })
    
    HomeTab:CreateLabel({Text = "Uranium Hub - Universal Script"})
    HomeTab:CreateDivider()
    HomeTab:CreateLabel({Text = "Version: " .. Config.UI.Version})
    HomeTab:CreateLabel({Text = "A professional, lightweight universal script hub with essential movement features and a clean, minimalistic interface."})
    HomeTab:CreateDivider()
    HomeTab:CreateLabel({Text = "Core Features:"})
    HomeTab:CreateLabel({Text = "- Noclip: Walk through walls and solid objects"})
    HomeTab:CreateLabel({Text = "- Fly: Smooth flight movement with customizable speed"})
    HomeTab:CreateLabel({Text = "- Settings: Fine-tune your experience"})
    HomeTab:CreateDivider()
    HomeTab:CreateLabel({Text = "Controls:"})
    HomeTab:CreateLabel({Text = "Toggle Menu: Press Right Shift"})
    HomeTab:CreateLabel({Text = "Fly Controls: WASD to move, Space/Ctrl for vertical movement"})
    
    return HomeTab
end

function UITabs:CreateMovementTab(window)
    local MovementTab = window:CreateTab({
        Name = "Movement",
        Icon = Config.Icons.Movement
    })
    
    local NoclipToggle = MovementTab:CreateToggle({
        Name = "Noclip",
        Default = Config.Features.Noclip.DefaultEnabled,
        Callback = function(Value)
            FeatureManager:ToggleNoclip()
        end
    })
    
    MovementTab:CreateLabel({Text = Config.Features.Noclip.Description})
    MovementTab:CreateDivider()
    
    local FlyToggle = MovementTab:CreateToggle({
        Name = "Fly",
        Default = Config.Features.Fly.DefaultEnabled,
        Callback = function(Value)
            FeatureManager:ToggleFly()
        end
    })
    
    MovementTab:CreateLabel({Text = Config.Features.Fly.Description})
    
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

function UITabs:CreateSettingsTab(window, toggles)
    local SettingsTab = window:CreateTab({
        Name = "Settings",
        Icon = Config.Icons.Settings
    })
    
    SettingsTab:CreateLabel({Text = "User Interface Settings"})
    SettingsTab:CreateDivider()
    SettingsTab:CreateLabel({Text = "Manage all active features and reset the hub state."})
    SettingsTab:CreateDivider()
    
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
    
    SettingsTab:CreateLabel({Text = "Disables all active features and resets to default state"})
    
    return SettingsTab
end

-- ============================================================================
-- MAIN ENTRY POINT
-- ============================================================================

        Config.ObsidianUI.Repository,
        Config.ObsidianUI.Fallback
    
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local ObsidianUILibrary = nil
local MainWindow = nil
local UIToggles = {}

local function LoadObsidianUI()
    print(Config.Messages.LoadingUI)
    
    ObsidianUILibrary = Helpers.LoadFromUrl(Config.ObsidianUI.Repository)
    
    if not ObsidianUILibrary then
        error(Config.Messages.UIFailed)
    end
    
    print(Config.Messages.UILoaded)
    return true
end

local function CreateMainInterface()
    MainWindow = UIWindow:Create(ObsidianUILibrary)
    
    local movementTabData = UITabs:CreateMovementTab(MainWindow)
    UITabs:CreateHomeTab(MainWindow)
    UITabs:CreateSettingsTab(MainWindow, movementTabData)
    
    UIToggles.NoclipToggle = movementTabData.NoclipToggle
    UIToggles.FlyToggle = movementTabData.FlyToggle
    
    print(Config.Messages.UILoaded)
end

local function Initialize()
    print("[Uranium Hub] Starting initialization...")
    
    LoadObsidianUI()
    
    FeatureManager:Initialize(Character)
    
    CreateMainInterface()
    
    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        FeatureManager:Initialize(Character)
        print(Config.Messages.CharacterRespawned)
    end)
    
    print(Config.Messages.Initialized)
    print(Config.Messages.Ready)
end

Initialize()

game:BindToClose(function()
    if FeatureManager then
        FeatureManager:Cleanup()
    end
end)
