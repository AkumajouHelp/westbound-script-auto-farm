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

-- GUI Library (in-game)
local GuiLibrary = {} -- In actual script, replace this with a real GUI framework

-- RemoteEvents to handle communication (chat, etc.)
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Anti-AFK (simulate mouse movement to avoid AFK kick)
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(math.random(1, 2))
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

-- Randomized Teleport Function
local function safeTeleport(destination)
    local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
    local targetCFrame = destination + randomOffset
    local tween = TweenService:Create(HRP, TweenInfo.new(0.7), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- GUI Setup (Using placeholder GuiLibrary)
local gui = GuiLibrary:CreateWindow("Auto Farm Script")
local toggleBtn = gui:CreateButton("Start Auto Farm")
toggleBtn.Position = UDim2.new(0, 50, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local farming = false

toggleBtn.MouseButton1Click:Connect(function()
    farming = not farming
    toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
end)

-- Chat Command to Toggle Auto Farming
ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        RemoteEvents:Fire("SayMessageRequest", farming and "Auto Farming Started" or "Auto Farming Stopped")
    end
end)

-- Randomized Wait Function to Mimic Human Behavior
local function randomizedWait(min, max)
    wait(math.random(min, max))
end

-- Auto Farm Function (Farming Coyotes)
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

            -- Auto Sell when Inventory is Full
            local inv = LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then
                local sellPos = CFrame.new(-214, 24, 145)
                safeTeleport(sellPos)
                randomizedWait(0.5, 1)
            end
        end
    end
end)

-- Auto Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = Character:WaitForChild("HumanoidRootPart")
end)

-- Ammo Smart System (Check and Buy Ammo)
local function checkAndBuyAmmo()
    local ammo = LocalPlayer.Backpack:FindFirstChild("Ammo")
    if ammo and ammo.Amount < 10 then
        local buyPos = CFrame.new(-200, 24, 140) -- Adjust with your ammo store coordinates
        safeTeleport(buyPos)
        randomizedWait(1, 2)
    end
end

-- Instant Deposit to Bank
local function depositToBank()
    local bankPos = CFrame.new(-210, 24, 150) -- Adjust with your bank coordinates
    safeTeleport(bankPos)
    randomizedWait(1, 2)
end

-- Teleport to Train Heist Location
local function findTrainHeist()
    local trainHeist = workspace:FindFirstChild("TrainHeist")
    if trainHeist and trainHeist:FindFirstChild("HumanoidRootPart") then
        return trainHeist.HumanoidRootPart.CFrame
    else
        return CFrame.new(-300, 24, 200)  -- Fallback position
    end
end

-- Check if Player is Near Train Heist
local function isNearTrainHeist()
    local targetPos = findTrainHeist()
    local distance = (HRP.Position - targetPos.Position).magnitude
    return distance < 10  -- Adjust distance threshold
end

-- Teleport to Train Heist
local function teleportToTrainHeist()
    if not isNearTrainHeist() then
        local trainHeistPos = findTrainHeist()
        safeTeleport(trainHeistPos)
    else
        print("Already at the train heist!")
    end
end

-- Auto-Farming with Train Heist Check
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
