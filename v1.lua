--// VALLEY PRISON - CHAT COMMAND WEAPON DROPPER
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Alapbeállítások
local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50) -- A börtön udvar koordinátája
_G.DelayTime = 0.1

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

-- Rendszerüzenet küldése a helyi chatbe (csak te látod), hogy tudd, elindult
local function sendSystemMessage(text)
    task.spawn(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:DisplaySystemMessage("<font color='#f0be28'>[Valley Dropper]: " .. text .. "</font>") end
        else
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[Valley Dropper]: " .. text,
                Color = Color3.fromRGB(240, 190, 40),
                Font = Enum.Font.GothamBold
            })
        end
    end)
end

-- Chat parancsok figyelése (Csak neked engedelmeskedik)
local function onChatted(msg)
    local lowerMsg = string.lower(msg)
    
    if lowerMsg == "--start" then
        _G.Dropping = true
        sendSystemMessage("Fegyver drop elindítva! (" .. _G.CurrentWeapon .. ")")
    
    elseif lowerMsg == "--stop" then
        _G.Dropping = false
        sendSystemMessage("Fegyver drop leállítva.")
        
    elseif lowerMsg == "--settings" then
        sendSystemMessage("Aktuális fegyver: " .. _G.CurrentWeapon .. " | Késleltetés: " .. tostring(_G.DelayTime) .. "s")
        
    -- Extra kényelmi parancsok fegyverváltáshoz közvetlenül a chatből!
    elseif lowerMsg == "--wep m4" then
        _G.CurrentWeapon = "M4A1"
        sendSystemMessage("Fegyver átállítva: M4A1")
    elseif lowerMsg == "--wep rm" then
        _G.CurrentWeapon = "Model 870 Tactical"
        sendSystemMessage("Fegyver átállítva: Model 870 Tactical")
    elseif lowerMsg == "--wep glock" then
        _G.CurrentWeapon = "Glock 17"
        sendSystemMessage("Fegyver átállítva: Glock 17")
    elseif lowerMsg == "--wep ak" then
        _G.CurrentWeapon = "AK-47"
        sendSystemMessage("Fegyver átállítva: AK-47")
    end
end

-- Összekötés a te karaktereddel
LocalPlayer.Chatted:Connect(onChatted)
sendSystemMessage("Sikeresen betöltve! Parancsok: --start, --stop, --settings, --wep m4/rm/ak/glock")
