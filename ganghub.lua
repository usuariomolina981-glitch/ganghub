-- 🔥 GANG HUB — Steal an Egg 🔥
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local running = true

local Settings = {
    StealSpeed = 32,
    GrabRange = 25,
    AntiGuardActive = true,
    AntiAFKActive = true
}

task.spawn(function()
    while running do
        task.wait(0.03)
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then continue end
        hum.WalkSpeed = Settings.StealSpeed
        local closestEgg, minDist = nil, Settings.GrabRange
        for _, d in ipairs(Workspace:GetDescendants()) do
            local nom = d.Name:lower()
            if d:IsA("BasePart") and (string.find(nom, "egg") or string.find(nom, "huevo")) then
                local dist = (hrp.Position - d.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestEgg = d
                end
            end
        end
        if closestEgg then
            hrp.CFrame = CFrame.new(closestEgg.Position + Vector3.new(0, 3, 0))
            task.wait(0.05)
            local prompt = closestEgg:FindFirstChildOfClass("ProximityPrompt")
            if not prompt and closestEgg.Parent then
                prompt = closestEgg.Parent:FindFirstChildOfClass("ProximityPrompt")
            end
            if prompt then prompt:InputHoldEnded(LocalPlayer) end
        end
    end
end)

local guardianNames = {"chicken", "swan", "scorpion", "tiger", "yeti", "dragon", "guardian", "guard"}
task.spawn(function()
    while running and Settings.AntiGuardActive do
        task.wait(0.08)
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

task.spawn(function()
    while running and Settings.AntiAFKActive do
        task.wait(45)
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

local Gui = Instance.new("ScreenGui")
Gui.Name = "GANGHUB"
Gui.Parent = game.CoreGui
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 160)
Main.Position = UDim2.new(0.02, 0, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.CornerRadius = UDim.new(0, 12)
Main.Parent = Gui
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(220, 28, 60)
Title.Text = "🔥 GANG HUB 🔥"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = Main
local function Label(texto, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 28)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.fromRGB(80, 255, 120)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Main
end
Label("✅ AutoSteal + Teleport", 55)
Label("✅ AntiGuard — Indetectable", 90)
Label("✅ AntiAFK — Activo", 125)
print("[GANG HUB] ✅ CARGADO")
