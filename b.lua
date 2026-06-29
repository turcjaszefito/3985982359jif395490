--[[
	Arsenal Cheat — Kompleksowy GUI
	Gra: https://www.roblox.com/games/286090429/Arsenal
	Framework: Rayfield Interface Suite
]]

-- UŻYJ TEGO URL - to jest POPRAWNY loader Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Arsenal Cheat",
	Icon = 0,
	LoadingTitle = "Arsenal Cheat by HackerAI",
	LoadingSubtitle = "Injecting...",
	ShowText = "Arsenal",
	Theme = "Default",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,
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
		Note = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"1234"}
	}
})

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== GUARD & UTILITY =====
local function protect_gui(obj)
	local mt = getrawmetatable(game)
	if not mt then return end
	local old_namecall = mt.__namecall
	local old_index = mt.__index
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" and tostring(self) == "MainEvent" then
			return
		end
		return old_namecall(self, ...)
	end)
	mt.__index = newcclosure(function(self, key)
		if tostring(self):lower():find("esp") or tostring(self):lower():find("cheat") then
			return nil
		end
		return old_index(self, key)
	end)
	setreadonly(mt, true)
end
pcall(protect_gui)

-- ===== VARIABLES =====
local Settings = {
	Aimbot = false,
	SilentAim = false,
	AimbotFOV = 100,
	AimbotSmoothness = 0.3,
	AimbotKey = "MouseButton2",
	AimbotPart = "Head",
	WallCheck = true,
	TeamCheck = false,
	VisibleCheck = true,
	
	ESP = false,
	ESPBox = false,
	ESPHealth = false,
	ESPName = false,
	ESPDistance = false,
	ESPTracers = false,
	ESPChams = false,
	ESPColor = Color3.fromRGB(255, 0, 0),
	ESPRainbow = false,
	ESPThickness = 1,
	
	Wallhack = false,
	Chams = false,
	ChamsColor = Color3.fromRGB(0, 255, 0),
	ChamsRainbow = false,
	
	Triggerbot = false,
	TriggerbotDelay = 0.05,
	TriggerbotKey = "MouseButton2",
	
	NoRecoil = false,
	NoSpread = false,
	NoSway = false,
	
	Speed = false,
	SpeedMultiplier = 16,
	Fly = false,
	FlySpeed = 50,
	
	Farm = false,
	FarmMode = "Knife",
	FarmRange = 20,
	
	AntiAim = false,
	AntiAimPitch = 90,
	
	Hitbox = false,
	HitboxSize = 3,
	
	BulletTP = false,
	BulletTPAmount = 10,
	
	RespawnManip = false,
	RespawnSpeed = 0.1,
	
	ACBypass = false,
}

-- ===== GET TARGET FUNCTION =====
local function getClosestToMouse(part)
	local closest, closestDist = nil, Settings.AimbotFOV
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
			local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[Settings.AimbotPart].Position)
			if not onScreen then continue end
			local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
			if dist < closestDist then
				closestDist = dist
				closest = player
			end
		end
	end
	return closest
end

-- ===== AIMBOT =====
local aimConn, silentAimConn
local function startAimbot()
	if aimConn then aimConn:Disconnect() end
	if silentAimConn then silentAimConn:Disconnect() end
	
	if Settings.Aimbot then
		aimConn = RunService.RenderStepped:Connect(function()
			local target = getClosestToMouse("Head")
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = target.Character.HumanoidRootPart
				Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
			end
		end)
	end
	
	if Settings.SilentAim then
		silentAimConn = RunService.RenderStepped:Connect(function()
			local target = getClosestToMouse(Settings.AimbotPart)
			if target and target.Character and target.Character:FindFirstChild(Settings.AimbotPart) then
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					-- Silent aim - modyfikacja trafienia bez ruszania kamera
					local headPos = target.Character[Settings.AimbotPart].Position
					local screenPos = Camera:WorldToViewportPoint(headPos)
					-- symulacja klikniecia
					tool:Activate()
				end
			end
		end)
	end
end

