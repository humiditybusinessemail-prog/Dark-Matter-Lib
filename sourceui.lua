-- Dark Matter UI Library Source Code

local DarkMatter = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Get CoreGui safely or fall back to PlayerGui
local ParentGui = gethui and gethui() or CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Color Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Card = Color3.fromRGB(22, 22, 22),
    Accent = Color3.fromRGB(138, 43, 226), -- Neon Purple / Dark Matter Violet
    AccentLight = Color3.fromRGB(160, 80, 255),
    Border = Color3.fromRGB(35, 35, 35),
    TextMain = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 150)
}

-- Automated Logo Asset Handling
local logoAsset = "rbxassetid://10850233076" -- Default backup asset
local logoUrl = "https://i.postimg.cc/cJQ521Mk/gptblackbg.png"
local fileName = "DarkMatter_Logo.png"

local hasCustomAssetSupport = pcall(function()
    if writefile and readfile and getcustomasset then
        if not isfile(fileName) then
            writefile(fileName, game:HttpGet(logoUrl))
        end
        logoAsset = getcustomasset(fileName)
    else
        -- Fallback for executors that allow direct URL loading in ImageLabels
        logoAsset = logoUrl
    end
end)

-- Dragging Framework
local function makeDrag(frame, dragHandle)
    local dragStart, startPos
    local dragging = false
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

