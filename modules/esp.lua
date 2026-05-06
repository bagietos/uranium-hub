--[[
    ☢️ Uranium Hub - ESP Module
    
    Advanced player detection system with multiple rendering options.
    Includes Box ESP, Tracer Lines, Names, Distance, and Health Bars.
]]

local ESP = {}
local Config = require(script.Parent:WaitForChild("config"))
local Utilities = require(script.Parent:WaitForChild("utilities"))

-- ============================================================================
-- DATA STRUCTURES
-- ============================================================================

local ESPData = {
    Active = false,
    Drawings = {},        -- Store all drawings for cleanup
    UpdateConnection = nil,
    PlayerDrawings = {},  -- Per-player drawing cache
}

-- ============================================================================
-- INITIALIZATION & CLEANUP
-- ============================================================================

--[[
    Initializes ESP system
    
    @return boolean - Success status
]]
function ESP:Init()
    self:Log("Initializing ESP system...", "DEBUG")
    
    if not Drawing then
        self:Log("Drawing library not available", "ERROR")
        return false
    end
    
    self:Log("ESP system initialized successfully", "INFO")
    return true
end

--[[
    Enables or disables ESP
    
    @param enabled boolean - True to enable, false to disable
]]
function ESP:SetEnabled(enabled)
    if enabled and not ESPData.Active then
        self:Log("Enabling ESP...", "DEBUG")
        ESPData.Active = true
        
        -- Start update loop
        if ESPData.UpdateConnection then
            ESPData.UpdateConnection:Disconnect()
        end
        
        ESPData.UpdateConnection = game:GetService("RunService").RenderStepped:Connect(function()
            self:Update()
        end)
        
        Utilities:Notify("ESP", "Enabled")
        self:Log("ESP enabled", "INFO")
        
    elseif not enabled and ESPData.Active then
        self:Log("Disabling ESP...", "DEBUG")
        ESPData.Active = false
        
        if ESPData.UpdateConnection then
            ESPData.UpdateConnection:Disconnect()
            ESPData.UpdateConnection = nil
        end
        
        self:ClearAll()
        Utilities:Notify("ESP", "Disabled")
        self:Log("ESP disabled", "INFO")
    end
end

-- ============================================================================
-- MAIN UPDATE LOOP
-- ============================================================================

--[[
    Main ESP update function (called every frame)
]]
function ESP:Update()
    if not ESPData.Active then
        return
    end
    
    local visiblePlayers = Utilities:GetOtherPlayers()
    local localPlayer = game:GetService("Players").LocalPlayer
    
    -- Process each visible player
    for _, player in ipairs(visiblePlayers) do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            self:UpdatePlayerESP(player)
        else
            self:ClearPlayerESP(player)
        end
    end
    
    -- Clean up drawings for players that left
    for player, _ in pairs(ESPData.PlayerDrawings) do
        if not game:GetService("Players"):FindFirstChild(player.Name) then
            self:ClearPlayerESP(player)
        end
    end
end

--[[
    Updates ESP for a specific player
    
    @param player Player - The player to update ESP for
]]
function ESP:UpdatePlayerESP(player)
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then
        self:ClearPlayerESP(player)
        return
    end
    
    local humanoidRoot = character.HumanoidRootPart
    local humanoid = character.Humanoid
    local localRoot = Utilities:GetLocalRoot()
    
    if not localRoot then
        return
    end
    
    -- Check distance
    local distance = Utilities:Distance(humanoidRoot.Position, localRoot.Position)
    if distance > Config.ESP.MaxDistance then
        self:ClearPlayerESP(player)
        return
    end
    
    -- Check if on screen
    if not Utilities:IsOnScreen(humanoidRoot.Position) then
        self:ClearPlayerESP(player)
        return
    end
    
    -- Initialize player drawings if needed
    if not ESPData.PlayerDrawings[player] then
        ESPData.PlayerDrawings[player] = {
            Box = nil,
            TracerLine = nil,
            NameText = nil,
            DistanceText = nil,
            HealthBar = nil,
        }
    end
    
    local drawings = ESPData.PlayerDrawings[player]
    
    -- Determine color
    local color = Config.ESP.Colors.Enemy
    if player.Team and game:GetService("Players").LocalPlayer.Team == player.Team then
        color = Config.ESP.Colors.Ally
    end
    
    -- Update Box ESP
    if Config.ESP.ShowBox then
        self:UpdateBox(drawings, humanoidRoot, color)
    else
        self:ClearDrawing(drawings.Box)
        drawings.Box = nil
    end
    
    -- Update Tracer
    if Config.ESP.ShowTracer then
        self:UpdateTracer(drawings, humanoidRoot, color)
    else
        self:ClearDrawing(drawings.TracerLine)
        drawings.TracerLine = nil
    end
    
    -- Update Name
    if Config.ESP.ShowNames then
        self:UpdateNameText(drawings, humanoidRoot, player.Name, color)
    else
        self:ClearDrawing(drawings.NameText)
        drawings.NameText = nil
    end
    
    -- Update Distance
    if Config.ESP.ShowDistance then
        self:UpdateDistanceText(drawings, humanoidRoot, distance, color)
    else
        self:ClearDrawing(drawings.DistanceText)
        drawings.DistanceText = nil
    end
    
    -- Update Health Bar
    if Config.ESP.ShowHealthBar then
        self:UpdateHealthBar(drawings, humanoidRoot, humanoid, color)
    else
        self:ClearDrawing(drawings.HealthBar)
        drawings.HealthBar = nil
    end
