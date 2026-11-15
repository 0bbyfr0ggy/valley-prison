local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon
local WeaponName = "M4A1"

while true do
    -- Ellenőrizzük, hogy a karakterünk még él-e, különben a script összeomolhat
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        
        -- Fegyver lekérése a szervertől
        Remote:FireServer(WeaponName) 
        
        -- Megvárjuk, amíg a fegyver tényleg bekerül a táskába (maximum 1 másodpercet vár, így nem akad ki a kód)
        local tool = game.Players.LocalPlayer.Backpack:WaitForChild(WeaponName, 1)
        
        if tool then
            -- Áttesszük a Workspace-be (a játéktérbe), így kiesik a kezünkből
            tool.Parent = game.Workspace
            
            -- Ide írd be a börtön udvarának a pontos koordinátáit: Vector3.new(X, Y, Z)
            tool:MoveTo(Vector3.new(100, 10, 50)) 
        end
    end
    
    -- BEÁLLÍTÁS: Itt tudod szabályozni a sebességet. 
    -- A 0.1 vagy 0.15 a legbiztonságosabb "gyors" érték. Ha még így is kidobna a játék, emeld fel 0.25-re.
    task.wait(0.1) 
end
