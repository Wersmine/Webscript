-- ============================================
-- WEBSHUB UNIVERSAL (FULL) by Webs_My
-- ============================================

local WebsHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wersmine/WebsHubv0.1/refs/heads/main/WebsHub.lua?v=1001"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = WebsHub:CreateWindow({ Name = "Webs_My v4", Subtitle = "by Webs_My" })
local MainTab = Window:CreateTab("Main")
local MoveTab = Window:CreateTab("Movement")
local EspTab = Window:CreateTab("ESP")
local AimTab = Window:CreateTab("Aimbot")
local TpTab = Window:CreateTab("Teleport")
local PlrTab = Window:CreateTab("Players")
local RageTab = Window:CreateTab("Rage")
local VisTab = Window:CreateTab("Visual")
local UtilTab = Window:CreateTab("Util")

-- HUD
local HudGui = Instance.new("ScreenGui", game.CoreGui)
HudGui.Name = "WebsHUD" HudGui.ResetOnSpawn = false
local HudFrame = Instance.new("Frame", HudGui)
HudFrame.Size = UDim2.new(0, 260, 0, 56) HudFrame.Position = UDim2.new(0, 10, 0, 40) HudFrame.BackgroundColor3 = Color3.fromRGB(15,15,15) HudFrame.BackgroundTransparency = 0.25
Instance.new("UICorner", HudFrame).CornerRadius = UDim.new(0, 8)
local Coords = Instance.new("TextLabel", HudFrame)
Coords.Size = UDim2.new(1,0,0.6,0) Coords.BackgroundTransparency = 1 Coords.TextColor3 = Color3.fromRGB(0,255,120) Coords.Font = Enum.Font.Code Coords.TextSize = 14 Coords.Text = "X: 0 Y: 0 Z: 0"
local Fps = Instance.new("TextLabel", HudFrame)
Fps.Size = UDim2.new(1,0,0.4,0) Fps.Position = UDim2.new(0,0,0.6,0) Fps.BackgroundTransparency = 1 Fps.TextColor3 = Color3.fromRGB(255,200,60) Fps.Font = Enum.Font.Code Fps.TextSize = 13 Fps.Text = "FPS: — Ping: —"

task.spawn(function()
    local count, time = 0, tick()
    while task.wait(0.1) do
        if not HudGui.Parent then break end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then local p = char.HumanoidRootPart.Position Coords.Text = "X: " .. math.floor(p.X) .. " Y: " .. math.floor(p.Y) .. " Z: " .. math.floor(p.Z) end
        count = count + 1
        if tick() - time >= 1 then local ping = "—" pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end) Fps.Text = "FPS: " .. count .. " Ping: " .. ping count, time = 0, tick() end
    end
end)

-- MAIN
local ws, jp, spinEnabled, spinSpeed, rgbEnabled = 16, 50, false, 360, false
local function applyStats(char) if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.WalkSpeed = ws char.Humanoid.UseJumpPower = true char.Humanoid.JumpPower = jp end end
WebsHub:CreateSection(MainTab, "Персонаж")
WebsHub:CreateSlider(MainTab, { Name = "Скорость", Min = 16, Max = 1000, CurrentValue = 16, Callback = function(v) ws = v applyStats(LocalPlayer.Character) end })
WebsHub:CreateSlider(MainTab, { Name = "Прыжок", Min = 50, Max = 5000, CurrentValue = 50, Callback = function(v) jp = v applyStats(LocalPlayer.Character) end })
WebsHub:CreateSlider(MainTab, { Name = "Скорость Spin", Min = 0, Max = 5000, CurrentValue = 360, Callback = function(v) spinSpeed = v end })
WebsHub:CreateToggle(MainTab, { Name = "Spin", CurrentValue = false, Callback = function(s) spinEnabled = s end })
WebsHub:CreateToggle(MainTab, { Name = "RGB", CurrentValue = false, Callback = function(s) rgbEnabled = s end })
RunService.Heartbeat:Connect(function(dt)
    if spinEnabled and LocalPlayer.Character then local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed)*dt, 0) end end
    if rgbEnabled and LocalPlayer.Character then local col = Color3.fromHSV(tick()%1, 1, 1) for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do if obj:IsA("BasePart") then obj.Color = col end end end
end)
WebsHub:CreateSection(MainTab, "Система")
WebsHub:CreateButton(MainTab, { Name = "🛑 ЗАКРЫТЬ СКРИПТ", Callback = function() HudGui:Destroy() Window.ScreenGui:Destroy() end })

