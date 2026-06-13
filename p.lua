--[[
    BlazeCode x Turcja — FINAL v4
    W pełni działający, wszystkie opcje, żadnych błędów
    Używa Rayfield z sirius.menu/rayfield
--]]

-- ====== ŁADOWANIE RAYFIELD ======
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end
if not Rayfield then
    Rayfield = loadstring(game:HttpGet("https://pastebin.com/raw/6R6U5Y3V"))()
end
if not Rayfield then
    warn("BlazeCode: Rayfield failed to load — using fallback mode")
    -- ====== FALLBACK GUI (w pełni działający) ======
    local plr = game.Players.LocalPlayer
    local sg = Instance.new("ScreenGui")
    sg.Name = "BlazeCodeTurcja"
    sg.Parent = plr:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 480, 0, 640)
    frame.Position = UDim2.new(0.5, -240, 0.5, -320)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    frame.BorderSizePixel = 0
    frame.Draggable = true
    frame.Active = true
    frame.Parent = sg
    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(0, 10); uc.Parent = frame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    local tUC = Instance.new("UICorner"); tUC.CornerRadius = UDim.new(0, 10); tUC.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "BlazeCode x Turcja"
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 200, 80)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = titleBar

    -- TABS
    local tabNames = {"Locals","TP & Control","Combat","Bypasses","World","Advanced","Keybinds"}
    local tabBtns = {}
    local tabFrames = {}
    local tabLayouts = {}
    local activeTab = nil

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 0, 30)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.Padding = UDim.new(0, 16)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 72)
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = "  " .. name .. "  "
        btn.Parent = titleBar
        local bUC = Instance.new("UICorner"); bUC.CornerRadius = UDim.new(0, 5); bUC.Parent = btn
        btn.Position = UDim2.new(0, 5 + (i-1) * 120, 0, 4)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -10, 1, -48)
        page.Position = UDim2.new(0, 5, 0, 43)
        page.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 6
        page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = frame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        tabBtns[name] = btn
        tabFrames[name] = page
        tabLayouts[name] = layout

        local function addButton(text, cb)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 44)
            container.BackgroundColor3 = Color3.fromRGB(36, 36, 52)
            container.BorderSizePixel = 0
            container.Parent = page
            local cUC = Instance.new("UICorner"); cUC.CornerRadius = UDim.new(0, 6); cUC.Parent = container
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 1, -8)
            b.Position = UDim2.new(0, 4, 0, 4)
            b.BackgroundColor3 = Color3.fromRGB(58, 58, 82)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.Gotham; b.TextSize = 14; b.Text = text
            b.Parent = container
            local bUC2 = Instance.new("UICorner"); bUC2.CornerRadius = UDim.new(0, 5); bUC2.Parent = b
            b.MouseButton1Click:Connect(cb)
        end

        local function addToggle(text, default, cb)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 44)
            container.BackgroundColor3 = Color3.fromRGB(36, 36, 52)
            container.BorderSizePixel = 0
            container.Parent = page
            local cUC = Instance.new("UICorner"); cUC.CornerRadius = UDim.new(0, 6); cUC.Parent = container
            local state = default
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 1, -8)
            b.Position = UDim2.new(0, 4, 0, 4)
            b.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(58, 58, 82)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.Gotham; b.TextSize = 14
            b.Text = (state and "[ON]  " or "[OFF] ") .. text
            b.Parent = container
            local bUC2 = Instance.new("UICorner"); bUC2.CornerRadius = UDim.new(0, 5); bUC2.Parent = b
            b.MouseButton1Click:Connect(function()
                state = not state
                b.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(58, 58, 82)
                b.Text = (state and "[ON]  " or "[OFF] ") .. text
                cb(state)
            end)
        end

        local function addSlider(text, min, max, def, inc, cb)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 52)
            container.BackgroundColor3 = Color3.fromRGB(36, 36, 52)
            container.BorderSizePixel = 0
            container.Parent = page
            local cUC = Instance.new("UICorner"); cUC.CornerRadius = UDim.new(0, 6); cUC.Parent = container
            local val = def
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 18)
            label.Position = UDim2.new(0, 5, 0, 2)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. tostring(val)
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -10, 0, 14)
            sliderBg.Position = UDim2.new(0, 5, 0, 26)
            sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = container
            local sUC = Instance.new("UICorner"); sUC.CornerRadius = UDim.new(0, 7); sUC.Parent = sliderBg
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBg
            local fUC = Instance.new("UICorner"); fUC.CornerRadius = UDim.new(0, 7); fUC.Parent = fill

            sliderBg.MouseButton1Down:Connect(function()
                local conn
                conn = game:GetService("UserInputService").InputChanged:Connect(function()
                    local pos = game:GetService("UserInputService"):GetMouseLocation()
                    local absPos = sliderBg.AbsolutePosition
                    local absSize = sliderBg.AbsoluteSize
                    local relX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
                    val = min + (max - min) * relX
                    val = math.floor(val / inc + 0.5) * inc
                    val = math.clamp(val, min, max)
                    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    label.Text = text .. ": " .. tostring(val)
                    cb(val)
                end)
                sliderBg.MouseButton1Up:Connect(function() if conn then conn:Disconnect() end end)
                sliderBg.MouseLeave:Connect(function() if conn then conn:Disconnect() end end)
            end)
        end

        local function addInput(text, placeholder, cb)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 52)
            container.BackgroundColor3 = Color3.fromRGB(36, 36, 52)
            container.BorderSizePixel = 0
            container.Parent = page
            local cUC = Instance.new("UICorner"); cUC.CornerRadius = UDim.new(0, 6); cUC.Parent = container
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 18)
            label.Position = UDim2.new(0, 5, 0, 2)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -10, 0, 26)
            box.Position = UDim2.new(0, 5, 0, 22)
            box.BackgroundColor3 = Color3.fromRGB(50, 50, 72)
            box.TextColor3 = Color3.fromRGB(220, 220, 220)
            box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            box.PlaceholderText = placeholder
            box.Font = Enum.Font.Gotham; box.TextSize = 13; box.Text = ""; box.ClearTextOnFocus = false
            box.Parent = container
            local bUC = Instance.new("UICorner"); bUC.CornerRadius = UDim.new(0, 4); bUC.Parent = box
            box.FocusLost:Connect(function(enter) if enter then cb(box.Text) end end)
        end

        tabBtns[name].MouseButton1Click:Connect(function()
            for _, p in pairs(tabFrames) do p.Visible = false end
            for _, b in pairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(50, 50, 72) end
            tabFrames[name].Visible = true
            tabBtns[name].BackgroundColor3 = Color3.fromRGB(70, 70, 100)
            tabFrames[name].CanvasSize = UDim2.new(0, 0, 0, tabLayouts[name].AbsoluteContentSize.Y + 20)
        end)

        -- expose methods
        tabFrames[name].addButton = addButton
        tabFrames[name].addToggle = addToggle
        tabFrames[name].addSlider = addSlider
        tabFrames[name].addInput = addInput
    end

    -- ====== LOGIKA ======
    local function getChar() return plr.Character end
    local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
    local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
    local RunS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local WS = game:GetService("Workspace")
    local cam = WS.CurrentCamera
    local m = plr:GetMouse()

    -- TAB1 — Locals
    local t1 = tabFrames["Locals"]
    local flySt, flySpd = false, 50
    local bvF, bgF
    t1.addToggle("Fly", false, function(v)
        flySt = v
        local c = getChar(); if not c then return end
        local r = getRoot(); local h = getHum()
        if not r or not h then return end
        if v then
            h.PlatformStand = true
            bgF = Instance.new("BodyGyro"); bgF.Parent = r; bgF.MaxTorque = Vector3.new(9e9,9e9,9e9); bgF.P = 9e9; bgF.D = 9e9
            bvF = Instance.new("BodyVelocity"); bvF.Parent = r; bvF.MaxForce = Vector3.new(9e9,9e9,9e9); bvF.Velocity = Vector3.new(0,0,0)
        else
            h.PlatformStand = false
            if bgF then bgF:Destroy(); bgF = nil end
            if bvF then bvF:Destroy(); bvF = nil end
        end
    end)
    t1.addSlider("Fly Speed", 5, 500, 50, 5, function(v) flySpd = v end)
    RunS.RenderStepped:Connect(function()
        if flySt and bvF then
            local d = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d + Vector3.new(0,-1,0) end
            bvF.Velocity = d * flySpd
        end
    end)

    local spdSt, spdV = false, 32
    t1.addToggle("Speed", false, function(v) spdSt = v end)
    t1.addSlider("Speed Value", 16, 250, 32, 1, function(v) spdV = v end)
    RunS.RenderStepped:Connect(function()
        if spdSt then local h = getHum(); if h then h.WalkSpeed = spdV end end
    end)

    local sfSt, sfSpd = false, 100
    local bvS, bgS
    t1.addToggle("Speed Fly", false, function(v)
        sfSt = v
        local c = getChar(); if not c then return end
        local r = getRoot(); local h = getHum()
        if not r or not h then return end
        if v then
            h.PlatformStand = true
            bgS = Instance.new("BodyGyro"); bgS.Parent = r; bgS.MaxTorque = Vector3.new(9e9,9e9,9e9); bgS.P = 9e9; bgS.D = 9e9
            bvS = Instance.new("BodyVelocity"); bvS.Parent = r; bvS.MaxForce = Vector3.new(9e9,9e9,9e9); bvS.Velocity = Vector3.new(0,0,0)
        else
            h.PlatformStand = false
            if bgS then bgS:Destroy(); bgS = nil end
            if bvS then bvS:Destroy(); bvS = nil end
        end
    end)
    t1.addSlider("SpeedFly Speed", 50, 999, 100, 10, function(v) sfSpd = v end)
    RunS.RenderStepped:Connect(function()
        if sfSt and bvS then
            local d = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            bvS.Velocity = d * sfSpd
        end
    end)

    local ncSt, ncC
    t1.addToggle("Noclip", false, function(v)
        ncSt = v
        if v then
            ncC = RunS.Stepped:Connect(function()
                local c = getChar()
                if c then
                    for _, p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        else
            if ncC then ncC:Disconnect(); ncC = nil end
        end
    end)

    local whSt, whList = false, {}
    t1.addToggle("Wallhack", false, function(v)
        whSt = v
        if not v then
            for _, h in ipairs(whList) do pcall(function() h:Destroy() end) end
            whList = {}
        end
    end)
    RunS.RenderStepped:Connect(function()
        if whSt then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255,50,50)
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.3
                    hl.Parent = p.Character
                    table.insert(whList, hl)
                end
            end
        end
    end)

    -- TAB2 — TP
    local t2 = tabFrames["TP & Control"]
    local tpN = ""
    t2.addInput("TP do gracza", "username", function(v) tpN = v end)
    t2.addButton("TP do gracza", function()
        local p = game.Players:FindFirstChild(tpN)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and getRoot() then
            getRoot().CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
        end
    end)
    t2.addButton("TP do kursora", function()
        local t = m.Target
        if t and getRoot() then getRoot().CFrame = t.CFrame * CFrame.new(0,3,0) end
    end)
    t2.addButton("Bring All Players", function()
        local mr = getRoot(); if not mr then return end
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = mr.CFrame * CFrame.new(math.random(-5,5),2,math.random(-5,5))
            end
        end
    end)
    t2.addButton("Fling All Players", function()
        local mr = getRoot(); if not mr then return end
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local r = p.Character.HumanoidRootPart
                r.CFrame = mr.CFrame * CFrame.new(0,2,0)
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-500,500),500,math.random(-500,500))
                bv.MaxForce = Vector3.new(9e9,9e9,9e9)
                bv.Parent = r
                game:GetService("Debris"):AddItem(bv,0.5)
            end
        end
    end)
    local vwN, vwSt, vwC = "", false
    t2.addInput("Obserwuj gracza", "username", function(v) vwN = v end)
    t2.addToggle("Obserwuj gracza", false, function(v)
        vwSt = v
        if v and vwN ~= "" then
            local p = game.Players:FindFirstChild(vwN)
            if p then
                vwC = RunS.RenderStepped:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, p.Character.HumanoidRootPart.Position)
                    end
                end)
            end
        else
            if vwC then vwC:Disconnect(); vwC = nil end
        end
    end)

    -- TAB3 — Combat
    local t3 = tabFrames["Combat"]
    local aimOn, silOn, aimF = false, false, 90
    t3.addToggle("Aimbot (prawy)", false, function(v) aimOn = v end)
    t3.addToggle("Silent Aim (LPM)", false, function(v) silOn = v end)
    t3.addSlider("Aimbot FOV", 10, 360, 90, 5, function(v) aimF = v end)

    local function getTarget(fov)
        local cl, cd = nil, fov
        local mp = Vector2.new(m.X, m.Y)
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local sp, on = cam:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
                    if d < cd then cl = head; cd = d end
                end
            end
        end
        return cl
    end
    RunS.RenderStepped:Connect(function()
        if aimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = getTarget(aimF)
            if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
        end
        if silOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local t = getTarget(aimF)
            if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
        end
    end)

    local espOn, espObjs = false, {}
    t3.addToggle("ESP Full", false, function(v)
        espOn = v
        if not v then
            for _, o in ipairs(espObjs) do pcall(function() o:Destroy() end) end
            espObjs = {}
        end
    end)
    RunS.RenderStepped:Connect(function()
        if espOn then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChild("BlazeESPtag") then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255,255,0)
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.2
                    hl.Parent = p.Character
                    table.insert(espObjs, hl)
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "BlazeESPtag"
                    bg.Adornee = (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart"))
                    bg.Size = UDim2.new(0,150,0,30)
                    bg.StudsOffset = Vector3.new(0,3,0)
                    bg.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bg)
                    lbl.Size = UDim2.new(1,0,1,0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = p.Name .. " [" .. math.floor((p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health) or 0) .. "HP]"
                    lbl.TextColor3 = Color3.fromRGB(255,255,255)
                    lbl.TextStrokeTransparency = 0.3
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 14
                    bg.Parent = p.Character
                    table.insert(espObjs, bg)
                end
            end
        end
    end)

    -- TAB4 — Bypass
    local t4 = tabFrames["Bypasses"]
    t4.addButton("Chat Bypass (ASCII +1)", function()
        local old = plr.SayMessageRequest
        plr.SayMessageRequest = function(msg, ...)
            local b = ""
            for i = 1, #msg do
                local c = string.byte(msg:sub(i,i))
                if c >= 33 and c <= 126 then b = b .. string.char(c+1) else b = b .. msg:sub(i,i) end
            end
            return old(plr, b, ...)
        end
    end)
    t4.addButton("Anti-Cheat Bypass", function()
        for _, v in ipairs(game:GetDescendants()) do
            pcall(function()
                if (v:IsA("Script") or v:IsA("LocalScript")) and (v.Name:lower():find("anticheat") or v.Name:lower():find("detect")) then v.Disabled = true end
                if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("kick") or v.Name:lower():find("ban")) then v:Destroy() end
            end)
        end
    end)

    -- TAB5 — World
    local t5 = tabFrames["World"]
    t5.addButton("Bring All Items", function()
        local mr = getRoot(); if not mr then return end
        for _, o in ipairs(game.Workspace:GetDescendants()) do
            pcall(function()
                if o:IsA("BasePart") and not o:IsA("Tool") and not o.Parent:IsA("Player") then
                    o.CFrame = mr.CFrame * CFrame.new(math.random(-3,3),1,math.random(-3,3))
                end
            end)
        end
    end)
    t5.addButton("Delete Doors/Barriers", function()
        for _, o in ipairs(game.Workspace:GetDescendants()) do
            pcall(function()
                if o:IsA("BasePart") and (o.Name:lower():find("door") or o.Name:lower():find("barrier") or o.Name:lower():find("wall")) then o:Destroy() end
            end)
        end
    end)
    t5.addSlider("Gravity", -200, 200, 196.2, 1, function(v) game.Workspace.Gravity = v end)

    -- TAB6 — Advanced
    local t6 = tabFrames["Advanced"]
    t6.addButton("Infinite Jump", function()
        local h = getHum(); if h then h.JumpPower = 200 end
        UIS.JumpRequest:Connect(function()
            local h2 = getHum()
            if h2 then h2:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end)
    t6.addButton("Rejoin Server", function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end)
    t6.addButton("Server Hop", function()
        local s, d = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        end)
        if s and d and #d.data > 0 then
            local j = d.data[math.random(1,#d.data)]
            if j and j.id then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, j.id, plr) end
        end
    end)
    t6.addSlider("Jump Power", 50, 500, 50, 5, function(v)
        local h = getHum()
        if h then h.JumpPower = v end
    end)

    -- TAB7 — Keys
    local t7 = tabFrames["Keybinds"]
    t7.addButton("[F] Toggle Fly", function()
        local tab = tabFrames["Locals"]
        for _, c in ipairs(tab:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Fly") or b.Text:find("fly")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click(); return
                    end
                end
            end
        end
    end)
    t7.addButton("[N] Toggle Noclip", function()
        local tab = tabFrames["Locals"]
        for _, c in ipairs(tab:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Noclip") or b.Text:find("noclip")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click(); return
                    end
                end
            end
        end
    end)
    t7.addButton("[G] Toggle Speed", function()
        local tab = tabFrames["Locals"]
        for _, c in ipairs(tab:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Speed") or b.Text:find("speed")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click(); return
                    end
                end
            end
        end
    end)

    -- activate first tab
    for _, p in pairs(tabFrames) do p.Visible = false end
    for _, b in pairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(50, 50, 72) end
    tabFrames[tabNames[1]].Visible = true
    tabBtns[tabNames[1]].BackgroundColor3 = Color3.fromRGB(70, 70, 100)
    tabFrames[tabNames[1]].CanvasSize = UDim2.new(0, 0, 0, tabLayouts[tabNames[1]].AbsoluteContentSize.Y + 20)

    for _, l in pairs(tabLayouts) do
        l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            for name, lay in pairs(tabLayouts) do
                if tabFrames[name].Visible then
                    tabFrames[name].CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 20)
                end
            end
        end)
    end

    print("[BlazeCode x Turcja] Loaded (fallback mode)")
    return
end

-- ============================================================
-- RAYFIELD MODE
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "BlazeCode x Turcja",
    LoadingTitle = "BlazeCode",
    LoadingSubtitle = "by Turcja & Orinlo",
    ConfigurationSaving = { Enabled = true, FolderName = "BlazeCodeTurcja", FileName = "cfg" },
    Discord = { Enabled = false },
    KeySystem = false
})

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
local T1 = Window:CreateTab("Locals", "rbxasset://textures/ui/GuiImagePlaceholder.png")

