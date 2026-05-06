--[[
    ☢️ URANIUM HUB - Simplified Edition
    Basic features: Noclip, Wallhack (ESP), Movement Speed
    Obsidian UI with Insert key toggle
]]

local Config = {
    Noclip = { Enabled = false, Speed = 25 },
    Movement = { Enabled = false, Speed = 50 },
    ESP = { Enabled = false, MaxDistance = 1000 },
}

local Connections = {}
local Drawings = {}

-- ============================================================================
-- UTILITIES
-- ============================================================================

local function GetRoot()
    return game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    return game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function GetCamera()
    return workspace.CurrentCamera
end

local function Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function IsOnScreen(pos)
    local camera = GetCamera()
    local screenSize = camera.ViewportSize
    local screenPoint = camera:WorldToScreenPoint(pos)
    return screenPoint.Z > 0 and screenPoint.X > 0 and screenPoint.X < screenSize.X and screenPoint.Y > 0 and screenPoint.Y < screenSize.Y
end

local function Notify(title, msg)
    print("[" .. title .. "] " .. msg)
end

-- ============================================================================
-- NOCLIP
-- ============================================================================

local function EnableNoclip()
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    
    Connections.Noclip = game:GetService("RunService").RenderStepped:Connect(function()
        local root = GetRoot()
        if not root then return end
        
        local camera = GetCamera()
        local input = game:GetService("UserInputService")
        local move = Vector3.new(0, 0, 0)
        
        if input:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
        if input:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
        if input:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
        if input:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
        if input:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if input:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move.Unit * Config.Noclip.Speed * 0.016)
        end
    end)
    
    Notify("Noclip", "Enabled")
end

local function DisableNoclip()
    if Connections.Noclip then
        Connections.Noclip:Disconnect()
        Connections.Noclip = nil
    end
    Notify("Noclip", "Disabled")
end

-- ============================================================================
-- MOVEMENT SPEED
-- ============================================================================

local function EnableMovement()
    if Connections.Movement then Connections.Movement:Disconnect() end
    
    Connections.Movement = game:GetService("RunService").Heartbeat:Connect(function()
        local hum = GetHumanoid()
        if hum then hum.WalkSpeed = Config.Movement.Speed end
    end)
    
    Notify("Movement", "Speed boosted to " .. Config.Movement.Speed)
end

local function DisableMovement()
    if Connections.Movement then
        Connections.Movement:Disconnect()
        Connections.Movement = nil
    end
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = 16 end
    Notify("Movement", "Disabled")
end

-- ============================================================================
-- WALLHACK (Simple ESP)
-- ============================================================================

local function ClearESP()
    for _, drawing in ipairs(Drawings) do
        pcall(function() drawing:Remove() end)
    end
    Drawings = {}
end

local function EnableESP()
    if Connections.ESP then Connections.ESP:Disconnect() end
    
    Connections.ESP = game:GetService("RunService").RenderStepped:Connect(function()
        ClearESP()
        
        local root = GetRoot()
        if not root then return end
        
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player == game:GetService("Players").LocalPlayer then continue end
            
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            
            local playerRoot = char.HumanoidRootPart
            local dist = Distance(root.Position, playerRoot.Position)
            
            if dist > Config.ESP.MaxDistance then continue end
            if not IsOnScreen(playerRoot.Position) then continue end
            
            local camera = GetCamera()
            local screenPoint = camera:WorldToScreenPoint(playerRoot.Position)
            local screenSize = camera.ViewportSize
            
            -- Box ESP
            local box = Drawing.new("Square")
            box.Position = Vector2.new(screenPoint.X - 30, screenPoint.Y - 40)
            box.Size = Vector2.new(60, 80)
            box.Color = Color3.fromRGB(255, 0, 0)
            box.Thickness = 2
            box.Filled = false
            box.Visible = true
            table.insert(Drawings, box)
            
            -- Name
            local name = Drawing.new("Text")
            name.Text = player.Name
            name.Position = Vector2.new(screenPoint.X, screenPoint.Y - 50)
            name.Color = Color3.fromRGB(255, 255, 255)
            name.Size = 14
            name.Visible = true
            table.insert(Drawings, name)
            
            -- Distance
            local distText = Drawing.new("Text")
            distText.Text = string.format("%.0fm", dist)
            distText.Position = Vector2.new(screenPoint.X, screenPoint.Y + 50)
            distText.Color = Color3.fromRGB(255, 255, 0)
            distText.Size = 12
            distText.Visible = true
            table.insert(Drawings, distText)
        end
    end)
    
    Notify("Wallhack", "Enabled")