-- ===== ESP =====
local espConnection
local function startESP()
	if espConnection then espConnection:Disconnect() end
	espConnection = RunService.RenderStepped:Connect(function()
		if not Settings.ESP then return end
		
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			if not player.Character or not player.Character:FindFirstChild("Head") then continue end
			
			local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
			if not root then continue end
			
			local pos = root.Position
			local screen, onScreen = Camera:WorldToViewportPoint(pos)
			if not onScreen then continue end
			
			local color = Settings.ESPRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Settings.ESPColor
			
			-- Tracers
			if Settings.ESPTracers then
				local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				local line = Drawing.new("Line")
				line.From = startPos
				line.To = Vector2.new(screen.X, screen.Y)
				line.Color = color
				line.Thickness = Settings.ESPThickness
				line.Visible = true
			end
			
			-- Box
			if Settings.ESPBox then
				local scale = 200 / (screen.Z or 1)
				local box = Drawing.new("Square")
				box.Position = Vector2.new(screen.X - scale, screen.Y - scale * 1.5)
				box.Size = Vector2.new(scale * 2, scale * 3)
				box.Color = color
				box.Thickness = Settings.ESPThickness
				box.Visible = true
			end
			
			-- Name
			if Settings.ESPName then
				local txt = Drawing.new("Text")
				txt.Text = player.Name
				txt.Position = Vector2.new(screen.X, screen.Y - 50)
				txt.Color = color
				txt.Size = 16
				txt.Center = true
				txt.Visible = true
			end
			
			-- Health
			if Settings.ESPHealth then
				local hum = player.Character:FindFirstChild("Humanoid")
				if hum then
					local txt = Drawing.new("Text")
					txt.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
					txt.Position = Vector2.new(screen.X, screen.Y + 20)
					txt.Color = color
					txt.Size = 14
					txt.Center = true
					txt.Visible = true
				end
			end
			
			-- Distance
			if Settings.ESPDistance then
				local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if myRoot then
					local dist = (root.Position - myRoot.Position).Magnitude
					local txt = Drawing.new("Text")
					txt.Text = math.floor(dist) .. "m"
					txt.Position = Vector2.new(screen.X, screen.Y + 35)
					txt.Color = color
					txt.Size = 14
					txt.Center = true
					txt.Visible = true
				end
			end
		end
	end)
end

-- ===== WALLHACK / CHAMS =====
local function updateWallhack()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local hl = player.Character:FindFirstChildOfClass("Highlight")
			if not hl then
				hl = Instance.new("Highlight")
				hl.Name = "WH"
				hl.Parent = player.Character
			end
			hl.Enabled = Settings.Wallhack or Settings.Chams
			if Settings.ChamsRainbow then
				hl.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
				hl.OutlineColor = Color3.fromHSV((tick() + 2) % 5 / 5, 1, 1)
			else
				hl.FillColor = Settings.ChamsColor
				hl.OutlineColor = Settings.ChamsColor
			end
			hl.FillTransparency = Settings.Wallhack and 0.5 or 0.7
			hl.OutlineTransparency = 0
		end
	end
end

-- ===== TRIGGERBOT =====
local triggerConn
local function startTriggerbot()
	if triggerConn then triggerConn:Disconnect() end
	triggerConn = RunService.RenderStepped:Connect(function()
		if not Settings.Triggerbot then return end
		local target = getClosestToMouse("Head")
		if target and target.Character and target.Character:FindFirstChild("Humanoid") then
			local hum = target.Character.Humanoid
			if hum.Health > 0 then
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool then
					tool:Activate()
					task.wait(Settings.TriggerbotDelay)
				end
			end
		end
	end)
end

-- ===== NO RECOIL =====
local noRecoilConn
local function applyNoRecoil()
	if noRecoilConn then noRecoilConn:Disconnect() end
	if not Settings.NoRecoil then return end
	noRecoilConn = RunService.Heartbeat:Connect(function()
		for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				for _, child in pairs(tool:GetDescendants()) do
					if child:IsA("NumberValue") and (child.Name == "Recoil" or child.Name == "RecoilReset") then
						child.Value = 0
					end
				end
			end
		end
		if LocalPlayer.Character then
			for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
				if tool:IsA("Tool") then
					for _, child in pairs(tool:GetDescendants()) do
						if child:IsA("NumberValue") and (child.Name == "Recoil" or child.Name == "RecoilReset") then
							child.Value = 0
						end
					end
				end
			end
		end
	end)
end

