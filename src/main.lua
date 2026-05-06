--[[
    URANIUM HUB - Main Entry Point
    Initialization and orchestration of the entire hub
]]

local Config = require(script.Parent.utils.config)
local Helpers = require(script.Parent.utils.helpers)
local FeatureManager = require(script.Parent.modules.feature_manager)
local UIWindow = require(script.Parent.ui.window)
local UITabs = require(script.Parent.ui.tabs)

-- ============================================================================
-- SERVICES
-- ============================================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- ============================================================================
-- GLOBAL STATE
-- ============================================================================

local ObsidianUILibrary = nil
local MainWindow = nil
local UIToggles = {}

-- ============================================================================
-- LOAD OBSIDIAN UI LIBRARY
-- ============================================================================

local function LoadObsidianUI()
    print(Config.Messages.LoadingUI)
    
    ObsidianUILibrary = Helpers.LoadFromUrl(
        Config.ObsidianUI.Repository,
        Config.ObsidianUI.Fallback
    )
    
    if not ObsidianUILibrary then
        error(Config.Messages.UIFailed)
    end
    
    print(Config.Messages.UILoaded)
    return true
end

-- ============================================================================
-- CREATE MAIN INTERFACE
-- ============================================================================

local function CreateMainInterface()
    -- Create main window
    MainWindow = UIWindow:Create(ObsidianUILibrary)
    
    -- Create tabs
    local movementTabData = UITabs:CreateMovementTab(MainWindow)
    UITabs:CreateHomeTab(MainWindow)
    UITabs:CreateSettingsTab(MainWindow, movementTabData)
    
    -- Store toggle references for later updates
    UIToggles.NoclipToggle = movementTabData.NoclipToggle
    UIToggles.FlyToggle = movementTabData.FlyToggle
    
    print(Config.Messages.UILoaded)
end

-- ============================================================================
-- INITIALIZE HUB
-- ============================================================================

local function Initialize()
    print("[Uranium Hub] Starting initialization...")
    
    -- Load UI library
    LoadObsidianUI()
    
    -- Initialize feature manager
    FeatureManager:Initialize(Character)
    
    -- Create UI interface
    CreateMainInterface()
    
    -- Setup character respawn handling
    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        FeatureManager:Initialize(Character)
        print(Config.Messages.CharacterRespawned)
    end)
    
    print(Config.Messages.Initialized)
    print(Config.Messages.Ready)
end

-- ============================================================================
-- STARTUP
-- ============================================================================

Initialize()

-- ============================================================================
-- CLEANUP HANDLING
-- ============================================================================

game:BindToClose(function()
    if FeatureManager then
        FeatureManager:Cleanup()
    end
end)
