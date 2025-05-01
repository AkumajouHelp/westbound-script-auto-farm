--[[
Westbound Auto Farm Script (Android/PC – Arceus X Neon Compatible)
Author: AkumajouHelp (2025)
MIT License – Free to use, modify, share
]]

-- SETTINGS
local SELL_POSITION = CFrame.new(-214, 24, 145) -- General Store
local TRAIN_HEIST_POSITION = CFrame.new(305, 24, 682) -- Example position
local BANK_POSITION = CFrame.new(-190, 24, 130) -- Example Bank position
local MAX_INVENTORY = 10
local AMMO_THRESHOLD = 5

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
	VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
	wait(1)
	VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 50, 0, 50)
button.Text = "Start Auto Farm"
button.BackgroundColor3 = Color3.new(0, 1, 0)
button.TextSize = 20

-- AMMO WARNING
local warningLabel = Instance.new("TextLabel", gui)
warningLabel.Size = UDim2.new(0, 300, 0, 50)
warningLabel.Position = UDim2.new(0, 50, 0, 110)
warningLabel.Text = ""
warningLabel.TextColor3 = Color3.new(1, 0, 0)
warningLabel.BackgroundTransparency = 1
warningLabel.TextSize = 20

-- STATE
local farming = false

local function buyAmmo()
	local shopRemote = ReplicatedStorage:FindFirstChild("RemoteEvent_BuyAmmo")
	if shopRemote then
		shopRemote:FireServer()
	end
end

local function checkAmmo()
	local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("Ammo") then
		return tool.Ammo.Value
	end
	return 0
end

local function switchToMelee()
	for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if item:IsA("Tool") and item:FindFirstChild("Type") and item.Type.Value == "Melee" then
			item.Parent = LocalPlayer.Character
			break
		end
	end
end

-- TOGGLE GUI & CHAT
button.MouseButton1Click:Connect(function()
	farming = not farming
	button.Text = farming and "Stop Auto Farm" or "Start Auto Farm"
	button.BackgroundColor3 = farming and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
end)

game.Players.LocalPlayer.Chatted:Connect(function(msg)
	if msg == "!togglefarm" then
		button:MouseButton1Click()
	end
end)

-- MAIN LOOP
spawn(function()
	while true do
		wait(1)
		if farming then
			-- Check ammo
			local currentAmmo = checkAmmo()
			if currentAmmo <= 0 then
				warningLabel.Text = "OUT OF AMMO! Switching to melee..."
				switchToMelee()
			elseif currentAmmo < AMMO_THRESHOLD then
				warningLabel.Text = "Low Ammo! Auto-buying..."
				buyAmmo()
			else
				warningLabel.Text = ""
			end

			-- Kill Coyotes
			local enemies = workspace:FindFirstChild("Enemies")
			if enemies then
				for _, mob in ipairs(enemies:GetChildren()) do
					if mob.Name == "Coyote" and mob:FindFirstChild("HumanoidRootPart") then
						HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
						wait(0.2)
						mob.Humanoid.Health = 0
					end
				end
			end

			-- Auto Sell
			if #LocalPlayer.Backpack:GetChildren() >= MAX_INVENTORY then
				HumanoidRootPart.CFrame = SELL_POSITION
				wait(0.5)
				local sellRemote = ReplicatedStorage:FindFirstChild("RemoteEvent_SellAll")
				if sellRemote then sellRemote:FireServer() end
			end

			-- Auto Bank Deposit (optional)
			if math.random(1, 10) == 5 then
				HumanoidRootPart.CFrame = BANK_POSITION
				wait(0.5)
				local deposit = ReplicatedStorage:FindFirstChild("RemoteEvent_DepositAll")
				if deposit then deposit:FireServer() end
			end

			-- Train Heist Teleport (optional trigger)
			if math.random(1, 25) == 7 then
				HumanoidRootPart.CFrame = TRAIN_HEIST_POSITION
			end
		end
	end
end)

-- AUTO RESPAWN
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
	wait(1)
end)
