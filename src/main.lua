require("game")

local isRunning = true
local game = Game:new(10)

game:init()

while(isRunning) do
    game:dump()

    ::continue::

    local input = io.read()
    local values = {}

    for match in string.gmatch(input, "%S+") do
        table.insert(values, match)
    end

    local command = values[1]
    local from = { tonumber(values[2]), tonumber(values[3]) }
    local direction = values[4]
    local to = {}

    if command == "q" then
        isRunning = false
        print("Game finished!")
    elseif command == "m" then
        if from[1] > 10 or from[1] < 1 or from[2] > 10 or from[2] < 1  then
            print("Invalid coordinates!")
            goto continue
        else
            if direction == "l" then
                to = { from[1], from[2] - 1 }
            elseif direction == "r" then
                to = { from[1], from[2] + 1 }
            elseif direction == "u" then
                to = { from[1] - 1, from[2] }
            elseif direction == "d" then
                to = { from[1] + 1, from[2] }
            else
                print("Invalid direction. Try again.")
                goto continue
            end
        end
        local result = game:move(from, to)
        if result == "success" then
            local hasMoves = game:tick()
            if hasMoves == false then
                game:mix()
            end
        else
            goto continue
        end
    else
        print("Invalid command. Try again.")
        goto continue
    end
end