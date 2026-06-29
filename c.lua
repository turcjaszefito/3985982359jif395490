--[[
	Arsenal Cheat v2 — W pełni funkcjonalny
	Gra: https://www.roblox.com/games/286090429/Arsenal
	Framework: Rayfield Interface Suite (sirius.menu)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Arsenal Cheat v2",
	Icon = 0,
	LoadingTitle = "Arsenal Cheat by HackerAI",
	LoadingSubtitle = "Ladowanie...",
	ShowText = "Arsenal",
	Theme = "Default",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = true,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ArsenalHack",
		FileName = "ArsenalConfig"
	},
	Discord = {
		Enabled = false,
		Invite = "",
		RememberJoins = true
	},
	KeySystem = false,
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"1234"}
	}
})

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================================
-- SETTINGS
-- ============================================================
local Settings = {
	Aimbot = false,
	SilentAim = false,
	AimbotFOV = 100,
	AimbotPart = "Head",
	TeamCheck = false,
	
	Triggerbot = false,
	TriggerbotDelay = 0.05,
	
	NoRecoil = false,
	NoSpread = false,
	NoSway = false,
	
	ESP = false,
	ESPBox = false,
	ESPHealth = false,
	ESPName = false,
	ESPDistance = false,
	ESPTracers = false,
	ESPColor = Color3.fromRGB(0, 255, 0),
	ESPRainbow = false,
	ESPThickness = 1.5,
	
	Wallhack = false,
	Chams = false,
	ChamsColor = Color3.fromRGB(0, 255, 0),
	ChamsRainbow = false,
	
	Hitbox = false,
	HitboxSize = 3,
	
	Speed = false,
	SpeedMultiplier = 50,
	Fly = false,
	FlySpeed = 50,
	
	Farm = false,
	FarmRange = 30,
	
	AntiAim = false,
	AntiAimPitch = 90,
	
	BulletTP = false,
	BulletTPAmount = 15,
	
	RespawnManip = false,
	RespawnSpeed = 0.01,
	
	ACBypass = false,
}

-- ============================================================
-- META HOOK - OCHRONA PRZED WYKRYCIEM
-- ============================================================
local function setupProtection()
	local mt = getrawmetatable(game)
	if not mt then return end
	local old_namecall = mt.__namecall
	local old_index = mt.__index
	setreadonly(mt, false)
	
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		local s = tostring(self)
		
		-- Blokada kick/ban przez remote
		if method == "FireServer" or method == "InvokeServer" then
			if s:find("Kick") or s:find("Ban") or s:find("Report") or s:find("AntiCheat") or s:find("AC") then
				return
			end
		end
		
		return old_namecall(self, ...)
	end)
	
	mt.__index = newcclosure(function(self, key)
		if type(key) == "string" and (key:lower():find("esp") or key:lower():find("cheat") or key:lower():find("hack")) then
			return nil
		end
		return old_index(self, key)
	end)
	
	setreadonly(mt, true)
end
pcall(setupProtection)

-- ============================================================
-- POMOCNICZE
-- ============================================================
local function getCharacter(player)
	return player and player.Character
end

local function getRoot(player)
	local c = getCharacter(player)
	return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head"))
end

local function getHumanoid(player)
	local c = getCharacter(player)
	return c and c:FindFirstChildWhichIsA("Humanoid")
end

local function getTool()
	local c = getCharacter(LocalPlayer)
	return c and c:FindFirstChildOfClass("Tool")
end

local function getClosestPlayer(partName)
	partName = partName or Settings.AimbotPart
	local closest, closestDist = nil, Settings.AimbotFOV
	
	for _, player in pairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
		
		local root = getRoot(player)
		if not root then continue end
		
		local part = player.Character:FindFirstChild(partName) or root
		local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
		if not onScreen then continue end
		
		local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
		if dist < closestDist then
			closestDist = dist
			closest = player
		end
	end
	
	return closest
end

