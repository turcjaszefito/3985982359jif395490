--[[
    BlazeCode x Turcja — FINAL
    Ładowanie Rayfield z alternatywnego URL + fallback local
    Działa na każdym executorze
--]]

local Rayfield = nil

-- próba 1: oryginalny URL
pcall(function()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
end)

-- próba 2: mirror 1
if not Rayfield then
    pcall(function()
        Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    end)
end

-- próba 3: mirror 2
if not Rayfield then
    pcall(function()
        Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skodon/Rayfield/main/source.lua"))()
    end)
end

-- próba 4: mirror 3
if not Rayfield then
    pcall(function()
        Rayfield = loadstring(game:HttpGet("https://pastebin.com/raw/6R6U5Y3V"))()
    end)
end

-- próba 5: wbudowany Rayfield (hardcoded minimalna wersja UI)
if not Rayfield then
    local plr = game.Players.LocalPlayer
    local sg = Instance.new("ScreenGui")
    sg.Name = "BlazeCodeGui"
    sg.Parent = plr:WaitForChild("PlayerGui")

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 420, 0, 580)
    f.Position = UDim2.new(0.5, -210, 0.5, -290)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    f.BorderSizePixel = 0
    f.Draggable = true
    f.Active = true
    f.Parent = sg

    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, 6)
    uc.Parent = f

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Text = "BlazeCode x Turcja"
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = f

    local scr = Instance.new("ScrollingFrame")
    scr.Size = UDim2.new(1, -10, 1, -45)
    scr.Position = UDim2.new(0, 5, 0, 40)
    scr.BackgroundTransparency = 1
    scr.ScrollBarThickness = 4
    scr.CanvasSize = UDim2.new(0, 0, 0, 0)
    scr.Parent = f

    local layout = Instance.new("UIListLayout")
    layout.Parent = scr
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function addBtn(text, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -10, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.Text = text
        b.Parent = scr
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 4)
        bc.Parent = b
        b.MouseButton1Click:Connect(cb)
    end

    local function addToggle(text, val, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -10, 0, 35)
        b.BackgroundColor3 = if val then Color3.fromRGB(70, 180, 70) else Color3.fromRGB(55, 55, 75)
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.Text = text .. (if val then " [ON]" else " [OFF]")
        b.Parent = scr
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 4)
        bc.Parent = b
        local state = val
        b.MouseButton1Click:Connect(function()
            state = not state
            b.BackgroundColor3 = if state then Color3.fromRGB(70, 180, 70) else Color3.fromRGB(55, 55, 75)
            b.Text = text .. (if state then " [ON]" else " [OFF]")
            cb(state)
        end)
        return function() return state end
    end

    local function addSlider(text, min, max, def, cb)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 50)
        container.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        container.Parent = scr
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(0, 4)
        cc.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. tostring(def)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.Parent = container

        local slider = Instance.new("ImageButton")
        slider.Size = UDim2.new(1, -20, 0, 8)
        slider.Position = UDim2.new(0, 10, 0, 30)
        slider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        slider.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        slider.BackgroundTransparency = 1
        slider.Parent = container
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        local val = def
        slider.MouseButton1Down:Connect(function()
            local conn
            conn = game:GetService("UserInputService").InputChanged:Connect(function()
                local pos = game:GetService("UserInputService"):GetMouseLocation()
                local absPos = slider.AbsolutePosition
                local absSize = slider.AbsoluteSize
                local relX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
                val = min + (max - min) * relX
                fill.Size = UDim2.new(relX, 0, 1, 0)
                label.Text = text .. ": " .. tostring(math.floor(val))
                cb(math.floor(val))
            end)
            slider.MouseButton1Up:Connect(function() conn:Disconnect() end)
        end)
    end

    local function addInput(text, placeholder, cb)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -10, 0, 35)
        box.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        box.TextColor3 = Color3.fromRGB(220, 220, 220)
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        box.PlaceholderText = placeholder
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Text = ""
        box.Parent = scr
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 4)
        bc.Parent = box
        box.FocusLost:Connect(function(enter)
            if enter then cb(box.Text) end
        end)
    end

    -- ====== LOGIKA ======
    local plr = game.Players.LocalPlayer
    local RunS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local WS = game:GetService("Workspace")
    local cam = WS.CurrentCamera
    local mouse = plr:GetMouse()

    local function getChar() return plr.Character end
    local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
    local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

    -- FLY
    local flyState = false
    local flySpd = 50
    local bvFly, bgFly
    addToggle("Fly", false, function(v)
        flyState = v
        local c = getChar()
        if not c then return end
        local r = getRoot()
        local h = getHum()
        if not r or not h then return end
        if v then
            h.PlatformStand = true
            bgFly = Instance.new("BodyGyro")
            bgFly.Parent = r
            bgFly.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bgFly.P = 9e9
            bgFly.D = 9e9
            bvFly = Instance.new("BodyVelocity")
            bvFly.Parent = r
            bvFly.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bvFly.Velocity = Vector3.new(0, 0, 0)
        else
            h.PlatformStand = false
            if bgFly then bgFly:Destroy() bgFly = nil end
            if bvFly then bvFly:Destroy() bvFly = nil end
        end
    end)
    addSlider("Fly Speed", 5, 500, 50, function(v) flySpd = v end)
    RunS.RenderStepped:Connect(function()
        if flyState and bvFly then
            local dir = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0, -1, 0) end
            bvFly.Velocity = dir * flySpd
        end
    end)

    -- SPEED
    local spdState = false
    local spdVal = 32
    addToggle("Speed", false, function(v) spdState = v end)
    addSlider("Speed Value", 16, 250, 32, function(v) spdVal = v end)
    RunS.RenderStepped:Connect(function()
        if spdState then
            local h = getHum()
            if h then h.WalkSpeed = spdVal end
        end
    end)

    -- NOCLIP
    local noclipState = false
    local noclipConn
    addToggle("Noclip", false, function(v)
        noclipState = v
        if v then
            noclipConn = RunS.Stepped:Connect(function()
                local c = getChar()
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end)

    -- TP do gracza
    local tpTarget = ""
    addInput("TP do gracza (nazwa)", "Username", function(v) tpTarget = v end)
    addBtn("TP do gracza", function()
        if tpTarget == "" then return end
        local p = game.Players:FindFirstChild(tpTarget)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and getRoot() then
            getRoot().CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end)

    -- TP do kursora
    addBtn("TP do kursora", function()
        local t = mouse.Target
        if t and getRoot() then
            getRoot().CFrame = t.CFrame * CFrame.new(0, 3, 0)
        end
    end)

    -- Bring All
    addBtn("Bring All Players", function()
        local my = getRoot()
        if not my then return end
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = my.CFrame * CFrame.new(math.random(-5, 5), 2, math.random(-5, 5))
            end
        end
    end)

    -- Fling All
    addBtn("Fling All Players", function()
        local my = getRoot()
        if not my then return end
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local r = p.Character.HumanoidRootPart
                r.CFrame = my.CFrame * CFrame.new(0, 2, 0)
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-500, 500), 500, math.random(-500, 500))
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Parent = r
                game:GetService("Debris"):AddItem(bv, 0.5)
            end
        end
    end)

    -- AIMBOT
    local aimState = false
    local aimFov = 90
    addToggle("Aimbot (prawy klawisz)", false, function(v) aimState = v end)
    addSlider("Aimbot FOV", 10, 360, 90, function(v) aimFov = v end)
    RunS.RenderStepped:Connect(function()
        if aimState and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local closest, dist = nil, aimFov
            local myPos = Vector2.new(mouse.X, mouse.Y)
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local sp, onSc = cam:WorldToViewportPoint(head.Position)
                        if onSc then
                            local d2 = (Vector2.new(sp.X, sp.Y) - myPos).Magnitude
                            if d2 < dist then closest = head; dist = d2 end
                        end
                    end
                end
            end
            if closest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
            end
        end
    end)

    -- WALLHACK / ESP
    local espState = false
    local espObjs = {}
    addToggle("ESP Full (highlight + nazwa)", false, function(v)
        espState = v
        if not v then
            for _, o in ipairs(espObjs) do pcall(function() o:Destroy() end) end
            espObjs = {}
        end
    end)
    RunS.RenderStepped:Connect(function()
        if espState then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChild("BlazeESPtag") then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.3
                    hl.Parent = p.Character
                    table.insert(espObjs, hl)
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "BlazeESPtag"
                    bg.Adornee = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                    bg.Size = UDim2.new(0, 150, 0, 30)
                    bg.StudsOffset = Vector3.new(0, 3, 0)
                    bg.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bg)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = p.Name
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lbl.TextStrokeTransparency = 0.3
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 14
                    bg.Parent = p.Character
                    table.insert(espObjs, bg)
                end
            end
        end
    end)

    -- SPEED FLY
    local sfState = false
    local sfSpd = 100
    local bvSf, bgSf
    addToggle("Speed Fly (hybryda)", false, function(v)
        sfState = v
        local c = getChar()
        if not c then return end
        local r = getRoot()
        local h = getHum()
        if not r or not h then return end
        if v then
            h.PlatformStand = true
            bgSf = Instance.new("BodyGyro")
            bgSf.Parent = r
            bgSf.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bgSf.P = 9e9
            bgSf.D = 9e9
            bvSf = Instance.new("BodyVelocity")
            bvSf.Parent = r
            bvSf.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bvSf.Velocity = Vector3.new(0, 0, 0)
        else
            h.PlatformStand = false
            if bgSf then bgSf:Destroy() bgSf = nil end
            if bvSf then bvSf:Destroy() bvSf = nil end
        end
    end)
    addSlider("Speed Fly Speed", 50, 999, 100, function(v) sfSpd = v end)
    RunS.RenderStepped:Connect(function()
        if sfState and bvSf then
            local dir = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            bvSf.Velocity = dir * sfSpd
        end
    end)

    -- Infinite Jump
    addBtn("Infinite Jump", function()
        local h = getHum()
        if h then h.JumpPower = 200 end
        UIS.JumpRequest:Connect(function()
            local h2 = getHum()
            if h2 then h2:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end)

    -- CHAT BYPASS
    addBtn("Chat Bypass (ASCII +1)", function()
        local old = plr.SayMessageRequest
        plr.SayMessageRequest = function(msg, ...)
            local bypassed = ""
            for i = 1, #msg do
                local c = string.byte(msg:sub(i, i))
                if c >= 33 and c <= 126 then
                    bypassed = bypassed .. string.char(c + 1)
                else
                    bypassed = bypassed .. msg:sub(i, i)
                end
            end
            return old(plr, bypassed, ...)
        end
    end)

    -- Anti-Cheat Bypass
    addBtn("Bypass Anti-Cheat", function()
        for _, v in ipairs(game:GetDescendants()) do
            pcall(function()
                if (v:IsA("Script") or v:IsA("LocalScript")) and (v.Name:lower():find("anticheat") or v.Name:lower():find("anti.cheat") or v.Name:lower():find("detect")) then
                    v.Disabled = true
                end
                if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("kick") or v.Name:lower():find("ban") or v.Name:lower():find("detect")) then
                    v:Destroy()
                end
            end)
        end
    end)

    -- Gravity
    addSlider("Gravity", -200, 200, 196.2, function(v) WS.Gravity = v end)

    -- Jump Power
    addSlider("Jump Power", 50, 500, 50, function(v)
        local h = getHum()
        if h then h.JumpPower = v end
    end)

    -- Rejoin
    addBtn("Rejoin Server", function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end)

    -- Server Hop
    addBtn("Server Hop", function()
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"))
        end)
        if success and data and #data.data > 0 then
            local job = data.data[math.random(1, #data.data)]
            if job and job.id then
                ts:TeleportToPlaceInstance(placeId, job.id, plr)
            end
        end
    end)

    -- Watch Player
    local watchTarget = ""
    local watchState = false
    local watchConn
    addInput("Obserwuj gracza (nazwa)", "Username", function(v) watchTarget = v end)
    addToggle("Obserwuj gracza", false, function(v)
        watchState = v
        if v and watchTarget ~= "" then
            local p = game.Players:FindFirstChild(watchTarget)
            if p then
                watchConn = RunS.RenderStepped:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, p.Character.HumanoidRootPart.Position)
                    end
                end)
            end
        else
            if watchConn then watchConn:Disconnect() watchConn = nil end
        end
    end)

    -- Delete Doors / Barriers
    addBtn("Usuń drzwi / bariery", function()
        for _, obj in ipairs(WS:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and (obj.Name:lower():find("door") or obj.Name:lower():find("barrier") or obj.Name:lower():find("wall")) then
                    obj:Destroy()
                end
            end)
        end
    end)

    -- Bring All Items
    addBtn("Bring All Items", function()
        local my = getRoot()
        if not my then return end
        for _, obj in ipairs(WS:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and not obj:IsA("Tool") and not obj.Parent:IsA("Player") then
                    obj.CFrame = my.CFrame * CFrame.new(math.random(-3,3), 1, math.random(-3,3))
                end
            end)
        end
    end)

    -- Silent Aim (uproszczony)
    local silentState = false
    addToggle("Silent Aim (LPM)", false, function(v) silentState = v end)
    RunS.RenderStepped:Connect(function()
        if silentState and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local closest, dist = nil, 90
            local myPos = Vector2.new(mouse.X, mouse.Y)
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local sp, onSc = cam:WorldToViewportPoint(head.Position)
                        if onSc then
                            local d2 = (Vector2.new(sp.X, sp.Y) - myPos).Magnitude
                            if d2 < dist then closest = head; dist = d2 end
                        end
                    end
                end
            end
            if closest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
            end
        end
    end)

    -- Keybinds via buttons
    addBtn("[F] Przełącz Fly", function()
        local btn = f:FindFirstChild("Fly [ON]", true) or f:FindFirstChild("Fly [OFF]", true)
        if btn then btn:Click() end
    end)
    addBtn("[N] Przełącz Noclip", function()
        local btn = f:FindFirstChild("Noclip [ON]", true) or f:FindFirstChild("Noclip [OFF]", true)
        if btn then btn:Click() end
    end)
    addBtn("[G] Przełącz Speed", function()
        local btn = f:FindFirstChild("Speed [ON]", true) or f:FindFirstChild("Speed [OFF]", true)
        if btn then btn:Click() end
    end)

    scr.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scr.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    Rayfield = {
        Notify = function(tbl)
            print("[BlazeCode] " .. tbl.Title .. ": " .. tbl.Content)
        end
    }

    return
