local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGui"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
 
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
 
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(0, 0, 139) 
uiStroke.Parent = mainFrame
 
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame
 
local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyBox"
keyBox.Size = UDim2.new(0.8, 0, 0.15, 0)
keyBox.Position = UDim2.new(0.1, 0, 0.1, 0)
keyBox.PlaceholderText = "Enter Key Here"
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255) 
keyBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180) 
keyBox.Parent = mainFrame
 
local function createButton(name, position, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.8, 0, 0.15, 0)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
    button.TextColor3 = Color3.fromRGB(255, 255, 255) 
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(0, 0, 139)
    button.Parent = mainFrame
    return button
end
 
local submitButton = createButton("SubmitButton", UDim2.new(0.1, 0, 0.3, 0), "Submit")
local getKeyButton = createButton("GetKeyButton", UDim2.new(0.1, 0, 0.5, 0), "Get Key")
local joinDiscordButton = createButton("JoinDiscordButton", UDim2.new(0.1, 0, 0.7, 0), "Join Discord")
 
local correctKey = "yoooo77"
 
submitButton.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Success";
            Text = "Key Verified✅";
            Duration = 3;
        })
 
        screenGui:Destroy()

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Waffi Hub', Center = true, AutoShow = true })
local Tabs = {Main = Window:AddTab('Main'),ViewMisc = Window:AddTab('View Items'),['UI Settings'] = Window:AddTab('UI Settings')}

local VirtualUser = game:GetService('VirtualUser')
local StarterGui = game:GetService('StarterGui')

StarterGui:SetCore("SendNotification", { Title = "Anti-AFK", Text = "Script Activated", Duration = 5 })

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)


local Main = Tabs.Main:AddLeftGroupbox('Main')
local Webhook = Tabs.Main:AddLeftGroupbox('WEBHOOK')
local Misc = Tabs.Main:AddRightGroupbox('Misc')
--local Buy = Tabs.Main:AddRightGroupbox('Buy')


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Nodes = workspace:WaitForChild("Nodes")
local ChickenFryers = workspace:WaitForChild("ChickenFryers")

local ChickenPrompts = {}
for i = 1, 8 do
    local node = Nodes:GetChildren()[i]
    if node and node:FindFirstChild("Node") and node.Node:FindFirstChild("ProximityPrompt") then
        local prompt = node.Node.ProximityPrompt
        prompt.HoldDuration = 0
        table.insert(ChickenPrompts, prompt)
    end
end

local FryerPrompts = {}

for i, fryer in ipairs(ChickenFryers:GetChildren()) do
    if fryer:FindFirstChild("Fryer") and fryer.Fryer:FindFirstChild("Interact") then
        table.insert(FryerPrompts, fryer.Fryer.Interact:FindFirstChildOfClass("ProximityPrompt"))
    end
    if fryer:GetChildren()[3] and fryer:GetChildren()[3]:FindFirstChild("Interact") then
        table.insert(FryerPrompts, fryer:GetChildren()[3].Interact:FindFirstChildOfClass("ProximityPrompt"))
    end
end

for _, prompt in ipairs(FryerPrompts) do
    if prompt then
        prompt.HoldDuration = 0
    end
end

local function hasChicken()
    for _, item in ipairs(Backpack:GetChildren()) do
        if item.Name == "Chicken Leg" or item.Name == "Chicken Fillet" then
            return item
        end
    end
    for _, item in ipairs(Character:GetChildren()) do
        if item.Name == "Chicken Leg" or item.Name == "Chicken Fillet" then
            return item
        end
    end
    return nil
end

local function freezeCharacter()
    Humanoid.PlatformStand = true
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

local function unfreezeCharacter()
    Humanoid.PlatformStand = false
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

local function safeTeleport(cf)
    freezeCharacter()
    Character:PivotTo(cf + Vector3.new(0, 3, 0))
    task.wait(0.1)
    unfreezeCharacter()
end

local AutoFarm = false