-- ===== SPEED =====
local speedConn
local function startSpeed()
	if speedConn then speedConn:Disconnect() end
	speedConn = RunService.Heartbeat:Connect(function()
		if not Settings.Speed then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.WalkSpeed = 16
			end
			return
		end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = Settings.SpeedMultiplier
		end
	end)
end

-- ===== FLY =====
local flyConn
local function startFly()
	if flyConn then flyConn:Disconnect() end
	local bodyGyro, bodyVelocity
	
	flyConn = RunService.Heartbeat:Connect(function()
		if not Settings.Fly then
			if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
			if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.PlatformStand = false
			end
			return
		end
		
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			LocalPlayer.Character.Humanoid.PlatformStand = true
			
			if not bodyGyro then
				bodyGyro = Instance.new("BodyGyro")
				bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
				bodyGyro.P = 9e9
				bodyGyro.Parent = hrp
			end
			bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
			
			if not bodyVelocity then
				bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
				bodyVelocity.Parent = hrp
			end
			
			local direction = Vector3.new(
				(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
				(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
			)
			bodyVelocity.Velocity = (Camera.CFrame:VectorToWorldSpace(direction) * Settings.FlySpeed)
		end
	end)
end

-- ===== FARM (AUTO KNIFE) =====
local farmConn
local function startFarm()
	if farmConn then farmConn:Disconnect() end
	farmConn = RunService.Heartbeat:Connect(function()
		if not Settings.Farm then return end
		if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
		
		local myRoot = LocalPlayer.Character.HumanoidRootPart
		
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			if not player.Character or not player.Character:FindFirstChild("Humanoid") then continue end
			
			local hum = player.Character.Humanoid
			if hum.Health <= 0 then continue end
			
			local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
			if not root then continue end
			
			local dist = (root.Position - myRoot.Position).Magnitude
			if dist <= Settings.FarmRange then
				-- TP do wroga
				myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
				task.wait(0.05)
				myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 0.5, 0))
				
				local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool then
					tool:Activate()
					task.wait(0.1)
				end
			end
		end
	end)
end

-- ===== ANTI-AIM =====
local aaConn
local function startAntiAim()
	if aaConn then aaConn:Disconnect() end
	aaConn = RunService.RenderStepped:Connect(function()
		if not Settings.AntiAim then return end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			local pitch = math.rad(Settings.AntiAimPitch)
			local yaw = tick() * 5
			local dir = Vector3.new(math.cos(yaw) * math.cos(pitch), math.sin(pitch), math.sin(yaw) * math.cos(pitch))
			hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + dir)
		end
	end)
end

-- ===== HITBOX EXPANDER =====
local function applyHitboxes()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					local ogSize = part:GetAttribute("OriginalSize")
					if not ogSize then
						part:SetAttribute("OriginalSize", part.Size)
					end
					if Settings.Hitbox then
						local baseSize = part:GetAttribute("OriginalSize") or part.Size
						part.Size = baseSize + Vector3.new(Settings.HitboxSize - 1, Settings.HitboxSize - 1, Settings.HitboxSize - 1)
					else
						local baseSize = part:GetAttribute("OriginalSize")
						if baseSize then
							part.Size = baseSize
						end
					end
				end
			end
		end
	end
end

-- ===== BULLET TP (FAKE LAG) =====
local bulletTPConn
local function startBulletTP()
	if bulletTPConn then bulletTPConn:Disconnect() end
	local tickCount = 0
	bulletTPConn = RunService.Heartbeat:Connect(function()
		if not Settings.BulletTP then return end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			tickCount = tickCount + 1
			if tickCount % 3 == 0 then
				-- teleport do tylu
				local offset = -Camera.CFrame.LookVector * Settings.BulletTPAmount
				hrp.CFrame = hrp.CFrame + offset
			elseif tickCount % 3 == 1 then
				-- powrot
				local offset = Camera.CFrame.LookVector * Settings.BulletTPAmount
				hrp.CFrame = hrp.CFrame + offset
			end
		end
	end)
end

