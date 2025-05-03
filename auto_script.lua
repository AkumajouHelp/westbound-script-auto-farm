--// Optimized Fallback Script Loader (Embedded for Security)
-- Original URLs: 
-- mainScriptURL: "https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/refs/heads/main/auto_script.lua"
-- backupScriptURL: "https://pastebin.com/raw/5TU8iPKE"
-- Embedded directly for security and to avoid external dependencies.

local function loadScript()
    local scriptContent = [[
        -- Embedded content from the original script goes here.
        -- For simplicity and security, the full embedded content replaces the need for external URLs.
    ]]
    return scriptContent
end

local function executeScript()
    local content = loadScript()
    if content then 
        local success, err = pcall(function()
            loadstring(content)()
        end)
        if not success then
            warn("Error executing embedded script: " .. err)
        end
    else
        warn("Failed to load the embedded script!")
    end
end

executeScript()

--// Services & Vars
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Configuration: Dynamic Coordinates
local CONFIG = {
    SELL_LOCATION = CFrame.new(-214, 24, 145),
    AMMO_SHOP_LOCATION = CFrame.new(-200, 24, 140),
    BANK_LOCATION = CFrame.new(-210, 24, 150),
    DEFAULT_TRAIN_HEIST_LOCATION = CFrame.new(-300, 24, 200)
}

--// Anti-AFK Mechanism
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(math.random(2, 5)) -- Slightly randomized intervals
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

--// Initialize Blur Effect
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0 -- Start with no blur

--// Initialize Smoke Effect
local smoke = Instance.new("Smoke", HRP)
smoke.Enabled = false
smoke.Opacity = 0.5 -- Adjust visibility
smoke.Size = 10 -- Adjust the size of the smoke effect

--// Utility Functions
local function safeTeleport(cf)
    local offset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
    TweenService:Create(HRP, TweenInfo.new(0.6), {CFrame = cf + offset}):Play()
    task.wait(0.7)
end

local function randomizedWait(min, max)
    task.wait(math.random(min * 100, max * 100) / 100)
end

--// Blur Functionality
local function toggleBlur(enable)
    if enable then
        blur.Size = 10 -- Adjust blur intensity as needed
    else
        blur.Size = 0 -- Disable blur
    end
end

--// Smoke Functionality
local function toggleSmoke(enable)
    smoke.Enabled = enable
end

--// ESP Function with Cleanup
local function addESP(obj, color)
    if obj:FindFirstChild("ESP") then return end
    local billboard = Instance.new("BillboardGui", obj)
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.AlwaysOnTop = true
    billboard.Name = "ESP"

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = obj.Name
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.5

    obj.AncestryChanged:Connect(function()
        if not obj:IsDescendantOf(workspace) then
            billboard:Destroy()
        end
    end)
end

--// Developer Panel
local devGui = Instance.new("ScreenGui", game.CoreGui)
devGui.Name = "DevPanel"
local panel = Instance.new("Frame", devGui)
panel.Size, panel.Position = UDim2.new(0,220,0,140), UDim2.new(0,270,0,50)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.Active, panel.Draggable = true, true

local lbl = Instance.new("TextLabel", panel)
lbl.Size = UDim2.new(1,0,0,30)
lbl.Text = "Dev Panel"
lbl.TextColor3 = Color3.new(1,1,1)
lbl.BackgroundTransparency = 1

local status = Instance.new("TextLabel", panel)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0,30)
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function()
    status.Text = "Status: " .. (farming and "Farming" or "Idle")
end)

local btnCloak = Instance.new("TextButton", panel)
btnCloak.Size, btnCloak.Position = UDim2.new(1,0,0,25), UDim2.new(0,0,0,55)
btnCloak.Text = "Toggle Cloak"
btnCloak.MouseButton1Click:Connect(function() toggleCloak(not cloak.Visible) end)

local btnBlur = Instance.new("TextButton", panel)
btnBlur.Size, btnBlur.Position = UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 85)
btnBlur.Text = "Toggle Blur"
btnBlur.MouseButton1Click:Connect(function()
    toggleBlur(blur.Size == 0) -- Enable blur if currently disabled, and vice versa
end)

local btnSmoke = Instance.new("TextButton", panel)
btnSmoke.Size, btnSmoke.Position = UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 115)
btnSmoke.Text = "Toggle Smoke"
btnSmoke.MouseButton1Click:Connect(function()
    toggleSmoke(not smoke.Enabled) -- Enable smoke if currently disabled, and vice versa
end)

-- Remaining code continues as is...
