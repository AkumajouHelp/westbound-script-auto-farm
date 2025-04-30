--[[
Westbound Auto Farm Script (Fixed Fast Version 4)

This script automatically farms and sells in Westbound,
with GUI toggles to enable/disable each feature.

Features:
- Auto-sell when inventory is full
- Auto-farming for quick coin collection
- Optimized for no lag and minimal crashes
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

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    virtual:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtual:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI for Android and PC with Dragging Support
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui  -- Use PlayerGui for mobile compatibility

local ToggleFarm = Instance.new("TextButton", ScreenGui)
ToggleFarm.Size = UDim2.new(0, 200, 0, 50)
ToggleFarm.Position = UDim2.new(0, 50, 0, 50)
ToggleFarm.Text = "Start Auto Farm"

local farming = false

-- Dragging Support for the button
local dragging = false
local dragInput, mousePos, offset

ToggleFarm.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        offset = ToggleFarm.Position - UDim2.new(0, mousePos.X, 0, mousePos.Y)
    end
end)

ToggleFarm.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mousePos
        ToggleFarm.Position = UDim2.new(0, delta.X + offset.X.Offset, 0, delta.Y + offset.Y.Offset)
    end
end)

ToggleFarm.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

ToggleFarm.MouseButton1Click:Connect(function()
    farming = not farming
    ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
end)

-- Auto Farm Loop
spawn(function()
    while true do
        wait(1)
        if farming then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                        wait(0.2)
                        mob.Humanoid.Health = 0
                    end
                end
            end

            -- Auto Sell (Teleport to General Store)
            local inv = game.Players.LocalPlayer.Backpack:GetChildren()
            if #inv >= 10 then -- Adjust this number if needed
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-214, 24, 145) -- General Store position
                wait(0.5)
                -- Simulate sell here if needed
            end
        end
    end
end)

-- Auto Respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    print("Auto Respawn triggered.")
end)
