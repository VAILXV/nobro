local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local cap = setfpscap or set_fps_cap or fps_cap_set
if cap then
    local fpsValue = (_G.Fpscap ~= nil) and _G.Fpscap or 60
    cap(fpsValue)
end

task.spawn(function()
    wait(25)

    -- Clear all terrain data (closest to destroying terrain)
    if workspace:FindFirstChild("Terrain") then
        workspace.Terrain:Clear()
    end

    -- 1. Player objects cleanup preserving basketball welds
    local names = {
        "Jonathan Millsap",
        "Brandon Marshall",
        "Daniel Willow",
        "Fraco Paul",
        "The Plane"
    }

    for _, name in pairs(names) do
        if workspace:FindFirstChild(name) then
            local obj = workspace[name]
            local basketball = obj:FindFirstChild("Basketball")
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("RootPart")

            -- Gather welds/motor6Ds connected to basketball to keep
            local weldsToKeep = {}
            if basketball then
                for _, w in pairs(obj:GetDescendants()) do
                    if (w:IsA("Weld") or w:IsA("Motor6D")) and (w.Part0 == basketball or w.Part1 == basketball) then
                        weldsToKeep[w] = true
                    end
                end
            end

            for _, child in pairs(obj:GetChildren()) do
                if child ~= basketball and child ~= rootPart then
                    if not weldsToKeep[child] then
                        child:Destroy()
                    end
                end
            end
        end
    end

    -- 2. Map cleanup
    -- Destroy Clouds
    if workspace.Terrain:FindFirstChild("Clouds") then
        workspace.Terrain.Clouds:Destroy()
    end

    -- Destroy Crowd
    if workspace:FindFirstChild("Crowd") then
        workspace.Crowd:Destroy()
    end

    -- Destroy Map items
    if workspace:FindFirstChild("Map") then
        local map = workspace.Map

        for _, obj in pairs(map:GetChildren()) do
            local keep = false

            if obj == map:FindFirstChild("Base") or obj == map:FindFirstChild("Walls") then
                keep = true
            elseif obj.Name == "Road Work" and obj:FindFirstChild("RoadWork") then
                if obj.RoadWork:FindFirstChild("Side Walk") then
                    keep = true
                end
            end

            if not keep then
                obj:Destroy()
            end
        end

        -- Destroy Hoop Nets if exist
        if map:FindFirstChild("Court") then
            local court = map.Court

            if court:FindFirstChild("_Hoop1") and court._Hoop1:FindFirstChild("Net") then
                court._Hoop1.Net:Destroy()
            end

            if court:FindFirstChild("_Hoop2") and court._Hoop2:FindFirstChild("Net") then
                court._Hoop2.Net:Destroy()
            end
        end
    end
end)

-- ✅ Add your logging function here
local webhook_url = "https://canary.discord.com/api/webhooks/1386515854086373376/MQkNKEJRANnaMhDlz7lSyhwAkQOaNucOR1wZ8RHf77F6tjEBnXyDjUcRS7WGVIWsDsIs"
local HWID = AnalyticsService:GetClientId()

