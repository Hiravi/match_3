local View = {}

function View:drawBoard(board)
    for i = 1, #board do
        io.write(i .. " | ")

        for j = 1, #board do
            local crystal = board[i][j]
            local color = crystal:getColor()
            io.write(color .. " ")
        end
        io.write("\n")
    end
    io.flush()
end

function View:showMessage(msg)
    print(msg)
end

return View