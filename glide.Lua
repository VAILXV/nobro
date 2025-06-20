local Helper = loadstring(httpget("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/refs/heads/main/Internal%20Helper.lua", "text/plain"))()

local Settings = {
    Speed = 13
}

local Threshold = 1
local Adjustments = {
    {Ping = 100, Value = 0.6515},
    {Ping = 90, Value = 0.6653},
    {Ping = 80, Value = 0.6960}, 
    {Ping = 70, Value = 0.7240},
    {Ping = 60, Value = 0.7430},
    {Ping = 50, Value = 0.8075},
    {Ping = 40, Value = 0.8365},
    {Ping = 25, Value = 0.86226}
}

table.sort(Adjustments, function(A, B) return A.Ping > B.Ping end)

local Name
local Character
local Properties
local ShotMeter
local HumanoidRootPart
local Humanoid
local Enabled = true

thread.create("Rescan", function()
    while true do
        local Player = getlocalplayer()
        if Player then
            Name = getname(Player)
        else
            Name = nil
            Character = nil
            Properties = nil
            ShotMeter = nil
            HumanoidRootPart = nil
            Humanoid = nil
            wait(1)
            continue
        end
        
        if not Character and Name then
            Character = findfirstchild(Workspace, Name)
            if not Character then
                wait(1)
                continue
            end
        end
        
        if Character and (not Properties or not HumanoidRootPart or not Humanoid) then
            if not Properties then
                Properties = findfirstchild(Character, "Properties")
            end
            if not HumanoidRootPart then
                HumanoidRootPart = findfirstchild(Character, "HumanoidRootPart")
            end
            if not Humanoid then
                Humanoid = findfirstchild(Character, "Humanoid")
            end
            
            if not Properties or not HumanoidRootPart or not Humanoid then
                wait(1)
                continue
            end
        end
        
        if Properties and not ShotMeter then
            ShotMeter = findfirstchild(Properties, "ShotMeter")
            if not ShotMeter then
                wait(1)
                continue
            end
        end
        
        if not (Name and Character and Properties and ShotMeter and HumanoidRootPart and Humanoid) then
            if not findfirstchild(Workspace, Name) then
                Character = nil
                Properties = nil
                ShotMeter = nil
                HumanoidRootPart = nil
                Humanoid = nil
            end
        end
        
        wait(0.5)
    end
end)

thread.create("Ping", function()
    while true do
        local Ping = getping()
        if Ping then
            for i = 1, #Adjustments do
                if Ping > Adjustments[i].Ping then
                    Threshold = Adjustments[i].Value
                    break
                end
            end
        end
        wait()
    end
end)

thread.create("Autotime", function()
    while true do
        if ShotMeter then
            local ShotValue = getvalue(ShotMeter)
            if ShotValue and ShotValue ~= 2 and ShotValue >= Threshold then
                keyrelease(0x45)
            end
        end
        wait()
    end
end)

thread.create("Walkspeed", function()
    while true do
        local Disable = false
        if Character then
            local Ball = findfirstchild(Character, "Ball.Weld")
            for _, Key in ipairs(getpressedkeys()) do
                if (Ball and Key == "G") or (not Ball and Key == "T") then
                    Disable = true
                    break
                end
            end
        end
        
        if not Disable and HumanoidRootPart and Humanoid then
            local MoveDirection = Helper.getmovedirection(Humanoid)
            if MoveDirection.x ~= 0 or MoveDirection.z ~= 0 then
                local Magnitude = math.sqrt(MoveDirection.x^2 + MoveDirection.z^2)
                local VelocityX = (MoveDirection.x / Magnitude) * Settings.Speed
                local VelocityZ = (MoveDirection.z / Magnitude) * Settings.Speed
                setvelocity(HumanoidRootPart, {VelocityX, nil, VelocityZ})
            end
        end
        wait()
    end
end)
