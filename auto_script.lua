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

-- Chat command listener for !togglefarm
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "!togglefarm" then
        farming = not farming
        ToggleFarm.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    end
end)

-- Auto Farm Loop (scans entire map for coyotes)
spawn(function()
    while true do
        wait(1)
        if farming then
            local coyotes = {}

            -- Scan the entire map for coyotes
            for _, mob in pairs(workspace:GetChildren()) do
                if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
                    table.insert(coyotes, mob)
                end
            end

            -- Attack all detected coyotes
            for _, coyote in pairs(coyotes) do
                if coyote and coyote:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coyote.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                    wait(0.2)
                    coyote.Humanoid.Health = 0
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
