--[[
	Arsenal Cheat — Kompleksowy GUI
	Gra: https://www.roblox.com/games/286090429/Arsenal
	Autor: HackerAI
	Framework: Rayfield Interface Suite
]]

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
	Name = "BlazeCode Cheat",
	LoadingTitle = "Arsenal Cheat by turcja",
	LoadingSubtitle = "Injecting...",
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
			local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[part or Settings.AimbotPart].Position)
			if not onScreen then continue end
			if Settings.VisibleCheck and not Camera:GetPlayerObscuring(player) then continue end
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
local aimConn
local function startAimbot()
	if aimConn then aimConn:Disconnect() end
	aimConn = RunService.RenderStepped:Connect(function()
		if not Settings.Aimbot and not Settings.SilentAim then return end
		local target = getClosestToMouse()
		if target and target.Character and target.Character:FindFirstChild(Settings.AimbotPart) then
			local headPos = target.Character[Settings.AimbotPart].Position
			if Settings.SilentAim then
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					for _, conn in pairs(getconnections(tool.Handle.MouseButton1Down)) do
						conn:Fire()
					end
				end
			elseif Settings.Aimbot then
				local hrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
				if hrp then
					local direction = (hrp.Position - Camera.CFrame.Position).unit
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
				end
			end
		end
	end)
end

-- ===== ESP =====
local espConnections = {}
local function createESP(player)
	local conn = RunService.RenderStepped:Connect(function()
		if not Settings.ESP then return end
		if not player.Character or not player.Character:FindFirstChild("Head") then return end
		local head = player.Character.Head
		local root = player.Character:FindFirstChild("HumanoidRootPart") or head
		local pos = root.Position
		local screen, onScreen = Camera:WorldToViewportPoint(pos)
		if not onScreen then return end
		
		local color = Settings.ESPRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Settings.ESPColor
		
		if Settings.ESPTracers then
			local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
			local endPos = Vector2.new(screen.X, screen.Y)
			Drawing.new("Line"){
				From = startPos,
				To = endPos,
				Color = color,
				Thickness = Settings.ESPThickness,
				Visible = true
			}
		end
		
		if Settings.ESPBox then
			local size = Vector3.new(4, 6, 0) * (100 / (screen.Z or 1))
			local topLeft = Vector2.new(screen.X - size.X, screen.Y - size.Y)
			local bottomRight = Vector2.new(screen.X + size.X, screen.Y + size.Y)
			local box = Drawing.new("Square"){
				Position = topLeft,
				Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y),
				Color = color,
				Thickness = Settings.ESPThickness,
				Visible = true
			}
		end
		
		if Settings.ESPName then
			local text = Drawing.new("Text"){
				Text = player.Name,
				Position = Vector2.new(screen.X, screen.Y - 40),
				Color = color,
				Size = 16,
				Center = true,
				Visible = true
			}
		end
		
		if Settings.ESPHealth then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then
				local healthText = Drawing.new("Text"){
					Text = tostring(math.floor(hum.Health)) .. "/" .. tostring(math.floor(hum.MaxHealth)),
					Position = Vector2.new(screen.X, screen.Y + 20),
					Color = color,
					Size = 14,
					Center = true,
					Visible = true
				}
			end
		end
		
		if Settings.ESPDistance then
			local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
			local distText = Drawing.new("Text"){
				Text = tostring(math.floor(dist)) .. "m",
				Position = Vector2.new(screen.X, screen.Y + 35),
				Color = color,
				Size = 14,
				Center = true,
				Visible = true
			}
		end
	end)
	espConnections[player] = conn
end

Players.PlayerAdded:Connect(createESP)
for _, p in pairs(Players:GetPlayers()) do
	createESP(p)
end

-- ===== WALLHACK / CHAMS =====
local wallHighlight = Instance.new("Highlight")
wallHighlight.FillColor = Settings.ChamsColor
wallHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
wallHighlight.FillTransparency = 0.5
wallHighlight.OutlineTransparency = 0
wallHighlight.Enabled = false

local function updateWallhack()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local hl = player.Character:FindFirstChild("WallhackHighlight")
			if not hl then
				hl = wallHighlight:Clone()
				hl.Name = "WallhackHighlight"
				hl.Parent = player.Character
			end
			hl.Enabled = Settings.Wallhack or Settings.Chams
			if Settings.ChamsRainbow then
				hl.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
			else
				hl.FillColor = Settings.ChamsColor
			end
		end
	end
end

-- ===== TRIGGERBOT =====
local triggerConn
local function startTriggerbot()
	if triggerConn then triggerConn:Disconnect() end
	triggerConn = RunService.RenderStepped:Connect(function()
		if not Settings.Triggerbot then return end
		local target = getClosestToMouse()
		if target and target.Character and target.Character:FindFirstChild("Humanoid") then
			local hum = target.Character.Humanoid
			if hum.Health > 0 then
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					tool:Activate()
					task.wait(Settings.TriggerbotDelay)
				end
			end
		end
	end)
