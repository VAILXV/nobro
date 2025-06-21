local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local OOB = Workspace:WaitForChild("Map"):WaitForChild("Court"):WaitForChild("OOB")
OOB:Destroy()

--autotime
local remote = game:GetService("ReplicatedStorage")["Game.Properties"].ClientEvent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local shotMeterValue = character:WaitForChild("Properties"):WaitForChild("ShotMeter")
local shotMeterValue = workspace[player.Name].Properties:WaitForChild("ShotMeter")
local Stats = game:GetService("Stats")

--// Variables
local lastFireTime = 0
local lastRecalculationTime = 0
local recalculationCooldown = 2

--// Define ping-to-value mapping
local pingPoints = {
    {ping = 30, value = 0.88},
    {ping = 50, value = 0.82},
    {ping = 70, value = 0.77},
    {ping = 90, value = 0.73},
    {ping = 110, value = 0.61},
    {ping = 130, value = 0.59},
    {ping = 150, value = 0.56},
}

--// Function to calculate NewValue based on ping
local function calculateNewValue(ping)
    -- Clamp ping within the points
    if ping <= pingPoints[1].ping then
        return pingPoints[1].value
    elseif ping >= pingPoints[#pingPoints].ping then
        return pingPoints[#pingPoints].value
    end

    -- Find the two points ping falls between
    for i = 1, #pingPoints - 1 do
        local lower = pingPoints[i]
        local upper = pingPoints[i+1]

        if ping >= lower.ping and ping <= upper.ping then
            -- Linear interpolation
            local alpha = (ping - lower.ping) / (upper.ping - lower.ping)
            return lower.value + alpha * (upper.value - lower.value)
        end
    end
end

--// Function to update _G.NewValue
local function updateNewValue()
    local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    print("Your Ping: " .. ping .. " ms")

    _G.NewValue = calculateNewValue(ping)

    print("Adjusted NewValue: ", _G.NewValue)
end

--// Function to fire when ShotMeter changes
local function onChanged()
    if shotMeterValue.Value ~= 2 then
        local currentTime = tick()

        if currentTime - lastRecalculationTime >= recalculationCooldown then
            updateNewValue()
            lastRecalculationTime = currentTime
        end

        while shotMeterValue.Value < _G.NewValue do
            shotMeterValue:GetPropertyChangedSignal("Value"):Wait()
        end

        if currentTime - lastFireTime >= 1 then
            local arguments = {
                [1] = "Shoot",
                [2] = false
            }
            remote:FireServer(unpack(arguments))
            lastFireTime = currentTime
        end
    end
end

--// Connect to changes
shotMeterValue:GetPropertyChangedSignal("Value"):Connect(onChanged)

--// Run once immediately
task.spawn(function()
    task.wait(25)
    onChanged()
end)



local function getCharacter()
    return Workspace:FindFirstChild(player.Name)
end

local function getHRP()
    local character = getCharacter()
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
end

local function hasBallWeld()
    local character = getCharacter()
    if character then
        return character:FindFirstChild("Ball.Weld") ~= nil
    end
    return false
end

local function horizontalDistance(pos1, pos2)
    return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
end

local function spamQuickChat()
    task.wait(2) 
    local args = {
        "QuickChat",
        {
            Option = 1,
            Category = "Team"
        }
    }
    ReplicatedStorage:WaitForChild("Game.Properties"):WaitForChild("ClientEvent"):FireServer(unpack(args))
end

local function moveToTarget(targetPosition, customStopDistance)
    local hrp = getHRP()
    if not hrp then
        return false
    end

    local stopDistance = customStopDistance or 0.9

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)

    while horizontalDistance(hrp.Position, targetPosition) > stopDistance do
        local direction = (targetPosition - hrp.Position).Unit
        local lookVector = Vector3.new(direction.X, 0, direction.Z)
        camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + lookVector)

        RunService.Heartbeat:Wait()

        if not hasBallWeld() then
            break
        end
    end

    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)

    return true
