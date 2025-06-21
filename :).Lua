if game.PlaceId == 15800296330 then
    local args = {
        "Get Players"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("MainFunction"):InvokeServer(unpack(args))
    task.wait(2)
    local HttpService = game:GetService("HttpService")
    local AnalyticsService = game:GetService("RbxAnalyticsService")

    local player = game:GetService("Players").LocalPlayer
    local gui = player:WaitForChild("PlayerGui")

    local slotPath = player.PlayerGui.MenuUI.MyPlayers.Canvas.List["Player"..TrackSlot].Slot
    local progressText = slotPath.Progress.Label.Text
    local levelText = slotPath.Level.Text

    local xp, maxXp = string.match(progressText, "(%d+)%s*/%s*(%d+)")
    xp = tonumber(xp)
    maxXp = tonumber(maxXp)

    local function sendExecutionLog()
        local data = {
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "Script Execution Log",
                    ["type"] = "rich",
                    ["color"] = tonumber(0x00FF00),
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
                            ["name"] = "Level",
                            ["value"] = levelText,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "XP",
                            ["value"] = xp and (xp .. "/" .. maxXp) or "Failed to parse XP",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Tracked Slot",
                            ["value"] = tostring(TrackSlot),
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

    sendExecutionLog()

    task.wait(1)
    local args = {
        "Play Conquer",
        {
            Team = {
                "Brandon Marshall",
                "Fraco Paul"
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