Main:AddToggle('Auto Farm', {Text = 'Chicken Job Farm', Default = false, Tooltip = 'USE SCRIPT ON ALT ONLY!!', Callback = function(value) AutoFarm = value end})

task.spawn(function()
    while task.wait(0.3) do
        if AutoFarm then
            for _, prompt in ipairs(ChickenPrompts) do
                if hasChicken() then break end
                if prompt and prompt.Parent then
                    safeTeleport(prompt.Parent.CFrame)
                    task.wait(0.1)
                    fireproximityprompt(prompt, 1)
                    task.wait(0.25)
                end
            end

            local chicken = hasChicken()
            if chicken then
                chicken.Parent = Character
                task.wait(0.2)

                for _, prompt in ipairs(FryerPrompts) do
                    if not hasChicken() then break end
                    if prompt and prompt.Parent then
                        safeTeleport(prompt.Parent.CFrame)
                        task.wait(0.1)
                        fireproximityprompt(prompt, 1)
                        task.wait(0.25)
                    end
                end
            end
        end
    end
end)

--Main:AddDivider()

local PlantFarm = false

--Main:AddToggle('Plant Farm', {Text = 'Plant Farm', Default = false, Tooltip = 'USE SCRIPT ON ALT ONLY!!', Callback = function(value) PlantFarm = value end})

task.spawn(function()
    while true do
        if PlantFarm then
            -- Main script logic starts here
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local BerryPots = workspace:WaitForChild("BerryPots")
            local LP = Players.LocalPlayer
            local Backpack = LP:WaitForChild("Backpack")
            local Character = LP.Character or LP.CharacterAdded:Wait()
            local HRP = Character:WaitForChild("HumanoidRootPart")

            local function hasSeed()
                for _, item in ipairs(Backpack:GetChildren()) do
                    if item:IsA("Tool") and item.Name == "Seed" then
                        return item
                    end
                end
                return nil
            end

            local args = {
                ReplicatedStorage:WaitForChild("StoreMenus"):WaitForChild("Ling Enterprises"):WaitForChild("Misc"):WaitForChild("Seed")
            }

            ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("StorePurchase"):InvokeServer(unpack(args))

            task.wait(0.5)

            local seedTool = hasSeed()
            if seedTool then
                seedTool.Parent = Character
            else
                warn("No Seed found in backpack after buying!")
                return
            end

            repeat task.wait() until Character:FindFirstChild("Seed")
            task.wait(0.2)

            local berryPot = BerryPots:GetChildren()[14]
            local partToTeleport

            if berryPot and berryPot:IsA("Model") then
                partToTeleport = berryPot:FindFirstChildWhichIsA("BasePart")
            end

            if partToTeleport then
                HRP.CFrame = partToTeleport.CFrame + Vector3.new(0, 5, 0)
            end

            task.wait(0.5)

            local function getPrompt()
                return berryPot:FindFirstChild("Interact"):FindFirstChildOfClass("ProximityPrompt")
            end

            local prompt = getPrompt()
            if prompt then
                fireproximityprompt(prompt)
                task.wait(1)

                for i = 1, 50 do
                    local newPrompt = getPrompt()
                    if newPrompt then
                        fireproximityprompt(newPrompt)
                    end
                    task.wait(0.2)
                end
            else
                warn("No ProximityPrompt found in BerryPot!")
            end

            task.wait(5 * 60 + 15)

            local harvestPrompt = getPrompt()
            if harvestPrompt then
                fireproximityprompt(harvestPrompt)
                task.wait(15)

                local firstItem = Backpack:GetChildren()[1]
                if firstItem then
                    firstItem.Parent = Character
                else
                    warn("No items found in the backpack to equip!")
                end
            else
                warn("No ProximityPrompt found for harvesting!")
            end

            task.wait(0.5)

            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")

            local packSelling = workspace:WaitForChild("PackSelling")

            local locations = {
                "Blake Construction Zone",
                "Brownsville Houses",
                "Chester Apartments",
                "Donnio's Pizza",
                "Glenmore Avenue",
                "MGA",
                "Rockaway Metro",
                "Tilden Housing",
                "Wah Yung",
                "Woodson's back alley",
                "the MGA playground",
                "the gas station",
                "the graveyard",
                "the gym's alley",
                "the gym's back exit",
                "the laundromat",
                "the port entrance",
                "the scrapyard",
                "the tat store"
            }

            for _, locName in ipairs(locations) do
                local location = packSelling:FindFirstChild(locName)
                if location then
                    local pookie = location:FindFirstChild("Pookie")
                    if pookie and pookie:FindFirstChild("HumanoidRootPart") then
                        local node = pookie.HumanoidRootPart:FindFirstChild("Node")
                        local prompt = node and node:FindFirstChildOfClass("ProximityPrompt")

                        if prompt then
                            print("Found active Pookie at:", locName)

                            local firstItem = Backpack:GetChildren()[1]
                            if firstItem then
                                firstItem.Parent = Character
                            else
                                warn("No items found in the backpack to equip!")
                            end

                            if pookie:IsA("Model") and pookie.PrimaryPart then
                                hrp.CFrame = pookie:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0)
                            end

                            task.wait(1)
                            fireproximityprompt(prompt)
                            break
                        end
                    end
                end
            end
        end
        task.wait(1) 
    end
