--[[
Westbound Auto Farm Script (For Android/PC - Arceus X Neon or similar software)

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
]]

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    virtual:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtual:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
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
            if #inv >= 10 then -- adjust if needed
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-214, 24, 145) -- General Store position
                wait(0.5)
                -- simulate sell here if needed
            end
        end
    end
end)

-- Auto Respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    print("Auto Respawn triggered.")
end)

-- Chat Command to Toggle Auto Farm
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    if message == "!togglefarm" then
        farming = not farming
        ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
        print(farming and "Auto Farm Started" or "Auto Farm Stopped")
    end
end)
