-- ====== BLAZECODE X TURCJA - ADVANCED ROBLOX CHEAT ======
-- ====== ŁADOWANIE RAYFIELD ======
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
end)
if not success or not Rayfield then
    success, err = pcall(function()
        Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    end)
end
if not success or not Rayfield then
    success, err = pcall(function()
        Rayfield = loadstring(game:HttpGet("https://pastebin.com/raw/6R6U5Y3V"))()
    end)
end
if not Rayfield then
    warn("BlazeCode x Turcja: Nie udalo sie zaladowac Rayfield!")
    return
end

-- ====== KONFIGURACJA ======
local Window = Rayfield:CreateWindow({
    Name = "BlazeCode x Turcja 🇹🇷",
    Subtitle = "Advanced Pentest Suite",
    LoadingTitle = "BlazeCode x Turcja",
    LoadingSubtitle = "by BlazeCode",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BlazeCodeTurcja",
        FileName = "BlazeConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "BlazeCode x Turcja",
        Subtitle = "Klucz dostępu",
        Note = "Autoryzowany pentest",
        FileName = "BlazeKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"Blaze2026"}
    }
})

-- ====== ZMIENNE GLOBALNE ======
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local vimInput = game:GetService("VirtualInputManager")
local httpService = game:GetService("HttpService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local starterGui = game:GetService("StarterGui")
local marketplace = game:GetService("MarketplaceService")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")

local isAlive = true
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local wallhackEnabled = false
local espEnabled = false
local espObjects = {}
local aimbotEnabled = false
local silentAimEnabled = false
local aimbotFov = 90
local aimbotSmooth = 5
local speedEnabled = false
local speedMultiplier = 2
local speedFlyEnabled = false
local speedFlySpeed = 100
local chamsEnabled = false
local xrayEnabled = false
local fullbrightEnabled = false
local infiniteJumpEnabled = false
local autoParry = false
local noCooldown = false
local bringAllEnabled = false
local flingAllEnabled = false
local antiChatFilter = false
local bypassAntiCheat = false
local stepTarget = nil
local selectedPlayer = nil
local autoFarm = false
local noFallDamage = false
local triggerbotEnabled = false
local triggerbotFov = 60
local espLines = {}
local tracerEnabled = false
local healthBarEnabled = false
local boxEspEnabled = false
local nameEspEnabled = false
local distanceEspEnabled = false
local cFrameEspEnabled = false
local fovCircle = nil
local waterMark = nil
local teleportHotkey = Enum.KeyCode.T
local flyHotkey = Enum.KeyCode.Space
local noclipHotkey = Enum.KeyCode.N
local speedKey = Enum.KeyCode.LeftShift
local antiLock = true
local antiReport = true
local antiAFK = true
local autoRespawn = true
local autoStrangle = false
local noClipOnFly = true
local teleportOnClick = false
local allEspTags = {}

-- ====== FUNKCJE POMOCNICZE ======
function getCharacter(p)
    if p and p.Character then
        return p.Character
    end
    return nil
end

function getRoot(p)
    local c = getCharacter(p)
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
        if hrp then return hrp end
    end
    return nil
end

function getHumanoid(p)
    local c = getCharacter(p)
    if c then
        return c:FindFirstChildWhichIsA("Humanoid")
    end
    return nil
end

function isPlayerAlive(p)
    local h = getHumanoid(p)
    if h and h.Health > 0 then return true end
    return false
end

function notify(message, duration)
    duration = duration or 5
    pcall(function()
        starterGui:SetCore("SendNotification", {
            Title = "BlazeCode x Turcja",
            Text = message,
            Duration = duration
        })
    end)
end

function getClosestPlayer()
    local closest = nil
    local shortestDist = aimbotFov
    local mousePos = userInput:GetMouseLocation()
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and p.Character and isPlayerAlive(p) then
            local hrp = getRoot(p)
            if hrp then
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

-- ====== ANTY-AFK ======
if antiAFK then
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- ====== AUTO RESPAWN ======
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    isAlive = true
end)

humanoid.Died:Connect(function()
    isAlive = false
    if autoRespawn then
        task.wait(3)
        player:LoadCharacter()
    end
end)

-- ====== FLY ======
local flyBodyGyro, flyBodyVelocity
local flyConnection