end)

--Main:AddDivider()

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local BoxFarm = false

--Main:AddToggle('Box Farm', {Text = 'Box Farm', Default = false, Tooltip = 'USE SCRIPT ON ALT ONLY!!', Callback = function(value) BoxFarm = value end})

spawn(function()
    while true do
        if BoxFarm then
            character:SetPrimaryPartCFrame(CFrame.new(168, 72, 367))

            local v = 1
            while v <= 22 do
                workspace.BoxStocker.Box.Node.ProximityPrompt.HoldDuration = 0
                workspace.BoxStocker.Box.Node.ProximityPrompt:InputHoldBegin()
                workspace.BoxStocker.Box.Node.ProximityPrompt:InputHoldEnd()
                wait(0.1)
                v = v + 1
            end

            character:SetPrimaryPartCFrame(CFrame.new(221, 72, 370))
            v = 1
            workspace.BoxStocker.Pallet.Node.ProximityPrompt.HoldDuration = 0
            while v <= 22 do
                workspace.BoxStocker.Pallet.Node.ProximityPrompt:InputHoldBegin()
                workspace.BoxStocker.Pallet.Node.ProximityPrompt:InputHoldEnd()
                wait(0.1) 
                v = v + 1
            end
        end

        wait(1) 
    end
end)

Main:AddDivider()


local PlayersDropdown = Main:AddDropdown('Player List', {Text = 'Select Player', Values = {}, Default = '', Callback = function(value) _G.PlayerName = value end})

local function updatePlayerList()
	local players = game:GetService("Players"):GetPlayers()
	local playerNames = {}
	for _, player in ipairs(players) do
		table.insert(playerNames, player.Name)
	end
	PlayersDropdown:SetValues(playerNames)
end

updatePlayerList()

game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)

Main:AddDropdown('Amount', {Text = 'Select Amount', Values = {'5000','10000', '20000', '30000', '40000', '50000', '100000'}, Default = '20000', Callback = function(value) _G.Amount = tonumber(value) end})
Main:AddDivider()
local AutoSendMoney = false

Main:AddToggle('Auto Send Money', {Text = 'Auto Send Money', Default = false, Tooltip = 'Automatically send money to the selected player', Callback = function(value) AutoSendMoney = value end})

task.spawn(function()
    while task.wait(1) do
        if AutoSendMoney and _G.PlayerName and _G.PlayerName ~= '' and _G.Amount then
            local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
            local bashApp = remoteEvents and remoteEvents:FindFirstChild("BashApp")
            
            if bashApp then
                local args = {
                    [1] = _G.Amount,
                    [2] = _G.PlayerName
                }

                bashApp:FireServer(unpack(args))
                Library:Notify("Success", "Sent " .. _G.Amount .. " to " .. _G.PlayerName, 5)
            else
                Library:Notify("Error", "BashApp RemoteEvent not found", 5)
            end
        end
    end
end)

