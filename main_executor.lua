--[[
    ☢️ URANIUM HUB - Standalone Executor Version
    Complete hub in one file for executors (Synapse, Fluxus, etc.)
    
    Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/bagietos/uranium-hub/main/main.lua"))()
]]

print("\n" .. string.rep("=", 60))
print("☢️ URANIUM HUB - INITIALIZING")
print("Version: 1.0.0 | Made for Roblox Executors")
print(string.rep("=", 60) .. "\n")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local Config = {
    UI = {
        Enabled = true,
        Theme = "dark",
        Colors = {
            Primary = Color3.fromRGB(255, 193, 7),
            Secondary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(76, 175, 80),
            Text = Color3.fromRGB(255, 255, 255),
            Danger = Color3.fromRGB(244, 67, 54),
        },
    },
    Features = {
        Fly = { Enabled = false, Speed = 50, MaxSpeed = 200 },
        Noclip = { Enabled = false, Speed = 25 },
        WalkSpeed = { Enabled = false, Speed = 100, Default = 16 },
        JumpPower = { Enabled = false, Power = 100, Default = 50 },
        GodMode = { Enabled = false },
        InfiniteStamina = { Enabled = false },
    },
    ESP = {
        Enabled = false,
        ShowBox = true,
        ShowTracer = true,
        ShowNames = true,
        ShowDistance = true,
        ShowHealthBar = true,
        MaxDistance = 1000,
    },
}

-- ============================================================================
-- UTILITIES
-- ============================================================================

local Utilities = {}

function Utilities:Log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%H:%M:%S")
    print(string.format("[%s][%s] %s", timestamp, level, message))
end

function Utilities:Notify(title, message, duration)
    print(string.format("[NOTIFY] %s: %s", title, message))
end

function Utilities:Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utilities:GetLocalPlayer()
    local character = game:GetService("Players").LocalPlayer.Character
    return character
end

function Utilities:GetLocalRoot()
    local character = Utilities:GetLocalPlayer()
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function Utilities:GetLocalHumanoid()
    local character = Utilities:GetLocalPlayer()
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

function Utilities:GetOtherPlayers()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local otherPlayers = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(otherPlayers, player)
        end
    end
    return otherPlayers
end

-- ============================================================================
-- UNIVERSAL FEATURES
-- ============================================================================

local Universal = {}
local FlyData = { Active = false, Connection = nil }
local NoclipData = { Active = false, Connection = nil }

function Universal:SetFly(enabled)
    local character = Utilities:GetLocalPlayer()
    local humanoidRoot = Utilities:GetLocalRoot()
    
    if not character or not humanoidRoot then return end
    
    if enabled and not FlyData.Active then
        Utilities:Log("Fly enabled", "INFO")
        FlyData.Active = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = humanoidRoot
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.Parent = humanoidRoot
        
        local UserInputService = game:GetService("UserInputService")
        local camera = workspace.CurrentCamera
        
        if FlyData.Connection then
            FlyData.Connection:Disconnect()
        end
        
        FlyData.Connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not FlyData.Active then return end
            
            if not bodyVelocity or not bodyVelocity.Parent then
                Universal:SetFly(false)
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            bodyVelocity.Velocity = moveDirection * Config.Features.Fly.Speed
            bodyGyro.CFrame = camera.CFrame
        end)
        
        Utilities:Notify("Fly", "Enabled")
        
    elseif not enabled and FlyData.Active then
        Utilities:Log("Fly disabled", "INFO")
        FlyData.Active = false
        
        if FlyData.Connection then
            FlyData.Connection:Disconnect()
            FlyData.Connection = nil
        end
        
        Utilities:Notify("Fly", "Disabled")
    end
end

function Universal:SetNoclip(enabled)
    local character = Utilities:GetLocalPlayer()
    if not character then return end
    
    if enabled and not NoclipData.Active then
        Utilities:Log("Noclip enabled", "INFO")
        NoclipData.Active = true
        
        local UserInputService = game:GetService("UserInputService")
        local camera = workspace.CurrentCamera
        
        if NoclipData.Connection then
            NoclipData.Connection:Disconnect()
        end
        
        NoclipData.Connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not NoclipData.Active then return end
            
            local humanoidRoot = Utilities:GetLocalRoot()
            if not humanoidRoot then
                Universal:SetNoclip(false)
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            humanoidRoot.CFrame = humanoidRoot.CFrame + (moveDirection * Config.Features.Noclip.Speed * 0.016)
        end)
        
        Utilities:Notify("Noclip", "Enabled")
        
    elseif not enabled and NoclipData.Active then
        Utilities:Log("Noclip disabled", "INFO")
        NoclipData.Active = false
        
        if NoclipData.Connection then
            NoclipData.Connection:Disconnect()
            NoclipData.Connection = nil
        end
        
        Utilities:Notify("Noclip", "Disabled")
    end
end

