local Node = require("base.Node")
local Asteroid = require("src.asteroid")
local Window = require("base.singleton.Window")
local Spaceship = require("src.spaceship")
local colors = require("assets.collections.colors")
local shaders = require("assets.collections.shaders")

local Game = Node:extend()

local asteroids = {}

function Game:new()
    self.super.new(self)
    -- BG_MUSIC = love.audio.newSource("assets/audio/race_to_mars.mp3", "stream")
    -- BG_MUSIC:setLooping(true)
    -- BG_MUSIC:setVolume(.1)
    -- BG_MUSIC:play()

    self:add_child(Spaceship())

    self.chromatic_shader = love.graphics.newShader("assets/shaders/chromatic.fs")
    self.blur_shader = love.graphics.newShader("assets/shaders/blur.fs")
    self.chromatic_shader:send("dir", {0.001, 0.001})
    local blur_radius = 2
    self.blur_weights = shaders.gen_gaussian(blur_radius)
    --print the weights
    for i, v in ipairs(self.blur_weights) do
        print(i, v)
    end


    self.blur_shader:send("weights", unpack(self.blur_weights))
    self.blur_shader:send("radius", blur_radius)
    self.blur_shader:send("texel_size", {1 / Window.width, 1 / Window.height})  

    math.randomseed(os.time())
    for i = 1, 5 do
        table.insert(asteroids, Asteroid(3))
    end

    self.score = 0
    self.missles = {}
    self.canvas = love.graphics.newCanvas(Window.screen_width, Window.screen_height)
    self.tmp_canvas = love.graphics.newCanvas(Window.screen_width, Window.screen_height)
    self.blur_canvas = love.graphics.newCanvas(Window.screen_width, Window.screen_height)
end

function Game:draw()
    -- first pass: draw scene to canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.print("Score: " .. self.score, 10, 10)

    self.super.draw(self)
    for _, asteroid in ipairs(asteroids) do
        asteroid:draw()
    end

    for _, missle in ipairs(self.missles) do
        love.graphics.setColor(colors.red:unpack())
        love.graphics.circle("fill", missle.x, missle.y, 2)
        love.graphics.setColor(0, 0, 0)
    end
    love.graphics.setCanvas()


    -- second pass: apply chromatic aberration
    love.graphics.setCanvas(self.tmp_canvas)
    love.graphics.clear()
    love.graphics.setShader(self.chromatic_shader)
    love.graphics.draw(self.canvas)
    love.graphics.setCanvas()

    -- third pass: apply blur
    love.graphics.setCanvas(self.blur_canvas)
    love.graphics.clear()
    love.graphics.setShader(self.blur_shader)
    self.blur_shader:send("dir", {1, 0})
    love.graphics.draw(self.tmp_canvas)
    love.graphics.setCanvas()
    love.graphics.clear()

    self.blur_shader:send("dir", {0, 1})
    love.graphics.draw(self.blur_canvas, 0, 0, 0, Window.scale, Window.scale)
    love.graphics.setShader()
end

function Game:update(dt)
    self.super.update(self, dt)
    for i, asteroid in ipairs(asteroids) do
        asteroid:update(dt)
        if asteroid.x < -asteroid.img_size or
            asteroid.x > Window.screen_width + asteroid.img_size or
            asteroid.y < -asteroid.img_size or
            asteroid.y > Window.screen_height + asteroid.img_size then
            table.remove(asteroids, i)
        end
    end

    if #asteroids < 6 then
        local to_add = math.random(2, 4)
        for i = 1, to_add do
            table.insert(asteroids, Asteroid(3))
        end
    end

    for i, missle in ipairs(self.missles) do
        missle.x = missle.x + math.cos(missle.angle) * missle.speed * dt
        missle.y = missle.y + math.sin(missle.angle) * missle.speed * dt
        if missle.x < 0 or missle.x > love.graphics.getWidth() or missle.y < 0 or missle.y > love.graphics.getHeight() then
            table.remove(self.missles, i)
        else
            -- Check collisions with asteroids
            for j, asteroid in ipairs(asteroids) do
                -- Calculate distance between missile and asteroid
                local dx = missle.x - asteroid.x
                local dy = missle.y - asteroid.y
                local distance = math.sqrt(dx * dx + dy * dy)
                -- Get the collision radius (half of asteroid's size)
                local collision_radius = asteroid.img_size / 2

                -- Check if missile hits asteroid
                if distance < collision_radius then
                    -- Remove both missile and asteroid
                    table.remove(self.missles, i)
                    table.remove(asteroids, j)

                    -- Increase score
                    self.score = self.score + (120 / asteroid.size)
                    -- If asteroid is large enough, split it into smaller ones
                    if asteroid.size > 2 then
                        -- Create two smaller asteroids
                        local new_scale = asteroid.size - 1

                        -- Add two new asteroids with random angles
                        for k = 1, 2 do
                            local new_angle = math.random() * math.pi * 2
                            local new_asteroid = Asteroid(new_scale)
                            new_asteroid.x = asteroid.x
                            new_asteroid.y = asteroid.y
                            new_asteroid.angle = new_angle
                            table.insert(asteroids, new_asteroid)
                        end
                    end
                    break -- Break inner loop since missile is destroyed
                end
            end
        end
    end
end

return Game