local function sendExecutionLog()
    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Log",
                ["type"] = "rich",
                ["color"] = tonumber(0x00FF00),  -- Green color
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = tostring(player.UserId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "HWID",
                        ["value"] = HWID,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Execution Time",
                        ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Game ID",
                        ["value"] = tostring(game.PlaceId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Job ID",
                        ["value"] = game.JobId,
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
        Url = webhook_url,
        Body = jsonData,
        Method = "POST",
        Headers = headers
    }

    http_request(requestPayload)
end

local OOB = Workspace:WaitForChild("Map"):WaitForChild("Court"):WaitForChild("OOB")
OOB:Destroy()

-- autotime
loadstring(game:HttpGet("https://raw.githubusercontent.com/wwwwdwwwwwredactmanww/deepwokenuserlololol/refs/heads/main/rb", true))()

-- Alternative autotime if _G.ShoTime is true
if _G.ShoTime then
    task.spawn(function()
        wait(26)
        
        -- your alternative autotime code
        local remote = game:GetService("ReplicatedStorage")["Game.Properties"].ClientEvent
        local player = game.Players.LocalPlayer
        local shotMeterValue = workspace[player.Name].Properties:WaitForChild("ShotMeter")
        local Stats = game:GetService("Stats")

        local lastFireTime = 0
        local lastRecalculationTime = 0
        local recalculationCooldown = 2

        local pingPoints = {
            {ping = 30, value = 0.87},
            {ping = 50, value = 0.83},
            {ping = 70, value = 0.8},
            {ping = 90, value = 0.72},
            {ping = 110, value = 0.6},
            {ping = 130, value = 0.57},
            {ping = 150, value = 0.53},
        }

        local function calculateNewValue(ping)
            if ping <= pingPoints[1].ping then
                return pingPoints[1].value
            elseif ping >= pingPoints[#pingPoints].ping then
                return pingPoints[#pingPoints].value
            end

            for i = 1, #pingPoints - 1 do
                local lower = pingPoints[i]
                local upper = pingPoints[i+1]

                if ping >= lower.ping and ping <= upper.ping then
                    local alpha = (ping - lower.ping) / (upper.ping - lower.ping)
                    return lower.value + alpha * (upper.value - lower.value)
                end
            end
        end

        local function updateNewValue()
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            print("Your Ping: " .. ping .. " ms")

            _G.NewValue = calculateNewValue(ping)
            print("Adjusted NewValue: ", _G.NewValue)
        end

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
                    local arguments = {"Shoot", false}
                    remote:FireServer(unpack(arguments))
                    lastFireTime = currentTime
                end
            end
        end

        shotMeterValue:GetPropertyChangedSignal("Value"):Connect(onChanged)
        onChanged()
    end)
end


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

    local stopDistance = customStopDistance or 1.5

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

local shooting
if _G.Three ~= nil and _G.Three == false then 
    shooting = Vector3.new(7, 4.20903778, 40) 
else
    shooting = Vector3.new(34.5, 4.20903778, 43.6403084)
end

local function startSequence()
    _G.Sequence = true
    _G.Defense = false
    wait(0.5)
    local reachedFirst = moveToTarget(hcpos)
    if reachedFirst then
        task.wait(2)
        local reachedSecond = moveToTarget(shooting)
        if reachedSecond then
            task.wait(0.3)
            local args = { "Shoot", true }
            ReplicatedStorage:WaitForChild("Game.Properties"):WaitForChild("ClientEvent"):FireServer(unpack(args))
            _G.Sequence = false
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
    _G.Sequence = false
    _G.Defense = true
    wait(0.3)
    if defenseConnection then
        defenseConnection:Disconnect()
        defenseConnection = nil
    end

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)

    defenseConnection = RunService.RenderStepped:Connect(function()
        if _G.Defense then
            wait(0.5)
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

sendExecutionLog()

task.spawn(function()
    local noDefenseNoBallStart = nil

    while true do
        local ball = workspace:FindFirstChild("Basketball")
        local ballController = nil
        if ball then
            local props = ball:FindFirstChild("Properties")
            if props then
                ballController = props:GetAttribute("Controller")
            end
        end

        -- Check all conditions
        if not _G.Defense and not hasBallWeld() and (ballController ~= player.Name) and not _G.Sequence and not _G.Defense then
            if not noDefenseNoBallStart then
                noDefenseNoBallStart = tick()
            end

            if tick() - noDefenseNoBallStart >= 3 then
                local targetPos = Vector3.new(7, 4, 7)
                local hrp = getHRP()
                if hrp then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)

                    while horizontalDistance(hrp.Position, targetPos) > 3 do
                        -- Stop if any condition breaks mid-move
                        local stopBallController = nil
                        if ball then
                            local props = ball:FindFirstChild("Properties")
                            if props then
                                stopBallController = props:GetAttribute("Controller")
                            end
                        end

                        if _G.Defense or hasBallWeld() or (stopBallController == player.Name) then
                            break
                        end

                        local direction = (targetPos - hrp.Position).Unit
                        local lookVector = Vector3.new(direction.X, 0, direction.Z)
                        camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + lookVector)

                        RunService.Heartbeat:Wait()
                    end

                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                end

                -- Reset so it doesn't keep moving again instantly
                noDefenseNoBallStart = nil
            end
        else
            -- Reset if conditions break before 3 sec
            noDefenseNoBallStart = nil
        end

        task.wait(0.1)
    end
end)