--[[ Misc:AddButton('Stat Change', function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    local stats = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(LocalPlayer.Name):WaitForChild("Statistics")
    local gamepasses = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(LocalPlayer.Name):WaitForChild("Gamepasses")

    stats.Agility.Value = 15
    stats.Driving.Value = 50
    stats.Intelligence.Value = 1000
    stats.Luck.Value = 100000
    stats.Stamina.Value = 1000
    stats.Strength.Value = 1000
    stats.Vitality.Value = 1000
    stats.Recovery.Value = 1000
    stats.Dexterity.Value = 100

    for _, passName in ipairs({
        "Bulletproof",
        "CustomBeams",
        "CustomCursor",
        "GrowZone",
        "InfiniteAmmo",
        "MutualRespect",
        "OverAchiever",
        "PhoneWallpaper",
        "StashUpgrade",
        "TimeMoney",
        "x2Cash",
        "x2Points",
        "x2Reputation"
    }) do
        local pass = gamepasses:FindFirstChild(passName)
        if pass then
            pass.Value = true
        end
    end
end) ]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:FindFirstChild("HumanoidRootPart")

Misc:AddButton('IY', function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
Misc:AddButton('Get Low Server', function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"

    local _place = game.PlaceId
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
    function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end

    local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
    until Server

    TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
end)
--Misc:AddDivider()
local Teleport = Tabs.Main:AddRightGroupbox('Teleports')
--Teleport:AddButton({ Text = 'Plant Shop', Func = function() if hrp then hrp.CFrame = CFrame.new(1360, 74, 142) end end })
Teleport:AddButton({ Text = 'Gun Store', Func = function() if hrp then hrp.CFrame = CFrame.new(414, 62, 158) end end })
Teleport:AddButton({ Text = 'Clothing Store', Func = function() if hrp then hrp.CFrame = CFrame.new(382, 73, -25) end end })
Teleport:AddButton({ Text = 'Chicken Job', Func = function() if hrp then hrp.CFrame = CFrame.new(1092, 73, 7) end end })
--Teleport:AddDivider()
--[[Teleport:AddButton("Find Pookie", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local packSelling = workspace:WaitForChild("PackSelling")

    local locations = {
        "Blake Construction Zone",
        "Brownsville Houses",
        "Chester Apartments",
        "Donnio's Pizza",
        "Glenmore Avenue",
        "MGA",
        "Rockaway Metro",
        "Tilden Housing",
        "Wah Yung",
        "Woodson's back alley",
        "the MGA playground",
        "the gas station",
        "the graveyard",
        "the gym's alley",
        "the gym's back exit",
        "the laundromat",
        "the port entrance",
        "the scrapyard",
        "the tat store"
    }

    for _, locationName in ipairs(locations) do
        local location = packSelling:FindFirstChild(locationName)
        if location then
            local pookie = location:FindFirstChild("Pookie")
            if pookie then
                print("Found Pookie at:", locationName)
                
                if pookie:IsA("BasePart") then
                    hrp.CFrame = pookie.CFrame + Vector3.new(0, 5, 0) 
                elseif pookie:IsA("Model") and pookie.PrimaryPart then
                    hrp.CFrame = pookie:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0)
                else
                end

                break 
            end
        end
    end
end)]]
--Teleport:AddButton({ Text = 'Wash Money', Func = function() if hrp then hrp.CFrame = CFrame.new(273, 72, 386) end end })


local ShootGroupBox = Tabs.Main:AddLeftGroupbox('Shooting')
local AimLockToggle = ShootGroupBox:AddToggle('AimLock', { Text = 'Aim Lock', Default = false })
local MaxAimDistanceSlider = ShootGroupBox:AddSlider('MaxAimDistance', { Text = 'Max Aim Distance', Default = 100, Min = 10, Max = 500, Rounding = 1, AutoRound = true, Suffix = 'Studs' })
local FOVRadiusSlider = ShootGroupBox:AddSlider('FOVRadius', { Text = 'FOV Radius', Default = 150, Min = 50, Max = 500, Rounding = 1, AutoRound = true, Suffix = 'px' })
local AimPartDropdown = ShootGroupBox:AddDropdown('AimPart', { Text = 'Aim Part', Default = 'UpperTorso', Values = { 'Head', 'UpperTorso', 'HumanoidRootPart' } })

local function AimLock()
    if _G.AimLock then
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local lockOn = false
        local target = nil
        local isRightMouseButtonDown = false
        local whitelist = { "keihura" }

        pcall(function()
            for _, friend in pairs(player:GetFriendsOnline()) do
                table.insert(whitelist, friend.UserName)
            end
        end)

        local function isWhitelisted(playerName)
            for _, name in pairs(whitelist) do
                if playerName == name then
                    return true
                end
            end
            return false
        end

        local function findNearestTarget()
            local nearestScreenDistance = math.huge
            local nearestTarget = nil
            local maxWorldDistance = MaxAimDistanceSlider.Value
            local fovRadius = FOVRadiusSlider.Value
            local mouseLocation = UserInputService:GetMouseLocation()
            local aimPartName = AimPartDropdown.Value

            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and not isWhitelisted(otherPlayer.Name) then
                    local character = otherPlayer.Character
                    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild(aimPartName) then
                        local humanoid = character.Humanoid
                        local aimPart = character:FindFirstChild(aimPartName)
                        if humanoid.Health > 0 and aimPart then
                            local aimPartPosition = aimPart.Position
                            local screenPoint, onScreen = camera:WorldToScreenPoint(aimPartPosition)

                            if onScreen then
                                local worldDistance = (aimPartPosition - player.Character.Head.Position).Magnitude
                                if worldDistance <= maxWorldDistance then
                                    local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude

                                    if screenDistance <= fovRadius then
                                        if screenDistance < nearestScreenDistance then
                                            nearestScreenDistance = screenDistance
                                            nearestTarget = aimPart
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return nearestTarget
        end


        local fovCircle = nil

        local function createFOVCircle()
            if Drawing and Drawing.new then
                fovCircle = Drawing.new("Circle")
                fovCircle.Visible = false
                fovCircle.Color = Color3.new(1, 1, 1)
                fovCircle.Thickness = 2
                fovCircle.Transparency = 0.5
            end
        end

		local function updateFOVCircle() if fovCircle and fovCircle.Visible then fovCircle.Position, fovCircle.Radius = UserInputService:GetMouseLocation(), FOVRadiusSlider.Value end end

		local function destroyFOVCircle() if fovCircle then fovCircle:Remove() fovCircle = nil end end


        local inputBeganConnection
        local inputEndedConnection
        local renderSteppedConnection

        inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.MouseButton2 and not gameProcessedEvent then
                isRightMouseButtonDown = true

                if fovCircle then
                    fovCircle.Visible = true
                else
                    createFOVCircle()
                     if fovCircle then fovCircle.Visible = true end
                end


            end
        end)

        inputEndedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                isRightMouseButtonDown = false
                lockOn = false
                target = nil
                if fovCircle then
                    fovCircle.Visible = false
                end
            end
        end)

        renderSteppedConnection = RunService.RenderStepped:Connect(function()
            if isRightMouseButtonDown then
                 updateFOVCircle()
            end


            if isRightMouseButtonDown and not lockOn then
                local newTarget = findNearestTarget()
                if newTarget then
                    lockOn = true
                    target = newTarget
                end
            end


            if lockOn and target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent.Humanoid.Health > 0 then
                local distanceToTarget = (target.Position - player.Character.Head.Position).Magnitude
                local fovRadius = FOVRadiusSlider.Value
                local mouseLocation = UserInputService:GetMouseLocation()
                local screenPoint, onScreen = camera:WorldToScreenPoint(target.Position)

                local isWithinFOV = false
                if onScreen then
                     local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                     if screenDistance <= fovRadius then
                         isWithinFOV = true
                     end
                end

                if distanceToTarget <= MaxAimDistanceSlider.Value and isWithinFOV then
                     local targetPosition = target.Position
                     camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
                else
                    lockOn = false
                    target = nil
                end
            else
                 if lockOn then
                    lockOn = false
                    target = nil
                 end
            end


        end)

        local cleanup = function()
            if inputBeganConnection then inputBeganConnection:Disconnect() end
            if inputEndedConnection then inputEndedConnection:Disconnect() end
            if renderSteppedConnection then renderSteppedConnection:Disconnect() end
            destroyFOVCircle()
            lockOn = false
            target = nil
            isRightMouseButtonDown = false
        end

        createFOVCircle()

        return cleanup
    end
