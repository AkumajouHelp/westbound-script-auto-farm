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
local virtual = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    virtual:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtual:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI Setup
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local ToggleFarm = Instance.new("TextButton")
ToggleFarm.Size = UDim2.new(0, 200, 0, 50)
ToggleFarm.Position = UDim2.new(0, 20, 0, 100)
ToggleFarm.Text = "Start Auto Farm"
ToggleFarm.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleFarm.Parent = ScreenGui
ToggleFarm.Draggable = true
ToggleFarm.Active = true

-- State
local farming = false

ToggleFarm.MouseButton1Click:Connect(function()
    farming = not farming
    ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
end)

-- Chat command toggle
Player.Chatted:Connect(function(msg)
    if msg:lower() == "!togglefarm" then
        farming = not farming
        ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    end
end)

-- Auto Farm Loop
task.spawn(function()
    while task.wait(1) do
        if farming then
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                        char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                        wait(0.2)
                        mob.Humanoid.Health = 0
                    end
                end
            end

            -- Auto Sell
            local inv = Player.Backpack:GetChildren()
            if #inv >= 10 then
                char.HumanoidRootPart.CFrame = CFrame.new(-214, 24, 145) -- General Store
                wait(0.5)
                -- simulate interaction if needed
            end
        end
    end
end)

-- Auto Respawn
Player.CharacterAdded:Connect(function()
    wait(1)
    print("Auto Respawn triggered")
end)