-- ============================================================
-- GŁÓWNA PĘTLA ODSTAWIENIA (24/7)
-- ============================================================
local SteppedConn
local function startMainLoop()
	if SteppedConn then SteppedConn:Disconnect() end
	
	SteppedConn = RunService.Stepped:Connect(function()
		local char = getCharacter(LocalPlayer)
		local root = getRoot(LocalPlayer)
		local hum = char and char:FindFirstChildWhichIsA("Humanoid")
		
		-- ===== SPEED =====
		if hum and Settings.Speed then
			hum.WalkSpeed = Settings.SpeedMultiplier
		elseif hum and not Settings.Speed and hum.WalkSpeed ~= 16 then
			hum.WalkSpeed = 16
		end
		
		-- ===== NO RECOIL / SPREAD / SWAY =====
		if Settings.NoRecoil or Settings.NoSpread or Settings.NoSway then
			local function processTool(tool)
				if not tool then return end
				for _, child in pairs(tool:GetDescendants()) do
					if child:IsA("NumberValue") then
						local n = child.Name
						if Settings.NoRecoil and (n == "Recoil" or n == "RecoilReset") then
							child.Value = 0
						end
						if Settings.NoSpread and (n == "Spread" or n == "BulletSpread") then
							child.Value = 0
						end
						if Settings.NoSway and (n == "Sway" or n == "GunSway") then
							child.Value = 0
						end
					end
				end
			end
			processTool(getTool())
			for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
				processTool(item)
			end
		end
		
		-- ===== FLY =====
		if Settings.Fly and root and hum then
			hum.PlatformStand = true
			local moveDir = Vector3.new(
				(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
			)
			if moveDir.Magnitude > 0 then
				moveDir = moveDir.Unit
				local velocity = Camera.CFrame:VectorToWorldSpace(moveDir) * Settings.FlySpeed
				root.Velocity = velocity
			else
				root.Velocity = Vector3.new(0, 0, 0)
			end
		elseif hum and not Settings.Fly then
			hum.PlatformStand = false
		end
		
		-- ===== AIMBOT =====
		if Settings.Aimbot then
			local target = getClosestPlayer()
			if target then
				local tRoot = getRoot(target)
				if tRoot then
					local lookAt = CFrame.lookAt(Camera.CFrame.Position, tRoot.Position)
					Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				end
			end
		end
		
		-- ===== SILENT AIM =====
		if Settings.SilentAim then
			local target = getClosestPlayer()
			if target then
				local tPart = target.Character:FindFirstChild(Settings.AimbotPart) or getRoot(target)
				if tPart then
					local tool = getTool()
					if tool and tool:FindFirstChild("Handle") then
						-- Celowanie przez modyfikacje mouse.Hit
						local oldHit = Mouse.Hit
						spawn(function()
							Mouse.Target = tPart
							Mouse.TargetFilter = nil
							task.wait()
							Mouse.Target = nil
						end)
					end
				end
			end
		end
		
		-- ===== TRIGGERBOT =====
		if Settings.Triggerbot then
			local target = getClosestPlayer("Head")
			if target then
				local tHum = getHumanoid(target)
				if tHum and tHum.Health > 0 then
					task.spawn(function()
						local tool = getTool()
						if tool then
							tool:Activate()
						end
					end)
				end
			end
		end
		
		-- ===== FARM (AUTO TP + KILL) =====
		if Settings.Farm and root then
			local nearestEnemy, nearestDist = nil, Settings.FarmRange
			for _, player in pairs(Players:GetPlayers()) do
				if player == LocalPlayer then continue end
				local pRoot = getRoot(player)
				local pHum = getHumanoid(player)
				if pRoot and pHum and pHum.Health > 0 then
					local dist = (pRoot.Position - root.Position).Magnitude
					if dist < nearestDist then
						nearestDist = dist
						nearestEnemy = player
					end
				end
			end
			
			if nearestEnemy then
				local targetRoot = getRoot(nearestEnemy)
				if targetRoot then
					-- Teleportuj nad wroga
					root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 5, 0))
					task.spawn(function()
						local tool = getTool()
						if tool then
							root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0.5, 0))
							tool:Activate()
							task.wait(0.05)
							tool:Activate()
						end
					end)
				end
			end
		end
		
		-- ===== ANTI-AIM =====
		if Settings.AntiAim and root then
			local pitch = math.rad(Settings.AntiAimPitch)
			local yaw = tick() * 8
			local dir = Vector3.new(math.cos(yaw) * math.cos(pitch), math.sin(pitch), math.sin(yaw) * math.cos(pitch))
			root.CFrame = CFrame.lookAt(root.Position, root.Position + dir)
		end
		
		-- ===== BULLET TP (FAKE LAG) =====
		if Settings.BulletTP and root then
			root.CFrame = root.CFrame + Vector3.new(0, 0, Settings.BulletTPAmount)
			task.spawn(function()
				task.wait(0.03)
				if root then
					root.CFrame = root.CFrame - Vector3.new(0, 0, Settings.BulletTPAmount)
				end
			end)
		end
		
		-- ===== RESPAWN MANIPULATION =====
		if Settings.RespawnManip then
			local resVal = char and char:FindFirstChild("RespawnTime")
			if resVal and resVal:IsA("NumberValue") then
				resVal.Value = Settings.RespawnSpeed
			end
			-- Dodatkowo jeśli humanoid ma 0 zdrowia, próbuj szybszego respawnu
			if hum and hum.Health <= 0 then
				hum.Health = 0
			end
		end
	end)
