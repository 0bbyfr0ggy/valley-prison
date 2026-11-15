--// VALLEY PRISON WEAPON DROPPER - RE-DESIGNED VISIBLE UI
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Header = Instance.new("Frame")
local HeaderCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local Content = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "VP_Dropper_Safe_Gui" then
        v:Destroy()
    end
end

ScreenGui.Name = "VP_Dropper_Safe_Gui"
ScreenGui.Parent = game.CoreGui
ScreenGui.DisplayOrder = 9999
ScreenGui.IgnoreGuiInset = true

-- FŐABLAK: Világos szegéllyel, hogy jól látszódjon a játéktéren!
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderColor3 = Color3.fromRGB(74, 99, 135)
Main.BorderSizePixel = 2
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.Size = UDim2.new(0, 350, 0, 220)
Main.Active = true
Main.Selectable = true
Main.ZIndex = 1

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Main

-- FEJLÉC: Teljesen különálló fekete sáv
Header.Name = "Header"
Header.Parent = Main
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.ZIndex = 5

HeaderCorner.CornerRadius = UDim.new(0, 6)
HeaderCorner.Parent = Header

Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.04, 0, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Valley Dropper"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(0.78, 0, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(240, 190, 40)
MinimizeBtn.TextSize = 18
MinimizeBtn.ZIndex = 6

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = Header
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.88, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(230, 70, 70)
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 6

-- GOMBDOKK (Content): Nem láthatatlan, sötétszürke hátteret kapott
Content.Name = "Content"
Content.Parent = Main
Content.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.Size = UDim2.new(1, -20, 1, -55)
Content.ClipsDescendants = true
Content.ZIndex = 2

UIListLayout.Parent = Content
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Garantált ablakmozgatás a fejléc megfogásával
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inputObj.Position
        startPos = Main.Position
        inputObj.Changed:Connect(function()
            if inputObj.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Header.InputChanged:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inputObj end
end)

UserInputService.InputChanged:Connect(function(inputObj)
    if inputObj == dragInput and dragging then
        local delta = inputObj.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Content.Visible = false
        Main:TweenSize(UDim2.new(0, 350, 0, 35), "Out", "Quad", 0.12, true)
        MinimizeBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 350, 0, 220), "Out", "Quad", 0.12, true, function() Content.Visible = true end)
        MinimizeBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
-- [ JÁTÉK LOGIKA ]
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50) 
_G.DelayTime = 0.1

local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon

task.spawn(function()
    while true do
        if _G.Dropping and ScreenGui.Parent then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Remote:FireServer(_G.CurrentWeapon) 
                local tool = game.Players.LocalPlayer.Backpack:WaitForChild(_G.CurrentWeapon, 0.4)
                if tool then
                    tool.Parent = game.Workspace
                    tool:MoveTo(_G.DropLocation) 
                end
            end
        end
        task.wait(_G.DelayTime)
    end
end)

-- 1. GOMB: Be/Ki kapcsoló (Magas prioritású ZIndex = 10)
local ToggleBtn = Instance.new("TextButton")
local TogCorner = Instance.new("UICorner")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Content
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleBtn.Size = UDim2.new(1, 0, 0, 35)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "Drop: KIKAPCSOLVA"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.ZIndex = 10

TogCorner.CornerRadius = UDim.new(0, 4)
TogCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    _G.Dropping = not _G.Dropping
    if _G.Dropping then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        ToggleBtn.Text = "Drop: BEKAPCSOLVA"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        ToggleBtn.Text = "Drop: KIKAPCSOLVA"
    end
end)

-- 2. PANEL: Fegyverválasztó gombok (ZIndex = 10)
local Weapons = {"Model 870 Tactical", "M4A1", "Glock 17", "AK-47"}
local WepFrame = Instance.new("Frame")
local WepGrid = Instance.new("UIGridLayout")

WepFrame.Name = "WepFrame"
WepFrame.Parent = Content
WepFrame.BackgroundTransparency = 1
WepFrame.Size = UDim2.new(1, 0, 0, 65)
WepFrame.ZIndex = 10

WepGrid.Parent = WepFrame
WepGrid.CellSize = UDim2.new(0.48, 0, 0, 28)
WepGrid.CellPadding = UDim2.new(0, 10, 0, 6)

for _, wepName in pairs(Weapons) do
    local WepBtn = Instance.new("TextButton")
    local WepCorner = Instance.new("UICorner")
    WepBtn.Parent = WepFrame
    WepBtn.BackgroundColor3 = (_G.CurrentWeapon == wepName) and Color3.fromRGB(74, 99, 135) or Color3.fromRGB(55, 55, 60)
    WepBtn.Font = Enum.Font.GothamSemibold
    WepBtn.Text = wepName
    WepBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    WepBtn.TextSize = 11
    WepBtn.ZIndex = 11
    
    WepCorner.CornerRadius = UDim.new(0, 4)
    WepCorner.Parent = WepBtn
    
    WepBtn.MouseButton1Click:Connect(function()
        _G.CurrentWeapon = wepName
        for _, btn in pairs(WepFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = (btn.Text == _G.CurrentWeapon) and Color3.fromRGB(74, 99, 135) or Color3.fromRGB(55, 55, 60)
            end
        end
    end)
end

-- 3. PANEL: Sebességgombok (ZIndex = 10)
local SpeedFrame = Instance.new("Frame")
local SpeedLayout = Instance.new("UIListLayout")
local SpeedLabel = Instance.new("TextLabel")

SpeedFrame.Parent = Content
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Size = UDim2.new(1, 0, 0, 35)
SpeedFrame.ZIndex = 10

SpeedLayout.Parent = SpeedFrame
SpeedLayout.FillDirection = Enum.FillDirection.Horizontal
SpeedLayout.Padding = UDim.new(0, 8)

SpeedLabel.Parent = SpeedFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 110, 1, 0)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "Késleltetés: 0.1s"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 11

local Speeds = {0.05, 0.1, 0.25}
for _, spd in pairs(Speeds) do
    local SpdBtn = Instance.new("TextButton")
    local SpdCorner = Instance.new("UICorner")
    SpdBtn.Parent = SpeedFrame
    SpdBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    SpdBtn.Size = UDim2.new(0, 60, 1, 0)
    SpdBtn.Font = Enum.Font.GothamBold
    SpdBtn.Text = tostring(spd) .. "s"
    SpdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpdBtn.TextSize = 11
    SpdBtn.ZIndex = 11
    
    SpdCorner.CornerRadius = UDim.new(0, 4)
    SpdCorner.Parent = SpdBtn
    
    SpdBtn.MouseButton1Click:Connect(function()
        _G.DelayTime = spd
        SpeedLabel.Text = "Késleltetés: " .. tostring(spd) .. "s"
    end)
end