function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        if not rootPart then return end
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "BlazeFlyGyro"
        bg.Parent = rootPart
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 1000
        bg.D = 50
        bg.CFrame = rootPart.CFrame
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BlazeFlyVelocity"
        bv.Parent = rootPart
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        flyBodyGyro = bg
        flyBodyVelocity = bv
        
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        notify("✈️ Fly ON - Sterowanie: Spacja=Góra, LShift=Dół", 3)
        
        flyConnection = runService.RenderStepped:Connect(function()
            if not flyEnabled or not rootPart or not rootPart.Parent then
                if flyEnabled then toggleFly() end
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = camera.CFrame
            
            if userInput:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + (camCF.LookVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - (camCF.LookVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - (camCF.RightVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + (camCF.RightVector * Vector3.new(1, 0, 1))
            end
            
            if userInput:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir + Vector3.new(0, -1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * flySpeed
            end
            
            flyBodyVelocity.Velocity = moveDir
            flyBodyGyro.CFrame = camCF
        end)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if humanoid then
            humanoid.PlatformStand = false
        end
        notify("✈️ Fly OFF", 2)
    end
end

-- ====== SPEED FLY ======
local speedFlyConnection
local speedFlyActive = false

function toggleSpeedFly()
    speedFlyActive = not speedFlyActive
    
    if speedFlyActive then
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        notify("⚡ SpeedFly ON", 2)
        
        speedFlyConnection = runService.RenderStepped:Connect(function()
            if not speedFlyActive or not rootPart or not rootPart.Parent then
                if speedFlyActive then toggleSpeedFly() end
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = camera.CFrame
            
            if userInput:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + (camCF.LookVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - (camCF.LookVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - (camCF.RightVector * Vector3.new(1, 0, 1))
            end
            if userInput:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + (camCF.RightVector * Vector3.new(1, 0, 1))
            end
            
            if userInput:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir + Vector3.new(0, -1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * speedFlySpeed
            end
            
            rootPart.Velocity = moveDir
        end)
    else
        if speedFlyConnection then speedFlyConnection:Disconnect() speedFlyConnection = nil end
        if humanoid then
            humanoid.PlatformStand = false
        end
        notify("⚡ SpeedFly OFF", 2)
    end
end

-- ====== NOCLIP ======
local noclipConnection

function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        notify("🔄 Noclip ON", 2)
        noclipConnection = runService.Stepped:Connect(function()
            if not noclipEnabled then
                noclipConnection:Disconnect()
                return
            end
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = true end)
                end
            end
        end
        notify("🔄 Noclip OFF", 2)
    end
end

-- ====== SPEED ======
function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled and humanoid then
        humanoid.WalkSpeed = 16 * speedMultiplier
        notify("💨 Speed " .. tostring(speedMultiplier) .. "x ON", 2)
    elseif humanoid then
        humanoid.WalkSpeed = 16
        notify("💨 Speed OFF", 2)
    end
end

-- ====== WALLHACK ======
function toggleWallhack()
    wallhackEnabled = not wallhackEnabled
    if wallhackEnabled then
        notify("👁️ Wallhack ON", 2)
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0.7
                    end
                end
            end
        end
        players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                task.wait(0.5)
                if wallhackEnabled then
                    for _, part in pairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0.7
                        end
                    end
                end
            end)
        end)
    else
        notify("👁️ Wallhack OFF", 2)
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end
end

-- ====== ESP ======
function createEsp(targetPlayer)
    if espObjects[targetPlayer] then return end
    
    local espData = {}
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    espData.box = box
    
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Filled = true
    healthBar.Transparency = 1
    espData.healthBar = healthBar
    
    local healthBarBg = Drawing.new("Square")
    healthBarBg.Visible = false
    healthBarBg.Color = Color3.fromRGB(0, 0, 0)
    healthBarBg.Filled = true
    healthBarBg.Transparency = 0.5
    espData.healthBarBg = healthBarBg
    
    local nameLabel = Drawing.new("Text")
    nameLabel.Visible = false
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = 14
    nameLabel.Center = true
    nameLabel.Outline = true
    espData.nameLabel = nameLabel
    
    local distLabel = Drawing.new("Text")
    distLabel.Visible = false
    distLabel.Color = Color3.fromRGB(200, 200, 200)
    distLabel.Size = 12
    distLabel.Center = true
    distLabel.Outline = true
    espData.distLabel = distLabel
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Thickness = 1
    espData.tracer = tracer
    
    local headDot = Drawing.new("Circle")
    headDot.Visible = false
    headDot.Color = Color3.fromRGB(255, 50, 50)
    headDot.Filled = true
    headDot.Thickness = 1
    headDot.NumSides = 16
    headDot.Radius = 4
    espData.headDot = headDot
    
    espObjects[targetPlayer] = espData
end

function updateEsp()
    if not espEnabled then
        for _, data in pairs(espObjects) do
            if data.box then data.box.Visible = false end
            if data.healthBar then data.healthBar.Visible = false end
            if data.healthBarBg then data.healthBarBg.Visible = false end
            if data.nameLabel then data.nameLabel.Visible = false end
            if data.distLabel then data.distLabel.Visible = false end
            if data.tracer then data.tracer.Visible = false end
            if data.headDot then data.headDot.Visible = false end
        end
        return
    end
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and isPlayerAlive(p) then
            local hrp = getRoot(p)
            local head = p.Character and p.Character:FindFirstChild("Head")
            
            if hrp and head then
                local hrpPos, hrpOnScreen = camera:WorldToViewportPoint(hrp.Position)
                local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position)
                local footPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                if hrpOnScreen then
                    local espData = espObjects[p]
                    if not espData then
                        createEsp(p)
                        espData = espObjects[p]
                    end
                    
                    if espData then
                        local boxHeight = math.abs(hrpPos.Y - footPos.Y) * 1.5
                        local boxWidth = boxHeight * 0.6
                        local boxX = hrpPos.X - boxWidth / 2
                        local boxY = hrpPos.Y - boxHeight / 2
                        
                        if boxEspEnabled then
                            espData.box.Visible = true
                            espData.box.Size = Vector2.new(boxWidth, boxHeight)
                            espData.box.Position = Vector2.new(boxX, boxY)
                        else
                            espData.box.Visible = false
                        end
                        
                        if healthBarEnabled and boxEspEnabled then
                            local hum = getHumanoid(p)
                            if hum then
                                local healthPercent = hum.Health / hum.MaxHealth
                                local barHeight = boxHeight
                                local barWidth = 4
                                local barX = boxX - barWidth - 2
                                local barY = boxY
                                
                                espData.healthBarBg.Visible = true
                                espData.healthBarBg.Size = Vector2.new(barWidth, barHeight)
                                espData.healthBarBg.Position = Vector2.new(barX, barY)
                                
                                espData.healthBar.Visible = true
                                espData.healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                                espData.healthBar.Position = Vector2.new(barX, barY + barHeight * (1 - healthPercent))
                                espData.healthBar.Color = Color3.fromRGB(math.floor(255 * (1 - healthPercent)), math.floor(255 * healthPercent), 0)
                            end
                        else
                            if espData.healthBar then espData.healthBar.Visible = false end
                            if espData.healthBarBg then espData.healthBarBg.Visible = false end
                        end
                        
                        if nameEspEnabled then
                            espData.nameLabel.Visible = true
                            espData.nameLabel.Position = Vector2.new(hrpPos.X, boxY - 16)
                            espData.nameLabel.Text = p.Name
                        else
                            espData.nameLabel.Visible = false
                        end
                        
                        if distanceEspEnabled then
                            local dist = math.floor((rootPart.Position - hrp.Position).Magnitude)
                            espData.distLabel.Visible = true
                            espData.distLabel.Position = Vector2.new(hrpPos.X, boxY + boxHeight + 2)
                            espData.distLabel.Text = tostring(dist) .. " stud"
                        else
                            espData.distLabel.Visible = false
                        end
                        
                        if tracerEnabled then
                            espData.tracer.Visible = true
                            espData.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            espData.tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        else
                            espData.tracer.Visible = false
                        end
                        
                        espData.headDot.Visible = true
                        espData.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                    end
                else
                    local espData = espObjects[p]
                    if espData then
                        if espData.box then espData.box.Visible = false end
                        if espData.healthBar then espData.healthBar.Visible = false end
                        if espData.healthBarBg then espData.healthBarBg.Visible = false end
                        if espData.nameLabel then espData.nameLabel.Visible = false end
                        if espData.distLabel then espData.distLabel.Visible = false end
                        if espData.tracer then espData.tracer.Visible = false end
                        if espData.headDot then espData.headDot.Visible = false end
                    end
                end
            else
                local espData = espObjects[p]
                if espData then
                    if espData.box then espData.box.Visible = false end
                    if espData.healthBar then espData.healthBar.Visible = false end
                    if espData.healthBarBg then espData.healthBarBg.Visible = false end
                    if espData.nameLabel then espData.nameLabel.Visible = false end
                    if espData.distLabel then espData.distLabel.Visible = false end
                    if espData.tracer then espData.tracer.Visible = false end
                    if espData.headDot then espData.headDot.Visible = false end
                end
            end
        end
    end
    
    for p, data in pairs(espObjects) do
        if not players:FindFirstChild(p.Name) then
            if data.box then data.box:Remove() end
            if data.healthBar then data.healthBar:Remove() end
            if data.healthBarBg then data.healthBarBg:Remove() end
            if data.nameLabel then data.nameLabel:Remove() end
            if data.distLabel then data.distLabel:Remove() end
            if data.tracer then data.tracer:Remove() end
            if data.headDot then data.headDot:Remove() end
            espObjects[p] = nil
        end
    end
end

task.spawn(function()
    while task.wait() do
        updateEsp()
    end
end)

-- ====== AIMBOT / SILENT AIM ======
local aimbotConnection

function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    
    if aimbotEnabled or silentAimEnabled then
        if silentAimEnabled then
            notify("🎯 Silent Aim ON", 2)
        end
        if aimbotEnabled then
            notify("🎯 Aimbot ON (FOV: " .. tostring(aimbotFov) .. "°)", 2)
        end
        
        aimbotConnection = runService.RenderStepped:Connect(function()
            if not aimbotEnabled or not isAlive then return end
            
            local target = getClosestPlayer()
            if target then
                local head = target.Character and target.Character:FindFirstChild("Head")
                if head then
                    local targetPos = head.Position
                    local smoothFactor = aimbotSmooth / 10
                    local currentCF = camera.CFrame
                    local targetCF = CFrame.lookAt(camera.CFrame.Position, targetPos)
                    local newCF = currentCF:Lerp(targetCF, smoothFactor)
                    camera.CFrame = newCF
                end
            end
        end)
    end
end

function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    startAimbot()
end

function toggleSilentAim()
    silentAimEnabled = not silentAimEnabled
    startAimbot()
end

-- ====== TRIGGERBOT ======
local triggerbotConnection

function toggleTriggerbot()
    triggerbotEnabled = not triggerbotEnabled
    
    if triggerbotEnabled then
        notify("🔫 Triggerbot ON", 2)
        triggerbotConnection = runService.RenderStepped:Connect(function()
            if not triggerbotEnabled or not isAlive then return end
            
            local mousePos = userInput:GetMouseLocation()
            local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
            raycastParams.FilterDescendantsInstances = {workspace}
            
            local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
            if result and result.Instance then
                local hitPart = result.Instance
                local hitPlayer = nil
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= player and p.Character then
                        for _, part in pairs(p.Character:GetDescendants()) do
                            if part == hitPart and part:IsA("BasePart") then
                                hitPlayer = p
                                break
                            end
                        end
                    end
                end
                
                if hitPlayer then
                    vimInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
                    task.wait(0.01)
                    vimInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
                end
            end
        end)
    else
        if triggerbotConnection then triggerbotConnection:Disconnect() triggerbotConnection = nil end
        notify("🔫 Triggerbot OFF", 2)
    end
end

-- ====== TELEPORTACJA ======
function teleportToPlayer(targetPlayer)
    if not targetPlayer then
        notify("❌ Nie wybrano gracza!", 3)
        return
    end
    
    local hrp = getRoot(targetPlayer)
    if hrp and rootPart then
        rootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0))
        notify("📡 Teleportacja do " .. targetPlayer.Name, 2)
        stepTarget = targetPlayer
    else
        notify("❌ Nie mozna teleportowac!", 3)
    end
end

function spectatePlayer(targetPlayer)
    if not targetPlayer then
        notify("❌ Nie wybrano gracza!", 3)
        return
    end
    
    if targetPlayer.Character and targetPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        local cam = workspace.CurrentCamera
        cam.CameraSubject = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        cam.CameraType = Enum.CameraType.Custom
        notify("👁️ Ogladasz: " .. targetPlayer.Name, 3)
    end
end

function stopSpectating()
    local cam = workspace.CurrentCamera
    if player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
        cam.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
        cam.CameraType = Enum.CameraType.Custom
        notify("👁️ Przestano ogladac", 2)
    end
end

-- ====== BRING ALL ======
function bringAllPlayers()
    if not rootPart then return end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local hrp = getRoot(p)
            if hrp then
                hrp.CFrame = rootPart.CFrame + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
            end
        end
    end
    notify("📦 Bring All wykonany!", 2)
end

-- ====== FLING ALL ======
function flingAllPlayers()
    if not rootPart then return end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local hrp = getRoot(p)
            if hrp then
                hrp.CFrame = rootPart.CFrame + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-500, 500), math.random(100, 500), math.random(-500, 500))
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = hrp
                debris:AddItem(bv, 1)
            end
        end
    end
    notify("🌀 Fling All wykonany!", 2)
