-- ==============================================
-- 🔥 GANG HUB 2.0 — Steal an Egg 🔥
-- AutoSteal • Teleport • AntiGuard • AntiAFK
-- Ventana interactiva — Enciende/Apaga todo
-- ==============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local running = true

-- ⚙️ CONFIGURACIÓN
local Settings = {
    AutoSteal = true,
    Teleport = true,
    AntiGuard = true,
    AntiAFK = true,
    StealSpeed = 32,
    GrabRange = 25
}

-- 🥚 AUTO STEAL + TELEPORT
task.spawn(function()
    while running do
        task.wait(0.03)
        if not Settings.AutoSteal then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then continue end

        hum.WalkSpeed = Settings.StealSpeed
        local closestEgg, minDist = nil, Settings.GrabRange

        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") or d:IsA("Model") then
                local nom = d.Name:lower()
                if string.find(nom, "egg") or string.find(nom, "huevo") then
                    local part = d:IsA("Model") and d.PrimaryPart or d
                    if part then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closestEgg = part
                        end
                    end
                end
            end
        end

        if closestEgg then
            if Settings.Teleport then
                pcall(function()
                    hrp.CFrame = CFrame.new(closestEgg.Position + Vector3.new(0, 3, 0))
                end)
            end
            task.wait(0.05)
            local prompt = closestEgg:FindFirstChildOfClass("ProximityPrompt") 
                or (closestEgg.Parent and closestEgg.Parent:FindFirstChildOfClass("ProximityPrompt"))
            if prompt then
                pcall(function() prompt:InputHoldEnded(LocalPlayer) end)
            end
        end
    end
end)

-- 👁️ ANTI GUARDIAN
local guardianNames = {"chicken", "swan", "scorpion", "tiger", "yeti", "dragon", "guardian", "guard", "boss"}
task.spawn(function()
    while running do
        task.wait(0.08)
        if not Settings.AntiGuard then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("Model") and d:FindFirstChild("Humanoid") then
                local nom = d.Name:lower()
                local isGuard = false
                for _, g in ipairs(guardianNames) do
                    if string.find(nom, g) then isGuard = true break end
                end
                if isGuard then
                    local gRoot = d:FindFirstChild("HumanoidRootPart")
                    if gRoot and (hrp.Position - gRoot.Position).Magnitude < 30 then
                        char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        task.delay(2, function()
                            if char and char.Humanoid then
                                char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- 🟢 ANTI AFK
task.spawn(function()
    while running do
        task.wait(45)
        if not Settings.AntiAFK then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local orig = hrp.CFrame
            hrp.CFrame = orig * CFrame.new(0, 0.05, 0)
            task.wait(0.2)
            hrp.CFrame = orig
        end
    end
end)

-- 📋 VENTANA INTERACTIVA
local Gui = Instance.new("ScreenGui")
Gui.Name = "GANGHUB"
Gui.Parent = game.CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Ventana principal
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 340)
Main.Position = UDim2.new(0.02, 0, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
Main.CornerRadius = UDim.new(0, 16)
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundColor3 = Color3.fromRGB(220, 28, 60)
Title.Text = "🔥 GANG HUB 2.0 🔥"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = Main

-- Función para crear botones
local function CrearBoton(nombre, clave, posicionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, posicionY)
    btn.BackgroundColor3 = Settings[clave] and Color3.fromRGB(30, 200, 90) or Color3.fromRGB(60, 60, 80)
    btn.Text = (Settings[clave] and "✅ " or "❌ ") .. nombre
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.CornerRadius = UDim.new(0, 10)
    btn.AutoLocalize = false
    btn.Parent = Main

    btn.MouseButton1Click:Connect(function()
        Settings[clave] = not Settings[clave]
        btn.BackgroundColor3 = Settings[clave] and Color3.fromRGB(30, 200, 90) or Color3.fromRGB(60, 60, 80)
        btn.Text = (Settings[clave] and "✅ " or "❌ ") .. nombre
    end)
end

-- Botones de control
CrearBoton("Auto Robar Huevos", "AutoSteal", 70)
CrearBoton("Teletransportar a Huevo", "Teleport", 130)
CrearBoton("Ocultarse de Guardianes", "AntiGuard", 190)
CrearBoton("No ser expulsado (AntiAFK)", "AntiAFK", 250)

-- Pie de página
local Pie = Instance.new("TextLabel")
Pie.Size = UDim2.new(1, 0, 0, 30)
Pie.Position = UDim2.new(0, 0, 1, -30)
Pie.BackgroundTransparency = 1
Pie.Text = "💡 Toca los botones para activar/desactivar | Arrastra la ventana"
Pie.TextColor3 = Color3.fromRGB(150, 150, 180)
Pie.Font = Enum.Font.Gotham
Pie.TextSize = 10
Pie.Parent = Main

print("[GANG HUB] ✅ CARGADO — Ventana lista")