function DarkMatter:CreateWindow(titleText, subtitleText)
    titleText = titleText or "DARK MATTER"
    subtitleText = subtitleText or "v1.0.0"
    
    -- Main Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DarkMatter_" .. math.random(100,999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ParentGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Sidebar Frame
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar
    
    -- Visual fixer (hides right corners of sidebar to keep clean alignment)
    local CornerFixer = Instance.new("Frame")
    CornerFixer.Size = UDim2.new(0, 10, 1, 0)
    CornerFixer.Position = UDim2.new(1, -10, 0, 0)
    CornerFixer.BackgroundColor3 = Theme.Sidebar
    CornerFixer.BorderSizePixel = 0
    CornerFixer.Parent = Sidebar
    
    -- Header (Drag Handle)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame
    makeDrag(MainFrame, Header)
    
    -- BRANDING LOGO (Dynamic Loading)
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(0, 32, 0, 32)
    LogoImage.Position = UDim2.new(0, 12, 0, 14)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = logoAsset
    LogoImage.Parent = Sidebar
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoImage
    
    -- App Title (Shifted to the right to accommodate Logo)
    local Title = Instance.new("TextLabel")
    Title.Text = titleText
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Theme.Accent
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 50, 0, 12)
    Title.Size = UDim2.new(0, 100, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar
    
    -- App Subtitle (Shifted to the right)
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Text = subtitleText
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.TextSize = 9
    Subtitle.TextColor3 = Theme.TextMuted
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Position = UDim2.new(0, 50, 0, 26)
    Subtitle.Size = UDim2.new(0, 100, 0, 20)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Parent = Sidebar
    
    -- Sidebar Tab Container
    local TabButtonContainer = Instance.new("ScrollingFrame")
    TabButtonContainer.Size = UDim2.new(1, 0, 1, -70)
    TabButtonContainer.Position = UDim2.new(0, 0, 0, 70)
    TabButtonContainer.BackgroundTransparency = 1
    TabButtonContainer.BorderSizePixel = 0
    TabButtonContainer.ScrollBarThickness = 0
    TabButtonContainer.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabButtonContainer
    
    -- Main Container for Content Pages
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -170, 1, -20)
    ContentContainer.Position = UDim2.new(0, 170, 0, 10)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -30, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme.TextMuted
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Parent = MainFrame
    CloseBtn.ZIndex = 5
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 75, 75)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextMuted}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Toggle UI visibility with Keybind (RightControl default)
    local UI_Visible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            UI_Visible = not UI_Visible
            MainFrame.Visible = UI_Visible
        end
    end)

    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }
    
    -- Window Method: Create Tab
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 140, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Theme.TextMuted
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabButtonContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Theme.Border
        TabStroke.Thickness = 1
        TabStroke.Parent = TabButton
        
        -- The Page Frame for Tab elements
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.Visible = false
        Page.Parent = ContentContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.Parent = Page
        
        -- Switch to this Tab Functionality
        local function selectTab()
            if Window.CurrentTab then
                Window.CurrentTab.Button.TextColor3 = Theme.TextMuted
                Window.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                Window.CurrentTab.Button.UIStroke.Color = Theme.Border
                Window.CurrentTab.Page.Visible = false
            end
            Window.CurrentTab = {Button = TabButton, Page = Page}
            TabButton.TextColor3 = Theme.TextMain
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.UIStroke.Color = Theme.AccentLight
            Page.Visible = true
        end
        
        TabButton.MouseButton1Click:Connect(selectTab)
        
        if Window.CurrentTab == nil then
            selectTab()
        end
        
        local Tab = {}
        
        -- Tab Method: Create Section
        function Tab:CreateSection(sectionTitle)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Theme.Card
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = Page
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = Theme.Border
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame
            
            local SectionHeader = Instance.new("TextLabel")
            SectionHeader.Text = sectionTitle:upper()
            SectionHeader.Font = Enum.Font.GothamBold
            SectionHeader.TextSize = 10
            SectionHeader.TextColor3 = Theme.Accent
            SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            SectionHeader.Position = UDim2.new(0, 10, 0, 10)
            SectionHeader.Size = UDim2.new(1, -20, 0, 15)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionFrame
            
            local ElementLayout = Instance.new("UIListLayout")
            ElementLayout.Padding = UDim.new(0, 6)
            ElementLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ElementLayout.Parent = SectionFrame
            
            -- Padding inside section
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingTop = UDim.new(0, 30)
            SectionPadding.PaddingBottom = UDim.new(0, 8)
            SectionPadding.PaddingLeft = UDim.new(0, 8)
            SectionPadding.PaddingRight = UDim.new(0, 8)
            SectionPadding.Parent = SectionFrame
            
            -- Auto-adjust height of section based on elements inside it
            ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ElementLayout.AbsoluteContentSize.Y + 38)
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            end)
            
            local Section = {}
            
            -- Section Element: Button
            function Section:CreateButton(text, callback)
                callback = callback or function() end
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 30)
                Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                Btn.Text = text
                Btn.TextColor3 = Theme.TextMain
                Btn.Font = Enum.Font.GothamMedium
                Btn.TextSize = 12
                Btn.AutoButtonColor = false
                Btn.Parent = SectionFrame
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = Btn
                
                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Theme.Border
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn
                
                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                end)
                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                end)
                Btn.MouseButton1Click:Connect(function()
                    Btn.Size = UDim2.new(1, -4, 0, 28)
                    task.wait(0.05)
                    Btn.Size = UDim2.new(1, 0, 0, 30)
                    pcall(callback)
                end)
            end
            
            -- Section Element: Toggle
            function Section:CreateToggle(text, default, callback)
                default = default or false
                callback = callback or function() end
                local toggled = default
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                ToggleFrame.Parent = SectionFrame
                
                local TCorner = Instance.new("UICorner")
                TCorner.CornerRadius = UDim.new(0, 6)
                TCorner.Parent = ToggleFrame
                
                local TStroke = Instance.new("UIStroke")
                TStroke.Color = Theme.Border
                TStroke.Thickness = 1
                TStroke.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Text = text
                ToggleLabel.Font = Enum.Font.GothamMedium
                ToggleLabel.TextSize = 12
                ToggleLabel.TextColor3 = Theme.TextMain
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
                ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleBtn.BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(15, 15, 15)
                ToggleBtn.Text = ""
                ToggleBtn.Parent = ToggleFrame
                
                local TBtnCorner = Instance.new("UICorner")
                TBtnCorner.CornerRadius = UDim.new(0, 10)
                TBtnCorner.Parent = ToggleBtn
                
                local TBtnStroke = Instance.new("UIStroke")
                TBtnStroke.Color = Theme.Border
                TBtnStroke.Thickness = 1
                TBtnStroke.Parent = ToggleBtn
                
                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 14, 0, 14)
                Indicator.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Indicator.Parent = ToggleBtn
                
                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(1, 0)
                IndCorner.Parent = Indicator
                
                local function updateToggle()
                    if toggled then
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
                    else
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                    end
                    pcall(callback, toggled)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                end)
            end
            
            -- Section Element: Slider
            function Section:CreateSlider(text, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                SliderFrame.Parent = SectionFrame
                
                local SCorner = Instance.new("UICorner")
                SCorner.CornerRadius = UDim.new(0, 6)
                SCorner.Parent = SliderFrame
                
                local SStroke = Instance.new("UIStroke")
                SStroke.Color = Theme.Border
                SStroke.Thickness = 1
                SStroke.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Text = text
                SliderLabel.Font = Enum.Font.GothamMedium
                SliderLabel.TextSize = 12
                SliderLabel.TextColor3 = Theme.TextMain
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Position = UDim2.new(0, 10, 0, 6)
                SliderLabel.Size = UDim2.new(0, 200, 0, 15)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Parent = SliderFrame
                
                local SliderVal = Instance.new("TextLabel")
                SliderVal.Text = tostring(default)
                SliderVal.Font = Enum.Font.GothamBold
                SliderVal.TextSize = 12
                SliderVal.TextColor3 = Theme.Accent
                SliderVal.TextXAlignment = Enum.TextXAlignment.Right
                SliderVal.Position = UDim2.new(1, -60, 0, 6)
                SliderVal.Size = UDim2.new(0, 50, 0, 15)
                SliderVal.BackgroundTransparency = 1
                SliderVal.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -20, 0, 6)
                SliderBar.Position = UDim2.new(0, 10, 0, 28)
                SliderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                local isDragging = false
                
                local function updateSlider(input)
                    local relativePos = input.Position.X - SliderBar.AbsolutePosition.X
                    local percent = math.clamp(relativePos / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderVal.Text = tostring(value)
                    pcall(callback, value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
            end
            
            -- Section Element: Dropdown
            function Section:CreateDropdown(text, options, default, callback)
                options = options or {}
                default = default or options[1] or ""
                callback = callback or function() end
                
                local open = false
                local selected = default
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                DropdownFrame.Parent = SectionFrame
                DropdownFrame.ClipsDescendants = true
                
                local DCorner = Instance.new("UICorner")
                DCorner.CornerRadius = UDim.new(0, 6)
                DCorner.Parent = DropdownFrame
                
                local DStroke = Instance.new("UIStroke")
                DStroke.Color = Theme.Border
                DStroke.Thickness = 1
                DStroke.Parent = DropdownFrame
                
                local DLabel = Instance.new("TextLabel")
                DLabel.Text = text .. " : " .. selected
                DLabel.Font = Enum.Font.GothamMedium
                DLabel.TextSize = 12
                DLabel.TextColor3 = Theme.TextMain
                DLabel.TextXAlignment = Enum.TextXAlignment.Left
                DLabel.Position = UDim2.new(0, 10, 0, 0)
                DLabel.Size = UDim2.new(1, -40, 0, 32)
                DLabel.BackgroundTransparency = 1
                DLabel.Parent = DropdownFrame
                
                local Arrow = Instance.new("TextLabel")
                Arrow.Text = "▼"
                Arrow.Font = Enum.Font.GothamBold
                Arrow.TextSize = 10
                Arrow.TextColor3 = Theme.TextMuted
                Arrow.Position = UDim2.new(1, -30, 0, 0)
                Arrow.Size = UDim2.new(0, 20, 0, 32)
                Arrow.BackgroundTransparency = 1
                Arrow.Parent = DropdownFrame
                
                local DButton = Instance.new("TextButton")
                DButton.Size = UDim2.new(1, 0, 0, 32)
                DButton.BackgroundTransparency = 1
                DButton.Text = ""
                DButton.Parent = DropdownFrame
                
                local OptionsContainer = Instance.new("Frame")
                OptionsContainer.Size = UDim2.new(1, -10, 0, #options * 26)
                OptionsContainer.Position = UDim2.new(0, 5, 0, 35)
                OptionsContainer.BackgroundTransparency = 1
                OptionsContainer.Parent = DropdownFrame
                
                local ContainerLayout = Instance.new("UIListLayout")
                ContainerLayout.Padding = UDim.new(0, 2)
                ContainerLayout.Parent = OptionsContainer
                
                local function resizeDropdown()
                    if open then
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 38 + (#options * 28))
                        Arrow.Text = "▲"
                    else
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                        Arrow.Text = "▼"
                    end
                end
                
                DButton.MouseButton1Click:Connect(function()
                    open = not open
                    resizeDropdown()
                end)
                
                for _, option in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    OptBtn.Text = "  " .. option
                    OptBtn.TextColor3 = Theme.TextMuted
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.Font = Enum.Font.GothamMedium
                    OptBtn.TextSize = 11
                    OptBtn.AutoButtonColor = false
                    OptBtn.Parent = OptionsContainer
                    
                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 4)
                    OptCorner.Parent = OptBtn
                    
                    OptBtn.MouseEnter:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextMain}):Play()
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Theme.TextMuted}):Play()
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = option
                        DLabel.Text = text .. " : " .. selected
                        open = false
                        resizeDropdown()
                        pcall(callback, selected)
                    end)
                end
            end
            
            -- Section Element: TextBox
            function Section:CreateTextBox(text, placeholder, callback)
                placeholder = placeholder or "Type here..."
                callback = callback or function() end
                
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 32)
                TextBoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                TextBoxFrame.Parent = SectionFrame
                
                local TBCorner = Instance.new("UICorner")
                TBCorner.CornerRadius = UDim.new(0, 6)
                TBCorner.Parent = TextBoxFrame
                
                local TBStroke = Instance.new("UIStroke")
                TBStroke.Color = Theme.Border
                TBStroke.Thickness = 1
                TBStroke.Parent = TextBoxFrame
                
                local TBLabel = Instance.new("TextLabel")
                TBLabel.Text = text
                TBLabel.Font = Enum.Font.GothamMedium
                TBLabel.TextSize = 12
                TBLabel.TextColor3 = Theme.TextMain
                TBLabel.TextXAlignment = Enum.TextXAlignment.Left
                TBLabel.Position = UDim2.new(0, 10, 0, 0)
                TBLabel.Size = UDim2.new(0, 150, 1, 0)
                TBLabel.BackgroundTransparency = 1
                TBLabel.Parent = TextBoxFrame
                
                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(1, -170, 0, 22)
                Input.Position = UDim2.new(1, -160, 0.5, -11)
                Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                Input.TextColor3 = Theme.TextMain
                Input.PlaceholderColor3 = Theme.TextMuted
                Input.PlaceholderText = placeholder
                Input.Text = ""
                Input.Font = Enum.Font.GothamMedium
                Input.TextSize = 11
                Input.ClearTextOnFocus = false
                Input.Parent = TextBoxFrame
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = Input
                
                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Theme.Border
                InputStroke.Thickness = 1
                InputStroke.Parent = Input
                
                Input.Focused:Connect(function()
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
                end)
                
                Input.FocusLost:Connect(function(enterPressed)
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
                    pcall(callback, Input.Text, enterPressed)
                end)
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return DarkMatter
