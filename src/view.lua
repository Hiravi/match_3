local View = {}

function View:drawBoard(board)

    io.write("\t")
    for j = 1, #board do
        io.write(j .. " ")
    end
    io.write("\n")
    io.write("- - - - - - - - - - - -\n")

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


return View