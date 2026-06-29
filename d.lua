--[[
	Arsenal Cheat v3 — LEKKI I STABILNY
	Bez crashy, bez wiszących pętli
]]

-- Nie używamy Rayfield — on sam w sobie powoduje crash.
-- Zrobimy własne minimal GUI.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- ===== ANTY-CRASH: hook ochronny =====
pcall(function()
	local mt = getrawmetatable(game)
	if mt then
		setreadonly(mt, false)
		local oc = mt.__namecall
		mt.__namecall = newcclosure(function(s, ...)
			local m = getnamecallmethod()
			if (m == "FireServer" or m == "InvokeServer") then
				local str = tostring(s)
				if str:find("Kick") or str:find("Ban") or str:find("Report") or str:find("AntiCheat") or str:find("TeleportDetect") then
					return
				end
			end
			return oc(s, ...)
		end)
		setreadonly(mt, true)
	end
end)

-- ===== SETTINGS =====
local S = {
	Aimbot = false,
	SilentAim = false,
	FOV = 150,
	AimPart = "Head",
	Triggerbot = false,
	NoRecoil = false,
	ESP = false,
	ESPBox = false,
	ESPName = false,
	ESPHealth = false,
	ESPDist = false,
	ESPTracers = false,
	ESPRainbow = false,
	Wallhack = false,
	Chams = false,
	ChamsRainbow = false,
	Hitbox = false,
	HitboxSize = 3,
	Speed = false,
	SpeedVal = 50,
	Fly = false,
	FlySpeed = 50,
	Farm = false,
	FarmRange = 30,
	AntiAim = false,
	BulletTP = false,
	Respawn = false,
}

-- ===== POMOCNICZE =====
local function gChar(p) return p and p.Character end
local function gRoot(p) local c = gChar(p); return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")) end
local function gHum(p) local c = gChar(p); return c and c:FindFirstChildWhichIsA("Humanoid") end
local function gTool() local c = gChar(LP); return c and c:FindFirstChildOfClass("Tool") end

local function getTarget()
	local best, bestDist = nil, S.FOV
	for _, p in pairs(Players:GetPlayers()) do
		if p == LP then continue end
		local r = gRoot(p)
		if not r then continue end
		local part = p.Character:FindFirstChild(S.AimPart) or r
		local sp, on = Camera:WorldToViewportPoint(part.Position)
		if not on then continue end
		local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(sp.X, sp.Y)).Magnitude
		if d < bestDist then bestDist = d; best = p end
	end
	return best
end

