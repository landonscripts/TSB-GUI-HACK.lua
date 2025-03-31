local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSB_GUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.08, 0)
title.Text = "TSB-GUI"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Name = "Title"

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 0.5, -5)
playerList.Position = UDim2.new(0, 5, 0.1, 0)
playerList.BackgroundTransparency = 1
playerList.ScrollBarThickness = 5
playerList.Name = "PlayerList"

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = playerList

-- Settings Frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -10, 0.25, 0)
settingsFrame.Position = UDim2.new(0, 5, 0.6, 0)
settingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
settingsFrame.BorderSizePixel = 0
settingsFrame.Name = "SettingsFrame"

-- Radius Control
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, 0, 0.3, 0)
radiusLabel.Text = "Radius: 3 studs"
radiusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = 14
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Name = "RadiusLabel"

local radiusSlider = Instance.new("TextButton")
radiusSlider.Size = UDim2.new(1, 0, 0.2, 0)
radiusSlider.Position = UDim2.new(0, 0, 0.3, 0)
radiusSlider.Text = ""
radiusSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
radiusSlider.Name = "RadiusSlider"

local radiusFill = Instance.new("Frame")
radiusFill.Size = UDim2.new(0.5, 0, 1, 0)
radiusFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
radiusFill.BorderSizePixel = 0
radiusFill.Name = "RadiusFill"

-- Speed Control
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0.3, 0)
speedLabel.Position = UDim2.new(0, 0, 0.5, 0)
speedLabel.Text = "Speed: 6"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Name = "SpeedLabel"

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(1, 0, 0.2, 0)
speedSlider.Position = UDim2.new(0, 0, 0.8, 0)
speedSlider.Text = ""
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.Name = "SpeedSlider"

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
speedFill.BorderSizePixel = 0
speedFill.Name = "SpeedFill"

-- Stop Button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.9, 0, 0.1, 0)
stopButton.Position = UDim2.new(0.05, 0, 0.87, 0)
stopButton.Text = "STOP CIRCLE"
stopButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 16
stopButton.Name = "StopButton"
stopButton.Visible = false

-- New Button for loading the other script
local otherScriptButton = Instance.new("TextButton")
otherScriptButton.Size = UDim2.new(0.9, 0, 0.1, 0)
otherScriptButton.Position = UDim2.new(0.05, 0, 0.76, 0)
otherScriptButton.Text = "Other Script Cool"
otherScriptButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
otherScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
otherScriptButton.Font = Enum.Font.GothamBold
otherScriptButton.TextSize = 16
otherScriptButton.Name = "OtherScriptButton"

-- Assemble GUI
radiusFill.Parent = radiusSlider
speedFill.Parent = speedSlider
radiusLabel.Parent = settingsFrame
radiusSlider.Parent = settingsFrame
speedLabel.Parent = settingsFrame
speedSlider.Parent = settingsFrame
title.Parent = mainFrame
playerList.Parent = mainFrame
settingsFrame.Parent = mainFrame
stopButton.Parent = mainFrame
otherScriptButton.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Variables
local localPlayer = Players.LocalPlayer
local currentlyCircling = nil
local circleConnections = {}
local currentRadius = 3
local currentSpeed = 6
local circleHeight = 2
local isDraggingSlider = nil

-- Update player list function (Improved)
local function updatePlayerList()
    -- Remove previous buttons without destroying the whole list
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Add current players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1, -10, 0, 36)
            playerButton.Text = player.Name
            playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.Font = Enum.Font.GothamMedium
            playerButton.TextSize = 14
            playerButton.Name = player.Name
            
            playerButton.MouseButton1Click:Connect(function()
                if currentlyCircling ~= player then
                    currentlyCircling = player
                    stopButton.Visible = true
                    startCirclingPlayer(player)
                end
            end)
            
            playerButton.Parent = playerList
        end
    end
end

