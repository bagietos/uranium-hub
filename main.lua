--[[
    URANIUM HUB - Roblox Universal Script Hub
    Version: 1.0
    UI Library: Obsidian UI
    
    Features:
    - Noclip with toggle
    - Smooth Fly movement
    - Clean tabbed interface
    - Right Shift toggle
    
    Structure: Modular design with clear separation of concerns
]]

-- ============================================================================
-- CONSTANTS & CONFIGURATION
-- ============================================================================

local TOGGLE_KEYBIND = Enum.KeyCode.RightShift
local UI_FADE_SPEED = 0.3

-- ============================================================================
-- SERVICE REFERENCES
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================================================
-- UI LIBRARY LOADING
-- ============================================================================

local ObsidianUI
local function LoadObsidianUI()
    local urls = {
        "https://raw.githubusercontent.com/ViktorVaughn/Obsidian-UI/main/Obsidian%20UI.lua",
        "https://raw.githubusercontent.com/infyiff/Obsidian/main/ObsidianUI.lua"
    }
    
    for _, url in ipairs(urls) do
        local response = syn.request({
            Url = url,
            Method = "GET"
        })
        
        if response.StatusCode == 200 then
            ObsidianUI = loadstring(response.Body)()
            if ObsidianUI then
                return true
            end
        end
    end
    
    warn("Failed to load Obsidian UI library from all sources")
    return false
end

-- Attempt to load UI library
if not LoadObsidianUI() then
    error("Cannot proceed without Obsidian UI library")
end

-- ============================================================================
-- FEATURE STATE
-- ============================================================================

local Features = {
    Noclip = {
        Enabled = false,
        Connection = nil
    },
    Fly = {
        Enabled = false,
        Connection = nil,
        Speed = 50,
        BodyVelocity = nil
    }
}

local GuiState = {
    Visible = true
}

-- ============================================================================
-- NOCLIP MODULE
-- ============================================================================

local NoclipModule = {}

