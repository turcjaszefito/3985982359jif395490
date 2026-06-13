--[[
    BlazeCode x Turcja
    Roblox Lua Script - Universal GUI
    Powered by Rayfield (sirius.menu/rayfield)
    Для использования в authorised pentest / educational context
--]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "BlazeCode x Turcja",
    LoadingTitle = "BlazeCode",
    LoadingSubtitle = "by Turcja",
    ConfigurationSaving = { Enabled = true, FolderName = "BlazeCodeTurcja", FileName = "cfg" },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Утилиты
local function getChar(plr)
    return plr.Character
end

local function getRoot(plr)
    local c = getChar(plr)
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum(plr)
    local c = getChar(plr)
    return c and c:FindFirstChildOfClass("Humanoid")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local mouse = LP:GetMouse()

-- ============================================================
-- TAB 1 – Локальные читы
-- ============================================================
local LocalTab = Window:CreateTab("Locals", "https://www.roblox.com/asset/?id=6031094663")

-- FLY
local flyActive = false
local flySpeed = 50
local bodyGyro, bodyVel

LocalTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        flyActive = v
        local c = getChar(LP)
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if flyActive then
            hum.PlatformStand = true
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Parent = root
            bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bodyGyro.P = 9e9
            bodyGyro.D = 9e9
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Parent = root
            bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
            bodyVel.Velocity = Vector3.new(0,0,0)
        else
            hum.PlatformStand = false
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
        end
    end
})

LocalTab:CreateSlider({
    Name = "Fly Speed",
    Min = 5,
    Max = 500,
    Default = 50,
    Increment = 5,
    Callback = function(v) flySpeed = v end
})

RunService.RenderStepped:Connect(function()
    if flyActive and bodyVel then
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0,-1,0) end
        bodyVel.Velocity = moveDir * flySpeed
    end
end)

-- SPEED
local speedActive = false
local speedValue = 32

LocalTab:CreateToggle({
    Name = "Speed",
    CurrentValue = false,
    Callback = function(v)
        speedActive = v
    end
})

LocalTab:CreateSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 250,
    Default = 32,
    Increment = 1,
    Callback = function(v) speedValue = v end
})

RunService.RenderStepped:Connect(function()
    if speedActive then
        local h = getHum(LP)
        if h and h.Parent then
            h.WalkSpeed = speedValue
        end
    end
end)

-- SPEED FLY (комбинированный)
local speedFlyActive = false
local speedFlyVal = 100

LocalTab:CreateToggle({
    Name = "Speed Fly (гибрид)",
    CurrentValue = false,
    Callback = function(v)
        speedFlyActive = v
        local c = getChar(LP)
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if speedFlyActive then
            hum.PlatformStand = true
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Parent = root
            bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bodyGyro.P = 9e9
            bodyGyro.D = 9e9
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Parent = root
            bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
            bodyVel.Velocity = Vector3.new(0,0,0)
        else
            hum.PlatformStand = false
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
        end
    end
})

LocalTab:CreateSlider({
    Name = "SpeedFly Speed",
    Min = 50,
    Max = 999,
    Default = 100,
    Increment = 10,
    Callback = function(v) speedFlyVal = v end
})

RunService.RenderStepped:Connect(function()
    if speedFlyActive and bodyVel then
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        bodyVel.Velocity = moveDir * speedFlyVal
    end
end)

-- NOCLIP
local noclipActive = false
local noclipConnection

LocalTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclipActive = v
        if noclipActive then
            noclipConnection = RunService.Stepped:Connect(function()
                for _, part in ipairs(getChar(LP):GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        end
    end
})

-- WALLHACK (ESP через Highlight)
local wallhackActive = false
local whHighlights = {}

LocalTab:CreateToggle({
    Name = "Wallhack (Highlight ESP)",
    CurrentValue = false,
    Callback = function(v)
        wallhackActive = v
        if not v then
            for _, hl in ipairs(whHighlights) do
                pcall(function() hl:Destroy() end)
            end
            whHighlights = {}
        end
    end
})