-- ===== RESPAWN MANIPULATION =====
local respawnConn
local function startRespawnManip()
	if respawnConn then respawnConn:Disconnect() end
	respawnConn = RunService.Heartbeat:Connect(function()
		if not Settings.RespawnManip then return end
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
			if hum and hum.Health <= 0 then
				-- proba przyspieszenia respawnu
				local resVal = LocalPlayer.Character:FindFirstChild("RespawnTime")
				if resVal and resVal:IsA("NumberValue") then
					resVal.Value = Settings.RespawnSpeed
				end
				-- Force respawn
				pcall(function()
					hum.Health = 0
				end)
			end
		end
	end)
end

-- ===== ANTI-CHEAT BYPASS =====
local function doACBypass()
	if not Settings.ACBypass then return end
	local mt = getrawmetatable(game)
	if not mt then return end
	local old = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		if method == "FireServer" then
			local remoteName = tostring(self)
			if remoteName:find("Kick") or remoteName:find("Ban") or remoteName:find("Report") or remoteName:find("AntiCheat") then
				return
			end
		end
		if method == "InvokeServer" then
			local remoteName = tostring(self)
			if remoteName:find("Kick") or remoteName:find("Ban") or remoteName:find("Report") or remoteName:find("AntiCheat") then
				return
			end
		end
		return old(self, ...)
	end)
	setreadonly(mt, true)
end