end

local function DisableESP()
    if Connections.ESP then
        Connections.ESP:Disconnect()
        Connections.ESP = nil
    end
    ClearESP()
    Notify("Wallhack", "Disabled")
end

-- ============================================================================
-- OBSIDIAN UI
-- ============================================================================

local UIVisible = true

local function CreateUI()
    -- Load Obsidian UI
    local ObsidianUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/deified-user/Obsidian/main/ObsidianUI.lua"))()
    
    local Window = ObsidianUI:CreateWindow({
        Name = "☢️ Uranium Hub",
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        Draggable = true,
    })
    
    -- NOCLIP TAB
    local NoclipTab = Window:AddTab({ Name = "Noclip" })
    
    NoclipTab:AddToggle({
        Name = "Enable Noclip",
        Default = false,
        Callback = function(value)
            Config.Noclip.Enabled = value
            if value then EnableNoclip() else DisableNoclip() end
        end
    })
    
    NoclipTab:AddSlider({
        Name = "Noclip Speed",
        Min = 5,
        Max = 100,
        Default = Config.Noclip.Speed,
        Callback = function(value)
            Config.Noclip.Speed = value
        end
    })
    
    -- MOVEMENT TAB
    local MovementTab = Window:AddTab({ Name = "Movement" })
    
    MovementTab:AddToggle({
        Name = "Speed Boost",
        Default = false,
        Callback = function(value)
            Config.Movement.Enabled = value
            if value then EnableMovement() else DisableMovement() end
        end
    })
    
    MovementTab:AddSlider({
        Name = "Speed Value",
        Min = 16,
        Max = 200,
        Default = Config.Movement.Speed,
        Callback = function(value)
            Config.Movement.Speed = value
        end
    })
    
    -- WALLHACK TAB
    local ESPTab = Window:AddTab({ Name = "Wallhack" })
    
    ESPTab:AddToggle({
        Name = "Enable Wallhack",
        Default = false,
        Callback = function(value)
            Config.ESP.Enabled = value
            if value then EnableESP() else DisableESP() end
        end
    })
    
    ESPTab:AddSlider({
        Name = "Max Distance",
        Min = 100,
        Max = 5000,
        Default = Config.ESP.MaxDistance,
        Callback = function(value)
            Config.ESP.MaxDistance = value
        end
    })
    
    ESPTab:AddButton({
        Name = "Clear All Drawings",
        Callback = function()
            ClearESP()
            Notify("ESP", "Cleared")
        end
    })
    
    -- SETTINGS TAB
    local SettingsTab = Window:AddTab({ Name = "Settings" })
    
    SettingsTab:AddButton({
        Name = "Unload Hub",
        Callback = function()
            -- Cleanup
            for _, conn in pairs(Connections) do
                if conn then conn:Disconnect() end
            end
            ClearESP()
            print("[☢️ Hub] Unloaded")
        end
    })
    
    SettingsTab:AddLabel({
        Text = "Uranium Hub v1.0"
    })
    
    SettingsTab:AddLabel({
        Text = "Press INS to toggle UI"
    })
    
    -- Return window reference for toggling
    return Window
end

-- ============================================================================
-- MAIN
-- ============================================================================

local success, Window = pcall(CreateUI)

if success then
    Notify("Uranium Hub", "Loaded! Press INS to toggle UI")
    
    -- INS key to toggle UI
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Insert then
            UIVisible = not UIVisible
            if UIVisible then
                Window.Enabled = true
            else
                Window.Enabled = false
            end
        end
    end)
else
    warn("Failed to load UI: " .. tostring(Window))
end

print("\n=== URANIUM HUB LOADED ===")
print("Press INS to toggle UI")
print("Features: Noclip, Wallhack, Movement Speed")
print("=====================================\n")