end

local aimLockCleanup = nil

AimLockToggle:OnChanged(function()
    _G.AimLock = AimLockToggle.Value
    if _G.AimLock then
        aimLockCleanup = AimLock()
    elseif aimLockCleanup then
        aimLockCleanup()
        aimLockCleanup = nil
    end
end)

AimLockToggle:SetValue(false)

local DroppedItemsGroup = Tabs.ViewMisc:AddRightGroupbox('Dropped Items')

local droppeditems = {
	items = {
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
		DroppedItemsGroup:AddLabel("", true),
	},
}

DroppedItemsGroup:AddButton('View Dropped Items', function()
	local DroppedTools = workspace:FindFirstChild("DroppedTools")
	if DroppedTools then
		local itemList = {}
		for _, tool in ipairs(DroppedTools:GetChildren()) do
			if tool:IsA("Tool") then
				table.insert(itemList, tool.Name)
			end
		end
		for i = 1, 10 do
			if itemList[i] then
				droppeditems.items[i]:SetText("Item " .. i .. ": " .. itemList[i])
			else
				droppeditems.items[i]:SetText("Item " .. i .. ": None")
			end
		end
		for i = 1, 10 do
			if DroppedTools:GetChildren()[i] then
				droppeditems.items[i]:SetText("Item " .. i .. ": " .. DroppedTools:GetChildren()[i].Name)
			else
				droppeditems.items[i]:SetText("Item " .. i .. ": None")
			end
		end
	else
		for i = 1, 10 do
			droppeditems.items[i]:SetText("Item " .. i .. ": No DroppedTools folder found.")
		end
	end
end)

