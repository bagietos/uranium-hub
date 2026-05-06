--[[
    ☢️ URANIUM HUB - Main Loader
    ============================================================================
    
    Professional, modular Roblox script hub with Obsidian UI.
    
    Features:
    - Universal gameplay features (Fly, Noclip, Speed, Jump, God Mode, Stamina)
    - Advanced ESP system with Box, Tracer, Names, Distance, Health Bar
    - Customizable settings and UI
    - Modular architecture for easy expansion
    
    Made with ☢️ for Roblox in 2026
    ============================================================================
]]

-- ============================================================================
-- VERSION & METADATA
-- ============================================================================

local HubVersion = "1.0.0"
local HubAuthor = "Uranium Team"
local CreatedDate = "May 2026"
local LastUpdated = os.date("%Y-%m-%d %H:%M:%S")

-- ============================================================================
-- SCRIPT SAFETY CHECKS
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Check if running in a valid environment
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Check if player is loaded
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("Failed to get local player")
    return
end

-- ============================================================================
-- MODULE LOADING & INITIALIZATION
-- ============================================================================

local Utilities
local Config
local UI
local Universal
local ESP

--[[
    Safely loads and requires a module
    
    @param modulePath string - Path to the module
    @param moduleName string - Name of module (for logging)
    @return table|nil - The loaded module or nil
]]
local function LoadModule(modulePath, moduleName)
    local success, module = pcall(function()
        return require(modulePath)
    end)
    
    if success and module then
        print("[☢️ Hub] ✓ Loaded module: " .. moduleName)
        return module
    else
        warn("[☢️ Hub] ✗ Failed to load module: " .. moduleName)
        print(module)
        return nil
    end
end

--[[
    Initializes all hub modules
    
    @return boolean - True if all modules loaded successfully
]]
local function InitializeHub()
    print("\n" .. string.rep("=", 50))
    print("☢️ URANIUM HUB - INITIALIZING")
    print("Version: " .. HubVersion)
    print("Author: " .. HubAuthor)
    print(string.rep("=", 50) .. "\n")
    
    -- Load modules in order of dependency
    print("[☢️ Hub] Loading modules...")
    
    Utilities = LoadModule(script:WaitForChild("modules"):WaitForChild("utilities"), "Utilities")
    if not Utilities then return false end
    
    Config = LoadModule(script:WaitForChild("modules"):WaitForChild("config"), "Config")
    if not Config then return false end
    
    Universal = LoadModule(script:WaitForChild("modules"):WaitForChild("universal"), "Universal")
    if not Universal then return false end
    
    ESP = LoadModule(script:WaitForChild("modules"):WaitForChild("esp"), "ESP")
    if not ESP then return false end
    
    UI = LoadModule(script:WaitForChild("modules"):WaitForChild("ui"), "UI")
    if not UI then return false end
    
    print("\n[☢️ Hub] All modules loaded successfully!\n")
    return true
end

-- ============================================================================
-- FEATURE MANAGEMENT
-- ============================================================================

local FeatureStates = {
    Fly = false,
    Noclip = false,
    WalkSpeed = false,
    JumpPower = false,
    GodMode = false,
    InfiniteStamina = false,
    ESP = false,
}

--[[
    Updates feature state based on config
]]
local function UpdateFeatureStates()
    if Universal then
        if FeatureStates.Fly ~= Config.Features.Fly.Enabled then
            FeatureStates.Fly = Config.Features.Fly.Enabled
            Universal:SetFly(FeatureStates.Fly)
        end
        
        if FeatureStates.Noclip ~= Config.Features.Noclip.Enabled then
            FeatureStates.Noclip = Config.Features.Noclip.Enabled
            Universal:SetNoclip(FeatureStates.Noclip)
        end
        
        if FeatureStates.WalkSpeed ~= Config.Features.WalkSpeed.Enabled then
            FeatureStates.WalkSpeed = Config.Features.WalkSpeed.Enabled
            Universal:SetWalkSpeed(FeatureStates.WalkSpeed)
        end
        
        if FeatureStates.JumpPower ~= Config.Features.JumpPower.Enabled then
            FeatureStates.JumpPower = Config.Features.JumpPower.Enabled
            Universal:SetJumpPower(FeatureStates.JumpPower)
        end
        
        if FeatureStates.GodMode ~= Config.Features.GodMode.Enabled then
            FeatureStates.GodMode = Config.Features.GodMode.Enabled
            Universal:SetGodMode(FeatureStates.GodMode)
        end
        
        if FeatureStates.InfiniteStamina ~= Config.Features.InfiniteStamina.Enabled then
            FeatureStates.InfiniteStamina = Config.Features.InfiniteStamina.Enabled
            Universal:SetInfiniteStamina(FeatureStates.InfiniteStamina)
        end
    end
    
    if ESP then
        if FeatureStates.ESP ~= Config.ESP.Enabled then
            FeatureStates.ESP = Config.ESP.Enabled
            ESP:SetEnabled(FeatureStates.ESP)
        end
    end
