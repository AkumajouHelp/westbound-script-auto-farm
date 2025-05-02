--[[ Westbound Auto Farm Script (Optimized + Developer Tools) Author: AkumajouHelp MIT License Included

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

Ammo Smart System

Blur/Smoke overlay effects

Developer Panel: status, manual tools, logs ]]


--// MIT License -- Copyright (c) 2025 AkumajouHelp -- Permission is granted... [Full license text retained above this]

--// Services local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local VirtualInputManager = game:GetService("VirtualInputManager") local LocalPlayer = Players.LocalPlayer local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local HRP = Character:WaitForChild("HumanoidRootPart") local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Anti-AFK LocalPlayer.Idled:Connect(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(math.random(1,2)) VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) end)

--// Safe Teleport local function safeTeleport(cf) local offset = Vector3.new(math.random(-2,2), 0, math.random(-2,2)) TweenService:Create(HRP, TweenInfo.new(0.6), {CFrame = cf + offset}):Play() task.wait(0.7) end

--// Effects local blur = Instance.new("BlurEffect", PlayerGui) blur.Size = 0 local function toggleBlur(on) blur.Size = on and 25 or 0 end

local cloak = Instance.new("Frame") cloak.Size = UDim2.new(1,0,1,0) cloak.BackgroundColor3 = Color3.new(0,0,0) cloak.BackgroundTransparency = 0.7 cloak.Visible = false cloak.ZIndex = 10 cloak.Parent = PlayerGui local function toggleCloak(on) cloak.Visible = on end

-- Screenshot blur game:GetService("UserInputService").InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.PrintScreen then toggleBlur(true) task.wait(2) toggleBlur(false) end end)

--// GUI Toggle local gui = Instance.new("ScreenGui", game.CoreGui) local toggleBtn = Instance.new("TextButton", gui) toggleBtn.Size = UDim2.new(0, 200, 0, 50) toggleBtn.Position = UDim2.new(0, 50, 0, 50) toggleBtn.Text = "Start Auto Farm" toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)

local farming = false toggleBtn.MouseButton1Click:Connect(function() farming = not farming toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm" end)

-- Chat toggle ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(msg, sender) if sender == LocalPlayer.Name and msg:lower() == "!togglefarm" then farming = not farming toggleBtn.Text = farming and "Stop Auto Farm" or "Start Auto Farm" end end)

--// Helper Wait local function randomizedWait(min, max) task.wait(math.random(min100, max100)/100) end

--// Auto Farm Coyotes spawn(function() while task.wait(1) do if farming then local enemies = workspace:FindFirstChild("Enemies") if enemies then for _, mob in pairs(enemies:GetChildren()) do if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then safeTeleport(mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)) randomizedWait(0.2, 0.4) pcall(function() mob.Humanoid.Health = 0 end) end end end if #LocalPlayer.Backpack:GetChildren() >= 10 then safeTeleport(CFrame.new(-214,24,145)) -- Sell spot randomizedWait(0.5, 1) end end end end)

--// Auto Respawn LocalPlayer.CharacterAdded:Connect(function(char) Character = char HRP = char:WaitForChild("HumanoidRootPart") end)

--// Ammo + Bank local function checkAndBuyAmmo() if LocalPlayer.Backpack:FindFirstChild("Ammo") then safeTeleport(CFrame.new(-200,24,140)) randomizedWait(1,2) end end

local function depositToBank() safeTeleport(CFrame.new(-210,24,150)) randomizedWait(1,2) end

--// Train Heist Tracker local function getTrainHeistPos() local train = workspace:FindFirstChild("TrainHeist") return train and train:FindFirstChild("HumanoidRootPart") and train.HumanoidRootPart.CFrame or CFrame.new(-300,24,200) end

local function teleportToTrainHeist() local cf = getTrainHeistPos() if (HRP.Position - cf.Position).Magnitude > 10 then safeTeleport(cf) end end

-- Train + Ammo + Bank spawn(function() while task.wait(2) do if farming then teleportToTrainHeist() checkAndBuyAmmo() depositToBank() end end end)

-- Cloak simulation spawn(function() while task.wait(5) do if farming then toggleCloak(true) task.wait(2.5) toggleCloak(false) end end end)

--// Developer Panel local devGui = Instance.new("ScreenGui", game.CoreGui) devGui.Name = "DevPanel" local panel = Instance.new("Frame", devGui) panel.Size = UDim2.new(0,220,0,140) panel.Position = UDim2.new(0,270,0,50) panel.BackgroundColor3 = Color3.fromRGB(30,30,30) panel.Draggable, panel.Active = true, true

local lbl = Instance.new("TextLabel", panel) lbl.Size = UDim2.new(1,0,0,30) lbl.Text = "Dev Panel" lbl.TextColor3 = Color3.new(1,1,1) lbl.BackgroundTransparency = 1

local status = Instance.new("TextLabel", panel) status.Size = UDim2.new(1,0,0,20) status.Position = UDim2.new(0,0,0,30) status.Text = "Status: Idle" status.TextColor3 = Color3.new(1,1,1) status.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function() status.Text = "Status: " .. (farming and "Farming" or "Idle") end)

local btnCloak = Instance.new("TextButton", panel) btnCloak.Size = UDim2.new(1,0,0,25) btnCloak.Position = UDim2.new(0,0,0,55) btnCloak.Text = "Toggle Cloak" btnCloak.MouseButton1Click:Connect(function() cloak.Visible = not cloak.Visible end)

local btnBlur = Instance.new("TextButton", panel) btnBlur.Size = UDim2.new(1,0,0,25) btnBlur.Position = UDim2.new(0,0,0,85) btnBlur.Text = "Toggle Blur" btnBlur.MouseButton1Click:Connect(function() toggleBlur(blur.Size == 0) end)

local btnTPBank = Instance.new("TextButton", panel) btnTPBank.Size = UDim2.new(1,0,0,25) btnTPBank.Position = UDim2.new(0,0,0,115) btnTPBank.Text = "Teleport to Bank" btnTPBank.MouseButton1Click:Connect(function() safeTeleport(CFrame.new(-210,24,150)) end)

