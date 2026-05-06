--[[
    URANIUM HUB - Fly Module
    Handles smooth flight functionality using BodyVelocity
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Fly = {}

-- ============================================================================
-- MODULE STATE
-- ============================================================================

Fly.Enabled = false
Fly.Speed = 50
Fly.Character = nil
Fly.RootPart = nil
Fly.BodyVelocity = nil
Fly.VelocityDirection = Vector3.new(0, 0, 0)
Fly.InputConnection = nil
Fly.RenderConnection = nil
Fly.IsFlying = false

-- ============================================================================
-- ENABLE FLY
-- ============================================================================

--[[
    Enable: Activate fly mode
    Creates BodyVelocity and sets up input handling
]]
function Fly:Enable()
    if self.Enabled or not self.RootPart then
        return
    end
    
    self.Enabled = true
    self.IsFlying = true
    self.VelocityDirection = Vector3.new(0, 0, 0)
    
    -- Create BodyVelocity for flight physics
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    self.BodyVelocity.Parent = self.RootPart
    
    -- Input handling for movement
    self.InputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not self.Enabled then
            return
        end
        
        -- WASD Movement
        if input.KeyCode == Enum.KeyCode.W then
            self.VelocityDirection = self.VelocityDirection + (self.Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.S then
            self.VelocityDirection = self.VelocityDirection - (self.Character.PrimaryPart.CFrame.LookVector)
        elseif input.KeyCode == Enum.KeyCode.A then
            self.VelocityDirection = self.VelocityDirection - (self.Character.PrimaryPart.CFrame.RightVector)
        elseif input.KeyCode == Enum.KeyCode.D then
            self.VelocityDirection = self.VelocityDirection + (self.Character.PrimaryPart.CFrame.RightVector)
        -- Vertical movement
        elseif input.KeyCode == Enum.KeyCode.Space then
            self.VelocityDirection = self.VelocityDirection + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            self.VelocityDirection = self.VelocityDirection - Vector3.new(0, 1, 0)
        end
    end)
    
    -- Render loop for smooth flight
    self.RenderConnection = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not self.BodyVelocity then
            return
        end
        
        if self.VelocityDirection.Magnitude > 0 then
            self.BodyVelocity.Velocity = self.VelocityDirection.Unit * self.Speed
        else
            self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Decay velocity direction for smooth handling
        self.VelocityDirection = self.VelocityDirection * 0.9
    end)
    
    print("[Fly] Enabled - Speed: " .. self.Speed)
end

-- ============================================================================
-- DISABLE FLY
-- ============================================================================

--[[
    Disable: Deactivate fly mode
    Cleans up BodyVelocity and input connections
]]
function Fly:Disable()
    if not self.Enabled then
        return
    end
    
    self.Enabled = false
    self.IsFlying = false
    
    -- Disconnect input
    if self.InputConnection then
        self.InputConnection:Disconnect()
        self.InputConnection = nil
    end
    
    -- Disconnect render loop
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
    
    -- Remove BodyVelocity
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    
    self.VelocityDirection = Vector3.new(0, 0, 0)
    
    print("[Fly] Disabled")
end

-- ============================================================================
-- TOGGLE FLY
-- ============================================================================

--[[
    Toggle: Toggle fly on/off
]]
function Fly:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- ============================================================================
-- SET SPEED
-- ============================================================================

--[[
    SetSpeed: Set the fly speed
    @param speed: New speed value
]]
function Fly:SetSpeed(speed)
    self.Speed = speed
    print("[Fly] Speed set to: " .. speed)
end

-- ============================================================================
-- SET CHARACTER
-- ============================================================================

--[[
    SetCharacter: Update the character reference
    @param character: The new character
]]
function Fly:SetCharacter(character)
    self.Character = character
    self.RootPart = character:WaitForChild("HumanoidRootPart")
end

-- ============================================================================
-- CLEANUP
-- ============================================================================

--[[
    Cleanup: Clean up fly resources
]]
function Fly:Cleanup()
    self:Disable()
    self.Character = nil
    self.RootPart = nil
end

return Fly