-- MOVEMENT
local noclip, fly, flySpeed, flyBV = false, false, 50, nil
WebsHub:CreateSection(MoveTab, "Noclip")
WebsHub:CreateToggle(MoveTab, { Name = "Noclip", CurrentValue = false, Callback = function(s) noclip = s end })
RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
WebsHub:CreateSection(MoveTab, "Полёт")
WebsHub:CreateSlider(MoveTab, { Name = "Скорость полёта", Min = 10, Max = 500, CurrentValue = 50, Callback = function(v) flySpeed = v end })
WebsHub:CreateToggle(MoveTab, { Name = "Fly", CurrentValue = false, Callback = function(s)
    fly = s
    if fly and LocalPlayer.Character then flyBV = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart) flyBV.MaxForce = Vector3.new(1e6,1e6,1e6) elseif not fly and flyBV then flyBV:Destroy() end
end })
RunService.RenderStepped:Connect(function()
    if fly and flyBV and LocalPlayer.Character then local cam = workspace.CurrentCamera local move = LocalPlayer.Character.Humanoid.MoveDirection flyBV.Velocity = cam.CFrame.LookVector * move.Z * flySpeed + cam.CFrame.RightVector * move.X * flySpeed end
end)
WebsHub:CreateSection(MoveTab, "Гравитация")
WebsHub:CreateSlider(MoveTab, { Name = "Гравитация", Min = 0, Max = 200, CurrentValue = workspace.Gravity, Callback = function(v) workspace.Gravity = v end })

-- ESP
local espBox, espName, espTracer, espBoxSize, espObjects, tracerLines = false, false, false, 3, {}, {}
local function clearESP(plr) if espObjects[plr] then for _, obj in pairs(espObjects[plr]) do obj:Destroy() end espObjects[plr] = nil end if tracerLines[plr] then pcall(function() tracerLines[plr]:Remove() end) tracerLines[plr] = nil end end
local function createESP(plr)
    clearESP(plr) espObjects[plr] = {} local char = plr.Character if not char then return end local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end
    if espBox then local box = Instance.new("BoxHandleAdornment", hrp) box.Size = Vector3.new(espBoxSize, espBoxSize*1.8, espBoxSize) box.Adornee = hrp box.AlwaysOnTop = true box.Color3 = Color3.fromRGB(255,0,0) table.insert(espObjects[plr], box) end
    if espName then local bg = Instance.new("BillboardGui", hrp) bg.Size = UDim2.new(0,100,0,20) bg.StudsOffset = Vector3.new(0,3,0) bg.AlwaysOnTop = true local txt = Instance.new("TextLabel", bg) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.Text = plr.Name txt.TextColor3 = Color3.fromRGB(255,255,255) txt.Font = Enum.Font.SourceSansBold table.insert(espObjects[plr], bg) end
end
local function updateAllESP() for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer then createESP(plr) end end end
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if espTracer and Drawing then
                if not tracerLines[plr] then local line = Drawing.new("Line") line.Thickness = 2 line.Color = Color3.fromRGB(255,255,0) tracerLines[plr] = line end
                local line = tracerLines[plr] local char = plr.Character if char and char:FindFirstChild("HumanoidRootPart") then local cam = workspace.CurrentCamera local pos, onScreen = cam:WorldToViewportPoint(char.HumanoidRootPart.Position) if onScreen then line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y) line.To = Vector2.new(pos.X, pos.Y) line.Visible = true else line.Visible = false end else line.Visible = false end
            elseif tracerLines[plr] then pcall(function() tracerLines[plr]:Remove() end) tracerLines[plr] = nil end
        end
    end
end)
WebsHub:CreateSection(EspTab, "ESP Настройки")
WebsHub:CreateToggle(EspTab, { Name = "ESP Бокс", CurrentValue = false, Callback = function(s) espBox = s updateAllESP() end })
WebsHub:CreateToggle(EspTab, { Name = "ESP Ники", CurrentValue = false, Callback = function(s) espName = s updateAllESP() end })
WebsHub:CreateToggle(EspTab, { Name = "ESP Трейсер", CurrentValue = false, Callback = function(s) espTracer = s end })
Players.PlayerAdded:Connect(function(plr) task.wait(1) createESP(plr) end) Players.PlayerRemoving:Connect(function(plr) clearESP(plr) end)

-- AIMBOT
local aimEnabled, aimFOV, aimRange, aimSmooth, aimPart = false, 300, 500, 0.3, "Head"
WebsHub:CreateSection(AimTab, "Аимбот")
WebsHub:CreateToggle(AimTab, { Name = "Аимбот", CurrentValue = false, Callback = function(s) aimEnabled = s end })
WebsHub:CreateSlider(AimTab, { Name = "FOV", Min = 50, Max = 1500, CurrentValue = 300, Callback = function(v) aimFOV = v end })
WebsHub:CreateSlider(AimTab, { Name = "Плавность", Min = 0.02, Max = 1, CurrentValue = 0.3, Callback = function(v) aimSmooth = v end })
local function getClosestTarget()
    local cam = workspace.CurrentCamera local camPos = cam.CFrame.Position local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2) local closest, closestScore = nil, aimFOV
    for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character then local hum = plr.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Health > 0 then local part = plr.Character:FindFirstChild(aimPart) or plr.Character:FindFirstChild("Head") if part then if (part.Position - camPos).Magnitude <= aimRange then local screenPos, onScreen = cam:WorldToViewportPoint(part.Position) if onScreen then local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude if screenDist < closestScore then closestScore = screenDist closest = part end end end end end end end
    return closest
