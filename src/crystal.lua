Crystal = {}
MetaCrystal = {}
MetaCrystal.__index = Crystal

function Crystal:new(color, type, isMoved)
    local instance = setmetatable({}, MetaCrystal)
    instance.color = color
    instance.type = type
    instance.isMoved = isMoved
    return instance
end

function Crystal:getColor()
    return self.color
end

function Crystal:getType()
    return self.type
end

function Crystal:isMoved()
    return self.isMoved
end

return Crystal