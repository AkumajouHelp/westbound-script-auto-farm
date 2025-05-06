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
    -- Close GUI on Death
    screenGui.Enabled = false
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

-- Ammo Management
local function manageAmmo()
    local inventory = player:WaitForChild("Backpack")
    for _, tool in pairs(inventory:GetChildren()) do
        if tool:IsA("Tool") then
            local ammo = tool:FindFirstChild("Ammo")
            if ammo and ammo.Value == 0 then
                -- Switch to another weapon if ammo is depleted
                selectBestWeapon()
                return
            end
        end
    end
end

-- ESP for Enemies
local function createESPForEnemy(enemy)
    local esp = Instance.new("BillboardGui")
    esp.Adornee = enemy
    esp.Parent = game.CoreGui
    esp.Size = UDim2.new(0, 100, 0, 100)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.AlwaysOnTop = true
    esp.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 100, 0, 20)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Text = enemy.Name
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextSize = 16
    textLabel.Parent = esp
end

-- Kill Aura
local function killNearbyEnemies()
    for _, model in pairs(workspace:GetChildren()) do
        if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= char then
            local distance = (hrp.Position - model.HumanoidRootPart.Position).Magnitude
            if distance <= killAuraRange then
                -- ESP for enemy
                createESPForEnemy(model)
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

-- Notification function
local function createNotification(message)
    local notification = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    local label = Instance.new("TextLabel", notification)
    label.Size = UDim2.new(0, 300, 0, 50)
    label.Position = UDim2.new(0.5, -150, 0, 20)
    label.Text = message
    label.TextSize = 24
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.new(1, 1, 1)

    -- Remove after a few seconds
    task.wait(3)
    notification:Destroy()
end

-- Smart Coyote Respawn Detection
local function trackCoyoteRespawn()
    local respawnedCoyotes = {}
    
    -- Detect coyotes that have been defeated and respawned
    for _, coyote in pairs(coyotes:GetChildren()) do
        if coyote:FindFirstChild("Humanoid") and coyote.Humanoid.Health <= 0 then
            if not respawnedCoyotes[coyote] then
                respawnedCoyotes[coyote] = tick()
            end
        end
    end
    
    -- Check if any respawned coyotes are back
    for coyote, respawnTime in pairs(respawnedCoyotes) do
        if tick() - respawnTime >= 10 then -- Adjust respawn time as needed
            respawnedCoyotes[coyote] = nil
            createNotification("Coyote Respawned!")
        end
    end
end

-- Auto Farm Loop
local function autoFarm()
    while farming do
        task.wait(0.5)

        -- Ammo Management
        manageAmmo()

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
                    createNotification("Coyote Defeated!")
                end
            end
        end

        -- Sell items if near merchant
        if sellingPoint and (hrp.Position - sellingPoint.Position).Magnitude < 20 then
            createNotification("Selling Items...")
            autoSell()
        end

        -- Kill aura around player
        killNearbyEnemies()

        -- Track Coyote Respawn
        trackCoyoteRespawn()
    end
end

-- Toggle Button
toggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    toggleButton.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    toggleButton.BackgroundColor3 = farming and Color3.new(0.6, 0, 0) or Color3.new(0, 0.6, 0)

    if farming then
        createNotification("Starting Auto Farm!")
        coroutine.wrap(autoFarm)()
    end
end)
