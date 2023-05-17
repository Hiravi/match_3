-- Main module
local Model = require("model")
local View = require("view")
local Controller = require("controller")

-- Create an instance of the Model class
local model = Model:new()

-- Initialize the game field


-- Create an instance of the View class
local view = View:new()

-- Create an instance of the Controller class
local controller = Controller:new()
controller:run()

-- Main game loop
while true do
    -- Show the game field
    view:showField(model.field)

    -- Get user input
    local cmd, x, y, d = view:getInput()

    -- Handle user input
    if cmd == "m" then
        -- Move the cells
        model:move({x, y}, {x, y+d})
    elseif cmd == "t" then
        -- Tick the cells
        model:tick()
    elseif cmd == "x" then
        -- Mix the cells
        model:mix()
    elseif cmd == "q" then
        -- Quit the game
        break
    end
end