end

-- ====== JEŚLI RAYFIELD ZAŁADOWANY ======
local Window = Rayfield:CreateWindow({
    Name = "BlazeCode x Turcja",
    LoadingTitle = "BlazeCode",
    LoadingSubtitle = "by Turcja & Orinlo",
    ConfigurationSaving = { Enabled = true, FolderName = "BlazeCodeTurcja", FileName = "cfg" },
    Discord = { Enabled = false },
    KeySystem = false
})

-- ====== UTYLITASY ======
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local mouse = LP:GetMouse()

local function getChar(p) return p.Character end
local function getRoot(p) local c = getChar(p); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(p) local c = getChar(p); return c and c:FindFirstChildOfClass("Humanoid") end

-- ====== TAB 1 — LOCALS ======
local T1 = Window:CreateTab("Locals", "6031094663")

local flyActive, flySpeed = false, 50
local bG, bV
T1:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v)
    flyActive = v
    local c = getChar(LP); if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart"); local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end
    if v then
        h.PlatformStand = true
        bG = Instance.new("BodyGyro"); bG.Parent = r; bG.MaxTorque = Vector3.new(9e9,9e9,9e9); bG.P = 9e9; bG.D = 9e9
        bV = Instance.new("BodyVelocity"); bV.Parent = r; bV.MaxForce = Vector3.new(9e9,9e9,9e9); bV.Velocity = Vector3.new(0,0,0)
    else
        h.PlatformStand = false
        if bG then bG:Destroy(); bG = nil end
        if bV then bV:Destroy(); bV = nil end
    end
