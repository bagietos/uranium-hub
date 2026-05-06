--[[
    ☢️ Uranium Hub - Utilities Module
    
    Helper functions and utilities for common tasks across the hub.
]]

local Utilities = {}

-- ============================================================================
-- LOGGING & DEBUGGING
-- ============================================================================

--[[
    Logs a message to console with timestamp and level
    
    @param message string - Message to log
    @param level string - Log level ("DEBUG", "INFO", "WARNING", "ERROR")
]]
function Utilities:Log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%H:%M:%S")
    local color = {
        DEBUG = "\27[36m",     -- Cyan
        INFO = "\27[32m",      -- Green
        WARNING = "\27[33m",   -- Yellow
        ERROR = "\27[31m",     -- Red
    }
    
    local prefix = string.format("[%s][%s]", timestamp, level)
    print(color[level] .. prefix .. "\27[0m " .. message)
end

--[[
    Shows a debug notification to player
    
    @param title string - Notification title
    @param message string - Notification message
    @param duration number - Duration in seconds
]]
function Utilities:Notify(title, message, duration)
    duration = duration or 3
    title = title or "Uranium Hub"
    
    -- Create notification (requires UI module in full implementation)
    self:Log(title .. ": " .. message, "INFO")
end

-- ============================================================================
-- VECTOR & MATH UTILITIES
-- ============================================================================

--[[
    Calculates distance between two points
    
    @param pos1 Vector3 - First position
    @param pos2 Vector3 - Second position
    @return number - Distance in studs
]]
function Utilities:Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

--[[
    Calculates distance between player and target player
    
    @param targetPlayer Player - Target player
    @return number - Distance in studs
]]
function Utilities:PlayerDistance(targetPlayer)
    local localPlayer = game:GetService("Players").LocalPlayer
    if not localPlayer or not localPlayer.Character then
        return math.huge
    end
    
    local targetChar = targetPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    return self:Distance(
        localPlayer.Character.HumanoidRootPart.Position,
        targetChar.HumanoidRootPart.Position
    )
end

--[[
    Gets world to screen position for rendering
    
    @param position Vector3 - World position
    @return table - {X, Y, Z} screen position or nil
]]
function Utilities:WorldToScreenPoint(position)
    local camera = workspace.CurrentCamera
    local screenSize = camera.ViewportSize
    
    local screenPoint = camera:WorldToScreenPoint(position)
    
    return {
        X = screenPoint.X,
        Y = screenPoint.Y,
        Z = screenPoint.Z,  -- Depth (negative = behind camera)
    }
end

--[[
    Checks if a world position is on screen
    
    @param position Vector3 - World position
    @return boolean - True if on screen
]]
function Utilities:IsOnScreen(position)
    local camera = workspace.CurrentCamera
    local screenSize = camera.ViewportSize
    local screenPoint = camera:WorldToScreenPoint(position)
    
    return screenPoint.Z > 0 and 
           screenPoint.X > 0 and screenPoint.X < screenSize.X and
           screenPoint.Y > 0 and screenPoint.Y < screenSize.Y
end

-- ============================================================================
-- PLAYER UTILITIES
-- ============================================================================

--[[
    Gets all players except local player
    
    @return table - Array of players
]]
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

--[[
    Gets all visible players (with character)
    
    @return table - Array of valid players
]]
function Utilities:GetVisiblePlayers()
    local Players = game:GetService("Players")
    local visiblePlayers = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            table.insert(visiblePlayers, player)
        end
    end
    
    return visiblePlayers
end

--[[
    Gets player's humanoid root part
    
    @param player Player - The player
    @return Instance - HumanoidRootPart or nil
]]
function Utilities:GetPlayerRoot(player)
    if not player or not player.Character then
        return nil
    end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

--[[
    Gets player's humanoid
    
    @param player Player - The player
    @return Instance - Humanoid or nil
]]
function Utilities:GetPlayerHumanoid(player)
    if not player or not player.Character then
        return nil
    end
    return player.Character:FindFirstChild("Humanoid")
end

--[[
    Gets local player's character
    
    @return Instance - Character or nil
]]
function Utilities:GetLocalPlayer()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    if localPlayer and localPlayer.Character then
        return localPlayer.Character
    end
    return nil
end