function NoclipModule.Enable()
    if Features.Noclip.Enabled then return end
    
    Features.Noclip.Enabled = true
    
    -- Disable collision detection
    Features.Noclip.Connection = RunService.Stepped:Connect(function()
        if not Features.Noclip.Enabled then return end
        
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function NoclipModule.Disable()
    if not Features.Noclip.Enabled then return end
    
    Features.Noclip.Enabled = false
    
    if Features.Noclip.Connection then
        Features.Noclip.Connection:Disconnect()
        Features.Noclip.Connection = nil
    end
    
    -- Re-enable collision detection
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

function NoclipModule.Toggle()
    if Features.Noclip.Enabled then
        NoclipModule.Disable()
    else
        NoclipModule.Enable()
    end
end

-- ============================================================================
-- FLY MODULE
-- ============================================================================

local FlyModule = {}

function FlyModule.Enable()
    if Features.Fly.Enabled then return end
    
    Features.Fly.Enabled = true
    
    -- Create BodyVelocity for smooth flight
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = RootPart
    
    Features.Fly.BodyVelocity = bodyVelocity
    
    -- Flight input handling
    local flying = true
    local velocityDirection = Vector3.new(0, 0, 0)
    
    -- Input handling
    local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if not Features.Fly.Enabled then return end
        
        -- WASD for movement
        if input.KeyCode == Enum.KeyCode.W then
            velocityDirection = velocityDirection + (Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.S then
            velocityDirection = velocityDirection - (Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.A then
            velocityDirection = velocityDirection - (Character.PrimaryPart.CFrame.RightVector)
        elseif input.KeyCode == Enum.KeyCode.D then
            velocityDirection = velocityDirection + (Character.PrimaryPart.CFrame.RightVector)
        elseif input.KeyCode == Enum.KeyCode.Space then
            velocityDirection = velocityDirection + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            velocityDirection = velocityDirection - Vector3.new(0, 1, 0)
        end
    end)
    
    -- Render loop for smooth flight
    Features.Fly.Connection = RunService.RenderStepped:Connect(function()
        if not Features.Fly.Enabled then return end
        
        if bodyVelocity then
            bodyVelocity.Velocity = velocityDirection.Unit * Features.Fly.Speed
        end
    end)
end

function FlyModule.Disable()
    if not Features.Fly.Enabled then return end
    
    Features.Fly.Enabled = false
    
    if Features.Fly.Connection then
        Features.Fly.Connection:Disconnect()
        Features.Fly.Connection = nil
    end
    
    if Features.Fly.BodyVelocity then
        Features.Fly.BodyVelocity:Destroy()
        Features.Fly.BodyVelocity = nil
    end
end

function FlyModule.Toggle()
    if Features.Fly.Enabled then
        FlyModule.Disable()
    else
        FlyModule.Enable()
    end
end

-- ============================================================================
-- UI BUILDER
-- ============================================================================

local function CreateUI()
    local Window = ObsidianUI:CreateWindow({
        Name = "Uranium Hub",
        Size = UDim2.new(0, 550, 0, 400),
        HasClosing = true,
        HasMinimizing = true,
        Draggable = true,
        ShowHideKey = TOGGLE_KEYBIND
    })
    
    -- ========================================================================
    -- HOME TAB
    -- ========================================================================
    
    local HomeTab = Window:CreateTab({
        Name = "Home",
        Icon = "rbxassetid://7734073543"
    })
    
    HomeTab:CreateLabel({
        Text = "Uranium Hub - Universal Script"
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Version: 1.0"
    })
    
    HomeTab:CreateLabel({
        Text = "A professional, lightweight universal script hub with essential movement features and a clean interface."
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Features:"
    })
    
    HomeTab:CreateLabel({
        Text = "- Noclip: Walk through walls and objects"
    })
    
    HomeTab:CreateLabel({
        Text = "- Fly: Smooth movement through the air"
    })
    
    HomeTab:CreateLabel({
        Text = "- Clean Settings interface"
    })
    
    HomeTab:CreateDivider()
    
    HomeTab:CreateLabel({
        Text = "Toggle Menu: Press Right Shift"
    })
    
    -- ========================================================================
    -- MOVEMENT TAB
    -- ========================================================================
    
    local MovementTab = Window:CreateTab({
        Name = "Movement",
        Icon = "rbxassetid://7734067945"
    })
    
    -- Noclip Toggle
    local NoclipToggle = MovementTab:CreateToggle({
        Name = "Noclip",
        Default = false,
        Callback = function(Value)
            if Value then
                NoclipModule.Enable()
            else
                NoclipModule.Disable()
            end
        end
    })
    
    MovementTab:CreateLabel({
        Text = "Walk through walls and solid objects"
    })
    
    MovementTab:CreateDivider()
    
    -- Fly Toggle
    local FlyToggle = MovementTab:CreateToggle({
        Name = "Fly",
        Default = false,
        Callback = function(Value)
            if Value then
                FlyModule.Enable()
            else
                FlyModule.Disable()
            end
        end
    })
    
    MovementTab:CreateLabel({
        Text = "Smooth flight movement - Use WASD to move, Space/Ctrl to ascend/descend"
    })
    
    -- Fly Speed Slider
    local FlySpeedSlider = MovementTab:CreateSlider({
        Name = "Fly Speed",
        Min = 10,
        Max = 200,
        Default = 50,
        Rounded = 1,
        Callback = function(Value)
            Features.Fly.Speed = Value
        end
    })
    
    -- ========================================================================
    -- SETTINGS TAB
    -- ========================================================================
    
    local SettingsTab = Window:CreateTab({
        Name = "Settings",
        Icon = "rbxassetid://7734068149"
    })
    
    SettingsTab:CreateLabel({
        Text = "User Interface Settings"
    })
    
    SettingsTab:CreateDivider()
    
    -- UI Theme Options (placeholder for potential expansion)
    SettingsTab:CreateLabel({
        Text = "This section can be expanded with additional customization options."
    })
    
    SettingsTab:CreateDivider()
    
    -- Reset Button
    local ResetButton = SettingsTab:CreateButton({
        Name = "Disable All Features",
        Callback = function()
            NoclipToggle:Set(false)
            FlyToggle:Set(false)
            NoclipModule.Disable()
            FlyModule.Disable()
        end
    })
    
    SettingsTab:CreateLabel({
        Text = "Disables all active features and resets to default state"
    })
    
    return Window
end

-- ============================================================================
-- MAIN INITIALIZATION
-- ============================================================================

local function Initialize()
    print("[Uranium Hub] Initializing...")
    
    -- Create the UI
    local Window = CreateUI()
    print("[Uranium Hub] UI Created Successfully")
    
    -- Handle character respawn
    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        
        -- Disable features on respawn
        NoclipModule.Disable()
        FlyModule.Disable()
        
        print("[Uranium Hub] Character respawned, features reset")
    end)
    
    print("[Uranium Hub] Ready to use. Press Right Shift to toggle menu.")
end

-- Start the script
Initialize()

-- ============================================================================
-- CLEANUP
-- ============================================================================

game:GetService("Players").LocalPlayer:WaitForChild("Backpack").DescendantRemoving:Connect(function()
    -- Cleanup on script removal
    NoclipModule.Disable()
    FlyModule.Disable()
end)

-- Safe exit handling
local runServiceConnection
runServiceConnection = RunService.Heartbeat:Connect(function()
    -- Basic heartbeat for stability monitoring
end)
