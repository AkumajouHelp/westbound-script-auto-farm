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

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Logging Function for Developer Debugging
local function log(message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("[%s] %s", timestamp, message))
end

-- Real-Time Monitoring (can be replaced with actual monitoring systems)
local function monitorFarmStatus()
    if farming then
        log("Auto-farming is active.")
    else
        log("Auto-farming is paused.")
    end
end

-- Error Handling and Debugging
local function handleError(errorMessage)
    log("Error occurred: " .. errorMessage)
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    -- Simulate mouse movement to prevent AFK kick
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(math.random(1, 2))
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

-- Randomized Teleport Function
local function safeTeleport(destination)
    -- Add monitoring and logging before and after teleportation
    log("Attempting teleport to: " .. tostring(destination))
    local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
    local targetCFrame = destination + randomOffset
    local tween = TweenService:Create(HRP, TweenInfo.new(0.7), {CFrame = targetCFrame})

    -- Wrap the teleportation call in a pcall for error handling
    local success, errorMessage = pcall(function()
        tween:Play()
        tween.Completed:Wait()
    end)

    if success then
        log("Teleport successful.")
    else
        handleError(errorMessage)
    end
end

-- Add Screen Blur Effect for Screenshot Prevention
local blurEffect = Instance.new("BlurEffect")
blurEffect.Parent = LocalPlayer.PlayerGui
blurEffect.Size = 0  -- Start with no blur

local function activateBlur()
    blurEffect.Size = 25  -- You can adjust the intensity of the blur
end

local function removeBlur()
    blurEffect.Size = 0
end

-- Function to activate the blur effect
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.PrintScreen then
        -- Activate blur when the screenshot button is pressed
        activateBlur()
        wait(2)  -- Keep the blur effect for 2 seconds
        removeBlur()
    end
end)

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
ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender)
    if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then
        farming = not farming
        toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        -- Chat notification when toggling farming state
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(farming and "Auto Farming Started" or "Auto Farming Stopped")
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
                local sellPos = CFrame.new(-214, 24, 145)  -- Update with your store coordinates
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

-- Ammo Smart System
local function checkAndBuyAmmo()
    log("Checking ammo levels...")
    local ammo = LocalPlayer.Backpack:FindFirstChild("Ammo")
    if ammo and ammo.Amount < 10 then
        log("Ammo is low, initiating purchase")
        -- Add the code to buy ammo
    end
end

-- Instant Deposit to Bank
local function depositToBank()
    local bankPos = CFrame.new(-210, 24, 150) -- Update with your bank coordinates
    safeTeleport(bankPos)
    randomizedWait(1, 2)
    -- Assuming deposit action can be triggered here
    -- depositMethod()
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
    return distance < 10  -- You can adjust this threshold
end

local function teleportToTrainHeist()
    if not isNearTrainHeist() then
        local trainHeistPos = findTrainHeist()
        safeTeleport(trainHeistPos)  -- Teleports to the train heist position
    else
        log("Already at the train heist!")
    end
end

-- Auto-farming with train heist check
spawn(function()
    while true do
        randomizedWait(1, 3)
        if farming then
            -- Check if near train heist, and teleport if not
            teleportToTrainHeist()

            -- Auto-sell items when near the store
            autoSellItems()

            -- Check and buy ammo if needed
            checkAndBuyAmmo()

            -- Deposit to bank if needed
            depositToBank()
        end
    end
end)
