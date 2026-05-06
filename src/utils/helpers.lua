--[[
    URANIUM HUB - Helper Functions Module
    Utility functions used throughout the hub
]]

local Helpers = {}

-- ============================================================================
-- HTTP REQUESTS
-- ============================================================================

--[[
    LoadFromUrl: Safely load and execute code from a URL
    @param url: The URL to load from
    @return: The loaded function or nil if failed
]]
function Helpers.LoadFromUrl(url)
    local success, response = pcall(function()
        return syn.request({
            Url = url,
            Method = "GET"
        })
    end)
    
    if not success then
        warn("Failed to connect to URL: " .. url)
        return nil
    end
    
    if response.StatusCode ~= 200 then
        warn("HTTP Error: " .. response.StatusCode)
        return nil
    end
    
    local loadSuccess, result = pcall(function()
        return loadstring(response.Body)()
    end)
    
    if not loadSuccess then
        warn("Failed to load code from: " .. url)
        return nil
    end
    
    return result
end

-- ============================================================================
-- TABLE UTILITIES
-- ============================================================================

--[[
    Merge: Merge two tables together
    @param t1: First table
    @param t2: Second table
    @return: Merged table
]]
function Helpers.Merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

-- ============================================================================
-- MATH UTILITIES
-- ============================================================================

--[[
    Clamp: Clamp a value between min and max
    @param value: The value to clamp
    @param min: Minimum value
    @param max: Maximum value
    @return: Clamped value
]]
function Helpers.Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- ============================================================================
-- LOGGING
-- ============================================================================

--[[
    Log: Print a formatted message
    @param message: The message to print
]]
function Helpers.Log(message)
    print(message)
end

--[[
    Warn: Print a formatted warning
    @param message: The warning message
]]
function Helpers.Warn(message)
    warn(message)
end

return Helpers