end

-- ============================================================================
-- INDIVIDUAL ESP COMPONENTS
-- ============================================================================

--[[
    Updates box ESP rendering
    
    @param drawings table - Player's drawing cache
    @param humanoidRoot Instance - HumanoidRootPart
    @param color Color3 - ESP color
]]
function ESP:UpdateBox(drawings, humanoidRoot, color)
    local screenPoint = Utilities:WorldToScreenPoint(humanoidRoot.Position)
    if screenPoint.Z <= 0 then
        return
    end
    
    local camera = workspace.CurrentCamera
    local screenSize = camera.ViewportSize
    
    -- Calculate box size based on distance (simple approximation)
    local distance = Utilities:Distance(humanoidRoot.Position, camera.CFrame.Position)
    local size = 60 / (distance / 100)
    size = math.max(30, math.min(100, size))
    
    if not drawings.Box then
        drawings.Box = Utilities:CreateBox(
            Vector2.new(screenPoint.X - size/2, screenPoint.Y - size/2),
            Vector2.new(size, size * 1.5),
            color,
            Config.ESP.BoxThickness,
            false
        )
        table.insert(ESPData.Drawings, drawings.Box)
    else
        drawings.Box.Position = Vector2.new(screenPoint.X - size/2, screenPoint.Y - size/2)
        drawings.Box.Size = Vector2.new(size, size * 1.5)
        drawings.Box.Color = color
    end
end

--[[
    Updates tracer line rendering
    
    @param drawings table - Player's drawing cache
    @param humanoidRoot Instance - HumanoidRootPart
    @param color Color3 - ESP color
]]
function ESP:UpdateTracer(drawings, humanoidRoot, color)
    local screenPoint = Utilities:WorldToScreenPoint(humanoidRoot.Position)
    if screenPoint.Z <= 0 then
        return
    end
    
    local camera = workspace.CurrentCamera
    local screenSize = camera.ViewportSize
    local centerScreen = Vector2.new(screenSize.X / 2, screenSize.Y)
    
    if not drawings.TracerLine then
        drawings.TracerLine = Utilities:CreateLine(
            centerScreen,
            Vector2.new(screenPoint.X, screenPoint.Y),
            color,
            Config.ESP.TracerThickness
        )
        table.insert(ESPData.Drawings, drawings.TracerLine)
    else
        drawings.TracerLine.From = centerScreen
        drawings.TracerLine.To = Vector2.new(screenPoint.X, screenPoint.Y)
        drawings.TracerLine.Color = color
    end
end

--[[
    Updates player name text
    
    @param drawings table - Player's drawing cache
    @param humanoidRoot Instance - HumanoidRootPart
    @param playerName string - Player's name
    @param color Color3 - ESP color
]]
function ESP:UpdateNameText(drawings, humanoidRoot, playerName, color)
    local screenPoint = Utilities:WorldToScreenPoint(humanoidRoot.Position)
    if screenPoint.Z <= 0 then
        return
    end
    
    if not drawings.NameText then
        drawings.NameText = Utilities:CreateText(
            playerName,
            Vector2.new(screenPoint.X, screenPoint.Y - 40),
            color,
            14
        )
        table.insert(ESPData.Drawings, drawings.NameText)
    else
        drawings.NameText.Text = playerName
        drawings.NameText.Position = Vector2.new(screenPoint.X, screenPoint.Y - 40)
        drawings.NameText.Color = color
    end
end

