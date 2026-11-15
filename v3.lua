--// VALLEY PRISON - HIGH VISIBILITY NO-CHAT CONTROLLER V3
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local WeaponBtn = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")

-- Takarítás futtatás előtt
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "VP_Dropper_Visible_Gui" then
        v:Destroy()
    end
end

ScreenGui.Name = "VP_Dropper_Visible_Gui"
ScreenGui.Parent = game.CoreGui
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true

-- FŐ PANEL: Kék szegély (ZIndex = 1)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 162, 255)
MainFrame.BorderSizePixel = 4
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.ZIndex = 1

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VALLEY DROPPER V3"
TitleLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
TitleLabel.TextSize = 16
TitleLabel.ZIndex = 2

-- DROP GOMB: Legfelső réteg (ZIndex = 10), hogy biztosan érzékelje a kattintást!
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0, 234, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "DROP: KIKAPCSOLVA"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 10

-- FEGYVER GOMB: Szintén felül (ZIndex = 10)
WeaponBtn.Name = "WeaponBtn"
WeaponBtn.Parent = MainFrame
WeaponBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
WeaponBtn.BorderSizePixel = 0
WeaponBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
WeaponBtn.Size = UDim2.new(0, 234, 0, 40)
WeaponBtn.Font = Enum.Font.GothamBold
WeaponBtn.Text = "FEGYVER: Model 870"
WeaponBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
WeaponBtn.TextSize = 12
WeaponBtn.ZIndex = 10

-- Ablakmozgatás logikája
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [ JÁTÉK LOGIKA ]
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50)
_G.DelayTime = 0.15

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

-- Kattintás kezelés megerősített eseménnyel
ToggleBtn.Activated:Connect(function()
    _G.Dropping = not _G.Dropping
    if _G.Dropping then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
        ToggleBtn.Text = "DROP: BEKAPCSOLVA"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        ToggleBtn.Text = "DROP: KIKAPCSOLVA"
    end
end)

local weaponList = {"Model 870 Tactical", "M4A1", "Glock 17", "AK-47"}
local weaponIndex = 1

WeaponBtn.Activated:Connect(function()
    weaponIndex = weaponIndex + 1
    if weaponIndex > #weaponList then weaponIndex = 1 end
    _G.CurrentWeapon = weaponList[weaponIndex]
    
    local shortName = _G.CurrentWeapon == "Model 870 Tactical" and "Model 870" or _G.CurrentWeapon
    WeaponBtn.Text = "FEGYVER: " .. shortName
end)
