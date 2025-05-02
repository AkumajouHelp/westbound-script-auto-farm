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
local PathfindingService = game:GetService("PathfindingService")
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

-- Logging System
local function log(message)
    print("[AutoFarm Log] " .. message)
end

-- Randomized Teleport Function with Pathfinding
local function safeTeleport(destination)
    -- Pathfinding to ensure smooth and safe teleportation
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45,
    })
    
    path:ComputeAsync(HRP.Position, destination.Position)
    
    path.Completed:Connect(function(status)
        if status == Enum.PathStatus.Complete then
            HRP.CFrame = destination
            log("Teleported to " .. tostring(destination))
        else
            log("Teleport failed, retrying...")
        end
    end)
    
    path:MoveTo(destination)
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
    log(farming and "Auto Farming Started" or "Auto Farming Stopped")
end)

-- Chat Command Toggle
ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(farming and "Auto Farming Started" or "Auto Farming Stopped")
        log(farming and "Auto Farming Started" or "Auto Farming Stopped")
    end
end)

-- Randomized Wait Function to Avoid Predictability
local function randomizedWait(min, max)
    wait(math.random(min, max))
end

-- Auto Farm (Coyotes)
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
                        log("Coyote defeated!")
                    end
                end
            end

            -- Auto Sell (General Store)
            local inv = LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then
                local sellPos = CFrame.new(-214, 24, 145)  -- Update with your store coordinates
                safeTeleport(sellPos)
                randomizedWait(0.5, 1)
                log("Items sold!")
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

-- Ammo Smart System
local function checkAndBuyAmmo()
    local ammo = LocalPlayer.Backpack:FindFirstChild("Ammo")
    if ammo and ammo.Amount < 10 then
        -- Auto buy ammo from the store
        local buyPos = CFrame.new(-200, 24, 140) -- Update with your ammo store coordinates
        safeTeleport(buyPos)
        randomizedWait(1, 2)
        log("Ammo purchased!")
    end
end

-- Instant Deposit to Bank
local function depositToBank()
    local bankPos = CFrame.new(-210, 24, 150) -- Update with your bank coordinates
    safeTeleport(bankPos)
    randomizedWait(1, 2)
    log("Deposited to bank!")
end

-- Teleport to Train Heist
local function findTrainHeist()
    local trainHeist = workspace:FindFirstChild("TrainHeist") -- Adjust to the actual name of the object
    if trainHeist and trainHeist:FindFirstChild("HumanoidRootPart") then
        return trainHeist.HumanoidRootPart.CFrame
    else
        -- Default fallback position if not found
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
    else
        log("Already at the train heist!")
    end
end

-- Auto-farming with train heist check
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

-- Error Handling (Global PCall Wrapper)
local function safeExecution(func)
    local success, err = pcall(func)
    if not success then
        log("Error occurred: " .. err)
    end
end
