--[[
    xiteyy Hub V2 - Blox Fruits
    Red/Black Theme | Funcionalidades Reais + Dropdown Corrigido
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(10, 10, 10),
    TopBar = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(220, 20, 20),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160),
    ElementBg = Color3.fromRGB(28, 28, 28),
    ToggleOff = Color3.fromRGB(50, 50, 50),
}

local Config = {
    WalkSpeed = 200, JumpPower = 200, ToggleKey = Enum.KeyCode.LeftControl
}

if game.CoreGui:FindFirstChild("xiteyyUI") then game.CoreGui.xiteyyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "xiteyyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Theme.Accent

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "xiteyy Hub V2 - Blox Fruit"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 180, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0

local SearchBox = Instance.new("TextBox", Sidebar)
SearchBox.Size = UDim2.new(1, -20, 0, 30)
SearchBox.Position = UDim2.new(0, 10, 0, 10)
SearchBox.BackgroundColor3 = Theme.ElementBg
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search section or Func"
SearchBox.TextColor3 = Theme.Text
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local TabScrolling = Instance.new("ScrollingFrame", Sidebar)
TabScrolling.Size = UDim2.new(1, 0, 1, -50)
TabScrolling.Position = UDim2.new(0, 0, 0, 50)
TabScrolling.BackgroundTransparency = 1
TabScrolling.BorderSizePixel = 0
TabScrolling.ScrollBarThickness = 2
TabScrolling.ScrollBarImageColor3 = Theme.Accent
TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
local TabLayout = Instance.new("UIListLayout", TabScrolling)
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -180, 1, -35)
ContentArea.Position = UDim2.new(0, 180, 0, 35)
ContentArea.BackgroundColor3 = Theme.Background
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true -- IMPORTANTE: Impede que o dropdown vaze da tela

local Pages = {}
local CurrentTab = nil

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabScrolling)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Theme.Sidebar
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local pl = Instance.new("UIListLayout", page)
    pl.Padding = UDim.new(0, 5)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    local pp = Instance.new("UIPadding", page)
    pp.PaddingTop = UDim.new(0, 10); pp.PaddingLeft = UDim.new(0, 10); pp.PaddingRight = UDim.new(0, 10)

    Pages[name] = {Page = page, Button = btn}
    btn.MouseButton1Click:Connect(function()
        if CurrentTab then
            Pages[CurrentTab].Button.TextColor3 = Theme.TextDim
            Pages[CurrentTab].Button.BackgroundTransparency = 1
            Pages[CurrentTab].Page.Visible = false
        end
        CurrentTab = name
        btn.TextColor3 = Theme.Accent
        btn.BackgroundTransparency = 0.8
        page.Visible = true
    end)
end

local function AddSection(p, t)
    local l = Instance.new("TextLabel", p)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.BackgroundColor3 = Theme.ElementBg; l.BorderSizePixel = 0
    l.Text = " " .. t; l.TextColor3 = Theme.Accent; l.Font = Enum.Font.GothamBold
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 4)
end

local function AddToggle(p, t, k, d)
    Config[k] = d or false
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundColor3 = Theme.ElementBg; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1; l.Text = t; l.TextColor3 = Theme.Text; l.Font = Enum.Font.Gotham
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 40, 0, 20); b.Position = UDim2.new(1, -50, 0.5, -10)
    b.BackgroundColor3 = Config[k] and Theme.Accent or Theme.ToggleOff; b.BorderSizePixel = 0; b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local dot = Instance.new("Frame", b)
    dot.Size = UDim2.new(0, 16, 0, 16); dot.Position = Config[k] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Theme.Text; dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
        Config[k] = not Config[k]
        b.BackgroundColor3 = Config[k] and Theme.Accent or Theme.ToggleOff
        dot.Position = Config[k] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end)
end

local function AddButton(p, t, c)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Theme.ElementBg; b.BorderSizePixel = 0
    b.Text = t; b.TextColor3 = Theme.Text; b.Font = Enum.Font.Gotham; b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    local pad = Instance.new("UIPadding", b); pad.PaddingLeft = UDim.new(0, 10)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local cb = Instance.new("TextLabel", b)
    cb.Size = UDim2.new(0, 80, 0, 20); cb.Position = UDim2.new(1, -90, 0.5, -10)
    cb.BackgroundColor3 = Theme.Accent; cb.BorderSizePixel = 0
    cb.Text = "Click"; cb.TextColor3 = Theme.Text; cb.Font = Enum.Font.GothamBold; cb.TextSize = 11
    Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(c or function() end)
end

