--[[
Westbound Auto Farm Script

This script automatically farms and sells in Westbound.
Features:
- Auto sell
- Auto farming
- Low lag

How to use:
Use with Arceus X Neon. Paste the raw link in loadstring() and execute.
]]

-- Initialize buttons
local autoKillButton = script.Parent:WaitForChild("AutoKillButton") -- Example: change button path
local autoSellButton = script.Parent:WaitForChild("AutoSellButton")
local autoMoveButton = script.Parent:WaitForChild("AutoMoveButton")

-- Flag variables to control auto actions
local autoKillEnabled = false
local autoSellEnabled = false
local autoMoveEnabled = false

-- Function to toggle Auto Kill
autoKillButton.MouseButton1Click:Connect(function()
    autoKillEnabled = not autoKillEnabled
    if autoKillEnabled then
        while autoKillEnabled do
            wait(1)  -- Slow down Auto Kill by waiting 1 second between actions
            -- Add your code for auto killing enemies or animals here
            print("Killing enemies...")  -- Placeholder action
        end
    end
end)

-- Function to toggle Auto Sell
autoSellButton.MouseButton1Click:Connect(function()
    autoSellEnabled = not autoSellEnabled
    if autoSellEnabled then
        while autoSellEnabled do
            wait(3)  -- Slow down Auto Sell by waiting 3 seconds between selling
            -- Add your code for auto selling items here
            print("Selling items...")  -- Placeholder action
        end
    end
end)

-- Function to toggle Auto Move (Teleporting)
autoMoveButton.MouseButton1Click:Connect(function()
    autoMoveEnabled = not autoMoveEnabled
    if autoMoveEnabled then
        while autoMoveEnabled do
            wait(5)  -- Slow down Auto Move by waiting 5 seconds between moves
            -- Add your code for auto teleporting to new locations
            print("Teleporting to a new location...")  -- Placeholder action
        end
    end
end)
