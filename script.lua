--// VALLEY PRISON WEAPON DROPPER WITH FIXED INTEGRATED UI AND MINIMIZE BUTTON
local Kavo = {}
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local Utility = {}
local Objects = {}

function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = inputObj.Position
            framePos = parent.Position
            inputObj.Changed:Connect(function()
                if inputObj.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = inputObj
        end
    end)
    input.InputChanged:Connect(function(inputObj)
        if inputObj == dragInput and dragging then
            local delta = inputObj.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local themeStyles = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(74, 99, 135),
        Background = Color3.fromRGB(36, 37, 43),
        Header = Color3.fromRGB(28, 29, 34),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(32, 32, 38)
    }
}

local LibName = "VP_Dropper_Gui_" .. tostring(math.random(100, 999))

function Kavo.CreateLib(kavName, themeList)
    local themeList = themeStyles.DarkTheme
    kavName = kavName or "Library"
    
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == kavName or v.Name:match("VP_Dropper_Gui_")) then
            v:Destroy()
        end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.3, 0, 0.3, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)
    Main.Active = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main

    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    MainHeader.Active = true

    local headerCover = Instance.new("UICorner")
    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Parent = MainHeader

    local coverup = Instance.new("Frame")
    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.75, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0.02, 0, 0.2, 0)
    title.Size = UDim2.new(0, 204, 0, 18)
    title.Font = Enum.Font.Gotham
    title.Text = kavName
    title.TextColor3 = themeList.TextColor
    title.TextSize = 14.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    local minimize = Instance.new("TextButton")
    minimize.Name = "minimize"
    minimize.Parent = MainHeader
    minimize.BackgroundTransparency = 1
    minimize.Position = UDim2.new(0.88, 0, 0.1, 0)
    minimize.Size = UDim2.new(0, 21, 0, 21)
    minimize.Font = Enum.Font.GothamBold
    minimize.Text = "-"
    minimize.TextColor3 = Color3.fromRGB(240, 190, 40)
    minimize.TextSize = 20
    minimize.ZIndex = 5

    local minimized = false
    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:TweenObject(Main, {Size = UDim2.new(0, 525, 0, 29)}, 0.15)
            minimize.Text = "+"
        else
            Utility:TweenObject(Main, {Size = UDim2.new(0, 525, 0, 318)}, 0.15)
            minimize.Text = "-"
        end
    end)

    local close = Instance.new("ImageButton")
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1.000
    close.Position = UDim2.new(0.94, 0, 0.13, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.ZIndex = 2
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MainSide = Instance.new("Frame")
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0.091, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)

    local tabFrames = Instance.new("Frame")
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.05, 0, 0, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    local tabListing = Instance.new("UIListLayout")
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    tabListing.Padding = UDim.new(0, 2)

    local pages = Instance.new("Frame")
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1.000
    pages.Position = UDim2.new(0.3, 0, 0.12, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    local Pages = Instance.new("Folder")
    Pages.Parent = pages

    local infoContainer = Instance.new("Frame")
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.Position = UDim2.new(0.3, 0, 0.85, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    Kavo:DraggingEnabled(MainHeader, Main)
    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize
            page.CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
        end

        page.Name = "Page"
        page.Parent = Pages
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 4
        page.Visible = false

        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 12.000

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
        else
            tabButton.BackgroundTransparency = 0.5
        end

        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = tabButton

        tabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do v.Visible = false end
            page.Visible = true
            for i,v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then v.BackgroundTransparency = 0.5 end
            end
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        end)

        local Sections = {}
        function Sections:NewSection(secName)
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")

            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0
            
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)

            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(0, 352, 0, 26)

            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.02, 0, 0, 0)
            sectionName.Size = UDim2.new(0.98, 0, 1, 0)
            sectionName.Font = Enum.Font.Gotham
            sectionName.Text = secName
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 12.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1

            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)

            local function updateSectionFrame()
                local innerSc = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionlistoknvm.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(0, 352, 0, frameSc.Y)
            end

            local Elements = {}

            function Elements:NewToggle(tname, nTip, callback)
                local toggled = false
                local toggleElement = Instance.new("TextButton")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")

                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.Size = UDim2.new(0, 352, 0, 30)
                toggleElement.Text = ""

                toggleDisabled.Parent = toggleElement
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.02, 0, 0.15, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)

                toggleEnabled.Parent = toggleElement
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.02, 0, 0.15, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = Color3.fromRGB(0, 255, 100)
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1

                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.1, 0, 0.25, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 12.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                toggleElement.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    toggleEnabled.ImageTransparency = toggled and 0 or 1
                    pcall(callback, toggled)
                end)

                updateSectionFrame()
                UpdateSize()
            end

            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local opened = false
                local dropFrame = Instance.new("Frame")
                local dropOpen = Instance.new("TextButton")
                local itemTextbox = Instance.new("TextLabel")
                local UIListLayout = Instance.new("UIListLayout")

                dropFrame.Parent = sectionInners
                dropFrame.BackgroundColor3 = themeList.Background
                dropFrame.Size = UDim2.new(0, 352, 0, 30)
                dropFrame.ClipsDescendants = true

                dropOpen.Parent = dropFrame
                dropOpen.BackgroundColor3 = themeList.ElementColor
                dropOpen.Size = UDim2.new(0, 352, 0, 30)
                dropOpen.Text = ""

                itemTextbox.Parent = dropOpen
                itemTextbox.BackgroundTransparency = 1
                itemTextbox.Position = UDim2.new(0.03, 0, 0.25, 0)
                itemTextbox.Size = UDim2.new(0, 250, 0, 14)
                itemTextbox.Font = Enum.Font.GothamSemibold
                itemTextbox.Text = dropname
                itemTextbox.TextColor3 = themeList.TextColor
                itemTextbox.TextSize = 12.000
                itemTextbox.TextXAlignment = Enum.TextXAlignment.Left

                UIListLayout.Parent = dropFrame
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 2)

                dropOpen.MouseButton1Click:Connect(function()
                    opened = not opened
                    dropFrame.Size = opened and UDim2.new(0, 352, 0, UIListLayout.AbsoluteContentSize.Y) or UDim2.new(0, 352, 0, 30)
                    updateSectionFrame()
                    UpdateSize()
                end)

                for i, v in next, list do
                    local optionSelect = Instance.new("TextButton")
                    optionSelect.Parent = dropFrame
                    optionSelect.BackgroundColor3 = themeList.ElementColor
                    optionSelect.Size = UDim2.new(0, 352, 0, 28)
                    optionSelect.Font = Enum.Font.GothamSemibold
                    optionSelect.Text = "  " .. v
                    optionSelect.TextColor3 = themeList.TextColor
                    optionSelect.TextSize = 12.000
                    optionSelect.TextXAlignment = Enum.TextXAlignment.Left

                    optionSelect.MouseButton1Click:Connect(function()
                        opened = false
                        dropFrame.Size = UDim2.new(0, 352, 0, 30)
                        itemTextbox.Text = v
                        pcall(callback, v)
                        updateSectionFrame()
                        UpdateSize()
                    end)
                end
                updateSectionFrame()
                UpdateSize()
            end

            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
                local sliderElement = Instance.new("TextButton")
                local togName = Instance.new("TextLabel")
                local sliderBtn = Instance.new("TextButton")
                local sliderDrag = Instance.new("Frame")
                local val = Instance.new("TextLabel")

                sliderElement.Parent = sectionInners
                sliderElement.BackgroundColor3 = themeList.ElementColor
                sliderElement.Size = UDim2.new(0, 352, 0, 30)
                sliderElement.Text = ""

                togName.Parent = sliderElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.03, 0, 0.25, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = slidInf
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 12.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                sliderBtn.Parent = sliderElement
                sliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                sliderBtn.Position = UDim2.new(0.5, 0, 0.4, 0)
                sliderBtn.Size = UDim2.new(0, 149, 0, 6)
                sliderBtn.Text = ""

                sliderDrag.Parent = sliderBtn
                sliderDrag.BackgroundColor3 = themeList.SchemeColor
                sliderDrag.Size = UDim2.new(0.5, 0, 1, 0)
                sliderDrag.BorderSizePixel = 0

                val.Parent = sliderElement
                val.BackgroundTransparency = 1
                val.Position = UDim2.new(0.38, 0, 0.25, 0)
                val.Size = UDim2.new(0, 41, 0, 14)
                val.Font = Enum.Font.GothamSemibold
                val.Text = tostring(minvalue)
                val.TextColor3 = themeList.TextColor
                val.TextSize = 11.000

                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local dragging = false

                sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
                uis.InputEnded:Connect(function(inputObj)
                    if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                run.RenderStepped:Connect(function()
                    if dragging then
                        local percentage = math.clamp((mouse.X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                        sliderDrag.Size = UDim2.new(percentage, 0, 1, 0)
                        local value = math.floor(minvalue + ((maxvalue - minvalue) * percentage))
                        val.Text = tostring(value)
                        pcall(callback, value)
                    end
                end)
                updateSectionFrame()
                UpdateSize()
            end
            return Elements
        end
        return Sections
    end
    return Tabs
end

-- [3. RÉSZ: JÁTÉK LOGIKA]
local Window = Kavo.CreateLib("Valley Prison Weapon Dropper", "DarkTheme")

local _G = _G or {}
_G.Dropping = false
_G.CurrentWeapon = "Model 870 Tactical"
_G.DropLocation = Vector3.new(100, 10, 50) 
_G.DelayTime = 0.1

local Remote = game:GetService("ReplicatedStorage").Events.GiveWeapon

task.spawn(function()
    while true do
        if _G.Dropping then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Remote:FireServer(_G.CurrentWeapon) 
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

local MainTab = Window:NewTab("Főmenü")
local MainSection = MainTab:NewSection("Fegyver Drop")

MainSection:NewToggle("Drop Indítása / Leállítása", "Parancs", function(state)
    _G.Dropping = state
end)

MainSection:NewDropdown("Fegyver Kiválasztása", "Parancs", {"Model 870 Tactical", "M4A1", "Glock 17", "AK-47"}, function(current)
    _G.CurrentWeapon = current
end)

MainSection:NewSlider("Sebesség (Késleltetés)", "Parancs", 50, 10, function(s)
    _G.DelayTime = s / 100
end)