end

-- ====== BYPASS CHAT ======
function sendBypassMessage(msg)
    local chatService = nil
    pcall(function()
        chatService = game:GetService("Chat")
    end)
    
    if chatService then
        local chars = {}
        for i = 1, #msg do
            local c = msg:sub(i, i)
            table.insert(chars, c)
        end
        table.insert(chars, " ")
        local bypassed = table.concat(chars, "")
        pcall(function()
            chatService:Chat(char.Head, bypassed, Enum.ChatColor.White)
        end)
    else
        pcall(function()
            local chatRemote = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") or 
                              replicatedStorage:FindFirstChild("ChatServiceRemote")
            if chatRemote then
                local sayMsg = chatRemote:FindFirstChild("SayMessageRequest")
                if sayMsg then
                    sayMsg:FireServer(msg, "All")
                end
            end
        end)
    end
end

-- ====== FULLBRIGHT ======
function toggleFullbright()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 3
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.GlobalShadows = false
        lighting.FogEnd = 100000
        notify("☀️ Fullbright ON", 2)
    else
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.GlobalShadows = true
        notify("☀️ Fullbright OFF", 2)
    end
end

-- ====== XRAY ======
function toggleXray()
    xrayEnabled = not xrayEnabled
    if xrayEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:FindFirstAncestorOfClass("Model") then
                v.LocalTransparencyModifier = 0.8
            end
        end
        notify("🔍 Xray ON", 2)
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0
            end
        end
        notify("🔍 Xray OFF", 2)
    end
