--[[
Westbound Auto Farm Script (Fixed Fast Version 3)

This script automatically farms and sells in Westbound.

Features:
- Auto sell
- Auto farming
- Low lag
- Fast auto kill
- Faster selling
- Quicker teleporting

Purpose:
This script is created to automatically farm coyote coins and sell items in the game Westbound. 
It helps players grind faster, avoid manual effort, and earn money efficiently with minimal lag. 
Perfect for users on Android using Arceus X or similar software.

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
]]

-- CONFIG
local killCooldown = 0.5
local sellCooldown = 2
local teleportCooldown = 4

-- UTILITIES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getHumanoidRootPart()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- AUTO KILL COYOTES
spawn(function()
    while task.wait(killCooldown) do
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc.Name == "Coyote" and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local hrp = getHumanoidRootPart()
                if hrp and npc:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- AUTO SELL AT BUTCHER
spawn(function()
    while task.wait(sellCooldown) do
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc.Name == "Butcher" and npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local hrp = getHumanoidRootPart()
                if hrp then
                    hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.5)

                    -- Try to simulate interaction (placeholder logic)
                    local proximityPrompt = npc:FindFirstChildOfClass("ProximityPrompt", true)
                    if proximityPrompt then
                        fireproximityprompt(proximityPrompt)
                    end
                end
            end
        end
    end
end)

-- RANDOM TELEPORT POINTS
local teleportPoints = {
    Vector3.new(400, 50, 900),
    Vector3.new(500, 50, 1000),
    Vector3.new(600, 50, 1100),
    Vector3.new(450, 50, 950),
}

spawn(function()
    while task.wait(teleportCooldown) do
        local hrp = getHumanoidRootPart()
        if hrp then
            local point = teleportPoints[math.random(1, #teleportPoints)]
            hrp.CFrame = CFrame.new(point)
        end
    end
end)
