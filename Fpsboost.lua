if getgenv().duy_xboost then
    return
end
getgenv().duy_xboost = true

local a = game:GetService("Lighting")
local b = game:GetService("Players")
local c = game:GetService("RunService")
local d = workspace:FindFirstChildOfClass("Terrain")

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

pcall(function()
    if sethiddenproperty then
        sethiddenproperty(game, "MeshPartHeadsAndAccessories", "Disabled")
    end
end)

pcall(function()
    if setfpscap then
        setfpscap(999)
    end
end)

pcall(function()

    a.GlobalShadows = false
    a.FogEnd = 9e9
    a.Brightness = 0
    a.ClockTime = 14
    a.EnvironmentDiffuseScale = 0
    a.EnvironmentSpecularScale = 0
    a.OutdoorAmbient = Color3.new(1,1,1)
    a.Ambient = Color3.new(1,1,1)

    for _,v in ipairs(a:GetDescendants()) do

        if v:IsA("Atmosphere")
        or v:IsA("Sky")
        or v:IsA("PostEffect") then

            v:Destroy()
        end
    end

end)

pcall(function()

    if d then
        d.WaterWaveSize = 0
        d.WaterWaveSpeed = 0
        d.WaterReflectance = 0
        d.WaterTransparency = 1
    end

end)

local function e(f)

    pcall(function()

        if f:IsA("BasePart") then

            f.CastShadow = false
            f.Reflectance = 0
            f.Material = Enum.Material.Plastic
            f.TopSurface = Enum.SurfaceType.Smooth
            f.BottomSurface = Enum.SurfaceType.Smooth

            if not f:IsDescendantOf(b.LocalPlayer.Character or workspace) then
                f.Color = Color3.fromRGB(80,80,80)
            end
        end

        if f:IsA("UnionOperation") then
            f.UsePartColor = true
            f.Material = Enum.Material.Plastic
        end

        if f:IsA("MeshPart") then
            f.TextureID = ""
            f.RenderFidelity = Enum.RenderFidelity.Performance
            f.Material = Enum.Material.Plastic
        end

        if f:IsA("SpecialMesh") then
            f.TextureId = ""
        end

        if f:IsA("Texture")
        or f:IsA("Decal") then

            f.Transparency = 1
        end

        if f:IsA("ParticleEmitter")
        or f:IsA("Trail")
        or f:IsA("Smoke")
        or f:IsA("Fire")
        or f:IsA("Sparkles")
        or f:IsA("Beam") then

            f.Enabled = false
        end

        if f:IsA("SurfaceAppearance")
        or f:IsA("Highlight") then

            f:Destroy()
        end

        if f:IsA("Explosion") then
            f.BlastPressure = 0
            f.BlastRadius = 0
        end

        if f:IsA("Clothing")
        or f:IsA("ShirtGraphic")
        or f:IsA("Accessory") then

            f:Destroy()
        end

        if f:IsA("Sound") then
            f.Volume = 0
        end

    end)

end

for _,g in ipairs(game:GetDescendants()) do
    e(g)
end

game.DescendantAdded:Connect(e)

task.spawn(function()

    while task.wait(5) do

        pcall(function()

            for _,h in ipairs(workspace:GetDescendants()) do

                if h:IsA("ParticleEmitter")
                or h:IsA("Trail")
                or h:IsA("Smoke")
                or h:IsA("Fire")
                or h:IsA("Sparkles")
                or h:IsA("Beam") then

                    h.Enabled = false
                end

                if h:IsA("Texture")
                or h:IsA("Decal") then

                    h.Transparency = 1
                end

                if h:IsA("Sound") then
                    h.Volume = 0
                end

            end

            collectgarbage("collect")

        end)

    end

end)

local function i(j)

    pcall(function()

        local k = j.Character
        if not k then
            return
        end

        for _,l in ipairs(k:GetDescendants()) do

            if l:IsA("Accessory")
            or l:IsA("Clothing")
            or l:IsA("ShirtGraphic") then

                l:Destroy()
            end

            if l:IsA("BasePart") then
                l.Material = Enum.Material.Plastic
                l.CastShadow = false
            end

        end

    end)

end

for _,m in ipairs(b:GetPlayers()) do

    i(m)

    m.CharacterAdded:Connect(function()
        task.wait(0.5)
        i(m)
    end)

end

b.PlayerAdded:Connect(function(n)

    n.CharacterAdded:Connect(function()
        task.wait(0.5)
        i(n)
    end)

end)

pcall(function()
    workspace.StreamingEnabled = true
end)

pcall(function()
    game:GetService("UserSettings").GameSettings.MasterVolume = 0
end)

task.spawn(function()

    while task.wait(30) do
        pcall(function()
            Stats = game:GetService("Stats")

            if Stats then
                collectgarbage("collect")
            end
        end)
    end

end)