end

-- ====== NO FALL DAMAGE ======
local fallConnection
fallConnection = runService.Stepped:Connect(function()
    if isAlive and humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        humanoid.BreakJointsOnDeath = false
    end
end)

-- ====== ANTY-LOCK ======
local antiLockConnection
if antiLock then
    antiLockConnection = runService.Stepped:Connect(function()
        if isAlive and char then
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BoolValue") and (v.Name:lower():find("lock") or v.Name:lower():find("grab") or v.Name:lower():find("stun")) then
                    v:Destroy()
                end
            end
        end
    end)
end

-- ====== ANTY-REPORT ======
if antiReport then
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                if self.Name:lower():find("report") or self.Name:lower():find("abuse") then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

-- ====== FOV CIRCLE ======
function createFovCircle()
    if fovCircle then fovCircle:Remove() end
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = true
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Filled = false
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = aimbotFov
    fovCircle.Transparency = 0.5
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end

-- ====== WATERMARK ======
function createWatermark()
    if waterMark then waterMark:Remove() end
    waterMark = Drawing.new("Text")
    waterMark.Visible = true
    waterMark.Color = Color3.fromRGB(255, 215, 0)
    waterMark.Size = 16
    waterMark.Center = false
    waterMark.Outline = true
    waterMark.Position = Vector2.new(10, 10)
    waterMark.Text = "BlazeCode x Turcja 🇹🇷 | v2.0"
