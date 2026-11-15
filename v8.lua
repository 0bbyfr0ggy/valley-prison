--// VALLEY PRISON - MOBILE AUTO-SCANNER CONTROLLER V8
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local WeaponBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "VP_Mobile_Final_Gui" then
        v:Destroy()
    end
end

ScreenGui.Name = "VP_Mobile_Final_Gui"
ScreenGui.Parent = game.CoreGui
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderColor3 = Color3.fromRGB(0, 162, 255)
Main.BorderSizePixel = 3
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.Size = UDim2.new(0, 240, 0, 150)
Main.ZIndex = 9999

Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(0, 130, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "VALLEY DROPPER"
Title.TextColor3 = Color3.fromRGB(0, 162, 255)
Title.TextSize = 13
Title.ZIndex = 10000

MinimizeBtn.Parent = Main
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(0, 175, 0, 5)
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(240, 190, 40)
MinimizeBtn.TextSize = 20
MinimizeBtn.ZIndex = 10000

CloseBtn.Parent = Main
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0, 205, 0, 25)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(230, 70, 70)
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10000

ToggleBtn.Parent = Main
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0, 216, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "DROP: KI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 10000

WeaponBtn.Parent = Main
WeaponBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
WeaponBtn.BorderSizePixel = 0
WeaponBtn.Position = UDim2.new(0.05, 0, 0.58, 0)
WeaponBtn.Size = UDim2.new(0, 216, 0, 35)
WeaponBtn.Font = Enum.Font.GothamBold
WeaponBtn.Text = "FEGYVER: Model 870"
WeaponBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
WeaponBtn.TextSize = 11
WeaponBtn.ZIndex = 10000

-- [ OKOS FEGYVER SCANNER LOGIKA ]
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50)
_G.DelayTime = 0.15

local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon

-- 1. LÉPÉS: Végigpásztázzuk a játék belső tárolóit a nevekért (Nem akad le!)
local foundWeapons = {}
local function scanFolder(folder)
    if folder then
        for _, item in pairs(folder:GetChildren()) do
            if item:IsA("Tool") or item:IsA("ModuleScript") or string.find(string.lower(item.Name), "wep") or string.find(string.lower(item.Name), "gun") then
                if not table.find(foundWeapons, item.Name) and #item.Name > 1 then
                    table.insert(foundWeapons, item.Name)
                end
            end
        end
    end
end

-- Átfésüljük a leggyakoribb Roblox tároló helyeket
pcall(function() scanFolder(game:GetService("ReplicatedStorage")) end)
pcall(function() scanFolder(game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")) end)
pcall(function() scanFolder(game:GetService("ReplicatedStorage"):FindFirstChild("Tools")) end)

-- Ha a játék teljesen elrejtette a mappákat, betöltjük a biztos alap listát
if #foundWeapons == 0 then
    foundWeapons = {"Model 870 Tactical", "M4A1", "Glock 17", "AK-47", "Deagle", "MP5"}
end

-- 2. LÉPÉS: Megkeressük, hogy a találtak közül melyik a sörétes, és azt tesszük be alapnak
for _, wep in ipairs(foundWeapons) do
    if string.find(wep, "870") or string.find(string.lower(wep), "tactical") or string.find(string.lower(wep), "shotgun") then
        _G.CurrentWeapon = wep
        local displayName = _G.CurrentWeapon == "Model 870 Tactical" and "Model 870" or _G.CurrentWeapon
        WeaponBtn.Text = "FEGYVER: " .. displayName
        break
    end
end

-- Fegyverosztó Loop
task.spawn(function()
    while true do
        if _G.Dropping and ScreenGui.Parent then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Remote:FireServer(_G.CurrentWeapon) 
                local tool = game.Players.LocalPlayer.Backpack:WaitForChild(_G.CurrentWeapon, 0.2)
                if tool then
                    tool.Parent = game.Workspace
                    tool:MoveTo(_G.DropLocation) 
                end
            end
        end
        task.wait(_G.DelayTime)
    end
end)

-- Gombok érintés kezelése mobilon
ToggleBtn.Activated:Connect(function()
    _G.Dropping = not _G.Dropping
    if _G.Dropping then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
        ToggleBtn.Text = "DROP: BE"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        ToggleBtn.Text = "DROP: KI"
    end
end)

local currentIdx = 1
WeaponBtn.Activated:Connect(function()
    currentIdx = currentIdx + 1
    if currentIdx > #foundWeapons then currentIdx = 1 end
    _G.CurrentWeapon = foundWeapons[currentIdx]
    
    local displayName = _G.CurrentWeapon == "Model 870 Tactical" and "Model 870" or _G.CurrentWeapon
    WeaponBtn.Text = "FEGYVER: " .. displayName
end)

-- Ablak kezelőszervek
local minimized = false
MinimizeBtn.Activated:Connect(function()
    minimized = not minimized
    if minimized then
        Main:TweenSize(UDim2.new(0, 240, 0, 35), "Out", "Quad", 0.12, true)
        MinimizeBtn.Text = "+"
        ToggleBtn.Visible = false
        WeaponBtn.Visible = false
    else
        Main:TweenSize(UDim2.new(0, 240, 0, 150), "Out", "Quad", 0.12, true)
        MinimizeBtn.Text = "-"
        ToggleBtn.Visible = true
        WeaponBtn.Visible = true
    end
end)

CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)

local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y - Main.AbsolutePosition.Y < 35 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
