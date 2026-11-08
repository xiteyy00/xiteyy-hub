--[[
    xiteyy Hub V2 - Blox Fruits
    Red/Black Theme | No Banana | Full Engine
    Script unificado com todas as 17 abas e funções base.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

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

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -180, 1, -35)
ContentArea.Position = UDim2.new(0, 180, 0, 35)
ContentArea.BackgroundColor3 = Theme.Background
ContentArea.BorderSizePixel = 0

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

local function AddDropdown(p, t, o, k)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Theme.ElementBg; b.BorderSizePixel = 0
    b.Text = " " .. t .. "                                        >"
    b.TextColor3 = Theme.Text; b.Font = Enum.Font.Gotham; b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local open = false
    local list = Instance.new("ScrollingFrame", p)
    list.Size = UDim2.new(1, 0, 0, 0); list.BackgroundColor3 = Theme.Sidebar; list.Visible = false
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

-- ================= MONTAGEM DAS ABAS =================

-- 1. Shop
CreateTab("Shop")
local s1 = Pages["Shop"].Page
AddSection(s1, "Misc Shop")
AddButton(s1, "Redeem Code")
AddButton(s1, "Teleport Old World")
AddButton(s1, "Teleport New World")
AddButton(s1, "Teleport Third Sea")
AddButton(s1, "Buy Dual Flintlock")
AddButton(s1, "Reroll Race")
AddButton(s1, "Reset Stats")
AddButton(s1, "Buy Race Cyborg")
AddButton(s1, "Buy Race Ghoul")
AddSection(s1, "Fighting Shop")
AddToggle(s1, "Black Leg", "S_BlackLeg")
AddToggle(s1, "Fishman Karate", "S_Fishman")
AddToggle(s1, "Electro", "S_Electro")
AddToggle(s1, "Dragon Breath", "S_DragonBreath")
AddToggle(s1, "SuperHuman", "S_SuperHuman")
AddToggle(s1, "Death Step", "S_DeathStep")
AddToggle(s1, "Sharkman Karate", "S_Sharkman")
AddToggle(s1, "Electric Claw", "S_ElectricClaw")
AddToggle(s1, "Dragon Talon", "S_DragonTalon")
AddToggle(s1, "God Human", "S_GodHuman")
AddToggle(s1, "Sanguine Art", "S_Sanguine")
AddSection(s1, "Abilities Shop")
AddButton(s1, "Skyjump [$10,000]")
AddButton(s1, "Buso Haki [$25,000]")
AddButton(s1, "Observation Haki [$750,000]")
AddButton(s1, "Soru [$100,000]")

-- 2. Status And Server
CreateTab("Status And Server")
local s2 = Pages["Status And Server"].Page
AddSection(s2, "Status")
AddButton(s2, "Open Gui Server Browser (Low Player)")
AddTextBox(s2, "Input JobId Normal And JobId BananaCat", "JobIDInput")
AddToggle(s2, "Spam Join", "SpamJoin")
AddButton(s2, "Join JobId")
AddButton(s2, "Copy JobId")
AddButton(s2, "Hop Server")
AddButton(s2, "Hop Server Less People")

-- 3. LocalPlayer
CreateTab("LocalPlayer")
local s3 = Pages["LocalPlayer"].Page
AddSection(s3, "Local Player")
AddToggle(s3, "Auto Translate", "AutoTrans")
AddButton(s3, "Stop Tween")
AddButton(s3, "Fix UI Button Game")
AddButton(s3, "Load config in Web")
AddButton(s3, "Push Data To Web")
AddButton(s3, "Show Item")
AddButton(s3, "Open Devil Fruit Shop")
AddButton(s3, "Open Devil Fruit Shop Mirage")
AddButton(s3, "Open Title")
AddButton(s3, "Open Color")
AddDropdown(s3, "Dropdown Auto Stats", {"Melee", "Defense", "Sword", "Gun", "Fruit"}, "AutoStats")
AddDropdown(s3, "Select Team", {"Pirates", "Marines"}, "SelectTeam")
AddToggle(s3, "Noclip", "Noclip")
AddDropdown(s3, "Select NPC", {"Dragon", "Swan", "Magma"}, "SelectNPC")
AddToggle(s3, "Teleport To NPC", "TPNPC")
AddDropdown(s3, "Select Island", {"Starter Island", "Marine Ford", "Fountain City"}, "SelectIsland")
AddToggle(s3, "Teleport To Island", "TPIsland")
AddToggle(s3, "Teleport Mirage", "TPMirage")
AddToggle(s3, "Teleport Prehistoric Island", "TPPrehistoric")

-- 4. Setting Farm
CreateTab("Setting Farm")
local s4 = Pages["Setting Farm"].Page
AddSection(s4, "Setting Farm")
AddDropdown(s4, "Select Weapon", {"Melee", "Sword", "Blox Fruit"}, "SelectWeapon")
AddToggle(s4, "Attack No Animation", "NoAnim")
AddToggle(s4, "Kill Aura Only Raid and Volcano", "KAOnly")
AddSlider(s4, "Time Delay Kill", "TimeDelay", 1, 10, 5)
AddToggle(s4, "Auto Click", "AutoClick")
AddToggle(s4, "Kill Aura With DragonStorm", "KADragon")
AddToggle(s4, "Auto Turn On Buso", "AutoBuso")
AddToggle(s4, "Auto Turn On Observation", "AutoObs")
AddToggle(s4, "Auto Turn On V4", "AutoV4")
AddToggle(s4, "Auto Turn On V3", "AutoV3")
AddToggle(s4, "Auto Dodge Skill Mobs", "AutoDodge")
AddToggle(s4, "Teleport Y if low health", "TPY")
AddSlider(s4, "% Health Player", "HealthPercent", 10, 100, 40)
AddSlider(s4, "Distance Teleport Y", "DistanceTPY", 100, 2000, 800)
AddToggle(s4, "Use Portal Teleport", "UsePortal")
AddSlider(s4, "Bring Mob Count", "BringMobCount", 1, 10, 2)
AddToggle(s4, "Bring Mob", "BringMob")
AddToggle(s4, "Reset Teleport [Beta]", "ResetTP")
AddSlider(s4, "Speed Tween", "SpeedTween", 100, 500, 300)

-- 5. Hold and Select Skill
CreateTab("Hold and Select Skill")
local s5 = Pages["Hold and Select Skill"].Page
AddSection(s5, "Hold Skills")
AddDropdown(s5, "Select Skills Melee (X, C, Z)", {"Z", "X", "C"}, "SkillMelee")
AddDropdown(s5, "Select Skills Sword", {"Z", "X", "C"}, "SkillSword")
AddDropdown(s5, "Select Skills Gun", {"Z", "X", "C"}, "SkillGun")
AddDropdown(s5, "Select Skills Blox Fruit (X, C, Z, V, F)", {"Z", "X", "C", "V", "F"}, "SkillFruit")
AddToggle(s5, "Use skill fast dont hold", "FastSkill")
AddSlider(s5, "Set Delay Melee", "DelayMelee", 1, 10, 1)
AddSlider(s5, "Set Delay Sword", "DelaySword", 1, 10, 1)

-- 6. Farming
CreateTab("Farming")
local s6 = Pages["Farming"].Page
AddSection(s6, "Farming")
AddDropdown(s6, "Select Method Farm", {"Farm Bones", "Level Farm", "Farm Katakuri", "Farm Tyrant", "Aura Farm"}, "FarmMethod")
AddSlider(s6, "Distance Farm Aura", "DistanceAura", 50, 1000, 300)
AddToggle(s6, "Ignore Attack Katakuri", "IgnoreKata")
AddToggle(s6, "Hop Find Katakuri", "HopKata")
AddToggle(s6, "Auto Quest", "AutoQuest")
AddButton(s6, "Start Farm")
AddSection(s6, "Mastery Farm")
AddDropdown(s6, "Select Method Farm Mastery", {"Gun", "Blox Fruit"}, "MasteryMethod")
AddSlider(s6, "Health %", "MasteryHealth", 10, 100, 40)
AddToggle(s6, "Farm Mastery", "FarmMastery")
AddSection(s6, "Farming Material")
AddDropdown(s6, "Select Material", {"Vampire Fang", "Fish Tail", "Leather", "Magma Ore"}, "SelectMaterial")
AddToggle(s6, "Farm Material", "FarmMaterial")

-- 7. Stack Farming
CreateTab("Stack Farming")
local s7 = Pages["Stack Farming"].Page
AddToggle(s7, "Auto Factory", "AutoFactory")
AddToggle(s7, "Auto Pirate Raid", "AutoPirate")
AddSection(s7, "Boss Rip Indra")
AddToggle(s7, "Auto Elite Hunter", "EliteHunter")
AddToggle(s7, "Hop Server Elite Hunter", "HopElite")
AddToggle(s7, "Auto Touch Pad Haki", "PadHaki")
AddToggle(s7, "Auto Summon Rip Indra", "SummonRip")
AddToggle(s7, "Attack Rip Indra", "AttackRip")
AddSection(s7, "Boss Soul Reaper")
AddToggle(s7, "Attack Soul Reaper", "AttackSoul")
AddToggle(s7, "Summon Soul Reaper", "SummonSoul")
AddSection(s7, "Boss Dough King")
AddToggle(s7, "Attack Dough King", "AttackDough")
AddToggle(s7, "Summon Dough King", "SummonDough")
AddToggle(s7, "Hop Find Dough King", "HopDough")
AddSection(s7, "Boss Darkbeard")
AddToggle(s7, "Attack Darkbeard", "AttackDark")
AddToggle(s7, "Summon Darkbeard", "SummonDark")
AddToggle(s7, "Hop Find Darkbeard", "HopDark")

-- 8. Farming Other
CreateTab("Farming Other")
local s8 = Pages["Farming Other"].Page
AddSection(s8, "Quest Dragon")
AddToggle(s8, "Auto Accept Quest Fishing", "AcceptFish")
AddToggle(s8, "Auto Quest Dojo Trainer", "QuestDojo")
AddToggle(s8, "Auto Quest Dragon Hunter", "QuestDragon")
AddSection(s8, "Attack All Mobs")
AddToggle(s8, "Auto Attack All Mob and Boss", "AttackAll")
AddSection(s8, "Berry")
AddToggle(s8, "Hop Find Berry", "HopBerry")
AddToggle(s8, "Auto Collect Berry", "CollectBerry")
AddSection(s8, "Farm Chest")
AddSlider(s8, "Value Collect Chest to Hop", "ChestHopVal", 1, 100, 45)
AddToggle(s8, "Auto Chest Hop", "ChestHop")
AddToggle(s8, "Use Method Teleport [Risk]", "TPChest")
AddToggle(s8, "Auto Chest", "AutoChest")
AddSection(s8, "Raid Law")
AddToggle(s8, "Auto Buy Chip and Attack Law", "RaidLaw")
AddSection(s8, "Farm Observation")
AddToggle(s8, "Auto UP Observation V2", "UpObs")
AddToggle(s8, "Farm Observation", "FarmObs")
AddToggle(s8, "Farm Observation [Hop Server]", "HopObs")
AddSection(s8, "Auto Kill Mob")
AddDropdown(s8, "Select Mob", {"Bandit", "Trainee", "Magma"}, "SelectMob")
AddToggle(s8, "Kill Mob", "KillMob")
AddSection(s8, "Auto Boss")
AddDropdown(s8, "Select Boss", {"Stone", "Diamond", "Ghost"}, "SelectBoss")
AddButton(s8, "Refresh Boss")
AddToggle(s8, "Kill Boss", "KillBoss")
AddToggle(s8, "Kill All Boss", "KillAllBoss")
AddToggle(s8, "Hop Server Find Boss", "HopBoss")

-- 9. Fruit and Raid, Dungeon
CreateTab("Fruit and Raid, Dungeon")
local s9 = Pages["Fruit and Raid, Dungeon"].Page
AddSection(s9, "Devil Fruit")
AddToggle(s9, "Random Devil Fruit", "RandFruit")
AddToggle(s9, "Auto Store Fruit", "StoreFruit", true)
AddDropdown(s9, "Blox Fruit Sniper Shop", {"Dragon", "Leopard", "Kitsune"}, "SniperShop")
AddToggle(s9, "Buy Blox Fruit Sniper Shop", "BuySniper")
AddSection(s9, "Raids")
AddDropdown(s9, "Select Raid", {"Flame", "Ice", "Quake"}, "SelectRaid")
AddToggle(s9, "Get Fruit in Inventory Low Beli", "LowBeli")
AddToggle(s9, "Auto Raid", "AutoRaid")
AddToggle(s9, "Hop Server Raid", "HopRaid")
AddToggle(s9, "Auto Awake Fruit", "AwakeFruit")
AddSection(s9, "Dungeon")
AddDropdown(s9, "Select Difficulty", {"Normal", "Hard", "Nightmare"}, "Difficulty")
AddToggle(s9, "Account Start Dungeon", "StartDungeon")
AddToggle(s9, "Auto Join Dungeon", "JoinDungeon")
AddToggle(s9, "Auto Attack Dungeon", "AttackDungeon")
AddToggle(s9, "Auto Pick Card Dungeon", "PickCard")

-- 10. Sea Event
CreateTab("Sea Event")
local s10 = Pages["Sea Event"].Page
AddSection(s10, "Setting")
AddDropdown(s10, "Select Zone", {"First Sea", "Second Sea", "Third Sea"}, "SeaZone")
AddDropdown(s10, "Select Boat", {"Guardian", "Beast Hunter"}, "SelectBoat")
AddToggle(s10, "Use Dragonstorm For Sea Event", "Dragonstorm")
AddToggle(s10, "Use Click M1 Skull Guitar", "SkullGuitar")
AddToggle(s10, "Auto Change Dragonstorm With Skull Guitar", "ChangeDragon")
AddToggle(s10, "Reset Character Buy Boat", "ResetBoat")
AddToggle(s10, "Auto Dodge Skill Terrorshark", "DodgeTerror")
AddToggle(s10, "Auto Dodge Skill SeaBeast", "DodgeBeast")
AddToggle(s10, "Teleport Boat Other CFrame if Rough Sea", "TPBoat")
AddToggle(s10, "Tween Until Have Sea Event", "TweenEvent")
AddToggle(s10, "Will Back When Over 10km", "Back10km")
AddSection(s10, "Farming")
AddButton(s10, "Refresh Player")
AddToggle(s10, "Auto Sea Event With Friend", "SeaFriend")
AddToggle(s10, "Auto Repair Ur Ship", "RepairShip")
AddToggle(s10, "Auto Sea Event", "AutoSea")
AddToggle(s10, "Auto Find Mirage", "FindMirage")
AddSection(s10, "Kitsune Event")
AddToggle(s10, "Teleport To Kitsune Island", "TPKitsune")
AddToggle(s10, "Hop Server [Next Night / Full Moon]", "HopKitsune")
AddToggle(s10, "Auto Spawn Kitsune Island", "SpawnKitsune")
AddToggle(s10, "Auto Summon Soul Ember", "SummonEmber")
AddToggle(s10, "Auto Collect Soul Ember", "CollectEmber")
AddSlider(s10, "Values Azure Ember", "AzureEmber", 1, 100, 10)
AddToggle(s10, "Auto Trade Azure Ember", "TradeEmber")
AddSection(s10, "Leviathan Event")
AddButton(s10, "Buy Spy")
AddButton(s10, "Teleport your boat to current Position")
AddToggle(s10, "Auto Buy Spy", "BuySpy")
AddToggle(s10, "Auto Buy Boat Beast Hunter", "BuyBeastHunter")
AddDropdown(s10, "Select Owner Boat Find Leviathan", {"My Boat", "Friend Boat"}, "OwnerBoat")
AddButton(s10, "Refresh Player")
AddToggle(s10, "Multi Find Leviathan", "MultiLevi")
AddToggle(s10, "Auto Find Leviathan", "FindLevi")
AddToggle(s10, "Auto Start Leviathan", "StartLevi")
AddToggle(s10, "Auto Destroy IDK", "DestroyIDK")
AddToggle(s10, "Attack Multi Segments Leviathan", "AttackMultiLevi")
AddSlider(s10, "Value Damage Multi Segments", "DamageLevi", 1000, 50000, 30000)
AddToggle(s10, "Auto Attack Leviathan", "AttackLevi")
AddToggle(s10, "Use Click M1 Fruit Leviathan", "M1FruitLevi")
AddToggle(s10, "Use Click M1 Skull Guitar Leviathan", "M1GuitarLevi")
AddSection(s10, "Boat Setting")
AddToggle(s10, "Fly Boat", "FlyBoat")
AddSlider(s10, "Value Speed Boat", "SpeedBoat", 100, 500, 300)
AddSlider(s10, "Value Speed Fly Boat", "SpeedFly", 1, 10, 3)
AddToggle(s10, "Change Speed Boat", "ChangeSpeedBoat")

-- 11. Upgrade Race
CreateTab("Upgrade Race")
local s11 = Pages["Upgrade Race"].Page
AddSection(s11, "Race Draco")
AddToggle(s11, "Auto Upgrade Race V2V3 Draco", "UpDraco")
AddToggle(s11, "Auto Trial Draco", "TrialDraco")
AddToggle(s11, "Fully Trial Draco", "FullTrialDraco")
AddToggle(s11, "Ignore Craft Volcanic Magnet", "IgnoreMagnet")
AddToggle(s11, "Auto Buy Gear Draco", "BuyGearDraco")
AddToggle(s11, "Auto Finish Train Draco Quest", "FinishDraco")
AddSection(s11, "Race Normal")
AddToggle(s11, "Auto Upgrade Race V2V3", "UpRace")
AddToggle(s11, "Auto Get Fully Cyborg", "FullCyborg")
AddToggle(s11, "Auto Get Cyborg Hop Collect Chest", "HopCyborg")
AddToggle(s11, "Auto Get Cyborg", "GetCyborg")
AddToggle(s11, "Hop Server Find Boss Cursed Captain", "HopCursed")
AddToggle(s11, "Auto Get Ghoul", "GetGhoul")
AddSection(s11, "Race V4")
AddToggle(s11, "No Frog", "NoFrog")
AddToggle(s11, "Teleport Acient Clock", "TPClock")
AddToggle(s11, "Auto Buy Gear", "BuyGear")
AddDropdown(s11, "Select Gear V4", {"Omega", "Alpha"}, "GearV4")
AddToggle(s11, "Auto Choose Gears", "ChooseGear")
AddToggle(s11, "Auto Finish Train Quest", "FinishQuest")
AddToggle(s11, "Stack Train with Trial Race", "StackTrain")
AddToggle(s11, "Hop Server [Trial or Pull Lever]", "HopTrial")
AddToggle(s11, "Auto Pull Lever", "PullLever")
AddSection(s11, "Multi Trial")
AddButton(s11, "Refresh Player")
AddToggle(s11, "Multi Trial", "MultiTrial")
AddToggle(s11, "Auto Reset Character", "ResetChar")
AddToggle(s11, "Auto Trial", "AutoTrial")
AddToggle(s11, "Auto Turn On V3 Near Door", "V3Door")
AddDropdown(s11, "Select Players Multi", {"Player1", "Player2"}, "PlayersMulti")
AddSection(s11, "Kill Trial")
AddDropdown(s11, "Select Weapon Attack Trials", {"Melee", "Sword", "Gun"}, "WeaponTrial")
AddToggle(s11, "Kill players When complete Trial", "KillTrial")
AddToggle(s11, "Use Skill when Kill Player", "SkillKill")
AddToggle(s11, "Just Use Skill when Player Active Ken", "SkillKen")

-- 12. Get and Upgrade Item
CreateTab("Get and Upgrade Item")
local s12 = Pages["Get and Upgrade Item"].Page
AddSection(s12, "Get Items")
AddToggle(s12, "Auto Trade Bone", "TradeBone")
AddToggle(s12, "Auto Buy Legendary Sword", "BuyLegend")
AddToggle(s12, "Auto Buy Haki Color", "BuyHaki")
AddToggle(s12, "Hop Server [Haki color or Legendary Sword]", "HopHaki")
AddToggle(s12, "Auto Get Rainbow Haki", "RainbowHaki")
AddToggle(s12, "Auto Soul Guitar", "SoulGuitar")
AddSection(s12, "Mastery Weapon")
AddDropdown(s12, "Select Method Hop CDK", {"Fast", "Slow"}, "HopCDK")
AddToggle(s12, "Auto CDK", "AutoCDK")
AddToggle(s12, "Auto Yama", "AutoYama")
AddToggle(s12, "Auto Tushita", "AutoTushita")
AddToggle(s12, "Auto TTK", "AutoTTK")
AddToggle(s12, "Auto Saber", "AutoSaber")
AddSection(s12, "Upgrade Weapon")
AddToggle(s12, "Auto Craft Item Shark Anchor", "SharkAnchor")
AddToggle(s12, "Auto Yoru Mini", "YoruMini")
AddToggle(s12, "Auto Yoru Mini [Hop Server]", "YoruMiniHop")
AddToggle(s12, "Auto Farm Mastery 600 Melees", "MasteryMelee")
AddToggle(s12, "Auto Farm Mastery 600 Sword in Inventory", "MasterySword")
AddToggle(s12, "Auto Upgrade Sword Inventory", "UpgradeSword")
AddToggle(s12, "Auto Upgrade Gun Inventory", "UpgradeGun")

-- 13. Volcano Event
CreateTab("Volcano Event")
local s13 = Pages["Volcano Event"].Page
AddSection(s13, "Settings Volcano")
AddDropdown(s13, "Select Weapon Kill Golem", {"Melee", "Sword"}, "WeaponGolem")
AddDropdown(s13, "Select Weapons Fix Lava", {"Melee", "Sword"}, "WeaponLava")
AddDropdown(s13, "Select Method Kill Golem", {"Click M1", "Instant Kill"}, "MethodGolem")
AddSection(s13, "Farming Volcano")
AddToggle(s13, "Auto Crafting Volcanic Magnet", "CraftMagnet")
AddToggle(s13, "Auto Find Prehistoric Island", "FindPrehistoric")
AddToggle(s13, "Auto Event Prehistoric Island", "EventPrehistoric")
AddToggle(s13, "Auto Collect Bone", "CollectBone")
AddToggle(s13, "Auto Collect Egg", "CollectEgg")
AddSection(s13, "Fully Volcano")
AddToggle(s13, "Ignore Craft Volcanic Magnet [Fully]", "IgnoreMagnetFull")
AddToggle(s13, "Ignore Collect Bone [Fully]", "IgnoreBoneFull")
AddToggle(s13, "Fully Event Prehistoric Island", "FullEvent")

-- 14. ESP
CreateTab("ESP")
local s14 = Pages["ESP"].Page
AddSection(s14, "ESP Tab")
AddToggle(s14, "ESP Berry", "EspBerry")
AddToggle(s14, "ESP Island", "EspIsland")
AddToggle(s14, "ESP Fruit", "EspFruit", true)
AddToggle(s14, "ESP Player", "EspPlayer", true)

-- 15. PVP
CreateTab("PVP")
local s15 = Pages["PVP"].Page
AddSection(s15, "PVP")
AddDropdown(s15, "Select Player PVP", {"Nenhum"}, "PlayerPVP")
AddDropdown(s15, "Select Method Aimbot", {"Camera", "Mouse"}, "MethodAim")
AddButton(s15, "Refresh Player")
AddToggle(s15, "Teleport Player", "TPPlayer")
AddToggle(s15, "Auto Aimbot", "AutoAimbot")
AddToggle(s15, "Auto Aimbot Gun", "AutoAimbotGun")
AddSection(s15, "MISC PVP")
AddSlider(s15, "Input Walkspeed", "WalkSpeed", 16, 500, 200)
AddSlider(s15, "Input JumpPower", "JumpPower", 0, 500, 200)
AddToggle(s15, "Change JumpPower", "ChangeJump")
AddToggle(s15, "Change Walkspeed", "ChangeWalk")
AddToggle(s15, "Walk On Water", "WalkWater")

-- 16. Tab Webhook
CreateTab("Tab Webhook")
local s16 = Pages["Tab Webhook"].Page
AddSection(s16, "Webhook")
AddTextBox(s16, "Input Url Webhook", "WebhookURL")
AddTextBox(s16, "Input Discord Ping", "DiscordPing")
AddToggle(s16, "Ping Everyone/Id Discord", "PingAll")
AddToggle(s16, "Noti Profile", "NotiProfile")
AddDropdown(s16, "Select Rarity Fruit", {"Any", "Rare", "Legendary"}, "RarityFruit")
AddToggle(s16, "Webhook Store Fruit", "WebhookFruit")
AddToggle(s16, "Webhook Find Prehistoric Island", "WebhookPrehistoric")
AddToggle(s16, "Webhook Find Leviathan", "WebhookLeviathan")
AddToggle(s16, "Webhook Destroy IDK", "WebhookIDK")
AddToggle(s16, "Webhook Find Mirage", "WebhookMirage")

-- 17. Setting
CreateTab("Setting")
local s17 = Pages["Setting"].Page
AddSection(s17, "Settings")
AddToggle(s17, "White Screen", "WhiteScreen")
AddToggle(s17, "Black Screen", "BlackScreen")
AddToggle(s17, "Remove Notifications", "RemoveNoti")
AddToggle(s17, "Auto rejoin Disconnect", "AutoRejoin")
AddToggle(s17, "Auto Load Script", "AutoLoad")
AddToggle(s17, "Boost Fps", "BoostFps")
AddButton(s17, "Copy Config")
AddDropdown(s17, "Toggle GUI (Keybind)", {"LeftControl", "RightControl", "Mouse3"}, "ToggleKeyDropdown")

-- ================= LÓGICA GERAL E SETTINGS =================
if Pages["Shop"] then
    Pages["Shop"].Button.TextColor3 = Theme.Accent
    Pages["Shop"].Button.BackgroundTransparency = 0.8
    Pages["Shop"].Page.Visible = true
    CurrentTab = "Shop"
end

-- Toggle GUI
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- WalkSpeed & JumpPower
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Config.ChangeWalk then hum.WalkSpeed = Config.WalkSpeed else hum.WalkSpeed = 16 end
        if Config.ChangeJump then hum.JumpPower = Config.JumpPower; hum.UseJumpPower = true else hum.JumpPower = 50 end
    end
end)

-- Fps Boost & Screen
RunService.RenderStepped:Connect(function()
    if Config.WhiteScreen then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    elseif Config.BlackScreen then
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    end
    if Config.BoostFps then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)