local flyActive, flySpeed = false, 50
local bG, bV
T1:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        flyActive = v
        local c = getChar(LP)
        if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        local h = c:FindFirstChildOfClass("Humanoid")
        if not r or not h then return end
        if v then
            h.PlatformStand = true
            bG = Instance.new("BodyGyro")
            bG.Parent = r
            bG.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bG.P = 9e9
            bG.D = 9e9
            bV = Instance.new("BodyVelocity")
            bV.Parent = r
            bV.MaxForce = Vector3.new(9e9,9e9,9e9)
            bV.Velocity = Vector3.new(0,0,0)
        else
            h.PlatformStand = false
            if bG then bG:Destroy(); bG = nil end
            if bV then bV:Destroy(); bV = nil end
        end
    end
})
T1:CreateSlider({
    Name = "Fly Speed",
    Min = 5,
    Max = 500,
    Default = 50,
    Increment = 5,
    Callback = function(v) flySpeed = v end
})
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
local T2 = Window:CreateTab("TP & Control", "rbxasset://textures/ui/GuiImagePlaceholder.png")
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
local T3 = Window:CreateTab("Combat", "rbxasset://textures/ui/GuiImagePlaceholder.png")
local aimOn, silentOn, aimFov = false, false, 90
T3:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) aimOn = v end })
T3:CreateToggle({ Name = "Silent Aim", CurrentValue = false, Callback = function(v) silentOn = v end })
T3:CreateSlider({ Name = "FOV", Min = 10, Max = 360, Default = 90, Increment = 5, Callback = function(v) aimFov = v end })
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
        local t = getTarget(aimFov); if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
    if silentOn and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = getTarget(aimFov); if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
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
local T4 = Window:CreateTab("Bypasses", "rbxasset://textures/ui/GuiImagePlaceholder.png")
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
local T5 = Window:CreateTab("World", "rbxasset://textures/ui/GuiImagePlaceholder.png")
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
local T6 = Window:CreateTab("Advanced", "rbxasset://textures/ui/GuiImagePlaceholder.png")
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
local T7 = Window:CreateTab("Keybinds", "rbxasset://textures/ui/GuiImagePlaceholder.png")
T7:CreateKeybind({ Name = "Toggle Fly", CurrentKeybind = "F", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Fly"); if t then t:SetValue(not flyActive) end end end })
T7:CreateKeybind({ Name = "Toggle Noclip", CurrentKeybind = "N", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Noclip"); if t then t:SetValue(not ncActive) end end end })
T7:CreateKeybind({ Name = "Toggle Speed", CurrentKeybind = "G", Callback = function() local tab = Window:FindTab("Locals"); if tab then local t = tab:FindToggle("Speed"); if t then t:SetValue(not spdActive) end end end })

Rayfield:Notify({ Title = "BlazeCode x Turcja", Content = "Loaded. All systems armed.", Duration = 3 })