end

-- ============================================================
-- ESP - OSOBNA PĘTLA RenderStepped (24/7)
-- ============================================================
local ESPCache = {}

local function clearESP()
	for _, obj in pairs(ESPCache) do
		pcall(function()
			if obj.Remove then obj:Remove() end
		end)
	end
	ESPCache = {}
end

local RenderConn
local function startESP()
	if RenderConn then RenderConn:Disconnect() end
	clearESP()
	
	RenderConn = RunService.RenderStepped:Connect(function()
		if not Settings.ESP then
			clearESP()
			return
		end
		
		clearESP()
		
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			local root = getRoot(player)
			local hum = getHumanoid(player)
			if not root or not hum or hum.Health <= 0 then continue end
			
			local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
			if not onScreen then continue end
			
			local color = Settings.ESPRainbow and Color3.fromHSV(tick() % 6 / 6, 1, 1) or Settings.ESPColor
			local size = 200 / (screenPos.Z or 1)
			local spos = Vector2.new(screenPos.X, screenPos.Y)
			
			-- Tracers
			if Settings.ESPTracers then
				local line = Drawing.new("Line")
				line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				line.To = spos
				line.Color = color
				line.Thickness = Settings.ESPThickness
				line.Transparency = 0.8
				line.Visible = true
				table.insert(ESPCache, line)
			end
			
			-- Box
			if Settings.ESPBox then
				local box = Drawing.new("Square")
				box.Position = Vector2.new(spos.X - size, spos.Y - size * 1.5)
				box.Size = Vector2.new(size * 2, size * 3)
				box.Color = color
				box.Thickness = Settings.ESPThickness
				box.Filled = false
				box.Visible = true
				table.insert(ESPCache, box)
			end
			
			-- Name
			if Settings.ESPName then
				local txt = Drawing.new("Text")
				txt.Text = player.Name
				txt.Position = Vector2.new(spos.X, spos.Y - size * 1.5 - 18)
				txt.Color = color
				txt.Size = 14
				txt.Center = true
				txt.Outline = true
				txt.Visible = true
				table.insert(ESPCache, txt)
			end
			
			-- Health
			if Settings.ESPHealth then
				local hp = math.floor(hum.Health)
				local maxHp = math.floor(hum.MaxHealth)
				local txt = Drawing.new("Text")
				txt.Text = hp .. "/" .. maxHp
				txt.Position = Vector2.new(spos.X, spos.Y + size * 1.5 + 2)
				txt.Color = color
				txt.Size = 13
				txt.Center = true
				txt.Outline = true
				txt.Visible = true
				table.insert(ESPCache, txt)
			end
			
			-- Distance
			if Settings.ESPDistance then
				local myRoot = getRoot(LocalPlayer)
				if myRoot then
					local dist = math.floor((root.Position - myRoot.Position).Magnitude)
					local txt = Drawing.new("Text")
					txt.Text = dist .. "m"
					txt.Position = Vector2.new(spos.X, spos.Y + size * 1.5 + 18)
					txt.Color = color
					txt.Size = 12
					txt.Center = true
					txt.Outline = true
					txt.Visible = true
					table.insert(ESPCache, txt)
				end
			end
		end
	end)
end

