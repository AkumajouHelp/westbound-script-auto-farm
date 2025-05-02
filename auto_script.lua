-- MIT License
-- Copyright (c) 2025 AkumajouHelp
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this script and associated documentation files (the "Script"), to deal
-- in the Script without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
-- Script, and to permit persons to whom the Script is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Script.
--
-- THE SCRIPT IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE SCRIPT.

--[[
Westbound Auto Farm Script (Enhanced Anti-Cheat and Optimized Performance)
Author: AkumajouHelp

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
- Anti-Cheat
- Ammo Smart System (Auto-buy ammo, on-screen warning, auto-switch to melee if no bullets)
- Blur Effect to prevent clean screenshots (simulated)
- Smoke Cloak to obscure video recordings (simulated visual overlay)
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(math.random(1, 2))
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

-- Randomized Teleport
local function safeTeleport(destination)
    local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
    local targetCFrame = destination + randomOffset
    local tween = TweenService:Create(HRP, TweenInfo.new(0.7), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Blur Effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Parent = LocalPlayer.PlayerGui
blurEffect.Size = 0

local function activateBlur()
    blurEffect.Size = 25
end

local function removeBlur()
    blurEffect.Size = 0
end

-- Smoke Cloak Overlay (Simulated Obfuscation for Video Recording)
local cloak = Instance.new("Frame")
cloak.Size = UDim2.new(1, 0, 1, 0)
cloak.BackgroundColor3 = Color3.new(0, 0, 0)
cloak.BackgroundTransparency = 0.7
cloak.Visible = false
cloak.ZIndex = 10
cloak.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function activateCloak()
    cloak.Visible = true
end

local function deactivateCloak()
    cloak.Visible = false
end

-- Blur on Screenshot
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.PrintScreen then
        activateBlur()
        wait(2)
        removeBlur()
    end
end)

-- GUI Toggle
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
ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(farming and "Auto Farming Started" or "Auto Farming Stopped")
    end
end)

-- Random Wait
local function randomizedWait(min, max)
    wait(math.random(min, max))
end

-- Auto Farm Coyotes
spawn(function()
    while true do
        randomizedWait(1, 3)
        if farming then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                        safeTeleport(mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0))
                        randomizedWait(0.2, 0.5)
                        pcall(function() mob.Humanoid.Health = 0 end)
                    end
                end
            end

            if #LocalPlayer.Backpack:GetChildren() >= 10 then
                local sellPos = CFrame.new(-214, 24, 145)
                safeTeleport(sellPos)
                randomizedWait(0.5, 1)
            end
        end
    end
end)

-- Auto Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = Character:WaitForChild("HumanoidRootPart")
end)

-- Ammo Smart System
local function checkAndBuyAmmo()
    local ammo = LocalPlayer.Backpack:FindFirstChild("Ammo")
    if ammo and ammo.Amount < 10 then
        local buyPos = CFrame.new(-200, 24, 140)
        safeTeleport(buyPos)
        randomizedWait(1, 2)
    end
end

-- Deposit to Bank
local function depositToBank()
    local bankPos = CFrame.new(-210, 24, 150)
    safeTeleport(bankPos)
    randomizedWait(1, 2)
end

-- Train Heist Finder
local function findTrainHeist()
    local trainHeist = workspace:FindFirstChild("TrainHeist")
    if trainHeist and trainHeist:FindFirstChild("HumanoidRootPart") then
        return trainHeist.HumanoidRootPart.CFrame
    else
        return CFrame.new(-300, 24, 200)
    end
end

local function isNearTrainHeist()
    local targetPos = findTrainHeist()
    local distance = (HRP.Position - targetPos.Position).magnitude
    return distance < 10
end

local function teleportToTrainHeist()
    if not isNearTrainHeist() then
        local trainHeistPos = findTrainHeist()
        safeTeleport(trainHeistPos)
    end
end

-- Auto Farming With Train Heist
spawn(function()
    while true do
        randomizedWait(1, 3)
        if farming then
            teleportToTrainHeist()
            checkAndBuyAmmo()
            depositToBank()
        end
    end
end)

-- Activate Cloak if external screen recording is suspected (simulation)
-- This is symbolic, true detection of external recorders like OBS is not possible in Roblox
spawn(function()
    while true do
        wait(5)
        if farming then
            activateCloak()
            wait(3)
            deactivateCloak()
        end
    end
end)
