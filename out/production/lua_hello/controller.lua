-- controller.lua
local Controller = {}

function Controller:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.model = require("model")
    obj.view = require("view")
    return obj
end

function Controller:run()
    self.model:init()
    while true do
        self.view:showField(self.model.field)
        local cmd, x, y, d = self.view:getInput()
        if cmd == "q" then
            break
        elseif cmd == "m" then
            self.model:move({x, y}, d)
        elseif cmd == "mix" then
            self.model:mix()
        elseif cmd == "tick" then
            self.model:tick()
        end
    end
end

return Controller