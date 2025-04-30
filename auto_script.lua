--[[
Westbound Auto Farm Script (Fixed Fast Version 4)

This script automatically farms and sells in Westbound,
with GUI toggles to enable/disable each feature.

Features:
- Auto sell
- Auto farming
- Fast auto kill
- Faster selling
- Quicker teleporting
- Auto farm coyotes
- Auto sell at General Store
- Anti-AFK (stay in-game)
- Auto respawn
- Safe teleport
- GUI with buttons
- Low lag
- Teleport to Train Heist
- Instant Deposit to Bank

Purpose:
This script is created to automatically farm coyote coins and sell items in the game Westbound. 
It helps players grind faster, avoid manual effort, and earn money efficiently with minimal lag. 
Perfect for users on Android using Arceus X or similar software.

**APPLICATION:**
https://www.mediafire.com/file/p5s58u1u34da2rn/Roblox_Arceus_X_NEO_1.6.5.apk/file?dkey=vr8ys86usvq&r=1127

How to Use In Any Software:
Use it with any Roblox executor that supports loadstring and HttpGet, such as:
Arceus X, Arcexus, Delta, Hydrogen, Codex

How to Use In Android:
Use with Arceus X Neon. Paste the raw link in loadstring() and execute.

SCRIPT:
loadstring(game:HttpGet("https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/main/auto_script.lua"))()

Credits:
Script by AkumajouHelp.
Modified by Ryokun.
Contact: Discord: ryokun2337.
        Facebook: https://www.facebook.com/profile.php?id=100083718851963
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Anti-AFK
local antiAFK = true
spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        if antiAFK then
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- Safe teleport
local function safeTP(part)
    if part then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.5)
    end
end

-- Auto Farm
local autoFarm = false
local targets = {"Coyote", "Wolf", "Cougar"}

spawn(function()
    while task.wait(2) do
        if autoFarm then
            for _, v in pairs(workspace:GetDescendants()) do
                if table.find(targets, v.Name) and v:FindFirstChild("Humanoid") then
                    safeTP(v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildOfClass("BasePart"))
                    v.Humanoid.Health = 0
                    task.wait(0.2)
                end
            end
        end
    end
end)

-- Auto Sell
local autoSell = false
spawn(function()
    while task.wait(5) do
        if autoSell then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "General Store" and obj:IsA("Model") then
                    safeTP(obj:FindFirstChild("Part") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart"))
                    task.wait(1.5)
                end
            end
        end
    end
end)

-- Auto Respawn
local autoRespawn = true
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Train Teleport (Teleport to Train Heist)
local function teleportToTrain()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Train" and v:IsA("Model") then
            safeTP(v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart)
            task.wait(0.5)
        end
    end
end

-- Instant Deposit (Teleport to Bank and Deposit)
local function instantDeposit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Bank" and obj:IsA("Model") then
            safeTP(obj:FindFirstChild("Part") or obj.PrimaryPart)
            task.wait(1)
            -- Assume bank interaction happens here (like pressing E to deposit)
        end
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local function makeButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 30)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = ScreenGui
    btn.MouseButton1Click:Connect(callback)
end

makeButton("Toggle Auto Farm", UDim2.new(0, 20, 0, 100), function()
    autoFarm = not autoFarm
end)

makeButton("Toggle Auto Sell", UDim2.new(0, 20, 0, 140), function()
    autoSell = not autoSell
end)

makeButton("Toggle Anti-AFK", UDim2.new(0, 20, 0, 180), function()
    antiAFK = not antiAFK
end)

makeButton("Toggle Auto Respawn", UDim2.new(0, 20, 0, 220), function()
    autoRespawn = not autoRespawn
end)

makeButton("Teleport to Train", UDim2.new(0, 20, 0, 260), function()
    teleportToTrain()
end)

makeButton("Instant Deposit", UDim2.new(0, 20, 0, 300), function()
    instantDeposit()
end) clarifications!