--[[
    Gets local player's humanoid root part
    
    @return Instance - HumanoidRootPart or nil
]]
function Utilities:GetLocalRoot()
    local character = self:GetLocalPlayer()
    if not character then
        return nil
    end
    return character:FindFirstChild("HumanoidRootPart")
end

--[[
    Gets local player's humanoid
    
    @return Instance - Humanoid or nil
]]
function Utilities:GetLocalHumanoid()
    local character = self:GetLocalPlayer()
    if not character then
        return nil
    end
    return character:FindFirstChild("Humanoid")
end

-- ============================================================================
-- TABLE UTILITIES
-- ============================================================================

--[[
    Deep copies a table
    
    @param tbl table - Table to copy
    @return table - Copied table
]]
function Utilities:DeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = self:DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--[[
    Merges two tables (second overwrites first)
    
    @param tbl1 table - Base table
    @param tbl2 table - Override table
    @return table - Merged table
]]
function Utilities:Merge(tbl1, tbl2)
    local result = self:DeepCopy(tbl1)
    for k, v in pairs(tbl2) do
        result[k] = v
    end
    return result
end

--[[
    Gets table size
    
    @param tbl table - The table
    @return number - Size
]]
function Utilities:TableSize(tbl)
    local size = 0
    for _ in pairs(tbl) do
        size = size + 1
    end
    return size
end

-- ============================================================================
-- STRING UTILITIES
-- ============================================================================

--[[
    Formats a number with commas
    
    @param num number - Number to format
    @return string - Formatted number
]]
function Utilities:FormatNumber(num)
    return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

--[[
    Rounds a number to decimal places
    
    @param num number - Number to round
    @param decimals number - Decimal places
    @return number - Rounded number
]]
function Utilities:Round(num, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(num * mult + 0.5) / mult
end

--[[
    Converts seconds to formatted time string
    
    @param seconds number - Seconds
    @return string - Formatted time
]]
function Utilities:FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

-- ============================================================================
-- INSTANCE UTILITIES
-- ============================================================================

--[[
    Recursively finds all instances of a class
    
    @param parent Instance - Parent to search
    @param className string - Class name to find
    @return table - Array of instances
]]
function Utilities:FindAllOfClass(parent, className)
    local found = {}
    
    local function search(obj)
        if obj:IsA(className) then
            table.insert(found, obj)
        end
        
        for _, child in ipairs(obj:GetChildren()) do
            search(child)
        end
    end
    
    search(parent)
    return found
end

--[[
    Safely destroys an instance
    
    @param instance Instance - Instance to destroy
]]
function Utilities:Destroy(instance)
    if instance and instance.Parent then
        instance:Destroy()
    end
end

-- ============================================================================
-- DRAWING UTILITIES (for ESP)
-- ============================================================================

--[[
    Creates a drawing line
    
    @param from Vector2 - Start position
    @param to Vector2 - End position
    @param color Color3 - Line color
    @param thickness number - Line thickness
    @return Instance - Line drawing
]]
function Utilities:CreateLine(from, to, color, thickness)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = color
    line.Thickness = thickness or 1
    line.Visible = true
    return line
end

--[[
    Creates a drawing box
    
    @param position Vector2 - Top-left position
    @param size Vector2 - Box size
    @param color Color3 - Box color
    @param thickness number - Box thickness
    @param filled boolean - Whether to fill
    @return Instance - Box drawing
]]
function Utilities:CreateBox(position, size, color, thickness, filled)
    local box = Drawing.new("Square")
    box.Position = position
    box.Size = size
    box.Color = color
    box.Thickness = thickness or 2
    box.Filled = filled or false
    box.Visible = true
    return box
end

--[[
    Creates a drawing text
    
    @param text string - Text to display
    @param position Vector2 - Text position
    @param color Color3 - Text color
    @param size number - Text size
    @return Instance - Text drawing
]]
function Utilities:CreateText(text, position, color, size)
    local textObj = Drawing.new("Text")
    textObj.Text = text
    textObj.Position = position
    textObj.Color = color
    textObj.Size = size or 14
    textObj.Visible = true
    return textObj
end

-- ============================================================================
-- PERFORMANCE MONITORING
-- ============================================================================

--[[
    Gets current FPS
    
    @return number - FPS
]]
function Utilities:GetFPS()
    local fps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    return fps
end

--[[
    Gets current memory usage in MB
    
    @return number - Memory in MB
]]
function Utilities:GetMemory()
    return collectgarbage("count") / 1024
end

return Utilities
