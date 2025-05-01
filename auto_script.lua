-- MIT License
-- Copyright (c) 2025 AkumajouHelp
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this script and associated documentation files (the "Script"), to deal
-- in the Script without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Script, and to permit persons to whom the Script is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Script.
--
-- THE SCRIPT IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE
-- SCRIPT.

--[[
Westbound Auto Farm Script (Enhanced Anti-Cheat and Optimized Performance)
Author: AkumajouHelp

My Main Script Link Page:
https://github.com/AkumajouHelp/westbound-script-auto-farm

Features:
- Auto farm coyotes
- Auto sell when inventory full
- Fast auto kill
- Faster teleporting
- Low lag & safe teleports
- Anti-AFK
- Auto respawn
- GUI with toggle buttons
- Teleport to Train Heist
- Instant Deposit to Bank
- Chat command: !togglefarm
- Ammo Smart System:

1. Auto-buy ammo when low
2. On-screen warning when out of ammo
3. Auto-switch to melee if no bullets
]]

-- Function to load script from a URL
local function loadScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        return response
    else
        return nil
    end
end

-- First try Pastebin
local scriptContent = loadScript("https://pastebin.com/raw/5TU8iPKE")

-- If Pastebin fails, try GitHub
if not scriptContent then
    scriptContent = loadScript("https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/refs/heads/main/auto_script.lua")
end

-- If a script was successfully loaded, execute it
if scriptContent then
    loadstring(scriptContent)()
else
    warn("Failed to load the script from both sources.")
end

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    -- Simulate mouse movement to prevent AFK kick
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(math.random(1, 2))
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

-- Randomized Teleport Function
local function safeTeleport(destination)
    -- Adding slight randomization to teleportation to avoid detection
    local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
    local targetCFrame = destination + randomOffset
    local tween = TweenService:Create(HRP, TweenInfo.new(0.7), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- GUI for Toggle Button
local gui = Instance.new("ScreenGui", game.CoreGui)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 200, 0, 50)
toggleBtn.Position = UDim2.new(0, 50, 0, 50)
toggleBtn.Text = "Start Auto Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local farming = false

toggleBtn.MouseButton1Click:Connect(function()
    farming = not farming
    toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
end)

-- Chat Command Toggle
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    end
end)

-- Randomized Wait Function to Avoid Predictability
local function randomizedWait(min, max)
    wait(math.random(min, max))
end

-- Auto Farm (Coyotes)
spawn(function()
    while true do
        randomizedWait(1, 3)  -- Randomized wait to prevent predictable patterns
        if farming then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                        safeTeleport(mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0))
                        randomizedWait(0.2, 0.5)  -- Randomized delay to mimic human behavior
                        pcall(function() mob.Humanoid.Health = 0 end)
                    end
                end
            end

            -- Auto Sell (General Store)
            local inv = LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then
                local sellPos = CFrame.new(-214, 24, 145)
                safeTeleport(sellPos)
                randomizedWait(0.5, 1)  -- Random delay to mimic human-like action
            end
        end
    end
end)

-- Auto Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = Character:WaitForChild("HumanoidRootPart")
end)

-- Function to Simulate More Human-Like Input
local function simulateMouseMove()
    local mousePos = game:GetService("Workspace").CurrentCamera.CFrame.Position
    local targetPos = mousePos + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
    VirtualInputManager:SendMouseMoveEvent(mousePos.X, mousePos.Y, true)
    VirtualInputManager:SendMouseMoveEvent(targetPos.X, targetPos.Y, false)
end
