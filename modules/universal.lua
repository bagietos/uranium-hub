--[[
    ☢️ Uranium Hub - Universal Features Module
    
    Core gameplay features: Fly, Noclip, Speed, Jump, God Mode, Stamina, etc.
]]

local Universal = {}
local Config = require(script.Parent:WaitForChild("config"))
local Utilities = require(script.Parent:WaitForChild("utilities"))

-- ============================================================================
-- FLY SYSTEM
-- ============================================================================

local FlyData = {
    Active = false,
    BodyVelocity = nil,
    Connection = nil,
}

--[[
    Enables or disables fly mode
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetFly(enabled)
    local character = Utilities:GetLocalPlayer()
    local humanoidRoot = Utilities:GetLocalRoot()
    
    if not character or not humanoidRoot then
        return
    end
    
    if enabled and not FlyData.Active then
        self:Log("Activating fly mode...", "DEBUG")
        FlyData.Active = true
        
        -- Create BodyVelocity for movement
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = humanoidRoot
        FlyData.BodyVelocity = bodyVelocity
        
        -- Create BodyGyro for rotation
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.Parent = humanoidRoot
        
        local UserInputService = game:GetService("UserInputService")
        local camera = workspace.CurrentCamera
        
        -- Fly input connection
        FlyData.Connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not FlyData.Active then
                return
            end
            
            if not bodyVelocity or not bodyVelocity.Parent then
                Universal:SetFly(false)
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Get input
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
            
            -- Normalize and apply speed
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            bodyVelocity.Velocity = moveDirection * Config.Features.Fly.Speed
            bodyGyro.CFrame = camera.CFrame
        end)
        
        Utilities:Notify("Fly", "Enabled")
        self:Log("Fly mode activated", "INFO")
        
    elseif not enabled and FlyData.Active then
        self:Log("Deactivating fly mode...", "DEBUG")
        FlyData.Active = false
        
        if FlyData.Connection then
            FlyData.Connection:Disconnect()
            FlyData.Connection = nil
        end
        
        if FlyData.BodyVelocity then
            FlyData.BodyVelocity:Destroy()
            FlyData.BodyVelocity = nil
        end
        
        Utilities:Notify("Fly", "Disabled")
        self:Log("Fly mode deactivated", "INFO")
    end
end

-- ============================================================================
-- NOCLIP MODE
-- ============================================================================

local NoclipData = {
    Active = false,
    Connection = nil,
}

--[[
    Enables or disables noclip mode
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetNoclip(enabled)
    local character = Utilities:GetLocalPlayer()
    
    if not character then
        return
    end
    
    if enabled and not NoclipData.Active then
        self:Log("Activating noclip...", "DEBUG")
        NoclipData.Active = true
        
        local UserInputService = game:GetService("UserInputService")
        local camera = workspace.CurrentCamera
        local humanoidRoot = Utilities:GetLocalRoot()
        
        if not humanoidRoot then
            return
        end
        
        NoclipData.Connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not NoclipData.Active then
                return
            end
            
            local humanoidRoot = Utilities:GetLocalRoot()
            if not humanoidRoot then
                Universal:SetNoclip(false)
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Get input
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
            
            -- Normalize and apply speed
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            humanoidRoot.CFrame = humanoidRoot.CFrame + (moveDirection * Config.Features.Noclip.Speed * 0.016)
        end)
        
        Utilities:Notify("Noclip", "Enabled")
        self:Log("Noclip activated", "INFO")
        
    elseif not enabled and NoclipData.Active then
        self:Log("Deactivating noclip...", "DEBUG")
        NoclipData.Active = false
        
        if NoclipData.Connection then
            NoclipData.Connection:Disconnect()
            NoclipData.Connection = nil
        end
        
        Utilities:Notify("Noclip", "Disabled")
        self:Log("Noclip deactivated", "INFO")
    end
end

-- ============================================================================
-- SPEED ENHANCEMENT
-- ============================================================================

local SpeedConnection = nil

--[[
    Enables or disables infinite walk speed
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetWalkSpeed(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    
    if not humanoid then
        return
    end
    
    if enabled then
        self:Log("Activating walk speed enhancement...", "DEBUG")
        
        if SpeedConnection then
            SpeedConnection:Disconnect()
        end
        
        SpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.WalkSpeed = Config.Features.WalkSpeed.Speed
            else
                Universal:SetWalkSpeed(false)
            end
        end)
        
        Utilities:Notify("Walk Speed", "Enabled: " .. Config.Features.WalkSpeed.Speed)
        self:Log("Walk speed enhancement activated", "INFO")
        
    else
        self:Log("Deactivating walk speed enhancement...", "DEBUG")
        
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
        
        if humanoid then
            humanoid.WalkSpeed = Config.Features.WalkSpeed.Default
        end
        
        Utilities:Notify("Walk Speed", "Disabled")
        self:Log("Walk speed enhancement deactivated", "INFO")
    end
end

-- ============================================================================
-- JUMP POWER ENHANCEMENT
-- ============================================================================

local JumpConnection = nil

--[[
    Enables or disables infinite jump power
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetJumpPower(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    
    if not humanoid then
        return
    end
    
    if enabled then
        self:Log("Activating jump power enhancement...", "DEBUG")
        
        if JumpConnection then
            JumpConnection:Disconnect()
        end
        
        JumpConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local humanoid = Utilities:GetLocalHumanoid()
            if humanoid then
                humanoid.JumpPower = Config.Features.JumpPower.Power
            else
                Universal:SetJumpPower(false)
            end
        end)
        
        Utilities:Notify("Jump Power", "Enabled: " .. Config.Features.JumpPower.Power)
        self:Log("Jump power enhancement activated", "INFO")
        
    else
        self:Log("Deactivating jump power enhancement...", "DEBUG")
        
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
        
        if humanoid then
            humanoid.JumpPower = Config.Features.JumpPower.Default
        end
        
        Utilities:Notify("Jump Power", "Disabled")
        self:Log("Jump power enhancement deactivated", "INFO")
    end
end

-- ============================================================================
-- GOD MODE
-- ============================================================================

local GodModeConnection = nil

--[[
    Enables or disables god mode (invincibility)
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetGodMode(enabled)
    local humanoid = Utilities:GetLocalHumanoid()
    
    if not humanoid then
        return
    end
    
    if enabled then
        self:Log("Activating god mode...", "DEBUG")
        
        if GodModeConnection then
            GodModeConnection:Disconnect()
        end
        
        GodModeConnection = humanoid.Damaged:Connect(function()
            -- Restore health immediately when damaged
            task.wait(0.01)
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        -- Also set initial health to max
        humanoid.Health = humanoid.MaxHealth
        
        Utilities:Notify("God Mode", "Enabled")
        self:Log("God mode activated", "INFO")
        
    else
        self:Log("Deactivating god mode...", "DEBUG")
        
        if GodModeConnection then
            GodModeConnection:Disconnect()
            GodModeConnection = nil
        end
        
        Utilities:Notify("God Mode", "Disabled")
        self:Log("God mode deactivated", "INFO")
    end
end

-- ============================================================================
-- INFINITE STAMINA
-- ============================================================================

local StaminaConnection = nil

--[[
    Enables or disables infinite stamina
    
    @param enabled boolean - True to enable, false to disable
]]
function Universal:SetInfiniteStamina(enabled)
    local character = Utilities:GetLocalPlayer()
    
    if not character then
        return
    end
    
    if enabled then
        self:Log("Activating infinite stamina...", "DEBUG")
        
        if StaminaConnection then
            StaminaConnection:Disconnect()
        end
        
        StaminaConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = Utilities:GetLocalPlayer()
            if character then
                local stamina = character:FindFirstChild("Stamina")
                if stamina then
                    stamina.Value = stamina.MaxValue or 100
                end
            else
                Universal:SetInfiniteStamina(false)
            end
        end)
        
        Utilities:Notify("Infinite Stamina", "Enabled")
        self:Log("Infinite stamina activated", "INFO")
        
    else
        self:Log("Deactivating infinite stamina...", "DEBUG")
        
        if StaminaConnection then
            StaminaConnection:Disconnect()
            StaminaConnection = nil
        end
        
        Utilities:Notify("Infinite Stamina", "Disabled")
        self:Log("Infinite stamina deactivated", "INFO")
    end
end

-- ============================================================================
-- CLEANUP
-- ============================================================================

--[[
    Disables all features on unload
]]
function Universal:Cleanup()
    self:Log("Cleaning up universal features...", "DEBUG")
    
    self:SetFly(false)
    self:SetNoclip(false)
    self:SetWalkSpeed(false)
    self:SetJumpPower(false)
    self:SetGodMode(false)
    self:SetInfiniteStamina(false)
    
    self:Log("Universal features cleaned up", "INFO")
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--[[
    Logs universal feature messages
]]
function Universal:Log(message, level)
    Utilities:Log("[Universal] " .. message, level)
end

return Universal
