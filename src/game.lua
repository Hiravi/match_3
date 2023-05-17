require("crystal")
local view = require("view")

Game = {}
MetaGame = {}
MetaGame.__index = Game

function Game:new(boardSize)
    local instance = setmetatable({}, MetaGame)
    instance.boardSize = boardSize
    instance.board = {}
    instance.colors = {'A', 'B', 'C', 'D', 'E', 'F'}
    return instance
end

local function shiftAndFillBoard(board, boardSize, colors)
    -- Shift crystals down
    local newBoard = board
    for j = 1, boardSize do
        local emptySpaces = 0
        for i = boardSize, 1, -1 do
            if newBoard[i][j].color == "" then
                emptySpaces = emptySpaces + 1
            elseif emptySpaces > 0 then
                newBoard[i + emptySpaces][j] = newBoard[i][j]
                newBoard[i][j] = Crystal:new("", newBoard[i][j].type, true)
            end
        end
    end

    -- Fill empty spaces with new crystals
    for j = 1, boardSize do
        for i = 1, boardSize do

            if newBoard[i][j].color == "" then
                local index = math.random(1, 6)
                local color = colors[index]
                newBoard[i][j] = Crystal:new(color, "common", true)
            end
        end
    end
    return newBoard
end

local function applyChanges(board, combinations, boardSize, colors)
    local changedBoard = board

    if #combinations > 3 then
        for i = 1, #combinations do
            local row = combinations[i][1]
            local col = combinations[i][2]
            changedBoard[row][col] = Crystal:new("", board[row][col].type, true)
        end
    end

    changedBoard = shiftAndFillBoard(changedBoard, boardSize, colors)

    return changedBoard
end

local function checkPossibilities(board)
    local rows = #board
    local cols = #board[1]

    for row = 1, rows do
        for col = 1, cols do
            local currentCrystal = board[row][col]

            if col < cols - 1 and board[row][col+1] == currentCrystal and board[row][col+2] == currentCrystal then
                return true
            end

            if row < rows - 1 and board[row+1][col] == currentCrystal and board[row+2][col] == currentCrystal then
                return true
            end
        end
    end

    return false
end

function Game:init()

    for i = 1, self.boardSize do
        self.board[i] = {}

        for j = 1, self.boardSize do
            local index = math.random(1, 6)
            local color = self.colors[index]

            if j > 2 then
                if i <= 2 then
                    if self.board[i][j - 1].color == color
                            and self.board[i][j - 1].color == self.board[i][j - 2].color
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)
                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                else
                    if (self.board[i][j - 1].color == color
                            and self.board[i][j - 1].color == self.board[i][j - 2].color)
                        or (self.board[i - 1][j].color ==  color
                            and self.board[i - 1][j].color == self.board[i - 2][j].color)
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)

                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                end
            elseif j <= 2 then
                if i > 2 then
                    if self.board[i - 1][j].color == color
                            and self.board[i - 1][j].color == self.board[i - 2][j].color
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)

                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                else
                    self.board[i][j] = Crystal:new(color, "common", false)
                end
            else
                self.board[i][j] = Crystal:new(color, "common", false)
            end
        end
    end
end

function Game:tick()
    local combinations = {}

    for i = 1, self.boardSize do
        for j = 1, self.boardSize do
            combinations = {}

            if self.board[i][j].isMoved == true then
                
                table.insert(combinations, {i, j})
                local currentColor = self.board[i][j].color
                local currentCombination = {{i, j}}

                for k = i + 1, self.boardSize do
                    if self.board[k][j].color == currentColor then
                        table.insert(currentCombination, {k, j})
                    else
                        break
                    end
                end

                for k = (i - 1), 1, -1 do
                    if self.board[k][j].color == currentColor then

                        table.insert(currentCombination, {k, j})

                        if k == self.boardSize and #currentCombination > 3 then
                            for _, value in ipairs(currentCombination) do
                                table.insert(combinations, value)
                            end
                        else
                            currentCombination = {{i, j}}
                        end
                    else
                        if #currentCombination > 3 then
                            for _, value in ipairs(currentCombination) do
                                table.insert(combinations, value)
                            end
                        else
                            currentCombination = {{i, j}}
                        end
                    end
                end

                for k = (j - 1), 1, -1 do
                    if self.board[i][k].color == currentColor then
                        table.insert(currentCombination, {i, k})
                    else
                        break
                    end
                end

                for k = (j + 1), self.boardSize do
                    if self.board[i][k].color == currentColor then

                        table.insert(currentCombination, {i, k})

                        if k == self.boardSize and #currentCombination > 3 then
                            for _, value in ipairs(currentCombination) do
                                table.insert(combinations, value)
                            end
                        else
                            currentCombination = {{i, j}}
                        end
                    else
                        if #currentCombination > 3 then
                            for _, value in ipairs(currentCombination) do
                                table.insert(combinations, value)
                            end
                        else
                            currentCombination = {{i, j}}
                        end
                    end
                end
                self.board = applyChanges(self.board, combinations, self.boardSize, self.colors)
            end
        end
    end

    return checkPossibilities(self.board)
end

function Game:move(from, to)
    if to[1] > #self.board or to[1] < 1 or to[2] > #self.board or to[2] < 1 then
        view:showMessage("Out of borders!")
        return "failed"
    else
        local x1, y1 = from[1], from[2]
        local x2, y2 = to[1], to[2]
        self.board[x1][y1] = Crystal:new(self.board[x2][y2].color, self.board[x2][y2].type, true)
        self.board[x2][y2] = Crystal:new(self.board[x1][y1].color, self.board[x1][y1].type, true)
        return "success"
    end
end

function Game:mix()

    for i = 1, self.boardSize do
        for j = 1, self.boardSize do
            local index = math.random(1, 6)
            local color = self.colors[index]

            if j > 2 then
                if i <= 2 then
                    if self.board[i][j - 1].color == color
                            and self.board[i][j - 1].color == self.board[i][j - 2].color
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)
                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                else
                    if (self.board[i][j - 1].color == color
                            and self.board[i][j - 1].color == self.board[i][j - 2].color)
                            or (self.board[i - 1][j].color ==  color
                            and self.board[i - 1][j].color == self.board[i - 2][j].color)
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)
                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                end
            elseif j <= 2 then
                if i > 2 then
                    if self.board[i - 1][j].color == color
                            and self.board[i - 1][j].color == self.board[i - 2][j].color
                    then
                        local uniqueColor = " "

                        repeat
                            local newIndex = math.random(1, 6)
                            uniqueColor = self.colors[newIndex]
                        until uniqueColor ~= color

                        self.board[i][j] = Crystal:new(uniqueColor, "common", false)
                    else
                        self.board[i][j] = Crystal:new(color, "common", false)
                    end
                else
                    self.board[i][j] = Crystal:new(color, "common", false)
                end
            else
                self.board[i][j] = Crystal:new(color, "common", false)
            end
        end
    end
end

function Game:dump()
    view:drawBoard(self.board)
end

