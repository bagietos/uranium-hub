--[[
    URANIUM HUB - Single File Distribution Version
    UI Library: Rayfield
]]

-- ============================================================================
-- CONFIG
-- ============================================================================

local Config = {}

Config.UI = {
    Name = "Uranium Hub",
    Version = "1.0",
}

Config.Features = {
    Noclip = {
        Description = "Walk through walls and solid objects",
        DefaultEnabled = false,
    },
    Fly = {
        Description = "Smooth flight movement - Use WASD to move, Space/Ctrl to ascend/descend",
        DefaultEnabled = false,
        DefaultSpeed = 50,
        MinSpeed = 10,
        MaxSpeed = 200,
    },
}

-- ============================================================================
-- SERVICES
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================================================
-- LOAD RAYFIELD
-- ============================================================================

print("[Uranium Hub] Loading Rayfield UI Library...")
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
print("[Uranium Hub] UI Loaded Successfully")

-- ============================================================================
-- NOCLIP MODULE
-- ============================================================================

local Noclip = { Enabled = false, Connection = nil }

function Noclip:Enable()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = RunService.Stepped:Connect(function()
        if not self.Enabled then return end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

function Noclip:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
end

-- ============================================================================
-- FLY MODULE
-- ============================================================================

local Fly = { Enabled = false, Speed = 50, Connection = nil, BodyVelocity = nil }

function Fly:Enable()
    if self.Enabled then return end
    self.Enabled = true

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = RootPart
    self.BodyVelocity = bodyVelocity

    local velocityDirection = Vector3.new(0, 0, 0)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not self.Enabled then return end
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

    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not bodyVelocity then return end
        if velocityDirection.Magnitude > 0 then
            bodyVelocity.Velocity = velocityDirection.Unit * self.Speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        velocityDirection = velocityDirection * 0.9
    end)
end

function Fly:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
end

-- ============================================================================
-- UI
-- ============================================================================

local Window = Rayfield:CreateWindow({
    Name = Config.UI.Name,
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
HomeTab:CreateSection("Uranium Hub v" .. Config.UI.Version)
HomeTab:CreateLabel("A professional, lightweight universal script hub with essential movement features.")
HomeTab:CreateSection("Features")
HomeTab:CreateLabel("Noclip: Walk through walls and solid objects")
HomeTab:CreateLabel("Fly: Smooth flight movement with customizable speed")
HomeTab:CreateSection("Controls")
HomeTab:CreateLabel("Fly: WASD to move, Space/Ctrl for vertical movement")

-- MOVEMENT TAB
local MovementTab = Window:CreateTab("Movement", 7734067945)

MovementTab:CreateSection("Noclip")
local NoclipToggle = MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = Config.Features.Noclip.DefaultEnabled,
    Flag = "NoclipToggle",
    Callback = function(Value)
        if Value then Noclip:Enable() else Noclip:Disable() end
    end,
})
MovementTab:CreateLabel(Config.Features.Noclip.Description)

MovementTab:CreateSection("Fly")
local FlyToggle = MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = Config.Features.Fly.DefaultEnabled,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then Fly:Enable() else Fly:Disable() end
    end,
})
MovementTab:CreateLabel(Config.Features.Fly.Description)
MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {Config.Features.Fly.MinSpeed, Config.Features.Fly.MaxSpeed},
    Increment = 1,
    CurrentValue = Config.Features.Fly.DefaultSpeed,
    Flag = "FlySpeed",
    Callback = function(Value)
        Fly.Speed = Value
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
        Noclip:Disable()
        Fly:Disable()
    end,
})
SettingsTab:CreateLabel("Disables all active features and resets to default state.")

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

print("[Uranium Hub] Starting initialization...")

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    RootPart = newCharacter:WaitForChild("HumanoidRootPart")
    Noclip:Disable()
    Fly:Disable()
    NoclipToggle:Set(false)
    FlyToggle:Set(false)
    print("[Uranium Hub] Character respawned, features reset")
end)

game:BindToClose(function()
    Noclip:Disable()
    Fly:Disable()
end)

print("[Uranium Hub] Ready.")
