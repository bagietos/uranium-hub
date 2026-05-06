--[[
    URANIUM HUB - Noclip Module
    Handles noclip functionality (collision bypass)
]]

local RunService = game:GetService("RunService")

local Noclip = {}

-- ============================================================================
-- MODULE STATE
-- ============================================================================

Noclip.Enabled = false
Noclip.Connection = nil
Noclip.Character = nil

-- ============================================================================
-- ENABLE NOCLIP
-- ============================================================================

--[[
    Enable: Activate noclip mode
    Disables collision for all character parts
]]
function Noclip:Enable()
    if self.Enabled then
        return
    end
    
    self.Enabled = true
    
    -- Disable collision detection on heartbeat
    self.Connection = RunService.Stepped:Connect(function()
        if not self.Enabled or not self.Character then
            return
        end
        
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    print("[Noclip] Enabled")
end

-- ============================================================================
-- DISABLE NOCLIP
-- ============================================================================

--[[
    Disable: Deactivate noclip mode
    Re-enables collision for all character parts
]]
function Noclip:Disable()
    if not self.Enabled then
        return
    end
    
    self.Enabled = false
    
    -- Disconnect the heartbeat connection
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    -- Re-enable collision detection
    if self.Character then
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    print("[Noclip] Disabled")
end

-- ============================================================================
-- TOGGLE NOCLIP
-- ============================================================================

--[[
    Toggle: Toggle noclip on/off
]]
function Noclip:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- ============================================================================
-- SET CHARACTER
-- ============================================================================

--[[
    SetCharacter: Update the character reference
    @param character: The new character
]]
function Noclip:SetCharacter(character)
    self.Character = character
end

-- ============================================================================
-- CLEANUP
-- ============================================================================

--[[
    Cleanup: Clean up noclip resources
]]
function Noclip:Cleanup()
    self:Disable()
    self.Character = nil
end

return Noclip