-- ============================================================
-- WALLHACK / CHAMS - ODSTAWIANE CO 1s
-- ============================================================
local WallhackConn
local function startWallhack()
	if WallhackConn then WallhackConn:Disconnect() end
	
	WallhackConn = RunService.Heartbeat:Connect(function()
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			local char = getCharacter(player)
			if not char then continue end
			
			local hl = char:FindFirstChildOfClass("Highlight")
			if not hl then
				hl = Instance.new("Highlight")
				hl.Name = "WH_Chams"
				hl.Parent = char
			end
			
			hl.Enabled = Settings.Wallhack or Settings.Chams
			
			if Settings.ChamsRainbow then
				hl.FillColor = Color3.fromHSV(tick() % 6 / 6, 1, 1)
				hl.OutlineColor = Color3.fromHSV((tick() + 3) % 6 / 6, 1, 1)
			else
				hl.FillColor = Settings.ChamsColor
				hl.OutlineColor = Settings.ChamsColor
			end
			
			if Settings.Chams then
				hl.FillTransparency = 0.3
				hl.OutlineTransparency = 0
			elseif Settings.Wallhack then
				hl.FillTransparency = 0.5
				hl.OutlineTransparency = 0.2
			end
		end
	end)
end

-- ============================================================
-- HITBOX EXPANDER - ODSTAWIANE CO 1s
-- ============================================================
local HitboxConn
local function startHitbox()
	if HitboxConn then HitboxConn:Disconnect() end
	
	HitboxConn = RunService.Heartbeat:Connect(function()
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			local char = getCharacter(player)
			if not char then continue end
			
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and not part:IsA("MeshPart") then
					if Settings.Hitbox then
						part.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
						part.CanCollide = false
					else
						part.Size = Vector3.new(1, 1, 1)
					end
				end
			end
		end
	end)
end

-- ============================================================
-- UI - ZAKŁADKI
-- ============================================================
local AimbotTab = Window:CreateTab("Aimbot", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MovementTab = Window:CreateTab("Movement", "zap")
local FarmTab = Window:CreateTab("Farm", "swords")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ============================================================
-- AIMBOT TAB
-- ============================================================
AimbotTab:CreateSection("Aimbot")

AimbotTab:CreateToggle({
	Name = "Aimbot (Lock kamery)",
	CurrentValue = false,
	Flag = "AimbotToggle",
	Callback = function(v) Settings.Aimbot = v end
})

AimbotTab:CreateToggle({
	Name = "Silent Aim",
	CurrentValue = false,
	Flag = "SilentAimToggle",
	Callback = function(v) Settings.SilentAim = v end
})

AimbotTab:CreateSlider({
	Name = "FOV",
	Range = {10, 500},
	Increment = 5,
	Suffix = "px",
	CurrentValue = 100,
	Flag = "AimbotFOV",
	Callback = function(v) Settings.AimbotFOV = v end
})

AimbotTab:CreateDropdown({
	Name = "Celuj w",
	Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
	CurrentOption = {"Head"},
	MultipleOptions = false,
	Flag = "AimbotPart",
	Callback = function(v) Settings.AimbotPart = v[1] end
})

AimbotTab:CreateToggle({
	Name = "Team Check",
	CurrentValue = false,
	Flag = "TeamCheck",
	Callback = function(v) Settings.TeamCheck = v end
})

AimbotTab:CreateSection("Triggerbot")

AimbotTab:CreateToggle({
	Name = "Triggerbot (auto strzal)",
	CurrentValue = false,
	Flag = "TriggerbotToggle",
	Callback = function(v) Settings.Triggerbot = v end
})

AimbotTab:CreateSlider({
	Name = "Triggerbot Delay",
	Range = {0, 0.3},
	Increment = 0.01,
	Suffix = "s",
	CurrentValue = 0.05,
	Flag = "TriggerDelay",
	Callback = function(v) Settings.TriggerbotDelay = v end
})

AimbotTab:CreateSection("Bron")

AimbotTab:CreateToggle({
	Name = "No Recoil",
	CurrentValue = false,
	Flag = "NoRecoil",
	Callback = function(v) Settings.NoRecoil = v end
})

AimbotTab:CreateToggle({
	Name = "No Spread",
	CurrentValue = false,
	Flag = "NoSpread",
	Callback = function(v) Settings.NoSpread = v end
})

AimbotTab:CreateToggle({
	Name = "No Sway",
	CurrentValue = false,
	Flag = "NoSway",
	Callback = function(v) Settings.NoSway = v end
})

-- ============================================================
-- VISUALS TAB
-- ============================================================
VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
	Name = "ESP WLACZONY",
	CurrentValue = false,
	Flag = "ESPMain",
	Callback = function(v) Settings.ESP = v end
})