RunService.RenderStepped:Connect(function()
    if wallhackActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and getChar(p) then
                local hl = getChar(p):FindFirstChildOfClass("Highlight")
                if not hl then
                    local newHl = Instance.new("Highlight")
                    newHl.Adornee = getChar(p)
                    newHl.FillColor = Color3.fromRGB(255,50,50)
                    newHl.OutlineColor = Color3.fromRGB(255,255,255)
                    newHl.FillTransparency = 0.3
                    newHl.Parent = getChar(p)
                    table.insert(whHighlights, newHl)
                end
            end
        end
    end
end)

-- ============================================================
-- TAB 2 – Телепортация / Player Control
-- ============================================================
var TabTP = Window:CreateTab("TP & Control", "https://www.roblox.com/asset/?id=6031094663")

-- TP к игроку (кнопка)
local targetTP = ""

TabTP:CreateInput({
    Name = "TP to player (имя)",
    PlaceholderText = "Username",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) targetTP = v end
})

TabTP:CreateButton({
    Name = "TP to Player",
    Callback = function()
        local plr = Players:FindFirstChild(targetTP)
        if not plr then return end
        local root = getRoot(plr)
        local myRoot = getRoot(LP)
        if root and myRoot then
            myRoot.CFrame = root.CFrame * CFrame.new(0,3,0)
        end
    end
})

-- TP через клик (мышь)
TabTP:CreateButton({
    Name = "TP to Mouse Target",
    Callback = function()
        local target = mouse.Target
        if not target then return end
        local myRoot = getRoot(LP)
        if myRoot then
            myRoot.CFrame = target.CFrame * CFrame.new(0,3,0)
        end
    end
})

-- Bring All
TabTP:CreateButton({
    Name = "Bring All Players",
    Callback = function()
        local myRoot = getRoot(LP)
        if not myRoot then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local r = getRoot(p)
                if r then
                    r.CFrame = myRoot.CFrame * CFrame.new(math.random(-5,5), 2, math.random(-5,5))
                end
            end
        end
    end
})

-- Fling All
TabTP:CreateButton({
    Name = "Fling All Players",
    Callback = function()
        local myRoot = getRoot(LP)
        if not myRoot then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local r = getRoot(p)
                if r then
                    r.CFrame = myRoot.CFrame * CFrame.new(0,2,0)
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-500,500), 500, math.random(-500,500))
                    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
                    bv.Parent = r
                    game:GetService("Debris"):AddItem(bv, 0.5)
                end
            end
        end
    end
})

-- View Player (камера следует)
local viewTarget = ""
local viewActive = false
local viewConnection

TabTP:CreateInput({
    Name = "View player (имя)",
    PlaceholderText = "Username",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) viewTarget = v end
})

TabTP:CreateToggle({
    Name = "Watch Player",
    CurrentValue = false,
    Callback = function(v)
        viewActive = v
        if viewActive and viewTarget ~= "" then
            local plr = Players:FindFirstChild(viewTarget)
            if not plr then return end
            viewConnection = RunService.RenderStepped:Connect(function()
                local root = getRoot(plr)
                if root then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
                end
            end)
        else
            if viewConnection then viewConnection:Disconnect() viewConnection = nil end
        end
    end
})

-- ============================================================
-- TAB 3 – Aimbot / Silent Aim / ESP
-- ============================================================
var TabAimbot = Window:CreateTab("Combat", "https://www.roblox.com/asset/?id=6031094663")

local aimbotActive = false
local silentAim = false
local aimFov = 90
local aimSmooth = 1
local aimPart = "Head"
local aimKey = Enum.UserInputType.MouseButton2

TabAimbot:CreateToggle({
    Name = "Aimbot (правый клик)",
    CurrentValue = false,
    Callback = function(v) aimbotActive = v end
})

TabAimbot:CreateToggle({
    Name = "Silent Aim (авто-наведение)",
    CurrentValue = false,
    Callback = function(v) silentAim = v end
})