end
RunService:BindToRenderStep("AimCam", Enum.RenderPriority.Camera.Value + 1, function()
    if not aimEnabled then return end local target = getClosestTarget() if not target then return end local cam = workspace.CurrentCamera cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), math.clamp(aimSmooth, 0, 1))
end)

-- TELEPORT
local savedPoints = {}
WebsHub:CreateSection(TpTab, "Сохранение точек")
for i = 1, 5 do
    WebsHub:CreateButton(TpTab, { Name = "Сохранить точку " .. i, Callback = function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then savedPoints[i] = LocalPlayer.Character.HumanoidRootPart.Position WebsHub:Notify("Сохранено", "Точка " .. i, 2) end end })
    WebsHub:CreateButton(TpTab, { Name = "ТП к точке " .. i, Callback = function() if savedPoints[i] and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[i] + Vector3.new(0,3,0)) end end })
end

-- PLAYERS
WebsHub:CreateSection(PlrTab, "Действия с ближайшим")
WebsHub:CreateButton(PlrTab, { Name = "🚀 ТП к ближайшему", Callback = function()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude if d < dist then dist = d closest = p.Character.HumanoidRootPart end end end
    if closest then LocalPlayer.Character.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0,3,0) end
end })
WebsHub:CreateButton(PlrTab, { Name = "🎣 Притянуть ближайшего", Callback = function()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude if d < dist then dist = d closest = p.Character.HumanoidRootPart end end end
    if closest then local bp = Instance.new("BodyPosition", closest) bp.MaxForce = Vector3.new(math.huge,math.huge,math.huge) bp.Position = LocalPlayer.Character.HumanoidRootPart.Position task.delay(3, function() bp:Destroy() end) end
end })
WebsHub:CreateButton(PlrTab, { Name = "💀 Убить ближайшего", Callback = function()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude if d < dist then dist = d closest = p.Character:FindFirstChildOfClass("Humanoid") end end end
    if closest then closest.Health = 0 end
end })
WebsHub:CreateButton(PlrTab, { Name = "🚀 Подбросить всех", Callback = function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then p.Character:PivotTo(CFrame.new(p.Character.HumanoidRootPart.Position.X, 5000, p.Character.HumanoidRootPart.Position.Z)) end end end })

-- RAGE
local invisibleEnabled = false
WebsHub:CreateSection(RageTab, "Невидимость")
WebsHub:CreateToggle(RageTab, { Name = "Включить", CurrentValue = false, Callback = function(s) invisibleEnabled = s end })
task.spawn(function() while task.wait(0.1) do if invisibleEnabled and LocalPlayer.Character then for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do if obj:IsA("BasePart") then obj.Transparency = 1 end end end end end)

-- VISUAL
local origBrightness, origClockTime, origAmbient, origOutdoor, origFogEnd, origFogStart, origShadows = Lighting.Brightness, Lighting.ClockTime, Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.FogEnd, Lighting.FogStart, Lighting.GlobalShadows
WebsHub:CreateSection(VisTab, "Графика")
WebsHub:CreateToggle(VisTab, { Name = "Улучшенная графика", CurrentValue = false, Callback = function(s)
    if s then Lighting.Brightness = 3 Lighting.ClockTime = 14 Lighting.Ambient = Color3.fromRGB(180,180,180) Lighting.OutdoorAmbient = Color3.fromRGB(180,180,180) Lighting.FogEnd = 100000 Lighting.FogStart = 100000 Lighting.GlobalShadows = false
    else Lighting.Brightness = origBrightness Lighting.ClockTime = origClockTime Lighting.Ambient = origAmbient Lighting.OutdoorAmbient = origOutdoor Lighting.FogEnd = origFogEnd Lighting.FogStart = origFogStart Lighting.GlobalShadows = origShadows end
end })

-- UTIL
WebsHub:CreateSection(UtilTab, "Утилиты")
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
WebsHub:CreateButton(UtilTab, { Name = "🔄 Server Hop", Callback = function()
    local ts = game:GetService("TeleportService") local placeId = game.PlaceId
    pcall(function() local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")) for _, s in pairs(servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then ts:TeleportToPlaceInstance(placeId, s.id, LocalPlayer) break end end end)
end })
WebsHub:CreateButton(UtilTab, { Name = "🔁 Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end })

Window:CreateMinimizeButton(UDim2.new(0, 20, 0.5, -17))
WebsHub:Notify("WebsHub", "Универсал загружен!", 4)