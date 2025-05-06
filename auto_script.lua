--// Westbound Auto Farm Script (Fixed & Optimized)
local player = game.Players.LocalPlayer
local char, hrp

-- Update character & HumanoidRootPart on spawn/respawn
local function updateCharacter()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end
updateCharacter()

player.CharacterAdded:Connect(function()
    updateCharacter()
    if bestWeapon then
        task.wait(1)
        char:WaitForChild("Humanoid"):EquipTool(bestWeapon)
    end
end)

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Start Auto Farm"
toggleButton.BackgroundColor3 = Color3.new(0, 0.6, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold

-- Vars
local farming = false
local bestWeapon = nil
local killAuraRange = 20
local respawnTimer = 0

local animals = workspace:WaitForChild("Animals")
local coyotes = animals:FindFirstChild("Coyotes")
local sellingPoint = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("SellPoint")

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Best Weapon Selector
local function selectBestWeapon()
    local inventory = player:WaitForChild("Backpack")
    local bestDamage = 0

    for _, tool in pairs(inventory:GetChildren()) do
        if tool:IsA("Tool") then
            local stats = tool:FindFirstChild("Stats")
            if stats and stats:FindFirstChild("Damage") then
                local dmg = stats.Damage.Value
                if dmg > bestDamage then
                    bestDamage = dmg
                    bestWeapon = tool
                end
            end
        end
    end

    if bestWeapon then
        char:WaitForChild("Humanoid"):EquipTool(bestWeapon)
    end
end

-- Kill Aura
local function killNearbyEnemies()
    for _, model in pairs(workspace:GetChildren()) do
        if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= char then
            local distance = (hrp.Position - model.HumanoidRootPart.Position).Magnitude
            if distance <= killAuraRange then
                model.Humanoid.Health = 0
            end
        end
    end
end

-- Auto Sell
local function autoSell()
    if sellingPoint and (hrp.Position - sellingPoint.Position).Magnitude < 20 then
        local prompt = sellingPoint:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            fireproximityprompt(prompt)
        end
    end
end

-- Auto Farm Loop
local function autoFarm()
    while farming do
        task.wait(0.5)

        if not hrp or not char then
            updateCharacter()
        end

        -- Equip best weapon if not equipped
        if not bestWeapon or not bestWeapon.Parent then
            selectBestWeapon()
        end

        -- Attack Coyotes
        if coyotes then
            for _, coyote in pairs(coyotes:GetChildren()) do
                if coyote:FindFirstChild("Humanoid") and coyote:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = coyote.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    task.wait(0.2)
                    coyote.Humanoid.Health = 0
                end
            end
        end

        -- Sell items if near merchant
        autoSell()

        -- Kill aura around player
        killNearbyEnemies()

        -- Coyote respawn delay (simulate)
        if tick() > respawnTimer then
            respawnTimer = tick() + 10
        end
    end
end

-- Toggle Button
toggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    toggleButton.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    toggleButton.BackgroundColor3 = farming and Color3.new(0.6, 0, 0) or Color3.new(0, 0.6, 0)

    if farming then
        coroutine.wrap(autoFarm)()
    end
end)