--[[
    Updates distance text
    
    @param drawings table - Player's drawing cache
    @param humanoidRoot Instance - HumanoidRootPart
    @param distance number - Distance value
    @param color Color3 - ESP color
]]
function ESP:UpdateDistanceText(drawings, humanoidRoot, distance, color)
    local screenPoint = Utilities:WorldToScreenPoint(humanoidRoot.Position)
    if screenPoint.Z <= 0 then
        return
    end
    
    local distanceText = string.format("%.1f", distance) .. "m"
    
    if not drawings.DistanceText then
        drawings.DistanceText = Utilities:CreateText(
            distanceText,
            Vector2.new(screenPoint.X, screenPoint.Y + 60),
            color,
            12
        )
        table.insert(ESPData.Drawings, drawings.DistanceText)
    else
        drawings.DistanceText.Text = distanceText
        drawings.DistanceText.Position = Vector2.new(screenPoint.X, screenPoint.Y + 60)
        drawings.DistanceText.Color = color
    end
end

--[[
    Updates health bar rendering
    
    @param drawings table - Player's drawing cache
    @param humanoidRoot Instance - HumanoidRootPart
    @param humanoid Instance - Humanoid
    @param color Color3 - ESP color
]]
function ESP:UpdateHealthBar(drawings, humanoidRoot, humanoid, color)
    local screenPoint = Utilities:WorldToScreenPoint(humanoidRoot.Position)
    if screenPoint.Z <= 0 then
        return
    end
    
    local healthPercent = math.max(0, humanoid.Health / humanoid.MaxHealth)
    local healthColor = Config.ESP.Colors.HealthLow
    
    if healthPercent > 0.5 then
        -- Interpolate between yellow and green
        local r = 1 - (healthPercent - 0.5) * 2
        healthColor = Color3.fromRGB(255 * r, 255, 0)
    else
        -- Interpolate between red and yellow
        local g = healthPercent * 2
        healthColor = Color3.fromRGB(255, 255 * g, 0)
    end
    
    if not drawings.HealthBar then
        drawings.HealthBar = Utilities:CreateBox(
            Vector2.new(screenPoint.X - Config.ESP.HealthBarWidth/2, screenPoint.Y - 50),
            Vector2.new(Config.ESP.HealthBarWidth * healthPercent, Config.ESP.HealthBarHeight),
            healthColor,
            1,
            true
        )
        table.insert(ESPData.Drawings, drawings.HealthBar)
    else
        drawings.HealthBar.Position = Vector2.new(screenPoint.X - Config.ESP.HealthBarWidth/2, screenPoint.Y - 50)
        drawings.HealthBar.Size = Vector2.new(Config.ESP.HealthBarWidth * healthPercent, Config.ESP.HealthBarHeight)
        drawings.HealthBar.Color = healthColor
    end
end

-- ============================================================================
-- CLEANUP FUNCTIONS
-- ============================================================================

--[[
    Clears ESP for a specific player
    
    @param player Player - The player
]]
function ESP:ClearPlayerESP(player)
    if not ESPData.PlayerDrawings[player] then
        return
    end
    
    local drawings = ESPData.PlayerDrawings[player]
    self:ClearDrawing(drawings.Box)
    self:ClearDrawing(drawings.TracerLine)
    self:ClearDrawing(drawings.NameText)
    self:ClearDrawing(drawings.DistanceText)
    self:ClearDrawing(drawings.HealthBar)
    
    ESPData.PlayerDrawings[player] = nil
end

--[[
    Clears a single drawing
    
    @param drawing Instance - The drawing to clear
]]
function ESP:ClearDrawing(drawing)
    if drawing then
        pcall(function()
            drawing.Visible = false
            drawing:Remove()
        end)
    end
end

--[[
    Clears all ESP drawings
]]
function ESP:ClearAll()
    self:Log("Clearing all ESP drawings...", "DEBUG")
    
    for _, drawing in ipairs(ESPData.Drawings) do
        self:ClearDrawing(drawing)
    end
    
    ESPData.Drawings = {}
    ESPData.PlayerDrawings = {}
    
    self:Log("All ESP drawings cleared", "DEBUG")
end

-- ============================================================================
-- CLEANUP ON UNLOAD
-- ============================================================================

--[[
    Cleans up ESP on module unload
]]
function ESP:Cleanup()
    self:Log("Cleaning up ESP...", "DEBUG")
    self:SetEnabled(false)
    self:ClearAll()
    self:Log("ESP cleanup complete", "INFO")
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--[[
    Logs ESP messages
]]
function ESP:Log(message, level)
    Utilities:Log("[ESP] " .. message, level)
end

return ESP
