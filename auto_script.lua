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

-- Anti-AFK
local virtual = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    virtual:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtual:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Random Delay Function to simulate human behavior
local function randomDelay(min, max)
    wait(math.random(min, max))
end

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

-- Chat Command for Toggling Farm
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "!togglefarm" then
        farming = not farming
        ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        print("Farm toggled via chat:", farming)  -- Debug line
    end
end)

-- Auto Farm Loop with random delays and fake movement
spawn(function()
    while true do
        wait(1)
        if farming then
            print("Farming started.")  -- Debug line
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                        -- Add random delay before moving and attacking
                        randomDelay(0.5, 1.5)  -- Random delay between 0.5 and 1.5 seconds
                        
                        -- Fake random movement around the target to simulate human behavior
                        local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + randomOffset
                        wait(0.2)
                        
                        -- Add another random delay before attacking
                        randomDelay(0.2, 0.5)
                        
                        -- Attack the Coyote
                        mob.Humanoid.Health = 0
                    end
                end
            end

            -- Auto Sell (Teleport to General Store)
            local inv = game.Players.LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then -- adjust if needed
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-214, 24, 145) -- General Store position
                wait(0.5)
                -- Simulate selling items here (add more logic if necessary)
                print("Selling items at General Store")  -- Debug line
            end
        end
    end
end)

-- Auto Respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    print("Auto Respawn triggered.")  -- Debug line
end)