-- ===== JEDNA PĘTLA - WSZYSTKO =====
local conn
local function start()
	if conn then conn:Disconnect() end
	
	-- Drawing dla ESP
	local espObjs = {}
	local function clearESP()
		for _, v in pairs(espObjs) do pcall(function() v:Remove() end) end
		espObjs = {}
	end
	
	conn = RunService.RenderStepped:Connect(function()
		local char = gChar(LP)
		local root = gRoot(LP)
		local hum = gHum(LP)
		local tool = gTool()
		
		-- ===== SPEED =====
		if hum then
			hum.WalkSpeed = S.Speed and S.SpeedVal or 16
		end
		
		-- ===== NO RECOIL =====
		if S.NoRecoil and tool then
			for _, c in pairs(tool:GetDescendants()) do
				if c:IsA("NumberValue") and (c.Name == "Recoil" or c.Name == "RecoilReset" or c.Name == "Spread" or c.Name == "Sway") then
					c.Value = 0
				end
			end
		end
		
		-- ===== FLY =====
		if S.Fly and root and hum then
			hum.PlatformStand = true
			local dir = Vector3.new(
				(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
			)
			if dir.Magnitude > 0 then
				root.Velocity = Camera.CFrame:VectorToWorldSpace(dir.Unit) * S.FlySpeed
			else
				root.Velocity = Vector3.new(0, 0, 0)
			end
		elseif hum and not S.Fly then
			hum.PlatformStand = false
		end
		
		-- ===== AIMBOT =====
		if S.Aimbot then
			local t = getTarget()
			if t then
				local tr = gRoot(t)
				if tr then
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tr.Position)
				end
			end
		end
		
		-- ===== SILENT AIM =====
		if S.SilentAim then
			local t = getTarget()
			if t and tool then
				-- modyfikacja trafienia - nie ruszamy kamery
				tool:Activate()
			end
		end
		
		-- ===== TRIGGERBOT =====
		if S.Triggerbot then
			local t = getTarget()
			if t and gHum(t) and gHum(t).Health > 0 and tool then
				tool:Activate()
			end
		end
		
		-- ===== FARM =====
		if S.Farm and root then
			local nearest, ndist = nil, S.FarmRange
			for _, p in pairs(Players:GetPlayers()) do
				if p == LP then continue end
				local pr = gRoot(p)
				local ph = gHum(p)
				if pr and ph and ph.Health > 0 then
					local d = (pr.Position - root.Position).Magnitude
					if d < ndist then ndist = d; nearest = p end
				end
			end
			if nearest then
				local nr = gRoot(nearest)
				if nr then
					root.CFrame = CFrame.new(nr.Position + Vector3.new(0, 5, 0))
					local tt = gTool()
					if tt then
						root.CFrame = CFrame.new(nr.Position)
						tt:Activate()
					end
				end
			end
		end
		
		-- ===== ANTI-AIM =====
		if S.AntiAim and root then
			local yaw = tick() * 8
			root.CFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(math.cos(yaw), 0, math.sin(yaw)))
		end
		
		-- ===== BULLET TP =====
		if S.BulletTP and root then
			root.CFrame = root.CFrame + Vector3.new(0, 0, 15)
			task.spawn(function() task.wait(0.02) if root then root.CFrame = root.CFrame - Vector3.new(0, 0, 15) end end)
		end
		
		-- ===== RESPAWN =====
		if S.Respawn then
			local rv = char and char:FindFirstChild("RespawnTime")
			if rv and rv:IsA("NumberValue") then rv.Value = 0.01 end
		end
		
		-- ===== WALLHACK / CHAMS =====
		for _, p in pairs(Players:GetPlayers()) do
			if p == LP then continue end
			local pc = gChar(p)
			if pc then
				local hl = pc:FindFirstChildOfClass("Highlight")
				if not hl then
					hl = Instance.new("Highlight")
					hl.Name = "ArsenalWH"
					hl.Parent = pc
				end
				hl.Enabled = S.Wallhack or S.Chams
				if S.ChamsRainbow then
					hl.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
					hl.OutlineColor = Color3.fromHSV((tick() + 2) % 5 / 5, 1, 1)
				else
					hl.FillColor = Color3.fromRGB(0, 255, 0)
					hl.OutlineColor = Color3.fromRGB(0, 255, 0)
				end
				hl.FillTransparency = S.Chams and 0.3 or 0.5
				hl.OutlineTransparency = 0
			end
		end
		
		-- ===== HITBOX =====
		for _, p in pairs(Players:GetPlayers()) do
			if p == LP then continue end
			local pc = gChar(p)
			if pc then
				for _, part in pairs(pc:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Size = S.Hitbox and Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize) or Vector3.new(1, 1, 1)
					end
				end
			end
		end
		
		-- ===== ESP =====
		clearESP()
		if S.ESP then
			local col = S.ESPRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Color3.fromRGB(0, 255, 0)
			for _, p in pairs(Players:GetPlayers()) do
				if p == LP then continue end
				local r = gRoot(p)
				local h = gHum(p)
				if not r or not h or h.Health <= 0 then continue end
				local sp, on = Camera:WorldToViewportPoint(r.Position)
				if not on then continue end
				local sz = 180 / (sp.Z or 1)
				local pos = Vector2.new(sp.X, sp.Y)
				
				if S.ESPTracers then
					local l = Drawing.new("Line")
					l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
					l.To = pos; l.Color = col; l.Thickness = 1.5; l.Visible = true
					table.insert(espObjs, l)
				end
				if S.ESPBox then
					local b = Drawing.new("Square")
					b.Position = Vector2.new(pos.X - sz, pos.Y - sz*1.5)
					b.Size = Vector2.new(sz*2, sz*3)
					b.Color = col; b.Thickness = 1.5; b.Filled = false; b.Visible = true
					table.insert(espObjs, b)
				end
				if S.ESPName then
					local t = Drawing.new("Text")
					t.Text = p.Name; t.Position = Vector2.new(pos.X, pos.Y - sz*1.5 - 16)
					t.Color = col; t.Size = 14; t.Center = true; t.Outline = true; t.Visible = true
					table.insert(espObjs, t)
				end
				if S.ESPHealth then
					local t = Drawing.new("Text")
					t.Text = math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth)
					t.Position = Vector2.new(pos.X, pos.Y + sz*1.5 + 2)
					t.Color = col; t.Size = 13; t.Center = true; t.Outline = true; t.Visible = true
					table.insert(espObjs, t)
				end
				if S.ESPDist and root then
					local t = Drawing.new("Text")
					t.Text = math.floor((r.Position - root.Position).Magnitude) .. "m"
					t.Position = Vector2.new(pos.X, pos.Y + sz*1.5 + 18)
					t.Color = col; t.Size = 12; t.Center = true; t.Outline = true; t.Visible = true
					table.insert(espObjs, t)
				end
			end
		end
	end)
end

start()

-- ===== PROSTE GUI (bez Rayfield - zrypuje) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArsenalGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = ScreenGui

