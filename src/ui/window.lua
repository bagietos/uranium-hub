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
function UIWindow:Create(ObsidianUI)
    local Window = ObsidianUI:CreateWindow({
        Name = Config.UI.Name,
        Size = Config.UI.WindowSize,
        HasClosing = Config.UI.HasClosing,
        HasMinimizing = Config.UI.HasMinimizing,
        Draggable = Config.UI.Draggable,
        ShowHideKey = Config.Keybinds.ToggleMenu
    })
    
    return Window
end

return UIWindow
