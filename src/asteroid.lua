local Node = require("engine.Node")
local Window = require("engine.singleton.Window")

local Asteroid = Node:extend()

--- Constructor
---@param size number 1 for big, 2 for medium, 3 for small
function Asteroid:new(size)
    Asteroid.super.new(self)
    local speed_multiplier = size == 3 and 1 or (size == 2 and 1.5 or 2)
    self.speed = 50 * speed_multiplier
    self.size = size
    self.rotation = 0
    if size > 1 then
        local i = math.random(1, 3)
        local suffix = (size == 3) and "" or "_md"
        self.img_size = (size == 3) and 32 or 22
        self.image = love.graphics.newImage("assets/images/asteroid" .. i .. suffix .. ".png")
        self.image:setFilter("nearest", "nearest")
    else
        self.img_size = 10
        self.image = love.graphics.newImage("assets/images/asteroid_sm.png")
    end

    -- random position
    local left_or_right = math.random(0, 1)
    local angle = math.random(15, 85) * .01
    if left_or_right == 0 then -- asteroid starts on left side
        self.x = -self.img_size
        -- we want to go to right side of unit circle
        self.angle = ((3 * math.pi) / 2) + angle * math.pi
    else
        self.x = Window.screen_width + self.img_size
        -- we want to go to left side of unit circle
        self.angle = (math.pi / 2) + angle * math.pi
    end

    self.y = math.random(0, Window.screen_height)
end

function Asteroid:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Asteroid:update(dt)
    self.rotation = self.rotation + 0.4 * dt
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
end

return Asteroid