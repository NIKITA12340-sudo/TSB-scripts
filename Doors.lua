local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({IntroText = "Doors GUI v1.2", Name = "Doors - By sashaaaaa#5351", HidePremium = false, SaveConfig = true, ConfigFolder = "DoorsSex"})

if game.PlaceId == 6516141723 then
    OrionLib:MakeNotification({
        Name = "Error",
        Content = "Please execute while in-game, not in the lobby.",
        Time = 2
    })
end

local UserInputService = game:GetService("UserInputService")

-- Открытие GUI на нажатие Ctrl
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftControl then
        Window:Toggle()
    end
end)

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CF = CFrame.new
local LastRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom
local ChaseStart = game:GetService("ReplicatedStorage").GameData.ChaseStart

local KeyHighlights = {}

VisualsTab:AddToggle({
    Name = "Key Highlights",
    Default = false,
    Flag = "KeyToggle",
    Save = true,
    Callback = function(Value)
        for i, v in pairs(KeyHighlights) do
            v.Enabled = Value
        end
    end    
})

local function ApplyKeyHighlight(inst)
    wait()
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.new(0.980392, 0.670588, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(0.792156, 0.792156, 0.792156)
    highlight.Parent = game:GetService("CoreGui")
    highlight.Adornee = inst
    highlight.Enabled = OrionLib.Flags["KeyToggle"].Value
    highlight.RobloxLocked = true
    return highlight
end

local KeyCoroutine = coroutine.create(function()
    workspace.CurrentRooms.DescendantAdded:Connect(function(inst)
        if inst.Name == "KeyObtain" then
            table.insert(KeyHighlights, ApplyKeyHighlight(inst))
        end
    end)
end)

for i, v in ipairs(workspace:GetDescendants()) do
    if v.Name == "KeyObtain" then
        table.insert(KeyHighlights, ApplyKeyHighlight(v))
    end
end

coroutine.resume(KeyCoroutine)

local BookHighlights = {}

VisualsTab:AddToggle({
    Name = "Book Highlights",
    Default = false,
    Flag = "BookToggle",
    Save = true,
    Callback = function(Value)
        for i, v in pairs(BookHighlights) do
            v.Enabled = Value
        end
    end    
})

local FigureHighlights = {}

VisualsTab:AddToggle({
    Name = "Figure Highlights",
    Default = false,
    Flag = "FigureToggle",
    Save = true,
    Callback = function(Value)
        for i, v in pairs(FigureHighlights) do
            v.Enabled = Value
        end
    end
})

local function ApplyBookHighlight(inst)
    if inst:IsDescendantOf(game:GetService("Workspace").CurrentRooms:FindFirstChild("50")) and game:GetService("ReplicatedStorage").GameData.LatestRoom.Value == 50 then
        wait()
        local highlight = Instance.new("Highlight")
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.new(0, 1, 0.749019)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(0.792156, 0.792156, 0.792156)
        highlight.Parent = game:GetService("CoreGui")
        highlight.Enabled = OrionLib.Flags["BookToggle"].Value
        highlight.Adornee = inst
        highlight.RobloxLocked = true
        return highlight
    end
end

local function ApplyFigureHighlight(inst)
    wait()
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(0.792156, 0.792156, 0.792156)
    highlight.Parent = game:GetService("CoreGui")
    highlight.Enabled = OrionLib.Flags["FigureToggle"].Value
    highlight.Adornee = inst
    highlight.RobloxLocked = true
    return highlight
end

local BookCoroutine = coroutine.create(function()
    task.wait(1)
    for i, v in pairs(game:GetService("Workspace").CurrentRooms["50"].Assets:GetDescendants()) do
        if v.Name == "LiveHintBook" then
            table.insert(BookHighlights, ApplyBookHighlight(v))
        end
    end
end)

local FigureCoroutine = coroutine.create(function()
    local figure = game:GetService("Workspace").CurrentRooms["50"].FigureSetup:WaitForChild("FigureRagdoll", 5)
    figure:WaitForChild("Torso", 2.5)
    table.insert(FigureHighlights, ApplyFigureHighlight(figure))
end)

local GameTab = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TargetSpeed
PlayerTab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 50,
    Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        TargetSpeed = Value
    end    
})

local pcl = Instance.new("SpotLight")
pcl.Brightness = 1
pcl.Face = Enum.NormalId.Front
pcl.Range = 90
pcl.Parent = game.Players.LocalPlayer.Character.Head
pcl.Enabled = false

PlayerTab:AddToggle({
    Name = "Flashlight",
    Default = false,
    Callback = function(Value)
        pcl.Enabled = Value
    end
})

GameTab:AddToggle({
    Name = "No Hands/Obstructions",
    Default = false,
    Flag = "NoSeek",
    Save = true
})

GameTab:AddToggle({
    Name = "Instant Interaction",
    Default = false,
    Flag = "InstantToggle",
    Save = true
})

GameTab:AddButton({
    Name = "Skip Level",
    Callback = function()
        pcall(function()
            local HasKey = false
            local CurrentDoor = workspace.CurrentRooms[tostring(game:GetService("ReplicatedStorage").GameData.LatestRoom.Value)]:WaitForChild("Door")
            for i, v in ipairs(CurrentDoor.Parent:GetDescendants()) do
                if v.Name == "KeyObtain" then
                    HasKey = v
                end
            end
            if HasKey then
                game.Players.LocalPlayer.Character:PivotTo(CF(HasKey.Hitbox.Position))
                wait(0.3)
                fireproximityprompt(HasKey.ModulePrompt, 0)
                game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
                wait(0.3)
                fireproximityprompt(CurrentDoor.Lock.UnlockPrompt, 0)
            end
            if LastRoom == 50 then
                CurrentDoor = workspace.CurrentRooms[tostring(LastRoom + 1)]:WaitForChild("Door")
            end
            game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
            wait(0.3)
            CurrentDoor.ClientOpen:FireServer()
        end)
    end    
})

GameTab:AddToggle({
    Name = "Auto Skip Level",
    Default = false,
    Flag = "AutoSkip",
    Save = true
})

-- Main loop to set speed
while wait(0.1) do
    if TargetSpeed then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
    end
end

OrionLib:Init()