end})
T1:CreateSlider({ Name = "Fly Speed", Min = 5, Max = 500, Default = 50, Increment = 5, Callback = function(v) flySpeed = v end })
RunService.RenderStepped:Connect(function()
    if flyActive and bV then
        local d = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then d = d + Vector3.new(0,-1,0) end
        bV.Velocity = d * flySpeed
    end
end)

local spdActive, spdVal = false, 32
T1:CreateToggle({ Name = "Speed", CurrentValue = false, Callback = function(v) spdActive = v end })
T1:CreateSlider({ Name = "Speed Value", Min = 16, Max = 250, Default = 32, Increment = 1, Callback = function(v) spdVal = v end })
RunService.RenderStepped:Connect(function()
    if spdActive then local h = getHum(LP); if h then h.WalkSpeed = spdVal end end
end)

local sfActive, sfSpd = false, 100
local bGS, bVS
T1:CreateToggle({ Name = "Speed Fly", CurrentValue = false, Callback = function(v)
    sfActive = v
    local c = getChar(LP); if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart"); local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end
    if v then
        h.PlatformStand = true
        bGS = Instance.new("BodyGyro"); bGS.Parent = r; bGS.MaxTorque = Vector3.new(9e9,9e9,9e9); bGS.P = 9e9; bGS.D = 9e9
        bVS = Instance.new("BodyVelocity"); bVS.Parent = r; bVS.MaxForce = Vector3.new(9e9,9e9,9e9); bVS.Velocity = Vector3.new(0,0,0)
    else
        h.PlatformStand = false
        if bGS then bGS:Destroy(); bGS = nil end
        if bVS then bVS:Destroy(); bVS = nil end
    end
end})
T1:CreateSlider({ Name = "SpeedFly Speed", Min = 50, Max = 999, Default = 100, Increment = 10, Callback = function(v) sfSpd = v end })
RunService.RenderStepped:Connect(function()
    if sfActive and bVS then
        local d = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + Camera.CFrame.RightVector end
        bVS.Velocity = d * sfSpd
    end
end)