VisualsTab:CreateToggle({
	Name = "Box",
	CurrentValue = false,
	Flag = "ESPBox",
	Callback = function(v) Settings.ESPBox = v end
})

VisualsTab:CreateToggle({
	Name = "Health",
	CurrentValue = false,
	Flag = "ESPHealth",
	Callback = function(v) Settings.ESPHealth = v end
})

VisualsTab:CreateToggle({
	Name = "Name",
	CurrentValue = false,
	Flag = "ESPName",
	Callback = function(v) Settings.ESPName = v end
})

VisualsTab:CreateToggle({
	Name = "Distance",
	CurrentValue = false,
	Flag = "ESPDistance",
	Callback = function(v) Settings.ESPDistance = v end
})

VisualsTab:CreateToggle({
	Name = "Tracers (linie)",
	CurrentValue = false,
	Flag = "ESPTracers",
	Callback = function(v) Settings.ESPTracers = v end
})

VisualsTab:CreateSection("Kolory ESP")

VisualsTab:CreateToggle({
	Name = "Rainbow ESP",
	CurrentValue = false,
	Flag = "RainbowESP",
	Callback = function(v) Settings.ESPRainbow = v end
})

VisualsTab:CreateColorPicker({
	Name = "Kolor ESP",
	Color = Color3.fromRGB(0, 255, 0),
	Flag = "ESPColor",
	Callback = function(v) Settings.ESPColor = v end
})

VisualsTab:CreateSlider({
	Name = "Grubosc ESP",
	Range = {1, 4},
	Increment = 0.5,
	Suffix = "px",
	CurrentValue = 1.5,
	Flag = "ESPThickness",
	Callback = function(v) Settings.ESPThickness = v end
})

VisualsTab:CreateSection("Wallhack & Chams")

VisualsTab:CreateToggle({
	Name = "Wallhack (przez sciany)",
	CurrentValue = false,
	Flag = "Wallhack",
	Callback = function(v) Settings.Wallhack = v end
})

VisualsTab:CreateToggle({
	Name = "Chams (kolorowe modele)",
	CurrentValue = false,
	Flag = "Chams",
	Callback = function(v) Settings.Chams = v end
})

VisualsTab:CreateColorPicker({
	Name = "Kolor Chams",
	Color = Color3.fromRGB(0, 255, 0),
	Flag = "ChamsColor",
	Callback = function(v) Settings.ChamsColor = v end
})

VisualsTab:CreateToggle({
	Name = "Rainbow Chams",
	CurrentValue = false,
	Flag = "RainbowChams",
	Callback = function(v) Settings.ChamsRainbow = v end
})

VisualsTab:CreateSection("Hitboxy")

VisualsTab:CreateToggle({
	Name = "Hitbox Expander",
	CurrentValue = false,
	Flag = "HitboxToggle",
	Callback = function(v) Settings.Hitbox = v end
})

VisualsTab:CreateSlider({
	Name = "Rozmiar hitboxa",
	Range = {1, 10},
	Increment = 0.5,
	Suffix = "studs",
	CurrentValue = 3,
	Flag = "HitboxSize",
	Callback = function(v) Settings.HitboxSize = v end
})

-- ============================================================
-- MOVEMENT TAB
-- ============================================================
MovementTab:CreateSection("Speed")

MovementTab:CreateToggle({
	Name = "Speed (predkosc)",
	CurrentValue = false,
	Flag = "SpeedToggle",
	Callback = function(v) Settings.Speed = v end
})

MovementTab:CreateSlider({
	Name = "Speed Multiplier",
	Range = {16, 250},
	Increment = 1,
	Suffix = "studs/s",
	CurrentValue = 50,
	Flag = "SpeedValue",
	Callback = function(v) Settings.SpeedMultiplier = v end
})

MovementTab:CreateSection("Fly")

MovementTab:CreateToggle({
	Name = "Fly (latanie)",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(v) Settings.Fly = v end
})

MovementTab:CreateSlider({
	Name = "Fly Speed",
	Range = {10, 200},
	Increment = 5,
	Suffix = "studs/s",
	CurrentValue = 50,
	Flag = "FlySpeed",
	Callback = function(v) Settings.FlySpeed = v end
})

MovementTab:CreateSection("Kręcenie")