end

-- ====== HOTKEY SYSTEM ======
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == teleportHotkey and selectedPlayer then
        teleportToPlayer(selectedPlayer)
    end
    
    if input.KeyCode == Enum.KeyCode.F and userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleFly()
    end
    
    if input.KeyCode == Enum.KeyCode.G and userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleNoclip()
    end
end)

-- ====== CLICK TP ======
if teleportOnClick then
    userInput.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local mousePos = userInput:GetMouseLocation()
            local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
            raycastParams.FilterDescendantsInstances = {workspace}
            local result = workspace:Raycast(ray.Origin, ray.Direction * 5000, raycastParams)
            if result and result.Position and rootPart then
                rootPart.CFrame = CFrame.new(result.Position + Vector3.new(0, 2, 0))
                notify("📡 Teleport do kliku", 1)
            end
        end
    end)
end

-- ====== INFINITE JUMP ======
userInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space and infiniteJumpEnabled and isAlive and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====== TWORZENIE GUI ======

-- MAIN TAB
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local MovementSection = MainTab:CreateSection("🚀 Movement")

MainTab:CreateToggle({
    Name = "Fly (Ctrl+F)",
    Info = "Latanie - Spacja gora, Shift dol",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(val)
        if val ~= flyEnabled then toggleFly() end
    end
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Info = "Predkosc latania",
    Min = 10,
    Max = 300,
    Default = 50,
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(val)
        flySpeed = val
    end
})