local ncActive, ncConn
T1:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v)
    ncActive = v
    if v then
        ncConn = RunService.Stepped:Connect(function()
            for _, p in ipairs(getChar(LP):GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end)
    else if ncConn then ncConn:Disconnect(); ncConn = nil end end
end})

local whActive, whList = false, {}
T1:CreateToggle({ Name = "Wallhack", CurrentValue = false, Callback = function(v)
    whActive = v
    if not v then for _, h in ipairs(whList) do pcall(function() h:Destroy() end) end; whList = {} end
end})
RunService.RenderStepped:Connect(function()
    if whActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and getChar(p) and not getChar(p):FindFirstChildOfClass("Highlight") then
                local hl = Instance.new("Highlight"); hl.Adornee = getChar(p); hl.FillColor = Color3.fromRGB(255,50,50); hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.3; hl.Parent = getChar(p)
                table.insert(whList, hl)
            end
        end
    end
end)

-- ====== TAB 2 — TP ======
local T2 = Window:CreateTab("TP & Control", "6031094663")
local tpName = ""
T2:CreateInput({ Name = "TP to player", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Callback = function(v) tpName = v end })
T2:CreateButton({ Name = "TP to Player", Callback = function()
    local p = Players:FindFirstChild(tpName)
    if p and getRoot(p) and getRoot(LP) then getRoot(LP).CFrame = getRoot(p).CFrame * CFrame.new(0,3,0) end
end})
T2:CreateButton({ Name = "TP to Mouse", Callback = function()
    local t = mouse.Target; if t and getRoot(LP) then getRoot(LP).CFrame = t.CFrame * CFrame.new(0,3,0) end
end})
T2:CreateButton({ Name = "Bring All", Callback = function()
    local mr = getRoot(LP); if not mr then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getRoot(p) then getRoot(p).CFrame = mr.CFrame * CFrame.new(math.random(-5,5),2,math.random(-5,5)) end
    end
end})
T2:CreateButton({ Name = "Fling All", Callback = function()
    local mr = getRoot(LP); if not mr then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getRoot(p) then
            local r = getRoot(p); r.CFrame = mr.CFrame * CFrame.new(0,2,0)
            local bv = Instance.new("BodyVelocity"); bv.Velocity = Vector3.new(math.random(-500,500),500,math.random(-500,500)); bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Parent = r
            game:GetService("Debris"):AddItem(bv,0.5)
        end
    end
end})
local vwName, vwActive, vwConn = "", false
T2:CreateInput({ Name = "Watch player", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Callback = function(v) vwName = v end })
T2:CreateToggle({ Name = "Watch Player", CurrentValue = false, Callback = function(v)
    vwActive = v
    if v and vwName ~= "" then
        local p = Players:FindFirstChild(vwName)
        if p then vwConn = RunService.RenderStepped:Connect(function()
            if getRoot(p) then Camera.CFrame = CFrame.new(Camera.CFrame.Position, getRoot(p).Position) end
        end) end
    else if vwConn then vwConn:Disconnect(); vwConn = nil end end
end})