-- Handle and start circling (optimized version)
local function startCirclingPlayer(targetPlayer)
    -- Avoid multiple connections for the same target
    if circleConnections[targetPlayer] then return end
    
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 20
    
    local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local targetRoot = targetCharacter:WaitForChild("HumanoidRootPart")
    
    -- Disconnect previous connections for the target if they exist
    if circleConnections[targetPlayer] then
        circleConnections[targetPlayer]:Disconnect()
    end
    
    local angle = 0
    local connection
    
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not targetCharacter or not targetRoot or not targetRoot:IsDescendantOf(workspace) then
            connection:Disconnect()
            circleConnections[targetPlayer] = nil
            return
        end
        
        angle = (angle + currentSpeed * deltaTime) % (2 * math.pi)
        
        -- Calculate position with current radius
        local offset = Vector3.new(
            math.cos(angle) * currentRadius,
            circleHeight,
            math.sin(angle) * currentRadius
        )
        
        local targetPosition = targetRoot.Position + offset
        
        -- Smooth look-at for better visual effect
        local lookAt = (targetRoot.Position - character:WaitForChild("HumanoidRootPart").Position)
        lookAt = Vector3.new(lookAt.X, 0, lookAt.Z).Unit
        character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(
            targetPosition,
            targetPosition + lookAt
        )
        
        humanoid:MoveTo(targetPosition)
    end)
    
    circleConnections[targetPlayer] = connection
    
    -- Handle character changes
    targetPlayer.CharacterAdded:Connect(function(newCharacter)
        if circleConnections[targetPlayer] then
            circleConnections[targetPlayer]:Disconnect()
            task.wait(1)
            startCirclingPlayer(targetPlayer)
        end
    end)
end

-- Stop circling (optimized)
stopButton.MouseButton1Click:Connect(function()
    if currentlyCircling and circleConnections[currentlyCircling] then
        circleConnections[currentlyCircling]:Disconnect()
        circleConnections[currentlyCircling] = nil
        
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        
        currentlyCircling = nil
        stopButton.Visible = false
    end
end)

-- Handle slider updates (optimized)
local function updateSliderValue(slider, fill, label, value, minValue, maxValue, isRadius)
    local fillSize = (value - minValue) / (maxValue - minValue)
    fill.Size = UDim2.new(fillSize, 0, 1, 0)
    
    if isRadius then
        label.Text = string.format("Radius: %.1f studs", value)
        currentRadius = value
    else
        label.Text = string.format("Speed: %.1f", value)
        currentSpeed = value
    end
    
    -- Update circling if active
    if currentlyCircling and circleConnections[currentlyCircling] then
        circleConnections[currentlyCircling]:Disconnect()
        startCirclingPlayer(currentlyCircling)
    end
end

-- Input handling for sliders (optimized)
local function handleSliderInput(input, slider, fill, label, minValue, maxValue, isRadius)
    if input.UserInputState == Enum.UserInputState.Begin then
        isDraggingSlider = slider
    elseif input.UserInputState == Enum.UserInputState.End then
        isDraggingSlider = nil
    end
    
    if input.UserInputState == Enum.UserInputState.Change and isDraggingSlider == slider then
        local xPosition = input.Position.X - slider.AbsolutePosition.X
        local percent = math.clamp(xPosition / slider.AbsoluteSize.X, 0, 1)
        local value = minValue + (maxValue - minValue) * percent
        updateSliderValue(slider, fill, label, value, minValue, maxValue, isRadius)
    end
end

radiusSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        handleSliderInput(input, radiusSlider, radiusFill, radiusLabel, 1, 10, true)
    end
end)

radiusSlider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        handleSliderInput(input, radiusSlider, radiusFill, radiusLabel, 1, 10, true)
    end
end)

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        handleSliderInput(input, speedSlider, speedFill, speedLabel, 1, 20, false)
    end
end)

speedSlider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        handleSliderInput(input, speedSlider, speedFill, speedLabel, 1, 20, false)
    end
end)

-- Initialize sliders
updateSliderValue(radiusSlider, radiusFill, radiusLabel, 3, 1, 10, true)
updateSliderValue(speedSlider, speedFill, speedLabel, 6, 1, 20, false)

-- Player management
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Handle respawns
localPlayer.CharacterAdded:Connect(function(character)
    if currentlyCircling then
        task.wait(1)
        startCirclingPlayer(currentlyCircling)
    end
end)

-- Make GUI draggable
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- New button click functionality for loading other script
otherScriptButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/TSBG/main/Solara"))()
end)
