local Node = require("base.Node")
local Window = require("base.singleton.Window")
local Input = require("base.singleton.Input")

local Spaceship = Node:extend()

function Spaceship:new()
    Spaceship.super.new(self)
    self.image = love.graphics.newImage("assets/images/spaceship.png")
    self.image:setFilter("nearest", "nearest")
    self.image_size = 14
    self.x = Window.half_screen_width
    self.y = Window.half_screen_height
    self.speed = 0
    self.max_speed = 150
    self.acceleration = 400
    self.turn_speed = 5
    self.rotation = 0
    self.bullet_speed = 500

    self.shoot_sound = love.audio.newSource("assets/audio/shoot.wav", "static")
end

function Spaceship:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

local can_shoot = true
function Spaceship:update(dt)
    self.super.update(self)
    -- value between 0 and 1
    local turn_left = Input:get "turn_left"
    local turn_right = Input:get "turn_right"
    local thrust = Input:get "forward"

    -- ship is initially pointing up, so we need to subtract 90 degrees
    local angle = self.rotation - (math.pi / 2)

    if can_shoot and Input:down "shoot" then
        -- calculate the top point of the ship
        local mx = self.x + math.cos(angle) * (self.image_size / 2)
        local my = self.y + math.sin(angle) * (self.image_size / 2)
        self.shoot_sound:setPitch(math.random(95, 105) * .01)
        self.shoot_sound:play()
        table.insert(self.parent.missles, {x = mx, y = my, angle = angle, speed = self.bullet_speed})
        can_shoot = false
    end
    if Input:released "shoot" then
        can_shoot = true
    end


    -- Accelerate the spaceship when thrust is applied
    if thrust > 0 then
        self.speed = math.min(self.speed + self.acceleration * dt, self.max_speed)
    else
        -- Optionally, slow down when not thrusting
        self.speed = math.max(self.speed - self.acceleration * dt, 0)
    end

    self.rotation = self.rotation + (turn_left - turn_right) * self.turn_speed * dt

    self.x = self.x + math.cos(angle) * self.speed * dt
    self.y = self.y + math.sin(angle) * self.speed * dt
end



return Spaceship