-- ====== TAB 3 — COMBAT ======
local T3 = Window:CreateTab("Combat", "6031094663")
local aimOn, silentOn, aimF = false, false, 90
T3:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) aimOn = v end })
T3:CreateToggle({ Name = "Silent Aim", CurrentValue = false, Callback = function(v) silentOn = v end })
T3:CreateSlider({ Name = "FOV", Min = 10, Max = 360, Default = 90, Increment = 5, Callback = function(v) aimF = v end })
T3:CreateDropdown({ Name = "Aim Part", Options = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, CurrentOption = "Head", Callback = function() end })
local function getTarget(fov)
    local cl, cd = nil, fov; local mp = Vector2.new(mouse.X, mouse.Y)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getChar(p) and getHum(p) and getHum(p).Health > 0 then
            local part = getChar(p):FindFirstChild("Head")
            if part then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude; if d < cd then cl = part; cd = d end end
            end
        end
    end
    return cl
end
RunService.RenderStepped:Connect(function()
    if aimOn and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getTarget(aimF); if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
    if silentOn and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = getTarget(aimF); if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
end)

local espOn, espTags = false, {}
T3:CreateToggle({ Name = "ESP Full", CurrentValue = false, Callback = function(v)
    espOn = v
    if not v then for _, o in ipairs(espTags) do pcall(function() o:Destroy() end) end; espTags = {} end
end})
RunService.RenderStepped:Connect(function()
    if espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and getChar(p) and not getChar(p):FindFirstChild("BlazeESP") then
                local hl = Instance.new("Highlight"); hl.Adornee = getChar(p); hl.FillColor = Color3.fromRGB(255,255,0); hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.2; hl.Parent = getChar(p); table.insert(espTags, hl)
                local bg = Instance.new("BillboardGui"); bg.Name = "BlazeESP"; bg.Adornee = getChar(p):FindFirstChild("Head") or getRoot(p); bg.Size = UDim2.new(0,150,0,30); bg.StudsOffset = Vector3.new(0,3,0); bg.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bg); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = p.Name .. " [" .. math.floor(getHum(p).Health or 0) .. "HP]"; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextStrokeTransparency = 0.3; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; bg.Parent = getChar(p); table.insert(espTags, bg)
            end
        end
    end