MainTab:CreateToggle({
    Name = "Speed Fly",
    Info = "Bardzo szybkie latanie",
    CurrentValue = false,
    Flag = "SpeedFlyToggle",
    Callback = function(val)
        if val ~= speedFlyActive then toggleSpeedFly() end
    end
})

MainTab:CreateSlider({
    Name = "Speed Fly Speed",
    Info = "Predkosc Speed Fly",
    Min = 50,
    Max = 500,
    Default = 100,
    Increment = 10,
    CurrentValue = 100,
    Flag = "SpeedFlySpeedSlider",
    Callback = function(val)
        speedFlySpeed = val
    end
})

MainTab:CreateToggle({
    Name = "Speed",
    Info = "Przyspieszenie chodzenia",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(val)
        if val ~= speedEnabled then toggleSpeed() end
    end
})

MainTab:CreateSlider({
    Name = "Speed Multiplier",
    Info = "Mnoznik predkosci",
    Min = 1,
    Max = 10,
    Default = 2,
    Increment = 0.5,
    CurrentValue = 2,
    Flag = "SpeedMultiSlider",
    Callback = function(val)
        speedMultiplier = val
        if speedEnabled and humanoid then
            humanoid.WalkSpeed = 16 * val
        end
    end
})

MainTab:CreateToggle({
    Name = "Noclip (Ctrl+G)",
    Info = "Przechodzenie przez sciany",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(val)
        if val ~= noclipEnabled then toggleNoclip() end
    end
})

MainTab:CreateToggle({
    Name = "No Fall Damage",
    Info = "Brak obrazen od upadku",
    CurrentValue = false,
    Flag = "NoFallToggle",
    Callback = function(val)
        noFallDamage = val
        notify("No Fall Damage: " .. (val and "ON" or "OFF"), 2)
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    Info = "Nieskonczony skok (spacja)",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(val)
        infiniteJumpEnabled = val
        notify("Infinite Jump: " .. (val and "ON" or "OFF"), 2)
    end
})

-- TELEPORT TAB
local TeleportTab = Window:CreateTab("📡 Teleporty", 4483362458)
local TeleportSection = TeleportTab:CreateSection("🎯 Teleportacja")

local playerNames = {}
for _, p in pairs(players:GetPlayers()) do
    if p ~= player then
        table.insert(playerNames, p.Name)
    end
end

local TeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Wybierz Gracza",
    Options = playerNames,
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TeleportDropdown",
    Callback = function(option)
        if option and #option > 0 then
            selectedPlayer = players:FindFirstChild(option[1])
        end
    end
})

players.PlayerAdded:Connect(function(p)
    if p ~= player then
        task.wait(1)
        local names = {}
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player then
                table.insert(names, plr.Name)
            end
        end
        TeleportDropdown:Set(names)
    end
end)

players.PlayerRemoving:Connect(function(p)
    task.wait(1)
    local names = {}
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            table.insert(names, plr.Name)
        end
    end
    TeleportDropdown:Set(names)
end)

TeleportTab:CreateButton({
    Name = "📡 Teleportuj do wybranego (T)",
    Info = "Teleportacja do zaznaczonego gracza",
    Callback = function()
        if selectedPlayer then
            teleportToPlayer(selectedPlayer)
        else
            notify("❌ Wybierz gracza!", 3)
        end
    end
})

TeleportTab:CreateButton({
    Name = "👁️ Ogladaj wybranego",
    Info = "Kamera sledzi wybranego gracza",
    Callback = function()
        if selectedPlayer then
            spectatePlayer(selectedPlayer)
        else
            notify("❌ Wybierz gracza!", 3)
        end
    end
})

TeleportTab:CreateButton({
    Name = "🚫 Przestan ogladac",
    Info = "Powrot kamery do Ciebie",
    Callback = function()
        stopSpectating()
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport przez klik (PPM)",
    Info = "Kliknij PPM aby teleportowac sie w miejsce",
    CurrentValue = false,
    Flag = "ClickTPToggle",
    Callback = function(val)
        teleportOnClick = val
        notify("Click TP: " .. (val and "ON" or "OFF"), 2)
    end
})

-- COMBAT TAB
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local AimbotSection = CombatTab:CreateSection("🎯 Aimbot")