end

-- ============================================================================
-- KEYBIND HANDLING
-- ============================================================================

--[[
    Sets up global keybind listeners
]]
local function SetupKeybinds()
    print("[☢️ Hub] Setting up keybinds...")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Fly toggle (F key)
        if input.KeyCode == Enum.KeyCode.F then
            Config.Features.Fly.Enabled = not Config.Features.Fly.Enabled
            UpdateFeatureStates()
        end
        
        -- Noclip toggle (X key)
        if input.KeyCode == Enum.KeyCode.X then
            Config.Features.Noclip.Enabled = not Config.Features.Noclip.Enabled
            UpdateFeatureStates()
        end
        
        -- God Mode toggle (Z key)
        if input.KeyCode == Enum.KeyCode.Z then
            Config.Features.GodMode.Enabled = not Config.Features.GodMode.Enabled
            UpdateFeatureStates()
        end
        
        -- ESP toggle (E key)
        if input.KeyCode == Enum.KeyCode.E then
            Config.ESP.Enabled = not Config.ESP.Enabled
            UpdateFeatureStates()
        end
        
        -- Unload hub (Delete key)
        if input.KeyCode == Enum.KeyCode.Delete then
            UnloadHub()
        end
    end)
    
    print("[☢️ Hub] Keybinds initialized")
end

-- ============================================================================
-- UI INITIALIZATION
-- ============================================================================

--[[
    Initializes the UI system
    
    @return boolean - Success status
]]
local function InitializeUI()
    print("[☢️ Hub] Initializing UI...")
    
    if not UI then
        warn("[☢️ Hub] UI module not loaded")
        return false
    end
    
    local success = pcall(function()
        return UI:Init()
    end)
    
    if success then
        print("[☢️ Hub] UI initialized successfully")
        return true
    else
        warn("[☢️ Hub] Failed to initialize UI")
        return false
    end
end

-- ============================================================================
-- CLEANUP & UNLOAD
-- ============================================================================

--[[
    Main cleanup function
]]
local function Cleanup()
    print("[☢️ Hub] Performing cleanup...")
    
    -- Disable all features
    if Universal then
        pcall(function()
            Universal:Cleanup()
        end)
    end
    
    -- Clear ESP
    if ESP then
        pcall(function()
            ESP:Cleanup()
        end)
    end
    
    print("[☢️ Hub] Cleanup complete")
end

