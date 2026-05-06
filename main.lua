--[[
    URANIUM HUB - Roblox Universal Script Hub
    Version: 1.0
    UI Library: Rayfield

    Features:
    - Noclip with toggle
    - Smooth Fly movement
    - Clean tabbed interface
    - Right Shift toggle
]]

-- ============================================================================
-- SERVICE REFERENCES
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================================================
-- UI LIBRARY LOADING
-- ============================================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ============================================================================
-- FEATURE STATE
-- ============================================================================

local Features = {
    Noclip = {
        Enabled = false,
        Connection = nil,
    },
    Fly = {
        Enabled = false,
        Connection = nil,
        Speed = 50,
        BodyVelocity = nil,
    },
}

-- ============================================================================
-- NOCLIP MODULE
-- ============================================================================

local NoclipModule = {}

function NoclipModule.Enable()
    if Features.Noclip.Enabled then return end
    Features.Noclip.Enabled = true
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
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- ============================================================================
-- FLY MODULE
-- ============================================================================

local FlyModule = {}

function FlyModule.Enable()
    if Features.Fly.Enabled then return end
    Features.Fly.Enabled = true

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = RootPart
    Features.Fly.BodyVelocity = bodyVelocity

    local velocityDirection = Vector3.new(0, 0, 0)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not Features.Fly.Enabled then return end
        if input.KeyCode == Enum.KeyCode.W then
            velocityDirection = velocityDirection + Character.PrimaryPart.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.S then
            velocityDirection = velocityDirection - Character.PrimaryPart.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.A then
            velocityDirection = velocityDirection - Character.PrimaryPart.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.D then
            velocityDirection = velocityDirection + Character.PrimaryPart.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.Space then
            velocityDirection = velocityDirection + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            velocityDirection = velocityDirection - Vector3.new(0, 1, 0)
        end
    end)

    Features.Fly.Connection = RunService.RenderStepped:Connect(function()
        if not Features.Fly.Enabled or not bodyVelocity then return end
        if velocityDirection.Magnitude > 0 then
            bodyVelocity.Velocity = velocityDirection.Unit * Features.Fly.Speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        velocityDirection = velocityDirection * 0.9
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

-- ============================================================================
-- UI BUILDER
-- ============================================================================

local function CreateUI()
    local Window = Rayfield:CreateWindow({
        Name = "Uranium Hub",
        LoadingTitle = "Uranium Hub",
        LoadingSubtitle = "Loading...",
        Theme = "Default",
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = true,
        ConfigurationSaving = { Enabled = false },
        KeySystem = false,
    })

    -- HOME TAB
    local HomeTab = Window:CreateTab("Home", 7734073543)
    HomeTab:CreateSection("Uranium Hub v1.0")
    HomeTab:CreateLabel("A professional, lightweight universal script hub with essential movement features.")
    HomeTab:CreateSection("Features")
    HomeTab:CreateLabel("Noclip: Walk through walls and solid objects")
    HomeTab:CreateLabel("Fly: Smooth flight movement with customizable speed")
    HomeTab:CreateSection("Controls")
    HomeTab:CreateLabel("Toggle Menu: Press Right Shift")
    HomeTab:CreateLabel("Fly: WASD to move, Space/Ctrl for vertical movement")

    -- MOVEMENT TAB
    local MovementTab = Window:CreateTab("Movement", 7734067945)

    MovementTab:CreateSection("Noclip")
    local NoclipToggle = MovementTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Flag = "NoclipToggle",
        Callback = function(Value)
            if Value then NoclipModule.Enable() else NoclipModule.Disable() end
        end,
    })
    MovementTab:CreateLabel("Walk through walls and solid objects")

    MovementTab:CreateSection("Fly")
    local FlyToggle = MovementTab:CreateToggle({
        Name = "Fly",
        CurrentValue = false,
        Flag = "FlyToggle",
        Callback = function(Value)
            if Value then FlyModule.Enable() else FlyModule.Disable() end
        end,
    })
    MovementTab:CreateLabel("Smooth flight - WASD to move, Space/Ctrl to ascend/descend")
    MovementTab:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 200},
        Increment = 1,
        CurrentValue = 50,
        Flag = "FlySpeed",
        Callback = function(Value)
            Features.Fly.Speed = Value
        end,
    })

    -- SETTINGS TAB
    local SettingsTab = Window:CreateTab("Settings", 7734068149)
    SettingsTab:CreateSection("Feature Management")
    SettingsTab:CreateButton({
        Name = "Disable All Features",
        Callback = function()
            NoclipToggle:Set(false)
            FlyToggle:Set(false)
            NoclipModule.Disable()
            FlyModule.Disable()
        end,
    })
    SettingsTab:CreateLabel("Disables all active features and resets to default state.")

    return Window
end

-- ============================================================================
-- MAIN INITIALIZATION
-- ============================================================================

local function Initialize()
    print("[Uranium Hub] Initializing...")

    CreateUI()

    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        RootPart = newCharacter:WaitForChild("HumanoidRootPart")
        NoclipModule.Disable()
        FlyModule.Disable()
        print("[Uranium Hub] Character respawned, features reset")
    end)

    print("[Uranium Hub] Ready.")
end

Initialize()
