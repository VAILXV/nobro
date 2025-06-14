if game.PlaceId == 15800296330 then
    task.wait(1)
    local args = {
        "Play Conquer",
        {
            Team = {
                "Brandon Marshall",
                "Jeff Hayward"
            },
            Game = "The Plane",
            Slot = _G.Slot
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("MainFunction"):InvokeServer(unpack(args))
end

if game.PlaceId == 85959597177250 then
    while true do
        local args = {
            "Teleport"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("MainFunction"):InvokeServer(unpack(args))
        task.wait(1)
    end
end
