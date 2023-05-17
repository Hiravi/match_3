-- Model module
Model = {}

function Model:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Model:init()
    self.field = {}
    for i = 1, 10 do
        self.field[i] = {}
        for j = 1, 10 do
            self.field[i][j] = string.char(math.random(65, 70))
        end
    end
end

function Model:tick()
    local changed = false
    repeat
        changed = false
        for i = 1, 9 do
            for j = 1, 10 do
                if self.field[i][j] ~= " " and self.field[i][j] == self.field[i+1][j] then
                    self.field[i][j] = " "
                    changed = true
                end
            end
        end
        for i = 9, 1, -1 do
            for j = 1, 10 do
                if self.field[i][j] == " " then
                    self.field[i][j] = self.field[i-1][j]
                    self.field[i-1][j] = " "
                    changed = true
                end
            end
        end
        for i = 1, 10 do
            for j = 1, 10 do
                if self.field[i][j] == " " then
                    self.field[i][j] = string.char(math.random(65, 70))
                    changed = true
                end
            end
        end
    until not changed
end

function Model:move(from, to)
    local x1, y1 = from[1], from[2]
    local x2, y2 = to[1], to[2]
    self.field[x1][y1], self.field[x2][y2] = self.field[x2][y2], self.field[x1][y1]
end

function Model:mix()
    local function swap(i1, j1, i2, j2)
        self.field[i1][j1], self.field[i2][j2] = self.field[i2][j2], self.field[i1][j1]
    end
    for i = 1, 10 do
        for j = 1, 10 do
            local r = math.random(i, 10)
            local c = math.random(1, 10)
            swap(i, j, r, c)
        end
    end
end

function Model:dump()
    for i = 0, 9 do
        io.write(i .. " | ")
        for j = 1, 10 do
            io.write(self.field[i][j] .. " ")
        end
        io.write("\n")
    end
end