CombatTab:CreateToggle({
    Name = "Aimbot",
    Info = "Automatyczne celowanie",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val)
        aimbotEnabled = val
        startAimbot()
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    Info = "Celowanie bez widocznego ruchu myszka",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(val)
        silentAimEnabled = val
        startAimbot()
    end
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Info = "Zasieg aimbota w stopniach",
    Min = 10,
    Max = 360,
    Default = 90,
    Increment = 5,
    CurrentValue = 90,
    Flag = "AimFOVSlider",
    Callback = function(val)
        aimbotFov = val
        if fovCircle then fovCircle.Radius = val end
    end
})

CombatTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Info = "Wygladzenie aimbota (1-szybki, 20-wolny)",
    Min = 1,
    Max = 20,
    Default = 5,
    Increment = 1,
    CurrentValue = 5,
    Flag = "AimSmoothSlider",
    Callback = function(val)
        aimbotSmooth = val
    end
})

CombatTab:CreateToggle({
    Name = "Show FOV Circle",
    Info = "Pokazuje kolko zasiegu aimbota",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(val)
        if val then
            createFovCircle()
        elseif fovCircle then
            fovCircle.Visible = false
        end
    end
})

CombatTab:CreateToggle({
    Name = "Triggerbot",
    Info = "Auto strzal gdy celownik jest na graczu",
    CurrentValue = false,
    Flag = "TriggerbotToggle",
    Callback = function(val)
        if val ~= triggerbotEnabled then toggleTriggerbot() end
    end
})

CombatTab:CreateToggle({
    Name = "Auto Parry",
    Info = "Automatyczny parry/blok",
    CurrentValue = false,
    Flag = "AutoParryToggle",
    Callback = function(val)
        autoParry = val
        notify("Auto Parry: " .. (val and "ON" or "OFF"), 2)
    end
})

-- ESP TAB
local EspTab = Window:CreateTab("👁️ ESP", 4483362458)
local EspSection = EspTab:CreateSection("🔄 ESP Settings")

EspTab:CreateToggle({
    Name = "ESP ON/OFF",
    Info = "Glowny przelacznik ESP",
    CurrentValue = false,
    Flag = "EspMainToggle",
    Callback = function(val)
        espEnabled = val
        notify("ESP: " .. (val and "ON" or "OFF"), 2)
    end
})

EspTab:CreateToggle({
    Name = "Box ESP",
    Info = "Ramka wokol graczy",
    CurrentValue = false,
    Flag = "BoxEspToggle",
    Callback = function(val)
        boxEspEnabled = val
    end
})

EspTab:CreateToggle({
    Name = "Name ESP",
    Info = "Pokazuje nick gracza",
    CurrentValue = false,
    Flag = "NameEspToggle",
    Callback = function(val)
        nameEspEnabled = val
    end
})

EspTab:CreateToggle({
    Name = "Distance ESP",
    Info = "Pokazuje odleglosc do gracza",
    CurrentValue = false,
    Flag = "DistEspToggle",
    Callback = function(val)
        distanceEspEnabled = val
    end
})

EspTab:CreateToggle({
    Name = "Tracer Lines",
    Info = "Linie od Ciebie do graczy",
    CurrentValue = false,
    Flag = "TracerToggle",
    Callback = function(val)
        tracerEnabled = val
    end
})

EspTab:CreateToggle({
    Name = "Health Bar",
    Info = "Pasek zdrowia przy ESP",
    CurrentValue = false,
    Flag = "HealthBarToggle",
    Callback = function(val)
        healthBarEnabled = val
    end
})

-- VISUAL TAB
local VisualTab = Window:CreateTab("🌈 Visuals", 4483362458)
local VisualSection = VisualTab:CreateSection("🎨 Efekty wizualne")

VisualTab:CreateToggle({
    Name = "Wallhack",
    Info = "Widzenie przez sciany (przezroczysci gracze)",
    CurrentValue = false,
    Flag = "WallhackToggle",
    Callback = function(val)
        if val ~= wallhackEnabled then toggleWallhack() end
    end
})

VisualTab:CreateToggle({
    Name = "Xray",
    Info = "Przezroczyste sciany i obiekty",
    CurrentValue = false,
    Flag = "XrayToggle",
    Callback = function(val)
        if val ~= xrayEnabled then toggleXray() end
    end
})

VisualTab:CreateToggle({
    Name = "Fullbright",
    Info = "Pelna jasnosc - widzenie w ciemnosci",
    CurrentValue = false,
    Flag = "FullbrightToggle",
    Callback = function(val)
        if val ~= fullbrightEnabled then toggleFullbright() end
    end
})

