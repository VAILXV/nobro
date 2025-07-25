--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

--// Load remote HWID table
local HWIDTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bentlyburgerd/hwid/refs/heads/main/hwidlist"))()

--// Get this player's HWID
local HWID = RbxAnalyticsService:GetClientId()

--// Check if HWID is in whitelist
local whitelisted = false
for _, v in pairs(HWIDTable) do
	if v == HWID then
		whitelisted = true
		break
	end
end

if whitelisted then
	print("✅ HWID is Whitelisted:", HWID)

	-- 🔽 Your script starts here
	-- Example:
	print("Running rest of script...")

	-- Add your actual code here

else
	warn("❌ HWID is NOT Whitelisted. Teleporting. HWID:", HWID)
	TeleportService:Teleport(15800296330, LocalPlayer)
	return -- ⛔ Stop the rest of the script
end

_G.GaurdDis = 7 
_G.SprintDis = 10
_G.AutoBlock = false
_G.Xoffball = 5
_G.Yoffball = 3
_G.BlockDelay = 0.75
_G.WideOpenDist = 10

local ReplicatedStorage = game:GetService("ReplicatedStorage")
wait(5)

local GameData = ReplicatedStorage:WaitForChild("GameData")

-- Wait until InGame becomes true
while not GameData:GetAttribute("InGame") do
    task.wait(0.1)
end

-- Wait 1 more second after InGame is true
task.wait(1)

print("Running comp jon...")


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local username = localPlayer.Name

local GameData = ReplicatedStorage:WaitForChild("GameData")
local Teams = GameData:WaitForChild("Teams")
local Team1 = Teams:WaitForChild("Team1")
local Team2 = Teams:WaitForChild("Team2")

local positions = {"C", "SG", "PG"}

-- Shared state
local localTeam = nil -- "Team1" or "Team2"
local localMatchup = nil
local defense = false
local rebounding = false

-- To track previous defense state and prevent spamming prints
local prevDefenseState = nil

-- Rims for each team
local rimPositions = {
	Team1 = Vector3.new(0, 4, -45),
	Team2 = Vector3.new(0, 4, 45),
}

-- Find your team and your matchup
local function findMatchup()
	for _, pos in ipairs(positions) do
		local team1Value = Team1:FindFirstChild(pos)
		local team2Value = Team2:FindFirstChild(pos)

		local val1 = team1Value and tostring(team1Value.Value)
		local val2 = team2Value and tostring(team2Value.Value)

		if val1 == username then
			localTeam = "Team1"
			localMatchup = val2
			print("[Init] You are on Team1 | Matchup:", localMatchup)
			return
		elseif val2 == username then
			localTeam = "Team2"
			localMatchup = val1
			print("[Init] You are on Team2 | Matchup:", localMatchup)
			return
		end
	end

	warn("[Init] You are not assigned to any of the checked positions!")
end

-- Get all team players
local function getTeamPlayers()
	return {
		team1C = tostring(Team1:FindFirstChild("C") and Team1.C.Value or ""),
		team1SG = tostring(Team1:FindFirstChild("SG") and Team1.SG.Value or ""),
		team1PG = tostring(Team1:FindFirstChild("PG") and Team1.PG.Value or ""),
		team2C = tostring(Team2:FindFirstChild("C") and Team2.C.Value or ""),
		team2SG = tostring(Team2:FindFirstChild("SG") and Team2.SG.Value or ""),
		team2PG = tostring(Team2:FindFirstChild("PG") and Team2.PG.Value or ""),
	}
end

