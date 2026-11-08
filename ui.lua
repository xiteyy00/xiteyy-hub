--[[
    xiteyy Hub V2 - Blox Fruits (Engine Real)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

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
    StartFarm = false,
    AutoClick = true,
    AutoAimbot = false,
    EspFruit = false,
    BringMob = true
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
ContentArea.ClipsDescendants = true -- CORRIGE O DROPDOWN

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

-- ================= LÓGICA DO AUTO FARM REAL =================

local VirtualUser = game:GetService("VirtualUser")

-- Função para achar o inimigo mais próximo
local function GetNearestEnemy()
    local nearest = nil
    local dist = math.huge
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    -- Procura na pasta padrão de inimigos do Blox Fruits (NPCs)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, v in pairs(enemiesFolder:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local mag = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if mag < dist and mag < 250 then
                    dist = mag
                    nearest = v
                end
            end
        end
    else
        -- Fallback: Procura no Workspace inteiro se a pasta Enemies não existir
        for _, v in pairs(Workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                local mag = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if mag < dist and mag < 250 then
                    dist = mag
                    nearest = v
                end
            end
        end
    end
    return nearest
end

-- Loop do Farm
RunService.Heartbeat:Connect(function()
    if not Config.StartFarm then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local enemy = GetNearestEnemy()
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        -- 1. Teletransporte para cima do inimigo
        hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
        
        -- 2. Auto Click (M1) e Skills
        if Config.AutoClick then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
                -- Tenta usar Skills (Z, X, C) se o jogador tiver
                pcall(function() 
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
                end)
            end
        end
    end
end)

-- ================= LÓGICA DO AIMBOT =================
RunService.RenderStepped:Connect(function()
    if not Config.AutoAimbot then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local mag = (char.Head.Position - v.Character.Head.Position).Magnitude
            if mag < dist then dist = mag; target = v.Character.Head end
        end
    end
    if target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end
end)

-- ================= MONTAGEM DAS ABAS =================
CreateTab("Setting Farm")
local s4 = Pages["Setting Farm"].Page
AddSection(s4, "Setting Farm")
AddToggle(s4, "Auto Click (M1)", "AutoClick", true)
AddToggle(s4, "Bring Mob (Vem até você)", "BringMob", true)

CreateTab("Farming")
local s6 = Pages["Farming"].Page
AddSection(s6, "Farming")
AddToggle(s6, "Start Auto Farm", "StartFarm", false)
AddButton(s6, "Start Farm (Button)", function() Config.StartFarm = true end)

CreateTab("PVP")
local s15 = Pages["PVP"].Page
AddSection(s15, "PVP")
AddToggle(s15, "Auto Aimbot", "AutoAimbot", false)

CreateTab("ESP")
local s14 = Pages["ESP"].Page
AddSection(s14, "ESP Tab")
AddToggle(s14, "ESP Fruit", "EspFruit", false)

-- Abre a aba de farm por padrão
Pages["Farming"].Button.TextColor3 = Theme.Accent
Pages["Farming"].Button.BackgroundTransparency = 0.8
Pages["Farming"].Page.Visible = true
CurrentTab = "Farming"

-- Toggle GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
