-- ==============================================
-- 🔥 GANG HUB — Steal an Egg 🔥
-- Basado en estilo Chilli • Todo igual
-- ==============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxUI/UI/main/Library.lua"))()
local Main = Library:CreateMain("GANG HUB", "Steal an Egg")

local AutoSection = Main:AddSection("Auto")
local VisualSection = Main:AddSection("Visuals")
local MiscSection = Main:AddSection("Misc")

local Settings = {
    AutoSteal = false,
    Teleport = false,
    AntiGuard = false,
    AntiAFK = false,
    Speed = 32,
    Range = 25
}

-- 🥚 AUTO STEAL
AutoSection:AddToggle("Auto Steal Eggs", function(state)
    Settings.AutoSteal = state
end)

AutoSection:AddToggle("Teleport to Egg", function(state)
    Settings.Teleport = state
end)

AutoSection:AddSlider("Walk Speed", 16, 100, 32, function(value)
    Settings.Speed = value
end)

-- 👁️ VISUALS
VisualSection:AddToggle("Hide from Guards", function(state)
    Settings.AntiGuard = state
end)

-- ⚙️ MISC
MiscSection:AddToggle("Anti AFK", function(state)
    Settings.AntiAFK = state
end)

MiscSection:AddButton("Destroy / Close", function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
    Settings.AutoSteal = false
    Settings.AntiGuard = false
    Settings.AntiAFK = false
    Library:Destroy()
end)

-- 🔄 LOOP PRINCIPAL
task.spawn(function()
    while task.wait(0.03) do
        if not Settings.AutoSteal then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then continue end

        hum.WalkSpeed = Settings.Speed
        local closest, dist = nil, Settings.Range

        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") then
                local n = d.Name:lower()
                if string.find(n, "egg") or string.find(n, "huevo") then
                    local d2 = (hrp.Position - d.Position).Magnitude
                    if d2 < dist then
                        dist = d2
                        closest = d
                    end
                end
            end
        end

        if closest then
            if Settings.Teleport then
                pcall(function()
                    hrp.CFrame = CFrame.new(closest.Position + Vector3.new(0, 3, 0))
                end)
            end
            task.wait(0.05)
            local pr = closest:FindFirstChildOfClass("ProximityPrompt") 
                or (closest.Parent and closest.Parent:FindFirstChildOfClass("ProximityPrompt"))
            if pr then pcall(function() pr:InputHoldEnded(LocalPlayer) end) end
        end
    end
end)

-- 🛡️ ANTI GUARD
task.spawn(function()
    while task.wait(0.1) do
        if not Settings.AntiGuard then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("Model") and d:FindFirstChild("Humanoid") then
                local n = d.Name:lower()
                if string.find(n, "guard") or string.find(n, "chicken") or string.find(n, "dragon") then
                    local gr = d:FindFirstChild("HumanoidRootPart")
                    if gr and (hrp.Position - gr.Position).Magnitude < 30 then
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
    while task.wait(45) do
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

print("[GANG HUB] ✅ Loaded — Style: Chilli")