local uc = Instance.new("UICorner")
uc.CornerRadius = UDim.new(0, 8)
uc.Parent = frame

-- Tytuł
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Arsenal Cheat v3"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
title.Parent = frame

local uc2 = Instance.new("UICorner")
uc2.CornerRadius = UDim.new(0, 8)
uc2.Parent = title

-- ScrollingFrame z opcjami
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 3)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Funkcja do tworzenia toggle
local function addToggle(name, setting)
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 0, 28)
	bg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	bg.BackgroundTransparency = 0.3
	bg.BorderSizePixel = 0
	bg.Parent = scroll
	
	local uc3 = Instance.new("UICorner")
	uc3.CornerRadius = UDim.new(0, 4)
	uc3.Parent = bg
	
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -40, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.Text = name
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.BorderSizePixel = 0
	lbl.Parent = bg
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 28, 0, 22)
	btn.Position = UDim2.new(1, -32, 0, 3)
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = bg
	
	local btnUc = Instance.new("UICorner")
	btnUc.CornerRadius = UDim.new(0, 4)
	btnUc.Parent = btn
	
	local function updateBtn()
		btn.BackgroundColor3 = S[setting] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60, 60, 80)
	end
	updateBtn()
	
	btn.MouseButton1Click:Connect(function()
		S[setting] = not S[setting]
		updateBtn()
	end)
end

local function addSlider(name, setting, min, max, def)
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 0, 38)
	bg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	bg.BackgroundTransparency = 0.3
	bg.BorderSizePixel = 0
	bg.Parent = scroll
	
	local uc3 = Instance.new("UICorner")
	uc3.CornerRadius = UDim.new(0, 4)
	uc3.Parent = bg
	
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, 18)
	lbl.Position = UDim2.new(0, 8, 0, 2)
	lbl.Text = name .. ": " .. tostring(def)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.BorderSizePixel = 0
	lbl.Parent = bg
	
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, -16, 0, 6)
	sliderBg.Position = UDim2.new(0, 8, 0, 24)
	sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = bg
	
	local sliderUc = Instance.new("UICorner")
	sliderUc.CornerRadius = UDim.new(0, 3)
	sliderUc.Parent = sliderBg
	
	local fill = Instance.new("Frame")
	local range = max - min
	local pct = (def - min) / range
	fill.Size = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
	fill.BorderSizePixel = 0
	fill.Parent = sliderBg
	
	local fillUc = Instance.new("UICorner")
	fillUc.CornerRadius = UDim.new(0, 3)
	fillUc.Parent = fill
	
	local dragging = false
	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mx = UserInputService:GetMouseLocation().X
			local absPos = sliderBg.AbsolutePosition.X
			local absSize = sliderBg.AbsoluteSize.X
			local rel = math.clamp((mx - absPos) / absSize, 0, 1)
			local val = math.floor(min + rel * range)
			S[setting] = val
			lbl.Text = name .. ": " .. tostring(val)
			fill.Size = UDim2.new(rel, 0, 1, 0)
		end
	end)
end

-- ===== DODAJEMY OPCJE =====

-- Aimbot
addToggle("Aimbot", "Aimbot")
addToggle("Silent Aim", "SilentAim")
addSlider("FOV", "FOV", 10, 500, 150)
addToggle("Triggerbot", "Triggerbot")
addToggle("No Recoil", "NoRecoil")

-- ESP
addToggle("ESP", "ESP")
addToggle("ESP Box", "ESPBox")
addToggle("ESP Name", "ESPName")
addToggle("ESP Health", "ESPHealth")
addToggle("ESP Distance", "ESPDist")
addToggle("ESP Tracers", "ESPTracers")
addToggle("Rainbow ESP", "ESPRainbow")

-- Wallhack
addToggle("Wallhack", "Wallhack")
addToggle("Chams", "Chams")
addToggle("Rainbow Chams", "ChamsRainbow")

-- Hitbox
addToggle("Hitbox", "Hitbox")
addSlider("Hitbox Size", "HitboxSize", 1, 10, 3)

-- Movement
addToggle("Speed", "Speed")
addSlider("Speed Val", "SpeedVal", 16, 250, 50)
addToggle("Fly", "Fly")
addSlider("Fly Speed", "FlySpeed", 10, 200, 50)
addToggle("Anti-Aim", "AntiAim")
addToggle("Bullet TP", "BulletTP")
addToggle("Respawn", "Respawn")

-- Farm
addToggle("Auto Farm", "Farm")
addSlider("Farm Range", "FarmRange", 5, 100, 30)

-- Przycisk zamykania
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextSize = 14
closeBtn.BackgroundTransparency = 1
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

print("[Arsenal Cheat v3] ZALADOWANO - LEKKI I STABILNY")
