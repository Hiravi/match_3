-- View module
local View = {}

function View:getInput()
    io.write("> ")
    local line = io.read()
    local cmd, x, y, d = string.match(line, "(%a) (%d) (%d) (%a)")
    return cmd, tonumber(x)+1, tonumber(y)+1, d
end

function View:showField(field)
    for i = 0, 9 do
        io.write(i .. " | ")
        for j = 1, 10 do
            io.write(field[i][j] .. " ")
        end
        io.write("\n")
    end
end