VisualTab:CreateToggle({
    Name = "Show Watermark",
    Info = "Pokazuje znak wodny BlazeCode x Turcja",
    CurrentValue = true,
    Flag = "WatermarkToggle",
    Callback = function(val)
        if val then
            createWatermark()
        elseif waterMark then
            waterMark.Visible = false
        end
    end
})

-- MISC TAB
local MiscTab = Window:CreateTab("🔧 Misc", 4483362458)
local PlayerSection = MiscTab:CreateSection("👥 Gracze")

MiscTab:CreateButton({
    Name = "📦 Bring All",
    Info = "Przyciaga wszystkich graczy do Ciebie",
    Callback = function()
        bringAllPlayers()
    end
})

MiscTab:CreateButton({
    Name = "🌀 Fling All",
    Info = "Rozrzuca wszystkich graczy (fling)",
    Callback = function()
        flingAllPlayers()
    end
})

local BypassSection = MiscTab:CreateSection("🛡️ Bypassy")

MiscTab:CreateToggle({
    Name = "Anti-Chat Filter",
    Info = "Bypass filtra czatu",
    CurrentValue = false,
    Flag = "AntiChatToggle",
    Callback = function(val)
        antiChatFilter = val
        notify("Anti-Chat Filter: " .. (val and "ON" or "OFF"), 2)
    end
})

MiscTab:CreateToggle({
    Name = "Anti-Lock/Stun",
    Info = "Blokada przed lockowaniem/stunowaniem",
    CurrentValue = true,
    Flag = "AntiLockToggle",
    Callback = function(val)
        antiLock = val
        notify("Anti-Lock: " .. (val and "ON" or "OFF"), 2)
    end
})

MiscTab:CreateToggle({
    Name = "Anti-Report",
    Info = "Blokada wysylania reportow",
    CurrentValue = true,
    Flag = "AntiReportToggle",
    Callback = function(val)
        antiReport = val
        notify("Anti-Report: " .. (val and "ON" or "OFF"), 2)
    end
})

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    Info = "Zapobiega wylogowaniu za afk",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(val)
        antiAFK = val
        notify("Anti-AFK: " .. (val and "ON" or "OFF"), 2)
    end
})

MiscTab:CreateToggle({
    Name = "Auto Respawn",
    Info = "Automatyczne odradzanie po smierci",
    CurrentValue = true,
    Flag = "AutoRespawnToggle",
    Callback = function(val)
        autoRespawn = val
        notify("Auto Respawn: " .. (val and "ON" or "OFF"), 2)
    end
})

local ChatSection = MiscTab:CreateSection("💬 Chat Bypass")

MiscTab:CreateInput({
    Name = "Wiadomosc do wyslania",
    Info = "Wpisz text i wyslij z bypassem",
    PlaceholderText = "Wpisz wiadomosc...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text and #text > 0 then
            sendBypassMessage(text)
        end
    end
})

-- CREDITS TAB
local CreditsTab = Window:CreateTab("⭐ Credits", 4483362458)
local CreditsSection = CreditsTab:CreateSection("🇹🇷 BlazeCode x Turcja")

CreditsTab:CreateLabel("BlazeCode x Turcja 🇹🇷")
CreditsTab:CreateLabel("Advanced Penetration Testing Suite")
CreditsTab:CreateLabel("Wersja: 2.0.0")
CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("📌 Funkcje:")
CreditsTab:CreateLabel("• Fly + Speed Fly")
CreditsTab:CreateLabel("• Wallhack & Xray")
CreditsTab:CreateLabel("• Speed & Noclip")
CreditsTab:CreateLabel("• Aimbot & Silent Aim")
CreditsTab:CreateLabel("• ESP (Box, Name, Dist, Tracer, HP)")
CreditsTab:CreateLabel("• Teleportacja do graczy")
CreditsTab:CreateLabel("• Bring All & Fling All")
CreditsTab:CreateLabel("• Bypass Chat & Anti-Filter")
CreditsTab:CreateLabel("• Anti-Lock, Anti-Report, Anti-AFK")
CreditsTab:CreateLabel("• Fullbright, Click TP, Triggerbot")
CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("Autoryzowany pentest tylko!")
CreditsTab:CreateLabel("BlazeCode 2026")

-- ====== INICJALIZACJA ======
createWatermark()
createFovCircle()
if fovCircle then fovCircle.Visible = false end

notify("🇹🇷 BlazeCode x Turcja zaladowany!", 5)