TabAimbot:CreateSlider({
    Name = "Aimbot FOV",
    Min = 10,
    Max = 360,
    Default = 90,
    Increment = 5,
    Callback = function(v) aimFov = v end
})

TabAimbot:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"},
    CurrentOption = "Head",
    Callback = function(v) aimPart = v end
})

local function getClosestTarget()
    local closestDist = aimFov
    local closestPlr = nil
    local closestPos = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getChar(p) and getHum(p) and getHum(p).Health > 0 then
            local part = getChar(p):FindFirstChild(aimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlr = p
                        closestPos = part.Position
                    end
                end
            end
        end
    end
    return closestPlr, closestPos
end

RunService.RenderStepped:Connect(function()
    if aimbotActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local _, pos = getClosestTarget()
        if pos then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
        end
    end
    if silentAim then
        local plr, pos = getClosestTarget()
        if plr and pos then
            -- Silent Aim работает через переопределение CFrame камеры в момент выстрела
            -- Ниже заготовка для RemoteEvent хука (зависит от игры)
            -- Для универсальности: меняем камеру при нажатии ЛКМ
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
            end
        end
    end
end)

-- ESP FULL
local espFull = false
local espConnections = {}

TabAimbot:CreateToggle({
    Name = "ESP Full (box + name + health)",
    CurrentValue = false,
    Callback = function(v)
        espFull = v
        if not v then
            for _, conn in ipairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            -- очистить BillboardGui
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and getChar(p) then
                    local existing = getChar(p):FindFirstChild("BlazeESP")
                    if existing then existing:Destroy() end
                end
            end
        end
    end
})

local function createESP(plr)
    local c = getChar(plr)
    if not c or c:FindFirstChild("BlazeESP") then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = "BlazeESP"
    bg.Adornee = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
    bg.Size = UDim2.new(0,200,0,50)
    bg.StudsOffset = Vector3.new(0,3,0)
    bg.AlwaysOnTop = true
    local tl = Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1,0,1,0)
    tl.BackgroundTransparency = 1
    tl.Text = plr.Name .. " | " .. tostring(math.floor(getHum(plr).Health)) .. "HP"
    tl.TextColor3 = Color3.fromRGB(255,255,255)
    tl.TextStrokeTransparency = 0.3
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 14
    local conn = RunService.RenderStepped:Connect(function()
        if bg.Adornee and bg.Adornee.Parent then
            tl.Text = plr.Name .. " | " .. tostring(math.floor(getHum(plr).Health)) .. "HP"
        end
    end)
    table.insert(espConnections, conn)
    bg.Parent = c
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espFull then createESP(p) end
    end)
end)

RunService.RenderStepped:Connect(function()
    if espFull then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and getChar(p) and not getChar(p):FindFirstChild("BlazeESP") then
                createESP(p)
            end
        end
    end
end)

-- ============================================================
-- TAB 4 – Байпасы / Anti-Cheat / Чат
-- ============================================================
var TabBypass = Window:CreateTab("Bypasses", "https://www.roblox.com/asset/?id=6031094663")

-- Chat Bypass (простейший — замена букв)
TabBypass:CreateButton({
    Name = "Inject Chat Bypass (ASCII shift)",
    Callback = function()
        local oldChat
        if game:GetService("Chat") and game:GetService("Chat").Chat then
            oldChat = game:GetService("Chat").Chat
        end
        -- Перехват отправки сообщения через LocalPlayer
        local oldSay = LP.SayMessageRequest
        LP.SayMessageRequest = function(msg, ...)
            local bypassed = ""
            for i=1, #msg do
                local code = string.byte(msg:sub(i,i))
                if code >= 33 and code <= 126 then
                    bypassed = bypassed .. string.char(code + 1)
                else
                    bypassed = bypassed .. msg:sub(i,i)
                end
            end
            return oldSay(LP, bypassed, ...)
        end
    end
})

