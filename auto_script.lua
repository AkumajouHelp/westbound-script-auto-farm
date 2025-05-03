--// Fallback Script Loader (GitHub > Pastebin)
local mainScriptURL = "https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/refs/heads/main/auto_script.lua"
local backupScriptURL = "https://pastebin.com/raw/5TU8iPKE"

local function loadScript(url)
    local success, result = pcall(function()
        return game:GetService("HttpService"):GetAsync(url)
    end)
    if success then return result else warn("Failed to load: " .. url) return nil end
end

local function loadScriptWithFallback()
    local content = loadScript(mainScriptURL) or loadScript(backupScriptURL)
    if content then loadstring(content)() else error("Failed to load from both sources!") end
end

loadScriptWithFallback()

--// Services & Vars
local Players, TweenService, RunService, ReplicatedStorage = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("ReplicatedStorage")
local VirtualInputManager, UserInputService, LocalPlayer = game:GetService("VirtualInputManager"), game:GetService("UserInputService"), Players.LocalPlayer
local Character, HRP = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(), nil
repeat HRP = Character:FindFirstChild("HumanoidRootPart") task.wait() until HRP
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(math.random(1, 2))
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

--// Utility
local function safeTeleport(cf)
    local offset = Vector3.new(math.random(-2,2), 0, math.random(-2,2))
    TweenService:Create(HRP, TweenInfo.new(0.6), {CFrame = cf + offset}):Play()
    task.wait(0.7)
end

local function randomizedWait(min, max)
    task.wait(math.random(min * 100, max * 100) / 100)
end

--// Visual Cloak + Blur
local blur = Instance.new("BlurEffect", PlayerGui)
blur.Size = 0
local function toggleBlur(on) blur.Size = on and 25 or 0 end

local cloak = Instance.new("Frame", PlayerGui)
cloak.Size = UDim2.new(1,0,1,0)
cloak.BackgroundColor3 = Color3.new(0,0,0)
cloak.BackgroundTransparency = 0.7
cloak.Visible = false
cloak.ZIndex = 10
local function toggleCloak(on) cloak.Visible = on end

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.PrintScreen then
        toggleBlur(true)
        task.wait(2)
        toggleBlur(false)
    end
end)

--// GUI Toggle
local gui = Instance.new("ScreenGui", game.CoreGui)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size, toggleBtn.Position = UDim2.new(0, 200, 0, 50), UDim2.new(0, 50, 0, 50)
toggleBtn.Text, toggleBtn.BackgroundColor3 = "Start Auto Farm", Color3.fromRGB(0,170,255)

local farming = false
toggleBtn.MouseButton1Click:Connect(function()
    farming = not farming
    toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
end)

ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    end
end)

--// ESP Function
local function addESP(obj, color)
    local billboard = Instance.new("BillboardGui", obj)
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = obj.Name
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.5
end

--// Equip Best Weapon
local function autoEquip()
    local best = nil
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (not best or tool.Name:lower():find("rifle") or tool.Name:lower():find("shotgun")) then
            best = tool
        end
    end
    if best then best.Parent = Character end
end

--// Auto Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character, HRP = char, char:WaitForChild("HumanoidRootPart")
end)

--// Auto Farm Coyotes (Kill Aura)
spawn(function()
    while task.wait(2) do
        if farming then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if not mob:FindFirstChild("ESP") then addESP(mob, Color3.new(1, 0, 0)) end
                        safeTeleport(mob.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
                        autoEquip()
                        for i = 1, 5 do
                            pcall(function() mob.Humanoid:TakeDamage(25) end)
                            task.wait(0.1)
                        end
                    end
                end
            end
            if #LocalPlayer.Backpack:GetChildren() >= 10 then
                safeTeleport(CFrame.new(-214,24,145)) -- Sell location
                randomizedWait(0.5, 1)
            end
        end
    end
end)

--// Bank & Ammo & Train
local function checkAndBuyAmmo()
    if LocalPlayer.Backpack:FindFirstChild("Ammo") then
        safeTeleport(CFrame.new(-200,24,140)) -- Ammo Shop
        randomizedWait(1,2)
    end
end

local function depositToBank()
    safeTeleport(CFrame.new(-210,24,150))
    randomizedWait(1,2)
end

local function getTrainHeistPos()
    local train = workspace:FindFirstChild("TrainHeist")
    if train and train:FindFirstChild("HumanoidRootPart") then
        if not train:FindFirstChild("ESP") then addESP(train, Color3.new(0,1,0)) end
        return train.HumanoidRootPart.CFrame
    end
    return CFrame.new(-300,24,200)
end

local function teleportToTrainHeist()
    local cf = getTrainHeistPos()
    if (HRP.Position - cf.Position).Magnitude > 10 then
        safeTeleport(cf)
    end
end

spawn(function()
    while task.wait(2) do
        if farming then
            teleportToTrainHeist()
            checkAndBuyAmmo()
            depositToBank()
        end
    end
end)

--// Visual Cloak Simulation
spawn(function()
    while task.wait(5) do
        if farming then
            toggleCloak(true)
            task.wait(2.5)
            toggleCloak(false)
        end
    end
end)

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
btnBlur.Size, btnBlur.Position = UDim2.new(1,0,0,25), UDim2.new(0,0,0,85)
btnBlur.Text = "Toggle Blur"
btnBlur.MouseButton1Click:Connect(function() toggleBlur(blur.Size == 0) end)

local btnTPBank = Instance.new("TextButton", panel)
btnTPBank.Size, btnTPBank.Position = UDim2.new(1,0,0,25), UDim2.new(0,0,0,115)
btnTPBank.Text = "Teleport to Bank"
btnTPBank.MouseButton1Click:Connect(function() safeTeleport(CFrame.new(-210,24,150)) end)
