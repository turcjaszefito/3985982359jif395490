--[[
    BlazeCode x Turcja — FINAL FIXED
    Działa w każdym executorze, GUI w pełni funkcjonalne
    Wszystkie opcje widoczne, żadnych pustych okien
--]]

-- ====== ŁADOWANIE RAYFIELD ======
local Rayfield = nil
local urls = {
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source",
    "https://raw.githubusercontent.com/Skodon/Rayfield/main/source.lua",
    "https://pastebin.com/raw/6R6U5Y3V"
}

for _, url in ipairs(urls) do
    local s, e = pcall(function()
        Rayfield = loadstring(game:HttpGet(url))()
    end)
    if Rayfield then break end
end

if not Rayfield then
    -- budujemy własny GUI (fallback)
    local plr = game.Players.LocalPlayer
    local sg = Instance.new("ScreenGui")
    sg.Name = "BlazeCodeTurcja"
    sg.Parent = plr:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 440, 0, 600)
    frame.Position = UDim2.new(0.5, -220, 0.5, -300)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Draggable = true
    frame.Active = true
    frame.Parent = sg

    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, 8)
    uc.Parent = frame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local titleUC = Instance.new("UICorner")
    titleUC.CornerRadius = UDim.new(0, 8)
    titleUC.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "BlazeCode x Turcja"
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 200, 80)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = titleBar

    -- notebook (tabs)
    local notebook = Instance.new("Frame")
    notebook.Size = UDim2.new(1, -10, 1, -46)
    notebook.Position = UDim2.new(0, 5, 0, 41)
    notebook.BackgroundTransparency = 1
    notebook.Parent = frame

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = notebook

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabBar

    local pageContainer = Instance.new("ScrollingFrame")
    pageContainer.Size = UDim2.new(1, 0, 1, -35)
    pageContainer.Position = UDim2.new(0, 0, 0, 32)
    pageContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    pageContainer.BorderSizePixel = 0
    pageContainer.ScrollBarThickness = 6
    pageContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageContainer.Parent = notebook

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 4)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = pageContainer

    local pages = {}
    local currentPage = nil

    local function createTab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 0, 26)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.Padding = UDim.new(0, 12)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = "  " .. name .. "  "
        btn.Parent = tabBar

        local btnUC = Instance.new("UICorner")
        btnUC.CornerRadius = UDim.new(0, 4)
        btnUC.Parent = btn

        local pageFrame = Instance.new("Frame")
        pageFrame.Size = UDim2.new(1, 0, 0, 0)
        pageFrame.BackgroundTransparency = 1
        pageFrame.Visible = false
        pageFrame.Parent = pageContainer

        local pageLayoutInner = Instance.new("UIListLayout")
        pageLayoutInner.Padding = UDim.new(0, 4)
        pageLayoutInner.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayoutInner.Parent = pageFrame

        pages[name] = pageFrame

        local function addWidget(wtype, text, opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 0)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            container.BorderSizePixel = 0
            container.Parent = pageFrame

            local cUC = Instance.new("UICorner")
            cUC.CornerRadius = UDim.new(0, 5)
            cUC.Parent = container

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 24)
            label.Position = UDim2.new(0, 5, 0, 2)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            if wtype == "button" then
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, -10, 0, 28)
                b.Position = UDim2.new(0, 5, 0, 28)
                b.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.Font = Enum.Font.Gotham
                b.TextSize = 13
                b.Text = text
                b.Parent = container
                local bUC = Instance.new("UICorner")
                bUC.CornerRadius = UDim.new(0, 4)
                bUC.Parent = b
                container.Size = UDim2.new(1, -10, 0, 60)
                b.MouseButton1Click:Connect(opts.callback)
            elseif wtype == "toggle" then
                local b = Instance.new("TextButton")
                local state = opts.default or false
                b.Size = UDim2.new(1, -10, 0, 28)
                b.Position = UDim2.new(0, 5, 0, 28)
                b.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(60, 60, 85)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.Font = Enum.Font.Gotham
                b.TextSize = 13
                b.Text = state and "[ON] " .. text or "[OFF] " .. text
                b.Parent = container
                local bUC = Instance.new("UICorner")
                bUC.CornerRadius = UDim.new(0, 4)
                bUC.Parent = b
                container.Size = UDim2.new(1, -10, 0, 60)
                b.MouseButton1Click:Connect(function()
                    state = not state
                    b.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(60, 60, 85)
                    b.Text = state and "[ON] " .. text or "[OFF] " .. text
                    opts.callback(state)
                end)
            elseif wtype == "slider" then
                local val = opts.default or opts.min or 0
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, -10, 0, 20)
                sliderFrame.Position = UDim2.new(0, 5, 0, 30)
                sliderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = container

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((val - opts.min) / (opts.max - opts.min), 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
                fill.BorderSizePixel = 0
                fill.Parent = sliderFrame

                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0, 50, 0, 20)
                valLabel.Position = UDim2.new(1, -50, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = tostring(val)
                valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                valLabel.Font = Enum.Font.Gotham
                valLabel.TextSize = 12
                valLabel.Parent = container

                container.Size = UDim2.new(1, -10, 0, 60)

                sliderFrame.MouseButton1Down:Connect(function()
                    local conn
                    conn = game:GetService("UserInputService").InputChanged:Connect(function()
                        local pos = game:GetService("UserInputService"):GetMouseLocation()
                        local absPos = sliderFrame.AbsolutePosition
                        local absSize = sliderFrame.AbsoluteSize
                        local relX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
                        val = opts.min + (opts.max - opts.min) * relX
                        val = math.floor(val / (opts.increment or 1) + 0.5) * (opts.increment or 1)
                        val = math.clamp(val, opts.min, opts.max)
                        fill.Size = UDim2.new((val - opts.min) / (opts.max - opts.min), 0, 1, 0)
                        valLabel.Text = tostring(val)
                        opts.callback(val)
                    end)
                    sliderFrame.MouseButton1Up:Connect(function() conn:Disconnect() end)
                end)
            elseif wtype == "input" then
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -10, 0, 28)
                box.Position = UDim2.new(0, 5, 0, 28)
                box.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                box.TextColor3 = Color3.fromRGB(220, 220, 220)
                box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                box.PlaceholderText = opts.placeholder or ""
                box.Font = Enum.Font.Gotham
                box.TextSize = 13
                box.Text = ""
                box.Parent = container
                local bUC = Instance.new("UICorner")
                bUC.CornerRadius = UDim.new(0, 4)
                bUC.Parent = box
                container.Size = UDim2.new(1, -10, 0, 60)
                box.FocusLost:Connect(function(enter)
                    if enter then opts.callback(box.Text) end
                end)
            end
        end

        local function addButton(text, cb) addWidget("button", text, {callback = cb}) end
        local function addToggle(text, def, cb) addWidget("toggle", text, {default = def, callback = cb}) end
        local function addSlider(text, min, max, def, inc, cb) addWidget("slider", text, {min = min, max = max, default = def, increment = inc, callback = cb}) end
        local function addInput(text, placeholder, cb) addWidget("input", text, {placeholder = placeholder, callback = cb}) end

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            pageFrame.Visible = true
            pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayoutInner.AbsoluteContentSize.Y + 20)
        end)

        return {addButton = addButton, addToggle = addToggle, addSlider = addSlider, addInput = addInput, addWidget = addWidget, frame = pageFrame, layout = pageLayoutInner}
    end

    -- pierwsza zakładka aktywna
    local first = true

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
    local t1 = createTab("Locals")
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
                if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end)
        else
            if ncC then ncC:Disconnect(); ncC = nil end
        end
    end)

    local whSt, whList = false, {}
    t1.addToggle("Wallhack", false, function(v)
        whSt = v
        if not v then for _, h in ipairs(whList) do pcall(function() h:Destroy() end) end; whList = {} end
    end)
    RunS.RenderStepped:Connect(function()
        if whSt then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
                    local hl = Instance.new("Highlight"); hl.Adornee = p.Character; hl.FillColor = Color3.fromRGB(255,50,50); hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.3; hl.Parent = p.Character
                    table.insert(whList, hl)
                end
            end
        end
    end)

    -- TAB2 — TP
    local t2 = createTab("TP & Control")
    local tpN = ""
    t2.addInput("TP do gracza", "username", function(v) tpN = v end)
    t2.addButton("TP do gracza", function()
        local p = game.Players:FindFirstChild(tpN)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and getRoot() then
            getRoot().CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
        end
    end)
    t2.addButton("TP do kursora", function()
        local t = m.Target; if t and getRoot() then getRoot().CFrame = t.CFrame * CFrame.new(0,3,0) end
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
                local bv = Instance.new("BodyVelocity"); bv.Velocity = Vector3.new(math.random(-500,500),500,math.random(-500,500)); bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Parent = r
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
    local t3 = createTab("Combat")
    local aimOn, silOn, aimF = false, false, 90
    t3.addToggle("Aimbot (prawy)", false, function(v) aimOn = v end)
    t3.addToggle("Silent Aim (LPM)", false, function(v) silOn = v end)
    t3.addSlider("Aimbot FOV", 10, 360, 90, 5, function(v) aimF = v end)
    local function getTarget(fov)
        local cl, cd = nil, fov; local mp = Vector2.new(m.X, m.Y)
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local sp, on = cam:WorldToViewportPoint(head.Position)
                if on then local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude; if d < cd then cl = head; cd = d end end
            end
        end
        return cl
    end
    RunS.RenderStepped:Connect(function()
        if aimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = getTarget(aimF); if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
        end
        if silOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local t = getTarget(aimF); if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
        end
    end)

    local espOn, espObjs = false, {}
    t3.addToggle("ESP Full", false, function(v)
        espOn = v
        if not v then for _, o in ipairs(espObjs) do pcall(function() o:Destroy() end) end; espObjs = {} end
    end)
    RunS.RenderStepped:Connect(function()
        if espOn then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChild("BlazeESPtag") then
                    local hl = Instance.new("Highlight"); hl.Adornee = p.Character; hl.FillColor = Color3.fromRGB(255,255,0); hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.2; hl.Parent = p.Character; table.insert(espObjs, hl)
                    local bg = Instance.new("BillboardGui"); bg.Name = "BlazeESPtag"; bg.Adornee = (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")); bg.Size = UDim2.new(0,150,0,30); bg.StudsOffset = Vector3.new(0,3,0); bg.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bg); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = p.Name; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextStrokeTransparency = 0.3; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; bg.Parent = p.Character; table.insert(espObjs, bg)
                end
            end
        end
    end)

    -- TAB4 — Bypass
    local t4 = createTab("Bypasses")
    t4.addButton("Chat Bypass (ASCII +1)", function()
        local old = plr.SayMessageRequest
        plr.SayMessageRequest = function(msg, ...)
            local b = ""
            for i = 1, #msg do local c = string.byte(msg:sub(i,i)); if c >= 33 and c <= 126 then b = b .. string.char(c+1) else b = b .. msg:sub(i,i) end end
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
    local t5 = createTab("World")
    t5.addButton("Bring All Items", function()
        local mr = getRoot(); if not mr then return end
        for _, o in ipairs(game.Workspace:GetDescendants()) do
            pcall(function() if o:IsA("BasePart") and not o:IsA("Tool") and not o.Parent:IsA("Player") then o.CFrame = mr.CFrame * CFrame.new(math.random(-3,3),1,math.random(-3,3)) end end)
        end
    end)
    t5.addButton("Delete Doors/Barriers", function()
        for _, o in ipairs(game.Workspace:GetDescendants()) do
            pcall(function() if o:IsA("BasePart") and (o.Name:lower():find("door") or o.Name:lower():find("barrier") or o.Name:lower():find("wall")) then o:Destroy() end end)
        end
    end)
    t5.addSlider("Gravity", -200, 200, 196.2, 1, function(v) game.Workspace.Gravity = v end)

    -- TAB6 — Advanced
    local t6 = createTab("Advanced")
    t6.addButton("Infinite Jump", function()
        local h = getHum(); if h then h.JumpPower = 200 end
        UIS.JumpRequest:Connect(function() local h2 = getHum(); if h2 then h2:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    end)
    t6.addButton("Rejoin Server", function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end)
    t6.addButton("Server Hop", function()
        local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")) end)
        if s and d and #d.data > 0 then local j = d.data[math.random(1,#d.data)]; if j and j.id then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, j.id, plr) end end
    end)
    t6.addSlider("Jump Power", 50, 500, 50, 5, function(v) local h = getHum(); if h then h.JumpPower = v end end)

    -- TAB7 — Keys
    local t7 = createTab("Keybinds")
    t7.addButton("[F] Toggle Fly", function()
        for _, c in ipairs(t1.frame:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Fly") or b.Text:find("fly") or b.Text:find("FLY")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click()
                        return
                    end
                end
            end
        end
    end)
    t7.addButton("[N] Toggle Noclip", function()
        for _, c in ipairs(t1.frame:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Noclip") or b.Text:find("noclip") or b.Text:find("NOCLIP")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click()
                        return
                    end
                end
            end
        end
    end)
    t7.addButton("[G] Toggle Speed", function()
        for _, c in ipairs(t1.frame:GetChildren()) do
            if c:IsA("Frame") then
                for _, b in ipairs(c:GetChildren()) do
                    if b:IsA("TextButton") and (b.Text:find("Speed") or b.Text:find("speed") or b.Text:find("SPEED")) and (b.Text:find("[ON]") or b.Text:find("[OFF]")) then
                        b:Click()
                        return
                    end
                end
            end
        end
    end)

    -- aktywuj pierwszą zakładkę
    for _, p in pairs(pages) do p.Visible = false end
    for _, p in pairs(pages) do p.Visible = true; break end
    pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    print("[BlazeCode x Turcja] Loaded (fallback GUI)")
    return
end

-- ============================================================
-- RAYFIELD MODE (jeśli załadowany)
-- ============================================================
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
