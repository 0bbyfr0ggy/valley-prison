--// VALLEY PRISON - OFFICIAL ROBLOX MOBILE BUTTON DROPPER
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Alapbeállítások
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50) -- A börtön udvar koordinátája
_G.DelayTime = 0.15

local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon

-- Háttérben futó fegyverosztó ciklus (Loop)
task.spawn(function()
    while true do
        if _G.Dropping then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Remote:FireServer(_G.CurrentWeapon) 
                local tool = LocalPlayer.Backpack:WaitForChild(_G.CurrentWeapon, 0.4)
                if tool then
                    tool.Parent = game.Workspace
                    tool:MoveTo(_G.DropLocation) 
                end
            end
        end
        task.wait(_G.DelayTime)
    end
end)

-- A funkció, ami lefut, ha megnyomod a gombot a telefonodon
local function onMobileButtonPress(actionName, inputState, inputObj)
    if inputState == Enum.UserInputState.Begin then
        _G.Dropping = not _G.Dropping
        
        -- Vizuális visszajelzés a gombra (megváltoztatjuk a szövegét, hogy lásd az állapotot)
        local button = ContextActionService:GetButton("ValleyDropAction")
        if button then
            local title = button:FindFirstChild("ActionTitle") or button:FindFirstChildWhichIsA("TextLabel")
            if title then
                title.Text = _G.Dropping and "DROP: BE" or "DROP: KI"
            end
        end
    end
end

-- Töröljük a gombot, ha már létezett korábbról
ContextActionService:UnbindAction("ValleyDropAction")

-- LÉTREHOZZUK A GYÁRI MOBIL GOMBOT
-- Ez egy szép nagy, kör alakú gombot tesz a képernyődre, amit nem takar el semmi!
ContextActionService:BindAction("ValleyDropAction", onMobileButtonPress, true)
ContextActionService:SetTitle("ValleyDropAction", "DROP: KI")

-- Biztosítjuk, hogy a gomb jól látható helyen legyen a telefonodon
local mainButton = ContextActionService:GetButton("ValleyDropAction")
if mainButton then
    mainButton.Size = UDim2.new(0, 70, 0, 70) -- Kényelmes, nagy mobilos méret
    mainButton.Position = UDim2.new(0.7, 0, 0.2, 0) -- A képernyő jobb felső/közép részére rakja
end
