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

local Noclip = { Enabled = false, Connection = nil, OriginalCollide = {} }

function Noclip:Enable()
    if self.Enabled then return end
    self.Enabled = true

    -- cache original CanCollide values
    self.OriginalCollide = {}
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.OriginalCollide[part] = part.CanCollide
        end
    end

    self.Connection = RunService.Stepped:Connect(function()
        if not self.Enabled then return end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
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
        if part:IsA("BasePart") then
            part.CanCollide = self.OriginalCollide[part] ~= false
        end
    end
    self.OriginalCollide = {}
end

-- ============================================================================
-- FLY MODULE
-- ============================================================================

local Fly = {
    Enabled = false,
    Speed = 50,
    Connection = nil,
    BodyVelocity = nil,
    BodyGyro = nil,
}

function Fly:Enable()
    if self.Enabled then return end
    self.Enabled = true

    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    local camera = workspace.CurrentCamera

    -- BodyVelocity — kontrola ruchu
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.P = 1e4
    bv.Parent = RootPart
    self.BodyVelocity = bv

    -- BodyGyro — obrót postaci w kierunku kamery
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 1e4
    bg.D = 100
    bg.CFrame = RootPart.CFrame
    bg.Parent = RootPart
    self.BodyGyro = bg

    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end

        -- animacja siedzenia podczas lotu
        if humanoid then humanoid.Sit = true end

        -- kierunek ruchu względem kamery (nie postaci)
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir += camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir += camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir -= Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            bv.Velocity = moveDir.Unit * self.Speed
            -- obróć postać w poziomie w stronę ruchu
            local flat = Vector3.new(moveDir.X, 0, moveDir.Z)
            if flat.Magnitude > 0 then
                bg.CFrame = CFrame.new(Vector3.zero, flat)
            end
        else
            bv.Velocity = Vector3.zero
        end
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
    if self.BodyGyro then
        self.BodyGyro:Destroy()
        self.BodyGyro = nil
    end

    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = false end
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