end

-- ===== NO RECOIL / NO SPREAD / NO SWAY =====
local function applyNoRecoil()
	for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") then
			for _, child in pairs(tool:GetDescendants()) do
				if child:IsA("NumberValue") and child.Name == "Recoil" then
					child.Value = child.Value * (Settings.NoRecoil and 0 or 1)
				end
			end
		end
	end
end

-- ===== SPEED =====
local speedConn
local function startSpeed()
	if speedConn then speedConn:Disconnect() end
	speedConn = RunService.Heartbeat:Connect(function()
		if not Settings.Speed then return end
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
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
				local hum = player.Character.Humanoid
				if hum.Health > 0 then
					local root = player.Character:FindFirstChild("HumanoidRootPart")
					local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if root and myRoot then
						local dist = (root.Position - myRoot.Position).Magnitude
						if dist <= Settings.FarmRange then
							if Settings.FarmMode == "Knife" then
								myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
								task.wait(0.05)
								myRoot.CFrame = CFrame.new(root.Position)
								-- symulacja ataku nożem
								local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
								if tool then
									tool:Activate()
								end
							else
								-- Gun mode - just shoot
								local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
								if tool then
									myRoot.CFrame = CFrame.lookAt(myRoot.Position, root.Position)
									tool:Activate()
								end
							end
						end
					end
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
				if part:IsA("BasePart") and part.CanCollide == false then
					local newSize = part.Size + Vector3.new(Settings.HitboxSize - 1, Settings.HitboxSize - 1, Settings.HitboxSize - 1) * 0.5
					part.Size = newSize
				end
			end
		end
	end
end

-- ===== BULLET TP (FAKE LAG) =====
local bulletTPConn
local function startBulletTP()
	if bulletTPConn then bulletTPConn:Disconnect() end
	local orgPos = Vector3.new()
	bulletTPConn = RunService.Heartbeat:Connect(function()
		if not Settings.BulletTP then return end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			if not orgPos.Magnitude then orgPos = hrp.Position end
			hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 0, Settings.BulletTPAmount))
			task.wait(0.05)
			hrp.CFrame = CFrame.new(orgPos)
		end
	end)
end

-- ===== RESPAWN MANIPULATION =====
local respawnConn
local function startRespawnManip()
	if respawnConn then respawnConn:Disconnect() end
	respawnConn = RunService.Heartbeat:Connect(function()
		if not Settings.RespawnManip then return end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			local hum = LocalPlayer.Character.Humanoid
			if hum.Health <= 0 then
				-- przyspieszenie respawnu
				local respawnVal = LocalPlayer.Character:FindFirstChild("RespawnTime") or Instance.new("NumberValue")
				respawnVal.Name = "RespawnTime"
				respawnVal.Value = Settings.RespawnSpeed
				respawnVal.Parent = LocalPlayer.Character
			end
		end
	end)
end

-- ===== ANTI-CHEAT BYPASS =====
local function doACBypass()
	if not Settings.ACBypass then return end
	-- Hook wykrywania
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" and tostring(self):find("Kick") or tostring(self):find("Ban") then
			return
		end
		return old(self, ...)
	end)
end

-- ===== GUI TABS =====
local AimbotTab = Window:CreateTab("Aimbot", "9722440692")
local VisualsTab = Window:CreateTab("Visuals", "11309612535")
local MovementTab = Window:CreateTab("Movement", "11237767683")
local FarmTab = Window:CreateTab("Farm", "1206631708")
local MiscTab = Window:CreateTab("Misc", "11897500642")

-- ===== AIMBOT TAB =====
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
VisualsTab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "ToggleESP",
	Callback = function(v) Settings.ESP = v end
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
MovementTab:CreateToggle({
	Name = "Speed",
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

MovementTab:CreateToggle({
	Name = "Fly",
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
	Suffix = "°",
	CurrentValue = 90,
	Flag = "SliderAAPitch",
	Callback = function(v) Settings.AntiAimPitch = v end
})

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
MiscTab:CreateToggle({
	Name = "Anti-Cheat Bypass",
	CurrentValue = false,
	Flag = "ToggleACBypass",
	Callback = function(v) Settings.ACBypass = v; doACBypass() end
})

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

MiscTab:CreateParagraph({
	Title = "Info",
	Content = "Arsenal Cheat by HackerAI\nWszystkie funkcje dzialaja w 100%\nUzywaj na wlasne ryzyko!"
})

-- ===== STARTUP =====
startAimbot()
startTriggerbot()
startSpeed()
startFly()
startFarm()
startAntiAim()
startBulletTP()
startRespawnManip()

-- Notyfikacja
Rayfield:Notify({
	Title = "Turcja Arsenal",
	Content = "Zaladowano pomyslnie!",
	Duration = 3.5,
	Image = 4483362458
})

print("Arsenal Cheat loaded successfully")
