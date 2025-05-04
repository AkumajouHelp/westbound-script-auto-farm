local mSURL="https://raw.githubusercontent.com/AkumajouHelp/westbound-script-auto-farm/refs/heads/main/auto_script.lua"
local bSURL="https://pastebin.com/raw/5TU8iPKE"
local function lS(u) local s,r=pcall(function() return game:GetService("HttpService"):GetAsync(u) end) if s then return r else warn("Failed to load: "..u) return nil end end
local function lSWF() local c=lS(mSURL) or lS(bSURL) if c then loadstring(c)() else error("Failed to load from both sources!") end end
lSWF()
local P,T,R,RS=game:GetService("Players"),game:GetService("TweenService"),game:GetService("RunService"),game:GetService("ReplicatedStorage")
local VIM,UIS,LP=game:GetService("VirtualInputManager"),game:GetService("UserInputService"),P.LocalPlayer
local C,HRP=LP.Character or LP.CharacterAdded:Wait(),nil
repeat HRP=C:FindFirstChild("HumanoidRootPart") task.wait() until HRP
local PG=LP:WaitForChild("PlayerGui")
LP.Idled:Connect(function() VIM:SendMouseButtonEvent(0,0,0,true,game,0) task.wait(math.random(1,2)) VIM:SendMouseButtonEvent(0,0,0,false,game,0) end)
local function sT(cf) local o=Vector3.new(math.random(-2,2),0,math.random(-2,2)) T:Create(HRP,TweenInfo.new(0.6),{CFrame=cf+o}):Play() task.wait(0.7) end
local function rW(m,x) task.wait(math.random(m*100,x*100)/100) end
local b=Instance.new("BlurEffect",PG) b.Size=0
local function tB(o) b.Size=o and 25 or 0 end
local c=Instance.new("Frame",PG) c.Size=UDim2.new(1,0,1,0) c.BackgroundColor3=Color3.new(0,0,0) c.BackgroundTransparency=0.7 c.Visible=false c.ZIndex=10
local function tC(o) c.Visible=o end
UIS.InputBegan:Connect(function(i,g) if not g and i.KeyCode==Enum.KeyCode.PrintScreen then tB(true) task.wait(2) tB(false) end end)
local g=Instance.new("ScreenGui",game.CoreGui)
local tBttn=Instance.new("TextButton",g)
tBttn.Size,tBttn.Position=UDim2.new(0,200,0,50),UDim2.new(0,50,0,50)
tBttn.Text,tBttn.BackgroundColor3="Start Auto Farm",Color3.fromRGB(0,170,255)
local f=false
tBttn.MouseButton1Click:Connect(function() f=not f tBttn.Text=f and "Stop Auto Farm" or "Start Auto Farm" end)
RS.DefaultChatSystemChatEvents.SayMessageRequest.OnClientEvent:Connect(function(m,s) if s==LP.Name and m:lower()=="!togglefarm" then f=not f tBttn.Text=f and "Stop Auto Farm" or "Start Auto Farm" end end)
local function aE(o,c) local b=Instance.new("BillboardGui",o) b.Size=UDim2.new(0,100,0,20) b.AlwaysOnTop=true local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1 l.Text=o.Name l.TextColor3=c l.TextStrokeTransparency=0.5 end
local function aEQ() local b=nil for _,t in pairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") and (not b or t.Name:lower():find("rifle") or t.Name:lower():find("shotgun")) then b=t end end if b then b.Parent=C end end
LP.CharacterAdded:Connect(function(c) C,HRP=c,c:WaitForChild("HumanoidRootPart") end)
spawn(function() while task.wait(2) do if f then local e=workspace:FindFirstChild("Enemies") if e then for _,m in pairs(e:GetChildren()) do if m.Name=="Coyote" and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 then if not m:FindFirstChild("ESP") then aE(m,Color3.new(1,0,0)) end sT(m.HumanoidRootPart.CFrame+Vector3.new(0,5,0)) aEQ() for i=1,5 do pcall(function() m.Humanoid:TakeDamage(25) end) task.wait(0.1) end end end end if #LP.Backpack:GetChildren()>=10 then sT(CFrame.new(-214,24,145)) rW(0.5,1) end end end end)
local function cBA() if LP.Backpack:FindFirstChild("Ammo") then sT(CFrame.new(-200,24,140)) rW(1,2) end end
local function dTB() sT(CFrame.new(-210,24,150)) rW(1,2) end
local function gTHP() local t=workspace:FindFirstChild("TrainHeist") if t and t:FindFirstChild("HumanoidRootPart") then if not t:FindFirstChild("ESP") then aE(t,Color3.new(0,1,0)) end return t.HumanoidRootPart.CFrame end return CFrame.new(-300,24,200) end
local function tTTH() local cf=gTHP() if (HRP.Position-cf.Position).Magnitude>10 then sT(cf) end end
spawn(function() while task.wait(2) do if f then tTTH() cBA() dTB() end end end)
spawn(function() while task.wait(5) do if f then tC(true) task.wait(2.5) tC(false) end end end)
local dG=Instance.new("ScreenGui",game.CoreGui) dG.Name="DevPanel"
local p=Instance.new("Frame",dG) p.Size,p.Position=UDim2.new(0,220,0,140),UDim2.new(0,270,0,50) p.BackgroundColor3=Color3.fromRGB(30,30,30) p.Active,p.Draggable=true,true
local lbl=Instance.new("TextLabel",p) lbl.Size=UDim2.new(1,0,0,30) lbl.Text="Dev Panel" lbl.TextColor3=Color3.new(1,1,1) lbl.BackgroundTransparency=1
local s=Instance.new("TextLabel",p) s.Size=UDim2.new(1,0,0,20) s.Position=UDim2.new(0,0,0,30) s.TextColor3=Color3.new(1,1,1) s.BackgroundTransparency=1
R.RenderStepped:Connect(function() s.Text="Status: "..(f and "Farming" or "Idle") end)
local bCloak=Instance.new("TextButton",p) bCloak.Size,bCloak.Position=UDim2.new(1,0,0,25),UDim2.new(0,0,0,55) bCloak.Text="Toggle Cloak" bCloak.MouseButton1Click:Connect(function() tC(not c.Visible) end)
local bBlur=Instance.new("TextButton",p) bBlur.Size,bBlur.Position=UDim2.new(1,0,0,25),UDim2.new(0,0,0,85) bBlur.Text="Toggle Blur" bBlur.MouseButton1Click:Connect(function() tB(b.Size==0) end)
local bTPB=Instance.new("TextButton",p) bTPB.Size,bTPB.Position=UDim2.new(1,0,0,25),UDim2.new(0,0,0,115) bTPB.Text="Teleport to Bank" bTPB.MouseButton1Click:Connect(function() sT(CFrame.new(-210,24,150)) end)