-- Check controller status
local function watchController()
	task.spawn(function()
		while true do
			local ball = Workspace:FindFirstChild("Basketball")
			if not ball then
				task.wait(0.5)
				continue
			end

			local props = ball:WaitForChild("Properties", 2)
			if not props then
				task.wait(0.5)
				continue
			end

			local function checkController()
				local controller = props:GetAttribute("Controller")
				local teamPlayers = getTeamPlayers()

				if not controller then return end

				local function isValid(name)
					for _, n in pairs(teamPlayers) do
						if name == n then return true end
					end
					return false
				end

				local function isTeammate(name)
					if localTeam == "Team1" then
						return name == teamPlayers.team1C or name == teamPlayers.team1SG or name == teamPlayers.team1PG
					elseif localTeam == "Team2" then
						return name == teamPlayers.team2C or name == teamPlayers.team2SG or name == teamPlayers.team2PG
					end
					return false
				end

				if isValid(controller) then
					if isTeammate(controller) then
						defense = false
					else
						defense = true
					end
				end
			end

			checkController()

			local connection = props:GetAttributeChangedSignal("Controller"):Connect(checkController)

			while Workspace:FindFirstChild("Basketball") == ball do
				task.wait(0.5)
			end

			if connection then connection:Disconnect() end
		end
	end)
end

local function FindMostOpenPoint()
    local pointsTeam1 = {
        Vector3.new(-35, 4, 47),
        Vector3.new(35, 4, 47),
    }
    local pointsTeam2 = {
        Vector3.new(-35, 4, -47),
        Vector3.new(35, 4, -47),
    }

    local points = (localTeam == "Team1") and pointsTeam1 or pointsTeam2
    if not points then return nil end

    local localChar = Workspace:FindFirstChild(username)
    if not localChar then return nil end
    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end

    -- Find point with max distance from all other players (open point)
    local bestPoint = nil
    local maxMinDist = -math.huge

    for _, point in ipairs(points) do
        -- Find min distance from this point to all humanoids (including opponents and teammates)
        local minDistToOthers = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            local char = Workspace:FindFirstChild(player.Name)
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and player.Name ~= username then
                    local dist = (hrp.Position - point).Magnitude
                    if dist < minDistToOthers then
                        minDistToOthers = dist
                    end
                end
            end
        end

        if minDistToOthers > maxMinDist then
            maxMinDist = minDistToOthers
            bestPoint = point
        end
    end

    return bestPoint
end
-- === Utility Functions from earlier ===
local function PassToClosest()
	local teamFolder = (localTeam == "Team1") and Team1 or Team2
	local localChar = Workspace:FindFirstChild(username)
	if not localChar then return end

	local localHRP = localChar:FindFirstChild("HumanoidRootPart")
	if not localHRP then return end

	local closestName = nil
	local closestDist = math.huge

	for _, pos in ipairs(positions) do
		local val = teamFolder:FindFirstChild(pos)
		if val then
			local name = tostring(val.Value)
			if name ~= "" and name ~= username then
				local char = Workspace:FindFirstChild(name)
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local dist = (localHRP.Position - hrp.Position).Magnitude
					if dist < closestDist then
						closestDist = dist
						closestName = name
					end
				end
			end
		end
	end

	if closestName then
		local args = {
		    "Icon Pass",
		    workspace:WaitForChild(closestName)
	    }
	game:GetService("ReplicatedStorage"):WaitForChild("Game.Properties"):WaitForChild("ClientEvent"):FireServer(unpack(args))
	end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local ClientEvent = ReplicatedStorage:WaitForChild("Game.Properties"):WaitForChild("ClientEvent")

local lastShooting = false
local currentGaurdDis = _G.GaurdDis or 7
local lastGuarding = false

-- Ensure globals are set
_G.GaurdDis = _G.GaurdDis or 7
_G.SprintDis = _G.SprintDis or 12
_G.AutoBlock = _G.AutoBlock or false
_G.Xoffball = _G.Xoffball or 5
_G.Yoffball = _G.Yoffball or 3
_G.BlockDelay = _G.BlockDelay or 0.75
_G.WideOpenDist = _G.WideOpenDist or 10
-- Variables for turn detection
local lastLookVector = nil
local turnCooldown = false
local guardDistanceTimer = 0
local turnDelayTimer = 0
local lastController = nil