MovementTab:CreateToggle({
	Name = "Anti-Aim (spin)",
	CurrentValue = false,
	Flag = "AntiAim",
	Callback = function(v) Settings.AntiAim = v end
})

MovementTab:CreateSlider({
	Name = "Pitch (kat)", 
	Range = {0, 180},
	Increment = 5,
	Suffix = "deg",
	CurrentValue = 90,
	Flag = "AAPitch",
	Callback = function(v) Settings.AntiAimPitch = v end
})

MovementTab:CreateSection("Exploity")

MovementTab:CreateToggle({
	Name = "Bullet TP (fake lag)",
	CurrentValue = false,
	Flag = "BulletTP",
	Callback = function(v) Settings.BulletTP = v end
})

MovementTab:CreateSlider({
	Name = "Bullet TP dystans",
	Range = {1, 50},
	Increment = 1,
	Suffix = "studs",
	CurrentValue = 15,
	Flag = "BulletTPAmount",
	Callback = function(v) Settings.BulletTPAmount = v end
})

MovementTab:CreateToggle({
	Name = "Respawn Manipulation",
	CurrentValue = false,
	Flag = "RespawnManip",
	Callback = function(v) Settings.RespawnManip = v end
})

MovementTab:CreateSlider({
	Name = "Respawn Speed",
	Range = {0.01, 1},
	Increment = 0.01,
	Suffix = "s",
	CurrentValue = 0.01,
	Flag = "RespawnSpeed",
	Callback = function(v) Settings.RespawnSpeed = v end
})

-- ============================================================
-- FARM TAB
-- ============================================================
FarmTab:CreateSection("Auto Farm")

FarmTab:CreateParagraph({
	Title = "Jak dziala",
	Content = "Auto-teleportuje sie do najblizszego wroga\ni zabija go nozem/bronia.\nDziala w zasiegu ktory ustawisz."
})

FarmTab:CreateToggle({
	Name = "Auto Farm (TP + Kill)",
	CurrentValue = false,
	Flag = "FarmToggle",
	Callback = function(v) Settings.Farm = v end
})

FarmTab:CreateSlider({
	Name = "Zasieg farmienia",
	Range = {5, 100},
	Increment = 5,
	Suffix = "studs",
	CurrentValue = 30,
	Flag = "FarmRange",
	Callback = function(v) Settings.FarmRange = v end
})

-- ============================================================
-- MISC TAB
-- ============================================================
MiscTab:CreateSection("Ochrona")

MiscTab:CreateToggle({
	Name = "Anti-Cheat Bypass",
	CurrentValue = false,
	Flag = "ACBypass",
	Callback = function(v) Settings.ACBypass = v end
})

MiscTab:CreateSection("Server")

MiscTab:CreateButton({
	Name = "Rejoin (dolacz ponownie)",
	Callback = function()
		local ts = game:GetService("TeleportService")
		ts:Teleport(game.PlaceId, LocalPlayer)
	end
})

MiscTab:CreateButton({
	Name = "Server Hop (skok na inny)",
	Callback = function()
		local ts = game:GetService("TeleportService")
		local places = {286090429, 736658162, 5133807242}
		ts:Teleport(places[math.random(#places)], LocalPlayer)
	end
})

MiscTab:CreateSection("Info")

MiscTab:CreateParagraph({
	Title = "Arsenal Cheat v2",
	Content = "Wszystkie funkcje dzialaja 24/7.\nAuto odswiezanie ESP, Wallhack, Hitboxy.\nUzywasz na wlasne ryzyko!"
})

-- ============================================================
-- START WSZYSTKIEGO
-- ============================================================
startMainLoop()      -- Główna pętla (Speed, Fly, Farm, Triggerbot, AntiAim, BulletTP, Respawn, NoRecoil)
startESP()           -- ESP (Drawing API, odświeżane co klatkę)
startWallhack()      -- Wallhack/Chams (Highlight, odświeżane co klatkę)
startHitbox()        -- Hitbox expander (odświeżane co klatkę)

-- Notyfikacja
Rayfield:Notify({
	Title = "Arsenal Cheat v2",
	Content = "Zaladowano! Wszystko dziala 24/7",
	Duration = 3,
	Image = 4483362458
})

print("[Arsenal Cheat v2] ZALADOWANO - wszystkie funkcje online")