--[[local BackpackGroup = Tabs.ViewMisc:AddLeftGroupbox('Player Backpacks')

local backpackItems = {
	items = {
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
		BackpackGroup:AddLabel("", true),
	},
} ]]

--[[BackpackGroup:AddDropdown('PlayerBackpackList', {
	Text = 'Select Player',
	Values = {},
	Default = '',
	Callback = function(value)
		local selectedPlayer = game:GetService("Players"):FindFirstChild(value)
		if selectedPlayer and selectedPlayer:FindFirstChild("Backpack") then
			local backpack = selectedPlayer.Backpack
			local itemList = {}
			for _, item in ipairs(backpack:GetChildren()) do
				table.insert(itemList, item.Name)
			end
			for i = 1, 10 do
				if itemList[i] then
					backpackItems.items[i]:SetText("Item " .. i .. ": " .. itemList[i])
				else
					backpackItems.items[i]:SetText("Item " .. i .. ": None")
				end
			end
		else
			for i = 1, 10 do
				backpackItems.items[i]:SetText("Item " .. i .. ": No Backpack found.")
			end
		end
	end,
})]]

--[[local function updatePlayerBackpackList()
	local players = game:GetService("Players"):GetPlayers()
	local playerNames = {}
	for _, player in ipairs(players) do
		table.insert(playerNames, player.Name)
	end
	Options.PlayerBackpackList:SetValues(playerNames)
end

updatePlayerBackpackList() ]]

