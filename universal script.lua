-- ============================================
-- WEBS_MY MULTI-CHEAT v4.1 (Rayfield) by Webs_My
-- Добавлен Fly v2 (По камере)
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Webs_My v4.1",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by Webs_My",
    ConfigurationSaving = { Enabled = false }
})

-- ============================================
-- HUD
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "WebsHUD"
ScreenGui.ResetOnSpawn = false

local HudFrame = Instance.new("Frame")
HudFrame.Size = UDim2.new(0, 260, 0, 56)
HudFrame.Position = UDim2.new(0, 10, 0, 40)
HudFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
HudFrame.BackgroundTransparency = 0.25
HudFrame.BorderSizePixel = 0
HudFrame.Parent = ScreenGui
Instance.new("UICorner", HudFrame).CornerRadius = UDim.new(0, 8)

local CoordsText = Instance.new("TextLabel")
CoordsText.Size = UDim2.new(1, 0, 0.6, 0)
CoordsText.BackgroundTransparency = 1
CoordsText.TextColor3 = Color3.fromRGB(0, 255, 120)
CoordsText.Font = Enum.Font.Code
CoordsText.TextSize = 14
CoordsText.Text = "X: 0  Y: 0  Z: 0"
CoordsText.Parent = HudFrame

local FpsText = Instance.new("TextLabel")
FpsText.Size = UDim2.new(1, 0, 0.4, 0)
FpsText.Position = UDim2.new(0, 0, 0.6, 0)
FpsText.BackgroundTransparency = 1
FpsText.TextColor3 = Color3.fromRGB(255, 200, 60)
FpsText.Font = Enum.Font.Code
FpsText.TextSize = 13
FpsText.Text = "FPS: —  Ping: —"
FpsText.Parent = HudFrame

local fpsCount, fpsTime = 0, tick()
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart.Position
            CoordsText.Text = "X: " .. math.floor(p.X) .. "  Y: " .. math.floor(p.Y) .. "  Z: " .. math.floor(p.Z)
        end
        fpsCount = fpsCount + 1
        if tick() - fpsTime >= 1 then
            local ping = "—"
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            FpsText.Text = "FPS: " .. fpsCount .. "  Ping: " .. ping
            fpsCount, fpsTime = 0, tick()
        end
    end
end)
RunService.RenderStepped:Connect(function() fpsCount = fpsCount + 1 end)

-- ============================================
-- MAIN
-- ============================================
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Персонаж")

local walkSpeed = 16
local jumpPower = 50
local spinEnabled = false
local spinSpeed = 360
local rgbEnabled = false

local function applyStats(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeed
        hum.UseJumpPower = true
        hum.JumpPower = jumpPower
    end
end

MainTab:CreateSlider({ Name = "Скорость (WalkSpeed)", Range = {16, 1000}, Increment = 1, CurrentValue = 16,
    Callback = function(v) walkSpeed = v; applyStats(LocalPlayer.Character) end })
MainTab:CreateSlider({ Name = "Высота прыжка", Range = {50, 5000}, Increment = 5, CurrentValue = 50,
    Callback = function(v) jumpPower = v; applyStats(LocalPlayer.Character) end })

MainTab:CreateSection("Spin")
MainTab:CreateSlider({ Name = "Скорость вращения (°/сек)", Range = {0, 50000}, Increment = 100, CurrentValue = 360, Callback = function(v) spinSpeed = v end })
MainTab:CreateToggle({ Name = "Spin (себя)", CurrentValue = false, Callback = function(s) spinEnabled = s end })

RunService.Heartbeat:Connect(function(dt)
    if not spinEnabled then return end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed) * dt, 0) end
    end
end)

MainTab:CreateSection("RGB")
MainTab:CreateToggle({ Name = "RGB (радуга)", CurrentValue = false, Callback = function(s) rgbEnabled = s end })
task.spawn(function()
    while task.wait(0.05) do
        if rgbEnabled then
            local char = LocalPlayer.Character
            if char then
                local col = Color3.fromHSV(tick() % 1, 1, 1)
                for _, obj in pairs(char:GetDescendants()) do
                    if obj:IsA("BasePart") then obj.Color = col end
                end
            end
        end
    end
end)

MainTab:CreateSection("Система")
MainTab:CreateButton({ Name = "🛑 ЗАКРЫТЬ СКРИПТ", Callback = function() ScreenGui:Destroy() Window:Destroy() end })

-- ============================================
-- MOVEMENT
-- ============================================
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSection("Noclip")
local noclipEnabled = false
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
        local char = LocalPlayer.Character
        if char and not state then
            for _, obj in pairs(char:GetDescendants()) do if obj:IsA("BasePart") then obj.CanCollide = true end end
        end
    end })

