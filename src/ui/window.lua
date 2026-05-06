--[[
    URANIUM HUB - UI Window Module
    Handles main window creation and management
]]

local Config = require(script.Parent.Parent.utils.config)

local UIWindow = {}

-- ============================================================================
-- CREATE WINDOW
-- ============================================================================

--[[
    Create: Create the main UI window
    @param ObsidianUI: The loaded Obsidian UI library
    @return: Window object
]]
function UIWindow:Create(Rayfield)
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

    return Window
end

return UIWindow