-- Returns a randomized guard distance between GaurdDis-1 and GaurdDis+1
local function recalcGuardDistance()
	return _G.GaurdDis + (math.random() * 2 - 1) -- random float between -1 and +1
end

-- Detect if opponent made a mostly opposite turn based on dot product
local function isSignificantTurn(lastVec, currentVec)
	if not lastVec or not currentVec then return false end
	local dot = lastVec:Dot(currentVec)
	return dot < -0.5 -- threshold; adjust sensitivity here if needed
end

local cachedOpenPoint = nil
local timeSinceLastCalc = 0
local recalcInterval = 5 -- seconds

task.spawn(function()
	while true do
	    local dt = RunService.Heartbeat:Wait()
	    timeSinceLastCalc = timeSinceLastCalc + dt

	    if not defense and localTeam then
        	local localChar = Workspace:FindFirstChild(username)
        	local ball = Workspace:FindFirstChild("Basketball")
        	local props = ball and ball:FindFirstChild("Properties")
        	local controller = props and props:GetAttribute("Controller")
        	local humanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
        	local hrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
        
        	if localChar and humanoid and hrp and controller then
                -- Only recalc every 5 seconds or if no cached point yet
                if timeSinceLastCalc >= recalcInterval or not cachedOpenPoint then
                    cachedOpenPoint = FindMostOpenPoint()
                    timeSinceLastCalc = 0
                end
            
                if controller == username then
                    if not alreadyPassed then
                        alreadyPassed = true
                        task.delay(1, function()
                            PassToClosest()
                        end)
                    end
            
                    if cachedOpenPoint then
                        humanoid.WalkToPoint = cachedOpenPoint
                        local distToPoint = (hrp.Position - cachedOpenPoint).Magnitude
            
                        if distToPoint < 2 then
                            -- Check if opponents are nearby
                            local teamPlayers = getTeamPlayers()
                            local opponents = {}
            
                            if localTeam == "Team1" then
                                opponents = {
                                    teamPlayers.team2C,
                                    teamPlayers.team2SG,
                                    teamPlayers.team2PG,
                                }
                            elseif localTeam == "Team2" then
                                opponents = {
                                    teamPlayers.team1C,
                                    teamPlayers.team1SG,
                                    teamPlayers.team1PG,
                                }
                            end
            
                            local opponentNearby = false
            
                            for _, opponentName in ipairs(opponents) do
                                if opponentName ~= "" then
                                    local opponentChar = Workspace:FindFirstChild(opponentName)
                                    local opponentHRP = opponentChar and opponentChar:FindFirstChild("HumanoidRootPart")
                                    if opponentHRP then
                                        local dist = (opponentHRP.Position - hrp.Position).Magnitude
                                        if dist <= _G.WideOpenDist then
                                            opponentNearby = true
                                            break
                                        end
                                    end
                                end
                            end
            
                            if not opponentNearby then
                                local args = { 
                                    "Shoot", 
                                    true
                                }
                                
                                ReplicatedStorage:WaitForChild("Game.Properties"):WaitForChild("ClientEvent"):FireServer(unpack(args))
                            end
                        end
                    end
                else
                    alreadyPassed = false
                    if cachedOpenPoint then
                        humanoid.WalkToPoint = cachedOpenPoint
                    end
                end
            end
	    end

		local dt = RunService.Heartbeat:Wait()

		if defense and localMatchup and not rebounding then
			local localChar = Workspace:FindFirstChild(localPlayer.Name)
			local opponentChar = Workspace:FindFirstChild(localMatchup)
			local opponentProps = opponentChar and opponentChar:FindFirstChild("Properties")

			local ball = Workspace:FindFirstChild("Basketball")
			local props = ball and ball:FindFirstChild("Properties")
			local controller = props and props:GetAttribute("Controller")

			if localChar and opponentChar and opponentProps and controller then
				local humanoid = localChar:FindFirstChildOfClass("Humanoid")
				local opponentHRP = opponentChar:FindFirstChild("HumanoidRootPart")
				local localHRP = localChar:FindFirstChild("HumanoidRootPart")
				local rimPos = rimPositions[localTeam]

				if controller ~= lastController then
					print("[Info] Controller changed:", controller)
					if controller == localMatchup then
						print("[Info] The controller is your matchup:", controller)
					end
					lastController = controller
				end

				if humanoid and opponentHRP and localHRP and rimPos then
					local isShooting = opponentProps:GetAttribute("Shooting")

					if isShooting and not lastShooting then
						currentGaurdDis = 1
						ClientEvent:FireServer("Sprint", true)

						if _G.AutoBlock then 
							task.delay(_G.BlockDelay, function()
								ClientEvent:FireServer("Jump")
							end)
						end
						lastShooting = true

					elseif not isShooting and lastShooting then
						currentGaurdDis = _G.GaurdDis
						ClientEvent:FireServer("Sprint", false)
						lastShooting = false
					end

					-- Re-randomize guard distance every second
					guardDistanceTimer += dt
					if guardDistanceTimer >= 1 then
						currentGaurdDis = _G.GaurdDis + (math.random() * 2 - 1)
						guardDistanceTimer = 0
					end

					-- Re-randomize delay every second
					turnDelayTimer += dt
					if turnDelayTimer >= 1 then
						turnReactionDelay = math.random(0, 300) / 1000
						turnDelayTimer = 0
					end

					-- Turn detection
					local currentLookVector = (opponentHRP.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
					if lastLookVector and isSignificantTurn(lastLookVector, currentLookVector) and not turnCooldown then
						turnCooldown = true
						task.delay(turnReactionDelay, function()
							turnCooldown = false
						end)
					end
					lastLookVector = currentLookVector

					-- Rim-relative movement logic
					local toRim = (rimPos - opponentHRP.Position).Unit
					local targetOffset = toRim * currentGaurdDis
					local desiredTarget = opponentHRP.Position + targetOffset

					local moveOffset = desiredTarget - localHRP.Position

					local rimForward = (rimPos - opponentHRP.Position).Unit
					local rimRight = rimForward:Cross(Vector3.new(0, 1, 0)).Unit

					local forwardDist = moveOffset:Dot(rimForward)
					local rightDist = moveOffset:Dot(rimRight)

					if controller ~= localMatchup then
						if math.abs(rightDist) <= _G.Xoffball then rightDist = 0 end
						if math.abs(forwardDist) <= _G.Yoffball then forwardDist = 0 end
					end

					local newTargetPos = localHRP.Position + rimForward * forwardDist + rimRight * rightDist
					humanoid.WalkToPoint = newTargetPos

					-- Sprinting logic
					local distToTarget = (localHRP.Position - newTargetPos).Magnitude
					local rimGap = (localHRP.Position - rimPos).Magnitude
					local oppGap = (opponentHRP.Position - rimPos).Magnitude
					local rimAdvantage = oppGap - rimGap

					if distToTarget >= _G.SprintDis or rimAdvantage <= 1 then
						ClientEvent:FireServer("Sprint", true)

						if lastGuarding then
							ClientEvent:FireServer("Guard", false)
							lastGuarding = false
						end
					else
						ClientEvent:FireServer("Sprint", false)

						if controller == localMatchup and not lastGuarding then
							ClientEvent:FireServer("Guard", true)
							lastGuarding = true
						elseif controller ~= localMatchup and lastGuarding then
							ClientEvent:FireServer("Guard", false)
							lastGuarding = false
						end
					end
				end
			end
		end
	end
end)


findMatchup()
watchController()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Bentlyburgerd/auto/refs/heads/main/auto"))()