end)

-- ====== TAB 4 — BYPASS ======
local T4 = Window:CreateTab("Bypasses", "6031094663")
T4:CreateButton({ Name = "Chat Bypass", Callback = function()
    local old = LP.SayMessageRequest
    LP.SayMessageRequest = function(msg, ...)
        local b = ""
        for i = 1, #msg do local c = string.byte(msg:sub(i,i)); if c >= 33 and c <= 126 then b = b .. string.char(c+1) else b = b .. msg:sub(i,i) end end
        return old(LP, b, ...)
    end
end})
T4:CreateButton({ Name = "Anti-Cheat Bypass", Callback = function()
    for _, v in ipairs(game:GetDescendants()) do
        pcall(function()
            if (v:IsA("Script") or v:IsA("LocalScript")) and (v.Name:lower():find("anticheat") or v.Name:lower():find("detect")) then v.Disabled = true end
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("kick") or v.Name:lower():find("ban")) then v:Destroy() end
        end)
    end
end})

-- ====== TAB 5 — WORLD ======
local T5 = Window:CreateTab("World", "6031094663")
T5:CreateButton({ Name = "Bring All Items", Callback = function()
    local mr = getRoot(LP); if not mr then return end
    for _, o in ipairs(Workspace:GetDescendants()) do
        pcall(function() if o:IsA("BasePart") and not o:IsA("Tool") and not o.Parent:IsA("Player") then o.CFrame = mr.CFrame * CFrame.new(math.random(-3,3),1,math.random(-3,3)) end end)
    end
end})
T5:CreateButton({ Name = "Delete Doors/Barriers", Callback = function()
    for _, o in ipairs(Workspace:GetDescendants()) do
        pcall(function() if o:IsA("BasePart") and (o.Name:lower():find("door") or o.Name:lower():find("barrier") or o.Name:lower():find("wall")) then o:Destroy() end end)
    end
end})
T5:CreateSlider({ Name = "Gravity", Min = -200, Max = 200, Default = 196.2, Increment = 1, Callback = function(v) Workspace.Gravity = v end })

