-- Simple Westbound Auto Farm Script for Arceus X Neon (Android Compatible)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

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
local coyotes = workspace:WaitForChild("Animals"):WaitForChild("Coyotes")
local sellingPoint = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("SellPoint")
local bestWeapon = nil -- This will be set by the weapon selection logic
local killAuraRange = 20 -- Range for kill aura (in studs)
local respawnTimer = 0

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Function to select the best weapon from the player's inventory
local function selectBestWeapon()
    local bestWeaponStats = nil

    -- Assuming the player's weapons are stored in an Inventory folder within the player
    local inventory = player:WaitForChild("Backpack") -- Change to your inventory folder if needed
    for _, item in pairs(inventory:GetChildren()) do
        -- Check if the item is a weapon (replace "Weapon" with your actual weapon name)
        if item:IsA("Tool") and item.Name == "Weapon" then
            local weaponStats = item:FindFirstChild("Stats") -- Assuming weapons have a "Stats" folder with damage value
            if weaponStats then
                local damage = weaponStats:FindFirstChild("Damage") and weaponStats.Damage.Value or 0
                if not bestWeaponStats or damage > bestWeaponStats.Damage then
                    bestWeaponStats = { Weapon = item, Damage = damage }
                end
            end
        end
    end

    -- If a best weapon was found, equip it
    if bestWeaponStats then
        bestWeapon = bestWeaponStats.Weapon
        player.Character.Humanoid:EquipTool(bestWeapon)
    end
end

-- Core Farming Logic
local function autoFarm()
    while farming do
        -- Auto Hunt Coyotes
        for _, coyote in pairs(coyotes:GetChildren()) do
            if coyote:FindFirstChild("HumanoidRootPart") and coyote:FindFirstChild("Humanoid") then
                hrp.CFrame = coyote.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                task.wait(0.1)
                coyote.Humanoid.Health = 0
            end
        end
        task.wait(1)

        -- Auto Sell when near merchant
        if sellingPoint and (hrp.Position - sellingPoint.Position).Magnitude < 20 then
            local proximityPrompt = sellingPoint:FindFirstChildOfClass("ProximityPrompt")
            if proximityPrompt then
                fireproximityprompt(proximityPrompt)
            end
        end

        -- Kill Aura: Auto kill enemies within a certain range
        for _, enemy in pairs(workspace:FindPartsInRegion3(hrp.Position - Vector3.new(killAuraRange, killAuraRange, killAuraRange), hrp.Position + Vector3.new(killAuraRange, killAuraRange, killAuraRange), nil)) do
            if enemy.Parent and enemy.Parent:FindFirstChild("Humanoid") then
                enemy.Parent.Humanoid.Health = 0
            end
        end

        -- Auto Equip Best Weapon (if not equipped already)
        if not bestWeapon then
            selectBestWeapon()
        end

        -- Respawn Tracker (track when coyotes respawn)
        if respawnTimer <= tick() then
            respawnTimer = tick() + 10 -- 10 seconds respawn delay
            -- You can add logic here to check if coyotes have respawned
        end
    end
end

-- Toggle Handler
toggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    toggleButton.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
    toggleButton.BackgroundColor3 = farming and Color3.new(0.6, 0, 0) or Color3.new(0, 0.6, 0)

    if farming then
        autoFarm()
    end
end)