end

local hcpos = Vector3.new(26.7702923, 4.21903753, 0.00644974224)
local shooting = Vector3.new(34.6452217, 4.20903778, 46.6403084, 0.93481499, 4.01193212e-08, 0.355135083, 1.30557325e-08, 1, -1.47335527e-07, -0.355135083, 1.42368009e-07, 0.93481499)

local function startSequence()
    local reachedFirst = moveToTarget(hcpos)
    if reachedFirst then
        task.wait(2)
        local reachedSecond = moveToTarget(shooting)
        if reachedSecond then
            task.wait(0.3)
            local args = { "Shoot", true }
            ReplicatedStorage:WaitForChild("Game.Properties"):WaitForChild("ClientEvent"):FireServer(unpack(args))
        end
    end
end


task.spawn(function()
    while true do
        if not hasBallWeld() then
            spamQuickChat()
        end
        task.wait(0.1)
    end
end)


task.spawn(function()
    while true do
        if hasBallWeld() then
            startSequence()
        end
        task.wait(0.5)
    end
end)

local function watchLocalInbounding()
    local localProperties = workspace:WaitForChild(player.Name):WaitForChild("Properties")

    localProperties:GetAttributeChangedSignal("Inbounding"):Connect(function()
        if localProperties:GetAttribute("Inbounding") then
            task.spawn(function()
                task.wait(5.5)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
            end)
        end
    end)

    if localProperties:GetAttribute("Inbounding") then
        task.spawn(function()
            task.wait(5.5)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
        end)
    end
end

watchLocalInbounding()

local character = Workspace:WaitForChild(player.Name)
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local glideStrength = 75

RunService.RenderStepped:Connect(function(deltaTime)
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude > 0 then
        hrp.Velocity = moveDirection.Unit * glideStrength
    else
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
    end
end)

_G.Defense = false

local rimPos = Vector3.new(0, 4, -45)

local function getDefenderTargetPosition(ballPos)
    local dir = (ballPos - rimPos)
    local dist = dir.Magnitude
    if dist <= 1 then
        return rimPos
    else
        return ballPos - dir.Unit * 1
    end
end

local defenseConnection

local function startDefenseCamera()
    if defenseConnection then
        defenseConnection:Disconnect()
        defenseConnection = nil
    end

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)

    defenseConnection = RunService.RenderStepped:Connect(function()
        if _G.Defense then
            local Basketball = workspace:FindFirstChild("Basketball")
            if Basketball and Basketball.Parent == workspace then
                local camPos = camera.CFrame.Position
                local targetPos = getDefenderTargetPosition(Basketball.Position)
                camera.CFrame = CFrame.new(camPos, targetPos)
            end
        else
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
            if defenseConnection then
                defenseConnection:Disconnect()
                defenseConnection = nil
            end
        end
    end)
end

local function watchController()
    task.spawn(function()
        while true do
            local ball = workspace:FindFirstChild("Basketball")
            if ball then
                local props = ball:WaitForChild("Properties", 2)
                if props then
                    local function checkController()
                        local controller = props:GetAttribute("Controller")
                        if controller == "Daniel Willow" or controller == "Jonathan Millsap" or controller == "The Plane" then
                            if not _G.Defense then
                                _G.Defense = true
                                print("Defense activated! Controller: " .. controller)
                                startDefenseCamera()
                            end
                        elseif controller == "Brandon Marshall" or controller == "Fraco Paul" or controller == player.Name then
                            if _G.Defense then
                                _G.Defense = false
                                print("Defense deactivated! Controller: " .. controller)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
                                if defenseConnection then
                                    defenseConnection:Disconnect()
                                    defenseConnection = nil
                                end
                            end
                        end
                    end

                    checkController()
                    props:GetAttributeChangedSignal("Controller"):Connect(checkController)

                    while workspace:FindFirstChild("Basketball") == ball do
                        task.wait(0.5)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

watchController()