-- ====== TAB 6 — ADVANCED ======
local T6 = Window:CreateTab("Advanced", "6031094663")
T6:CreateButton({ Name = "Infinite Jump", Callback = function()
    local h = getHum(LP); if h then h.JumpPower = 200 end
    UserInputService.JumpRequest:Connect(function() local h2 = getHum(LP); if h2 then h2:ChangeState(Enum.HumanoidStateType.Jumping) end end)
end})
T6:CreateButton({ Name = "Rejoin", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end })
T6:CreateButton({ Name = "Server Hop", Callback = function()
    local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")) end)
    if s and d and #d.data > 0 then local j = d.data[math.random(1,#d.data)]; if j and j.id then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, j.id, LP) end end
end})
T6:CreateSlider({ Name = "Jump Power", Min = 50, Max = 500, Default = 50, Increment = 5, Callback = function(v) local h = getHum(LP); if h then h.JumpPower = v end end })

-- ====== TAB 7 — KEYBINDS ======
local T7 = Window:CreateTab("Keybinds", "6031094663")
T7:CreateKeybind({ Name = "Toggle Fly", CurrentKeybind = "F", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Fly"); if t then t:SetValue(not flyActive) end end end })
T7:CreateKeybind({ Name = "Toggle Noclip", CurrentKeybind = "N", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Noclip"); if t then t:SetValue(not ncActive) end end end })
T7:CreateKeybind({ Name = "Toggle Speed", CurrentKeybind = "G", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Speed"); if t then t:SetValue(not spdActive) end end end })

Rayfield:Notify({ Title = "BlazeCode x Turcja", Content = "Loaded. All systems armed.", Duration = 3 })