-- Anti-Cheat bypass (попытка отключить детекты — универсально)
TabBypass:CreateButton({
    Name = "Bypass Anti-Cheat (удаление скриптов)",
    Callback = function()
        for _, v in ipairs(game:GetDescendants()) do
            pcall(function()
                if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    if v.Name:lower():find("anticheat") or v.Name:lower():find("anti.cheat") or v.Name:lower():find("detect") then
                        v.Disabled = true
                    end
                end
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    if v.Name:lower():find("kick") or v.Name:lower():find("ban") or v.Name:lower():find("detect") then
                        v:Destroy()
                    end
                end
            end)
        end
    end
})

-- ============================================================
-- TAB 5 – World / Server
-- ============================================================
var TabWorld = Window:CreateTab("World", "https://www.roblox.com/asset/?id=6031094663")

TabWorld:CreateButton({
    Name = "Bring All Items",
    Callback = function()
        local myRoot = getRoot(LP)
        if not myRoot then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:IsA("Tool") == false and obj.Parent:IsA("Player") == false then
                pcall(function()
                    obj.CFrame = myRoot.CFrame * CFrame.new(math.random(-3,3), 1, math.random(-3,3))
                end)
            end
        end
    end
})

TabWorld:CreateButton({
    Name = "Delete All Doors / Barriers",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("Part") and (obj.Name:lower():find("door") or obj.Name:lower():find("wall") or obj.Name:lower():find("barrier")) then
                    obj:Destroy()
                end
            end)
        end
    end
})

TabWorld:CreateSlider({
    Name = "Gravity",
    Min = -200,
    Max = 200,
    Default = 196.2,
    Increment = 1,
    Callback = function(v) Workspace.Gravity = v end
})

-- ============================================================
-- TAB 6 – Misc / Advanced
-- ============================================================
var TabMisc = Window:CreateTab("Advanced", "https://www.roblox.com/asset/?id=6031094663")

TabMisc:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        local oldJump = false
        local hum = getHum(LP)
        if not hum then return end
        hum.JumpPower = 200
        UserInputService.JumpRequest:Connect(function()
            if getHum(LP) then
                getHum(LP):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
})

TabMisc:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        ts:TeleportToPlaceInstance(placeId, jobId, LP)
    end
})

TabMisc:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local _, jobs = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100")) end)
        if jobs and #jobs.data > 0 then
            local newJob = jobs.data[math.random(1, #jobs.data)]
            if newJob and newJob.id then
                ts:TeleportToPlaceInstance(placeId, newJob.id, LP)
            end
        end
    end
})

TabMisc:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 5,
    Callback = function(v)
        local h = getHum(LP)
        if h then h.JumpPower = v end
    end
})

-- ============================================================
-- TAB 7 – Keybinds / Settings
-- ============================================================
var TabKb = Window:CreateTab("Keybinds", "https://www.roblox.com/asset/?id=6031094663")

TabKb:CreateKeybind({
    Name = "Toggle Fly",
    CurrentKeybind = "F",
    Callback = function()
        local tab = Window:FindTab("Locals")
        if tab then
            local toggle = tab:FindToggle("Fly")
            if toggle then toggle:SetValue(not flyActive) end
        end
    end
})

TabKb:CreateKeybind({
    Name = "Toggle Noclip",
    CurrentKeybind = "N",
    Callback = function()
        local tab = Window:FindTab("Locals")
        if tab then
            local toggle = tab:FindToggle("Noclip")
            if toggle then toggle:SetValue(not noclipActive) end
        end
    end
})

TabKb:CreateKeybind({
    Name = "Toggle Speed",
    CurrentKeybind = "G",
    Callback = function()
        local tab = Window:FindTab("Locals")
        if tab then
            local toggle = tab:FindToggle("Speed")
            if toggle then toggle:SetValue(not speedActive) end
        end
    end
})

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "BlazeCode x Turcja",
    Content = "Loaded. Use responsibly.",
    Duration = 3
})