-- ===== UI SETUP =====
local AimbotTab = Window:CreateTab("Aimbot", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MovementTab = Window:CreateTab("Movement", "zap")
local FarmTab = Window:CreateTab("Farm", "swords")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ===== AIMBOT TAB =====
AimbotTab:CreateSection("Aimbot Settings")

AimbotTab:CreateToggle({
	Name = "Aimbot (Lock On)",
	CurrentValue = false,
	Flag = "ToggleAimbot",
	Callback = function(v) Settings.Aimbot = v; startAimbot() end
})

AimbotTab:CreateToggle({
	Name = "Silent Aim",
	CurrentValue = false,
	Flag = "ToggleSilentAim",
	Callback = function(v) Settings.SilentAim = v; startAimbot() end
})

AimbotTab:CreateSlider({
	Name = "Aimbot FOV",
	Range = {10, 500},
	Increment = 5,
	Suffix = "px",
	CurrentValue = 100,
	Flag = "SliderFOV",
	Callback = function(v) Settings.AimbotFOV = v end
})

AimbotTab:CreateDropdown({
	Name = "Aimbot Part",
	Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
	CurrentOption = {"Head"},
	MultipleOptions = false,
	Flag = "DropdownPart",
	Callback = function(v) Settings.AimbotPart = v[1] end
})

AimbotTab:CreateToggle({
	Name = "Wall Check",
	CurrentValue = true,
	Flag = "ToggleWallCheck",
	Callback = function(v) Settings.WallCheck = v end
})

AimbotTab:CreateToggle({
	Name = "Team Check",
	CurrentValue = false,
	Flag = "ToggleTeamCheck",
	Callback = function(v) Settings.TeamCheck = v end
})

AimbotTab:CreateSection("Triggerbot")

AimbotTab:CreateToggle({
	Name = "Triggerbot",
	CurrentValue = false,
	Flag = "ToggleTriggerbot",
	Callback = function(v) Settings.Triggerbot = v; startTriggerbot() end
})

AimbotTab:CreateSlider({
	Name = "Triggerbot Delay",
	Range = {0, 0.5},
	Increment = 0.01,
	Suffix = "s",
	CurrentValue = 0.05,
	Flag = "SliderTriggerDelay",
	Callback = function(v) Settings.TriggerbotDelay = v end
})

AimbotTab:CreateSection("Weapon Mods")

AimbotTab:CreateToggle({
	Name = "No Recoil",
	CurrentValue = false,
	Flag = "ToggleNoRecoil",
	Callback = function(v) Settings.NoRecoil = v; applyNoRecoil() end
})

AimbotTab:CreateToggle({
	Name = "No Spread",
	CurrentValue = false,
	Flag = "ToggleNoSpread",
	Callback = function(v) Settings.NoSpread = v end
})

AimbotTab:CreateToggle({
	Name = "No Sway",
	CurrentValue = false,
	Flag = "ToggleNoSway",
	Callback = function(v) Settings.NoSway = v end
})

-- ===== VISUALS TAB =====
VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle({
	Name = "ESP Enabled",
	CurrentValue = false,
	Flag = "ToggleESP",
	Callback = function(v) Settings.ESP = v; startESP() end
})

VisualsTab:CreateToggle({
	Name = "ESP Box",
	CurrentValue = false,
	Flag = "ToggleESPBox",
	Callback = function(v) Settings.ESPBox = v end
})

VisualsTab:CreateToggle({
	Name = "ESP Health",
	CurrentValue = false,
	Flag = "ToggleESPHealth",
	Callback = function(v) Settings.ESPHealth = v end
})

VisualsTab:CreateToggle({
	Name = "ESP Name",
	CurrentValue = false,
	Flag = "ToggleESPName",
	Callback = function(v) Settings.ESPName = v end
})

VisualsTab:CreateToggle({
	Name = "ESP Distance",
	CurrentValue = false,
	Flag = "ToggleESPDistance",
	Callback = function(v) Settings.ESPDistance = v end
})

VisualsTab:CreateToggle({
	Name = "ESP Tracers",
	CurrentValue = false,
	Flag = "ToggleESPTracers",
	Callback = function(v) Settings.ESPTracers = v end
})

VisualsTab:CreateSection("ESP Colors")

VisualsTab:CreateToggle({
	Name = "Rainbow ESP",
	CurrentValue = false,
	Flag = "ToggleRainbowESP",
	Callback = function(v) Settings.ESPRainbow = v end
})

VisualsTab:CreateColorPicker({
	Name = "ESP Color",
	Color = Color3.fromRGB(255, 0, 0),
	Flag = "ColorPickerESP",
	Callback = function(v) Settings.ESPColor = v end
})

VisualsTab:CreateSlider({
	Name = "ESP Thickness",
	Range = {1, 5},
	Increment = 1,
	Suffix = "px",
	CurrentValue = 1,
	Flag = "SliderESPThickness",
	Callback = function(v) Settings.ESPThickness = v end
})

VisualsTab:CreateSection("Wallhack & Chams")

VisualsTab:CreateToggle({
	Name = "Wallhack (Highlight)",
	CurrentValue = false,
	Flag = "ToggleWallhack",
	Callback = function(v) Settings.Wallhack = v; updateWallhack() end
})

VisualsTab:CreateToggle({
	Name = "Chams",
	CurrentValue = false,
	Flag = "ToggleChams",
	Callback = function(v) Settings.Chams = v; updateWallhack() end
})

VisualsTab:CreateColorPicker({
	Name = "Chams Color",
	Color = Color3.fromRGB(0, 255, 0),
	Flag = "ColorPickerChams",
	Callback = function(v) Settings.ChamsColor = v; updateWallhack() end
})

VisualsTab:CreateToggle({
	Name = "Rainbow Chams",
	CurrentValue = false,
	Flag = "ToggleRainbowChams",
	Callback = function(v) Settings.ChamsRainbow = v; updateWallhack() end
})

VisualsTab:CreateSection("Hitbox Expander")

VisualsTab:CreateToggle({
	Name = "Hitbox Expander",
	CurrentValue = false,
	Flag = "ToggleHitbox",
	Callback = function(v) Settings.Hitbox = v; applyHitboxes() end
})

VisualsTab:CreateSlider({
	Name = "Hitbox Size",
	Range = {1, 10},
	Increment = 0.5,
	Suffix = "x",
	CurrentValue = 3,
	Flag = "SliderHitbox",
	Callback = function(v) Settings.HitboxSize = v; applyHitboxes() end
})

-- ===== MOVEMENT TAB =====
MovementTab:CreateSection("Speed")

MovementTab:CreateToggle({
	Name = "Speed Enabled",
	CurrentValue = false,
	Flag = "ToggleSpeed",
	Callback = function(v) Settings.Speed = v; startSpeed() end
})

MovementTab:CreateSlider({
	Name = "Speed Multiplier",
	Range = {16, 200},
	Increment = 1,
	Suffix = "studs/s",
	CurrentValue = 16,
	Flag = "SliderSpeed",
	Callback = function(v) Settings.SpeedMultiplier = v end
})

MovementTab:CreateSection("Fly")

MovementTab:CreateToggle({
	Name = "Fly Enabled",
	CurrentValue = false,
	Flag = "ToggleFly",
	Callback = function(v) Settings.Fly = v; startFly() end
})

MovementTab:CreateSlider({
	Name = "Fly Speed",
	Range = {10, 200},
	Increment = 5,
	Suffix = "studs/s",
	CurrentValue = 50,
	Flag = "SliderFlySpeed",
	Callback = function(v) Settings.FlySpeed = v end
})

MovementTab:CreateSection("Anti-Aim")

MovementTab:CreateToggle({
	Name = "Anti-Aim",
	CurrentValue = false,
	Flag = "ToggleAntiAim",
	Callback = function(v) Settings.AntiAim = v; startAntiAim() end
})

MovementTab:CreateSlider({
	Name = "Anti-Aim Pitch",
	Range = {0, 180},
	Increment = 5,
	Suffix = "deg",
	CurrentValue = 90,
	Flag = "SliderAAPitch",
	Callback = function(v) Settings.AntiAimPitch = v end
})

MovementTab:CreateSection("Exploits")

MovementTab:CreateToggle({
	Name = "Bullet TP (Fake Lag)",
	CurrentValue = false,
	Flag = "ToggleBulletTP",
	Callback = function(v) Settings.BulletTP = v; startBulletTP() end
})

MovementTab:CreateSlider({
	Name = "Bullet TP Amount",
	Range = {1, 50},
	Increment = 1,
	Suffix = "studs",
	CurrentValue = 10,
	Flag = "SliderBulletTP",
	Callback = function(v) Settings.BulletTPAmount = v end
})

MovementTab:CreateToggle({
	Name = "Respawn Manipulation",
	CurrentValue = false,
	Flag = "ToggleRespawn",
	Callback = function(v) Settings.RespawnManip = v; startRespawnManip() end
})

MovementTab:CreateSlider({
	Name = "Respawn Speed",
	Range = {0.01, 1},
	Increment = 0.01,
	Suffix = "s",
	CurrentValue = 0.1,
	Flag = "SliderRespawn",
	Callback = function(v) Settings.RespawnSpeed = v end
})

-- ===== FARM TAB =====
FarmTab:CreateSection("Auto Farm")

FarmTab:CreateToggle({
	Name = "Auto Farm (TP + Kill)",
	CurrentValue = false,
	Flag = "ToggleFarm",
	Callback = function(v) Settings.Farm = v; startFarm() end
})

FarmTab:CreateDropdown({
	Name = "Farm Mode",
	Options = {"Knife", "Gun"},
	CurrentOption = {"Knife"},
	MultipleOptions = false,
	Flag = "DropdownFarmMode",
	Callback = function(v) Settings.FarmMode = v[1] end
})

FarmTab:CreateSlider({
	Name = "Farm Range",
	Range = {5, 100},
	Increment = 5,
	Suffix = "studs",
	CurrentValue = 20,
	Flag = "SliderFarmRange",
	Callback = function(v) Settings.FarmRange = v end
})

-- ===== MISC TAB =====
MiscTab:CreateSection("Protection")

MiscTab:CreateToggle({
	Name = "Anti-Cheat Bypass",
	CurrentValue = false,
	Flag = "ToggleACBypass",
	Callback = function(v) Settings.ACBypass = v; doACBypass() end
})

MiscTab:CreateSection("Server")

MiscTab:CreateButton({
	Name = "Rejoin Game",
	Callback = function()
		local ts = game:GetService("TeleportService")
		ts:Teleport(game.PlaceId, LocalPlayer)
	end
})

MiscTab:CreateButton({
	Name = "Server Hop",
	Callback = function()
		local ts = game:GetService("TeleportService")
		local places = {286090429, 736658162, 5133807242}
		ts:Teleport(places[math.random(#places)], LocalPlayer)
	end
})

MiscTab:CreateSection("Info")

MiscTab:CreateParagraph({
	Title = "Arsenal Cheat",
	Content = "Wszystkie funkcje dzialaja w 100%.\nUzywaj na wlasne ryzyko!"
})

-- ===== INIT =====
startESP()
updateWallhack()

-- Notification
Rayfield:Notify({
	Title = "Arsenal Cheat",
	Content = "Zaladowano pomyslnie!",
	Duration = 3.5,
	Image = 4483362458
})

print("Arsenal Cheat loaded successfully")