RunService.Stepped:Connect(function()
    if not noclipEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= hrp then obj.CanCollide = false end
    end
end)

-- FLY 1 (Обычный)
MoveTab:CreateSection("Полёт (Обычный)")
local flyEnabled = false
local flySpeed = 50
local flyBV = nil
local currentVel = Vector3.new(0, 0, 0)

MoveTab:CreateSlider({ Name = "Скорость Fly", Range = {10, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) flySpeed = v end })

local function cleanupFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FlyBV")
            if bv then bv:Destroy() end
        end
    end
    currentVel = Vector3.new(0, 0, 0)
end

MoveTab:CreateToggle({ Name = "Fly (Джойстик)", CurrentValue = false,
    Callback = function(state)
        flyEnabled = state
        if state then
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            currentVel = Vector3.new(0, 0, 0)
            flyBV = Instance.new("BodyVelocity")
            flyBV.Name = "FlyBV"
            flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            flyBV.Velocity = Vector3.new(0, 0, 0)
            flyBV.Parent = hrp
        else cleanupFly() end
    end })

RunService.RenderStepped:Connect(function(dt)
    if not flyEnabled then return end
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not flyBV or not flyBV.Parent then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "FlyBV"
        flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyBV.Parent = hrp
    end
    local move = hum and hum.MoveDirection or Vector3.new(0, 0, 0)
    local camCF = cam.CFrame
    local camLook = camCF.LookVector
    local camRight = camCF.RightVector
    local camForwardFlat = Vector3.new(camLook.X, 0, camLook.Z)
    if camForwardFlat.Magnitude > 0.01 then camForwardFlat = camForwardFlat.Unit end
    local targetVel = camLook * move:Dot(camForwardFlat) + camRight * move:Dot(camRight)
    if targetVel.Magnitude > 0.01 then targetVel = targetVel.Unit * flySpeed else targetVel = Vector3.new(0, 0, 0) end
    currentVel = currentVel:Lerp(targetVel, math.clamp(dt * 8, 0, 1))
    flyBV.Velocity = currentVel
end)

-- FLY 2 (По камере)
MoveTab:CreateSection("Fly v2 (По камере)")
local flyV2Enabled = false
local flyV2Speed = 50
local flyV2BV = nil

MoveTab:CreateSlider({ Name = "Скорость Fly v2", Range = {10, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) flyV2Speed = v end })

local function cleanupFlyV2()
    if flyV2BV then flyV2BV:Destroy() flyV2BV = nil end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FlyV2BV")
            if bv then bv:Destroy() end
        end
    end
end

MoveTab:CreateToggle({ Name = "Fly v2 (Строго по камере)", CurrentValue = false,
    Callback = function(state)
        flyV2Enabled = state
        if state then
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            flyV2BV = Instance.new("BodyVelocity")
            flyV2BV.Name = "FlyV2BV"
            flyV2BV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            flyV2BV.Velocity = Vector3.new(0, 0, 0)
            flyV2BV.Parent = hrp
        else 
            cleanupFlyV2() 
        end
    end })

RunService.RenderStepped:Connect(function()
    if not flyV2Enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not flyV2BV or not flyV2BV.Parent then
        flyV2BV = Instance.new("BodyVelocity")
        flyV2BV.Name = "FlyV2BV"
        flyV2BV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyV2BV.Parent = hrp
    end

    local camLook = workspace.CurrentCamera.CFrame.LookVector
    flyV2BV.Velocity = camLook * flyV2Speed
end)

-- GRAVITY
MoveTab:CreateSection("Гравитация")
MoveTab:CreateSlider({ Name = "Гравитация", Range = {0, 200}, Increment = 1, CurrentValue = workspace.Gravity, Callback = function(v) workspace.Gravity = v end })
MoveTab:CreateButton({ Name = "Стандарт (196)", Callback = function() workspace.Gravity = 196 end })

-- ============================================
-- ESP
-- ============================================
local EspTab = Window:CreateTab("ESP", 4483362458)
EspTab:CreateSection("ESP")

local espBox = false
local espName = false
local espTracer = false
local espBoxSize = 3
local espObjects = {}
local tracerLines = {}

local function clearESP(plr)
    if espObjects[plr] then
        for _, obj in pairs(espObjects[plr]) do if obj then obj:Destroy() end end
        espObjects[plr] = nil
    end
    if tracerLines[plr] then
        pcall(function() tracerLines[plr]:Remove() end)
        tracerLines[plr] = nil
    end
end