--[[
    Unloads the entire hub
]]
function UnloadHub()
    print("\n[☢️ Hub] Unloading Uranium Hub...")
    Cleanup()
    print("[☢️ Hub] Hub unloaded successfully\n")
    
    -- Disconnect all connections
    if _G.UraniumConnections then
        for _, connection in ipairs(_G.UraniumConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        _G.UraniumConnections = nil
    end
    
    -- Signal completion
    if _G.UraniumHub then
        _G.UraniumHub = nil
    end
end

-- ============================================================================
-- FEATURE UPDATE LOOP
-- ============================================================================

--[[
    Creates the main update loop
]]
local function CreateUpdateLoop()
    print("[☢️ Hub] Starting feature update loop...")
    
    local updateConnection = RunService.Heartbeat:Connect(function()
        -- Update feature states every frame
        UpdateFeatureStates()
    end)
    
    if not _G.UraniumConnections then
        _G.UraniumConnections = {}
    end
    
    table.insert(_G.UraniumConnections, updateConnection)
    print("[☢️ Hub] Update loop started")
end

-- ============================================================================
-- LOADING SCREEN
-- ============================================================================

--[[
    Shows a simple loading screen
    
    @param duration number - Duration in seconds
]]
local function ShowLoadingScreen(duration)
    duration = duration or 3
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UraniumLoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Background
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.7
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Parent = screenGui
    
    -- Loading container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.Size = UDim2.new(0, 300, 0, 150)
    container.Position = UDim2.new(0.5, -150, 0.5, -75)
    container.Parent = screenGui
    
    -- Corner radius effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(255, 193, 7)
    title.Font = Enum.Font.GothamBold
    title.Text = "☢️ URANIUM HUB"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.Parent = container
    
    -- Loading text
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.BackgroundTransparency = 1
    loadingText.TextSize = 14
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.Gotham
    loadingText.Text = "Loading v" .. HubVersion .. "..."
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 55)
    loadingText.Parent = container
    
    -- Version
    local versionText = Instance.new("TextLabel")
    versionText.Name = "VersionText"
    versionText.BackgroundTransparency = 1
    versionText.TextSize = 11
    versionText.TextColor3 = Color3.fromRGB(150, 150, 150)
    versionText.Font = Enum.Font.Gotham
    versionText.Text = "Made with ☢️ for Roblox"
    versionText.Size = UDim2.new(1, 0, 0, 20)
    versionText.Position = UDim2.new(0, 0, 0, 85)
    versionText.Parent = container
    
    -- Wait and fade out
    task.wait(duration)
    
    -- Fade out animation
    for i = 1, 10 do
        background.BackgroundTransparency = 0.7 + (i / 10) * 0.3
        screenGui:FindFirstChild("Container").BackgroundColor3 = Color3.fromRGB(
            45 + (i / 10) * 210,
            45 + (i / 10) * 210,
            45 + (i / 10) * 210
        )
        task.wait(0.05)
    end
    
    screenGui:Destroy()
end

-- ============================================================================
-- MAIN STARTUP
-- ============================================================================

--[[
    Main initialization function
]]
local function Main()
    -- Show loading screen
    task.spawn(function()
        ShowLoadingScreen(2)
    end)
    
    -- Initialize all modules
    if not InitializeHub() then
        warn("[☢️ Hub] Failed to initialize hub modules")
        return
    end
    
    -- Initialize ESP first (needs Drawing library check)
    if ESP then
        if not ESP:Init() then
            warn("[☢️ Hub] ESP module failed to initialize")
        end
    end
    
    -- Setup keybinds
    SetupKeybinds()
    
    -- Create update loop
    CreateUpdateLoop()
    
    -- Initialize UI
    InitializeUI()
    
    -- Store reference globally
    _G.UraniumHub = {
        Version = HubVersion,
        Author = HubAuthor,
        LoadedAt = LastUpdated,
        IsRunning = true,
        Unload = UnloadHub,
    }
    
    print("\n" .. string.rep("=", 50))
    print("☢️ URANIUM HUB LOADED SUCCESSFULLY")
    print("Version: " .. HubVersion)
    print("Type: UnloadHub() to unload")
    print("Press Delete to unload via keybind")
    print(string.rep("=", 50) .. "\n")
    
    Utilities:Notify("Uranium Hub", "Loaded successfully! Press Delete to unload.", 5)
end

-- ============================================================================
-- ERROR HANDLING & SAFETY
-- ============================================================================

local success, error_message = pcall(function()
    Main()
end)

if not success then
    warn("[☢️ Hub] FATAL ERROR DURING INITIALIZATION:")
    print(error_message)
    print("\nPlease report this error on the GitHub repository.")
    if Utilities then
        Utilities:Notify("Error", "Failed to load hub. Check console for details.", 10)
    end
end

-- ============================================================================
-- CLEANUP ON PLAYER LEAVE
-- ============================================================================

Players.LocalPlayer:Attribute:Changed:Connect(function()
    -- If player leaves, unload hub
    if not Players:FindFirstChild(LocalPlayer.Name) then
        Cleanup()
    end
end)

-- ============================================================================
-- INFINITE LOOP PROTECTION
-- ============================================================================

-- Ensure script can be stopped
print("[☢️ Hub] Type: UnloadHub() to unload the hub")
print("[☢️ Hub] Or press Delete key to unload")

return "Uranium Hub Loaded"