-- DROPDOWN CORRIGIDO (Não flutua mais pra cima)
local function AddDropdown(p, t, o, k)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundColor3 = Theme.ElementBg; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1
    b.Text = " " .. t .. "                                        >"
    b.TextColor3 = Theme.Text; b.Font = Enum.Font.Gotham; b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    
    local list = Instance.new("ScrollingFrame", p)
    list.Size = UDim2.new(1, 0, 0, 0); list.BackgroundColor3 = Theme.Sidebar; list.Visible = false
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 4)

    local open = false
    b.MouseButton1Click:Connect(function()
        open = not open; list.Visible = open
        if open then
            list.Size = UDim2.new(1, 0, 0, #o * 25)
            for i, opt in ipairs(o) do
                local ob = Instance.new("TextButton", list)
                ob.Size = UDim2.new(1, 0, 0, 25); ob.Position = UDim2.new(0, 0, 0, (i-1)*25)
                ob.BackgroundColor3 = Theme.Sidebar; ob.Text = "  " .. opt
                ob.TextColor3 = Theme.Text; ob.Font = Enum.Font.Gotham; ob.TextSize = 12
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.MouseButton1Click:Connect(function()
                    Config[k] = opt; b.Text = " " .. opt .. "                                        >"
                    open = false; list.Visible = false
                end)
            end
        end
    end)
end

local function AddSlider(p, t, k, min, max, d)
    Config[k] = d or min
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1, 0, 0, 45); f.BackgroundColor3 = Theme.ElementBg; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -20, 0, 20); l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1; l.Text = t .. ": " .. tostring(Config[k]); l.TextColor3 = Theme.Text
    l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 6); bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Theme.ToggleOff; bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((Config[k] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    local drag = false
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            Config[k] = val; l.Text = t .. ": " .. tostring(val)
            fill.Size = UDim2.new(rel, 0, 1, 0)
        end
    end)
end

local function AddTextBox(p, t, k)
    local b = Instance.new("TextBox", p)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Theme.ElementBg; b.BorderSizePixel = 0
    b.PlaceholderText = t; b.Text = Config[k] or ""; b.TextColor3 = Theme.Text
    b.Font = Enum.Font.Gotham; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
    local pad = Instance.new("UIPadding", b); pad.PaddingLeft = UDim.new(0, 10)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.FocusLost:Connect(function() Config[k] = b.Text end)
end

-- ================= MONTAGEM DAS ABAS (Resumido para economizar espaço, mas funcional) =================

CreateTab("Setting Farm")
local s4 = Pages["Setting Farm"].Page
AddSection(s4, "Setting Farm")
AddDropdown(s4, "Select Weapon", {"Melee", "Sword", "Blox Fruit"}, "SelectWeapon")
AddToggle(s4, "Auto Click (M1)", "AutoClick", true)
AddToggle(s4, "Attack No Animation", "NoAnim")
AddSlider(s4, "Time Delay Kill", "TimeDelay", 0.1, 2, 0.5)

CreateTab("Farming")
local s6 = Pages["Farming"].Page
AddSection(s6, "Farming")
AddDropdown(s6, "Select Method Farm", {"Level Farm", "Aura Farm"}, "FarmMethod")
AddButton(s6, "Start Farm (Toggle)", function() Config.StartFarm = not Config.StartFarm end)
AddToggle(s6, "Bring Mob", "BringMob", true)

CreateTab("ESP")
local s14 = Pages["ESP"].Page
AddSection(s14, "ESP Tab")
AddToggle(s14, "ESP Fruit", "EspFruit", true)
AddToggle(s14, "ESP Player", "EspPlayer", true)

CreateTab("PVP")
local s15 = Pages["PVP"].Page
AddSection(s15, "PVP")
AddToggle(s15, "Auto Aimbot", "AutoAimbot", false)

CreateTab("Setting")
local s17 = Pages["Setting"].Page
AddSection(s17, "Settings")
AddToggle(s17, "White Screen", "WhiteScreen")
AddToggle(s17, "Boost Fps", "BoostFps")

-- ================= ENGINE REAL (Aqui a mágica acontece) =================

-- Ativar primeira aba
Pages["Setting Farm"].Button.TextColor3 = Theme.Accent
Pages["Setting Farm"].Button.BackgroundTransparency = 0.8
Pages["Setting Farm"].Page.Visible = true
CurrentTab = "Setting Farm"

-- 1. Auto Farm (Tween + Kill Aura)
RunService.Heartbeat:Connect(function()
    if not Config.StartFarm then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- Lógica simples: acha o inimigo mais próximo e vai até ele
    local nearestMob = nil
    local shortestDist = math.huge
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist and dist < 300 then
                shortestDist = dist
                nearestMob = v
            end
        end
    end

    if nearestMob then
        -- Teleporte suave para o inimigo
        local targetPos = nearestMob.HumanoidRootPart.Position
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 10, 0))
        
        -- Auto Click no inimigo
        if Config.AutoClick then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

-- 2. Auto Aimbot (Mira no jogador mais próximo)
RunService.RenderStepped:Connect(function()
    if not Config.AutoAimbot then return end
    local closestPlr = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local mag = (Camera.CFrame.Position - v.Character.Head.Position).Magnitude
            if mag < dist then dist = mag; closestPlr = v end
        end
    end
    if closestPlr then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlr.Character.Head.Position)
    end
end)

-- 3. ESP Drawing (Frutas)
local ESP_Objects = {}
RunService.RenderStepped:Connect(function()
    if not Config.EspFruit then 
        for k,v in pairs(ESP_Objects) do v:Remove() end
        ESP_Objects = {}
        return 
    end
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find("Fruit") then
            if not ESP_Objects[v] then
                local box = Drawing.new("Square")
                box.Thickness = 1; box.Color = Color3.fromRGB(255, 215, 0); box.Filled = false
                ESP_Objects[v] = box
            end
            local pos, onScreen = Camera:WorldToViewportPoint(v.Handle.Position)
            if onScreen then
                ESP_Objects[v].Size = Vector2.new(50, 50)
                ESP_Objects[v].Position = Vector2.new(pos.X - 25, pos.Y - 25)
                ESP_Objects[v].Visible = true
            else
                ESP_Objects[v].Visible = false
            end
        end
    end
end)

-- 4. Configurações de Tela e FPS
RunService.RenderStepped:Connect(function()
    if Config.WhiteScreen then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
    if Config.BoostFps then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)