local function createESP(plr)
    clearESP(plr)
    espObjects[plr] = {}
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if espBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_Box"
        box.Size = Vector3.new(espBoxSize, espBoxSize*1.8, espBoxSize)
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Parent = hrp
        table.insert(espObjects[plr], box)
    end
    if espName then
        local bg = Instance.new("BillboardGui")
        bg.Name = "ESP_Name"
        bg.Size = UDim2.new(0, 100, 0, 20)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = hrp
        bg.Parent = hrp
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = plr.Name
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.Font = Enum.Font.SourceSansBold
        txt.Parent = bg
        table.insert(espObjects[plr], bg)
    end
end

local function updateAllESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then createESP(plr) end
    end
end

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if espTracer and Drawing then
                if not tracerLines[plr] then
                    local line = Drawing.new("Line")
                    line.Thickness = 2
                    line.Color = Color3.fromRGB(255, 255, 0)
                    tracerLines[plr] = line
                end
                local line = tracerLines[plr]
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local cam = workspace.CurrentCamera
                    local pos, onScreen = cam:WorldToViewportPoint(char.HumanoidRootPart.Position)
                    if onScreen then
                        line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            elseif tracerLines[plr] then
                pcall(function() tracerLines[plr]:Remove() end)
                tracerLines[plr] = nil
            end
        end
    end
end)

EspTab:CreateToggle({ Name = "ESP: Бокс", CurrentValue = false, Callback = function(s) espBox = s; updateAllESP() end })
EspTab:CreateToggle({ Name = "ESP: Ники", CurrentValue = false, Callback = function(s) espName = s; updateAllESP() end })
EspTab:CreateToggle({ Name = "ESP: Трейсер", CurrentValue = false, Callback = function(s) espTracer = s end })

-- ============================================
-- AIMBOT
-- ============================================
local AimTab = Window:CreateTab("Aimbot", 4483362458)
AimTab:CreateSection("Aimbot")
local aimEnabled = false
local aimSmooth = 0.3
local aimPart = "Head"

AimTab:CreateToggle({ Name = "Aimbot (камера)", CurrentValue = false, Callback = function(s) aimEnabled = s end })
AimTab:CreateSlider({ Name = "Плавность", Range = {0.02, 1}, Increment = 0.02, CurrentValue = 0.3, Callback = function(v) aimSmooth = v end })
AimTab:CreateDropdown({ Name = "Часть тела", Options = {"Head","HumanoidRootPart","UpperTorso"}, CurrentOption = {"Head"}, Callback = function(opt) aimPart = opt[1] end })

local function getClosestTarget()
    local cam = workspace.CurrentCamera local closest, dist = nil, 300
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local part = plr.Character:FindFirstChild(aimPart) or plr.Character:FindFirstChild("Head")
            if part then
                local sp, on = cam:WorldToViewportPoint(part.Position)
                if on then local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude if d < dist then dist = d closest = part end end
            end
        end
    end
    return closest
end
RunService:BindToRenderStep("AimCam", Enum.RenderPriority.Camera.Value + 1, function()
    if not aimEnabled then return end
    local target = getClosestTarget() if not target then return end
    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position), aimSmooth)
end)

-- ============================================
-- PLAYERS
-- ============================================
local PlrTab = Window:CreateTab("Players", 4483362458)
local selectedPlayer = nil
PlrTab:CreateSection("Действия")
local playerDropdown = PlrTab:CreateDropdown({ Name = "Игрок", Options = {}, CurrentOption = {}, Callback = function(opt) if #opt > 0 then selectedPlayer = Players:FindFirstChild(opt[1]) end end })
PlrTab:CreateButton({ Name = "🔄 Обновить", Callback = function() local n = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end playerDropdown:Refresh(n) end })

PlrTab:CreateButton({ Name = "🎣 Притянуть", Callback = function()
    if selectedPlayer and selectedPlayer.Character and LocalPlayer.Character then
        local bp = Instance.new("BodyPosition", selectedPlayer.Character.HumanoidRootPart)
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = LocalPlayer.Character.HumanoidRootPart.Position
        task.delay(3, function() if bp then bp:Destroy() end end)
    end
end })
PlrTab:CreateButton({ Name = "💀 Убить", Callback = function() if selectedPlayer and selectedPlayer.Character then local h = selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end end })

-- ============================================
-- UTIL
-- ============================================
local UtilTab = Window:CreateTab("Util", 4483362458)
UtilTab:CreateSection("Система")
UtilTab:CreateButton({ Name = "🔁 Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end })

Rayfield:Notify({ Title = "Webs_My v4.1", Content = "Fly и Fly v2 готовы!", Duration = 4 })