--[[Buy:AddButton({ Text = 'Buy Mask', Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StoreMenus = ReplicatedStorage:WaitForChild("StoreMenus")
        local MaskArgs = {
            StoreMenus:WaitForChild("Ling Enterprises"):WaitForChild("Misc"):WaitForChild("Mask")
        }

        ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("StorePurchase"):InvokeServer(unpack(MaskArgs))

        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        local function waitForMask()
            local backpack = Player:WaitForChild("Backpack")
            local mask
            repeat
                mask = backpack:FindFirstChild("Mask")
                task.wait(0.1)
            until mask
            return mask
        end

        local mask = waitForMask()
        mask.Parent = Player.Character

        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToggleMask"):FireServer()
    end}) ]]

    --[[Buy:AddButton({ Text = 'Buy +25 Armor', Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StoreMenus = ReplicatedStorage:WaitForChild("StoreMenus")
        local ArmorArgs = {StoreMenus:WaitForChild("Ling Enterprises"):WaitForChild("Misc"):WaitForChild("+25 Armor")}
        ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("StorePurchase"):InvokeServer(unpack(ArmorArgs))
    end}) ]]


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerStats = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(player.Name):WaitForChild("Statistics")

local webhookEnabled = false
local webhookURL = ""

Webhook:AddToggle('Webhook', { Text = 'Webhook', Default = false, Callback = function(value) webhookEnabled = value end })

Webhook:AddInput('WebhookURL', { Text = 'Webhook URL', Default = '', PlaceholderText = 'Enter your webhook URL here', Callback = function(value) webhookURL = value end })

local interval = 300

local requestFunc = http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
if not requestFunc then
	Library:Notify("Error", "HTTP request function not available", 5)
	return
end

local function mapReputation(rep)
	if rep >= 1 and rep <= 3 then
		return "Rookie " .. rep
	elseif rep >= 4 and rep <= 6 then
		return "Pro " .. (rep - 3)
	elseif rep >= 7 and rep <= 9 then
		return "All-Star " .. (rep - 6)
	elseif rep >= 10 and rep <= 12 then
		return "Legend " .. (rep - 9)
	else
		return "Unranked"
	end
end

local function sendPlayerData()
	if not webhookEnabled or webhookURL == "" then
		Library:Notify("Error", "Webhook is disabled or URL is empty", 5)
		return
	end

	local cash = playerStats:FindFirstChild("Cash") and playerStats.Cash.Value or 0
	local rep = playerStats:FindFirstChild("ReputationLevel") and playerStats.ReputationLevel.Value or 0
	local repLabel = mapReputation(rep)

	local data = {
		["content"] = "",
		["embeds"] = {
			{
				["title"] = "Player Progress Data",
				["type"] = "rich",
				["color"] = tonumber(0xFFA500),
				["fields"] = {
					{
						["name"] = "Username",
						["value"] = player.Name,
						["inline"] = true
					},
					{
						["name"] = "Cash",
						["value"] = tostring(cash),
						["inline"] = true
					},
					{
						["name"] = "Reputation",
						["value"] = repLabel .. " (" .. tostring(rep) .. ")",
						["inline"] = true
					}
				}
			}
		}
	}

	local jsonData = HttpService:JSONEncode(data)
	local headers = {
		["content-type"] = "application/json"
	}
	local requestPayload = {
		Url = webhookURL,
		Body = jsonData,
		Method = "POST",
		Headers = headers
	}

	local success, response = pcall(function()
		return requestFunc(requestPayload)
	end)

	if success then
		Library:Notify("Success", "Player data sent to webhook", 5)
	else
		Library:Notify("Error", "Failed to send data to webhook", 5)
	end
end

task.spawn(function()
	while task.wait(interval) do
		sendPlayerData()
	end
end)

game:GetService("Players").PlayerAdded:Connect(updatePlayerBackpackList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerBackpackList)


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Z', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

else
    print("Invalid Key!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error";
        Text = "Wrong key! Please get the correct key.";
        Duration = 5;
    })
end
end)
 
getKeyButton.MouseButton1Click:Connect(function()
setclipboard("https://link-target.net/1251036/key")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Key";
    Text = "Paste link in you browser to get the key";
    Duration = 10;
})
end)
 
joinDiscordButton.MouseButton1Click:Connect(function()
setclipboard("SOON")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Discord";
    Text = "Discord link copied to clipboard";
    Duration = 3;
})
end)
