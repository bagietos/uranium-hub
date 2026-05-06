--[[
    URANIUM HUB - Feature Manager Module
    Centralized management of all features
]]

local Noclip = require(script.Parent.noclip)
local Fly = require(script.Parent.fly)

local FeatureManager = {}

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

--[[
    Initialize: Set up all features with character reference
    @param character: The player character
]]
function FeatureManager:Initialize(character)
    Noclip:SetCharacter(character)
    Fly:SetCharacter(character)
end

-- ============================================================================
-- FEATURE TOGGLES
-- ============================================================================

--[[
    ToggleNoclip: Toggle noclip feature
]]
function FeatureManager:ToggleNoclip()
    Noclip:Toggle()
end

--[[
    ToggleFly: Toggle fly feature
]]
function FeatureManager:ToggleFly()
    Fly:Toggle()
end

-- ============================================================================
-- FEATURE STATE GETTERS
-- ============================================================================

--[[
    IsNoclipEnabled: Check if noclip is enabled
    @return: Boolean
]]
function FeatureManager:IsNoclipEnabled()
    return Noclip.Enabled
end

--[[
    IsFlyEnabled: Check if fly is enabled
    @return: Boolean
]]
function FeatureManager:IsFlyEnabled()
    return Fly.Enabled
end

-- ============================================================================
-- SETTINGS
-- ============================================================================

--[[
    SetFlySpeed: Set the fly speed
    @param speed: New speed value
]]
function FeatureManager:SetFlySpeed(speed)
    Fly:SetSpeed(speed)
end

--[[
    GetFlySpeed: Get current fly speed
    @return: Current speed
]]
function FeatureManager:GetFlySpeed()
    return Fly.Speed
end

-- ============================================================================
-- DISABLE ALL FEATURES
-- ============================================================================

--[[
    DisableAll: Disable all active features
]]
function FeatureManager:DisableAll()
    if Noclip.Enabled then
        Noclip:Disable()
    end
    
    if Fly.Enabled then
        Fly:Disable()
    end
    
    print("[FeatureManager] All features disabled")
end

-- ============================================================================
-- CLEANUP
-- ============================================================================

--[[
    Cleanup: Clean up all features
    Called on character respawn or script unload
]]
function FeatureManager:Cleanup()
    Noclip:Cleanup()
    Fly:Cleanup()
end

return FeatureManager