function Universal:SetWalkSpeed(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    if not humanoid then return end
    
    if enabled then
        Utilities:Log("Walk speed enhanced", "INFO")
        
        local connection = game:GetService("RunService").Heartbeat:Connect(function()
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.WalkSpeed = Config.Features.WalkSpeed.Speed
            end
        end)
        
        Universal._SpeedConnection = connection
        Utilities:Notify("Walk Speed", "Enabled: " .. Config.Features.WalkSpeed.Speed)
    else
        if Universal._SpeedConnection then
            Universal._SpeedConnection:Disconnect()
            Universal._SpeedConnection = nil
        end
        if humanoid then
            humanoid.WalkSpeed = Config.Features.WalkSpeed.Default
        end
        Utilities:Notify("Walk Speed", "Disabled")
    end
end

function Universal:SetJumpPower(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    if not humanoid then return end
    
    if enabled then
        Utilities:Log("Jump power enhanced", "INFO")
        
        local connection = game:GetService("RunService").Heartbeat:Connect(function()
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.JumpPower = Config.Features.JumpPower.Power
            end
        end)
        
        Universal._JumpConnection = connection
        Utilities:Notify("Jump Power", "Enabled: " .. Config.Features.JumpPower.Power)
    else
        if Universal._JumpConnection then
            Universal._JumpConnection:Disconnect()
            Universal._JumpConnection = nil
        end
        if humanoid then
            humanoid.JumpPower = Config.Features.JumpPower.Default
        end
        Utilities:Notify("Jump Power", "Disabled")
    end
end

function Universal:SetGodMode(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    if not humanoid then return end
    
    if enabled then
        Utilities:Log("God mode enabled", "INFO")
        
        if Universal._GodConnection then
            Universal._GodConnection:Disconnect()
        end
        
        Universal._GodConnection = humanoid.Damaged:Connect(function()
            task.wait(0.01)
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        humanoid.Health = humanoid.MaxHealth
        Utilities:Notify("God Mode", "Enabled")
    else
        if Universal._GodConnection then
            Universal._GodConnection:Disconnect()
            Universal._GodConnection = nil
        end
        Utilities:Notify("God Mode", "Disabled")
    end
end

function Universal:Cleanup()
    Utilities:Log("Cleaning up features...", "INFO")
    
    self:SetFly(false)
    self:SetNoclip(false)
    self:SetWalkSpeed(false)
    self:SetJumpPower(false)
    self:SetGodMode(false)
end

-- ============================================================================
-- KEYBINDS
-- ============================================================================

local function SetupKeybinds()
    Utilities:Log("Setting up keybinds...", "INFO")
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F then
            Config.Features.Fly.Enabled = not Config.Features.Fly.Enabled
            Universal:SetFly(Config.Features.Fly.Enabled)
        elseif input.KeyCode == Enum.KeyCode.X then
            Config.Features.Noclip.Enabled = not Config.Features.Noclip.Enabled
            Universal:SetNoclip(Config.Features.Noclip.Enabled)
        elseif input.KeyCode == Enum.KeyCode.Z then
            Config.Features.GodMode.Enabled = not Config.Features.GodMode.Enabled
            Universal:SetGodMode(Config.Features.GodMode.Enabled)
        elseif input.KeyCode == Enum.KeyCode.W then
            Config.Features.WalkSpeed.Enabled = not Config.Features.WalkSpeed.Enabled
            Universal:SetWalkSpeed(Config.Features.WalkSpeed.Enabled)
        elseif input.KeyCode == Enum.KeyCode.Delete then
            UnloadHub()
        end
    end)
    
    Utilities:Log("Keybinds initialized", "INFO")
end

-- ============================================================================
-- UNLOAD
-- ============================================================================

function UnloadHub()
    print("\n[☢️ Hub] Unloading...")
    Universal:Cleanup()
    print("[☢️ Hub] Hub unloaded successfully\n")
end

-- ============================================================================
-- MAIN
-- ============================================================================

local function Main()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    Utilities:Log("All systems online", "INFO")
    Utilities:Log("Press F for Fly", "INFO")
    Utilities:Log("Press X for Noclip", "INFO")
    Utilities:Log("Press Z for God Mode", "INFO")
    Utilities:Log("Press W for Walk Speed", "INFO")
    Utilities:Log("Press Delete to Unload", "INFO")
    
    SetupKeybinds()
    
    _G.UraniumHub = {
        Unload = UnloadHub,
        SetFly = function(v) Universal:SetFly(v) end,
        SetNoclip = function(v) Universal:SetNoclip(v) end,
        SetGodMode = function(v) Universal:SetGodMode(v) end,
        SetWalkSpeed = function(v) Universal:SetWalkSpeed(v) end,
    }
    
    print("\n" .. string.rep("=", 60))
    print("☢️ URANIUM HUB LOADED SUCCESSFULLY")
    print("Version: 1.0.0")
    print("Type: _G.UraniumHub.Unload() to unload")
    print(string.rep("=", 60) .. "\n")
    
    Utilities:Notify("Uranium Hub", "Loaded! Use keybinds to activate features", 5)
end

local success, error_msg = pcall(Main)
if not success then
    warn("[☢️ Hub] ERROR: " .. tostring(error_msg))
end

return "Uranium Hub Loaded"
