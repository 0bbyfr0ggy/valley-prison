-- Modern UI a Valley Prison Fegyver Spawnolóhoz
local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Window = Library.CreateLib("Valley Prison Weapon Dropper", "DarkTheme")

-- Fő beállítások tárolása
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50) -- Ide írd majd a börtön udvar koordinátáját
_G.DelayTime = 0.1

local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon

-- Háttérben futó hurok (Loop)
task.spawn(function()
    while true do
        if _G.Dropping then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Fegyver kérése
                Remote:FireServer(_G.CurrentWeapon) 
                
                -- Várakozás a fegyverre az inventoryban
                local tool = game.Players.LocalPlayer.Backpack:WaitForChild(_G.CurrentWeapon, 0.5)
                
                if tool then
                    tool.Parent = game.Workspace
                    tool:MoveTo(_G.DropLocation) 
                end
            end
        end
        task.wait(_G.DelayTime)
    end
end)

-- UI Lapok és Gombok létrehozása
local MainTab = Window:NewTab("Főmenü")
local MainSection = MainTab:NewSection("Fegyver Drop")

-- BE / KI Kapcsoló gomb
MainSection:NewToggle("Drop Indítása / Leállítása", "Be- és kikapcsolja a fegyverek potyogtatását.", function(state)
    _G.Dropping = state
end)

-- Fegyver választó legördülő menü (Dropdown)
-- Ide írd be azokat a neveket pontosan, amiket Dex-ben találsz!
MainSection:NewDropdown("Fegyver Kiválasztása", "Válaszd ki, melyik fegyvert akarod spawnolni.", {"Model 870 Tactical", "M4A1", "Glock 17", "AK-47"}, function(current)
    _G.CurrentWeapon = current
end)

-- Sebesség állító (Slider) - Így játék közben is állíthatod a biztonsági időzítést!
MainSection:NewSlider("Sebesség (Késleltetés)", "Minél kisebb, annál gyorsabb. Ajánlott: 0.1 - 0.2", 50, 10, function(s)
    _G.DelayTime = s / 100 -- Átalakítja másodperccé (pl. 10 -> 0.1)
end)
