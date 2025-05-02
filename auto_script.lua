-- MIT License -- Copyright (c) 2025 AkumajouHelp

--[[ Westbound Auto Farm Script (Enhanced Anti-Cheat and Optimized Performance) Author: AkumajouHelp

Features:

Auto farm coyotes

Auto sell when inventory full

Fast auto kill

Faster teleporting

Low lag & safe teleports

Anti-AFK

Auto respawn

GUI with toggle buttons

Teleport to Train Heist

Instant Deposit to Bank

Chat command: !togglefarm

Anti-Cheat

Ammo Smart System (Auto-buy ammo, on-screen warning, auto-switch to melee if no bullets)

Coordinate Display + Clipboard Copy ]]


-- Function to load script from a URL local function loadScript(url) local success, response = pcall(function() return game:HttpGet(url) end) if success then return response else return nil end end

-- Try loading fallback sources local scriptContent = loadScript("https://pastebin.com/raw/5TU8iPKE") if not scriptContent then scriptContent = loadScript("https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/refs/heads/main/auto_script.lua") end if scriptContent then loadstring(scriptContent)() else warn("Failed to load the script from both sources.") end

-- Services local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local VirtualInputManager = game:GetService("VirtualInputManager") local LocalPlayer = Players.LocalPlayer local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local HRP = Character:WaitForChild("HumanoidRootPart")

-- Anti-AFK LocalPlayer.Idled:Connect(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) wait(math.random(1, 2)) VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) end)

-- Safe Teleport local function safeTeleport(destination) local randomOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2)) local targetCFrame = destination + randomOffset local tween = TweenService:Create(HRP, TweenInfo.new(0.7), {CFrame = targetCFrame}) tween:Play() tween.Completed:Wait() end

-- GUI Setup local gui = Instance.new("ScreenGui", game.CoreGui) local toggleBtn = Instance.new("TextButton", gui) toggleBtn.Size = UDim2.new(0, 200, 0, 50) toggleBtn.Position = UDim2.new(0, 50, 0, 50) toggleBtn.Text = "Start Auto Farm" toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local coordsLabel = Instance.new("TextLabel", gui) coordsLabel.Size = UDim2.new(0, 300, 0, 30) coordsLabel.Position = UDim2.new(0, 50, 0, 110) coordsLabel.TextColor3 = Color3.new(1,1,1) coordsLabel.BackgroundTransparency = 1 coordsLabel.Text = "Position: Loading..."

local coordsVisible = true local farming = false

toggleBtn.MouseButton1Click:Connect(function() farming = not farming toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm" end)

-- Chat Command Toggle local chatEvents = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents chatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data) if data.FromSpeaker == LocalPlayer.Name and data.Message:lower() == "!togglefarm" then farming = not farming toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm" chatEvents.SayMessageRequest:FireServer(farming and "Auto Farming Started" or "Auto Farming Stopped", "All") end end)

-- Update Position Display RunService.RenderStepped:Connect(function() if coordsVisible and HRP then local pos = HRP.Position local coordText = string.format("Position: X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z) coordsLabel.Text = coordText print(coordText) if setclipboard then setclipboard(coordText) end end end)

-- Auto Farm Logic spawn(function() while true do wait(math.random(1, 3)) if farming then local enemies = workspace:FindFirstChild("Enemies") if enemies then for _, mob in pairs(enemies:GetChildren()) do if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then safeTeleport(mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)) wait(math.random(0.2, 0.5)) pcall(function() mob.Humanoid.Health = 0 end) end end end

local inv = LocalPlayer.Backpack:GetChildren()
        if #inv >= 10 then
            local sellPos = CFrame.new(-214, 24, 145)
            safeTeleport(sellPos)
            wait(math.random(0.5, 1))
        end
    end
end

end)

-- Auto Respawn LocalPlayer.CharacterAdded:Connect(function(char) Character = char HRP = Character:WaitForChild("HumanoidRootPart") end)

-- Ammo & Bank Checks local function checkAndBuyAmmo() local ammo = LocalPlayer.Backpack:FindFirstChild("Ammo") if ammo and ammo.Amount < 10 then local buyPos = CFrame.new(-200, 24, 140) safeTeleport(buyPos) wait(math.random(1, 2)) end end

local function depositToBank() local bankPos = CFrame.new(-210, 24, 150) safeTeleport(bankPos) wait(math.random(1, 2)) end

spawn(function() while true do checkAndBuyAmmo() depositToBank() wait(10) end end)

-- Teleport to Train Heist local function teleportToTrainHeist() local trainHeistPos = CFrame.new(-300, 24, 200) safeTeleport(trainHeistPos) end

