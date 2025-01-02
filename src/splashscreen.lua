local Window = require("engine.singleton.Window")
local timer = require("lib.hump.timer")
local Node = require("engine.Node")
local anim8 = require("lib.anim8.anim8")

local SplashScreen = Node:extend()

local AnimCharacter = Node:extend()
function AnimCharacter:new(x, y, char, delay)
    AnimCharacter.super.new(self, x, y)
    self._char = char
    self.alpha = 0
    self.y = self.y - 8

    timer.after(delay, function()
        timer.tween(0.5, self, {y = y, alpha = 255}, "out-elastic", nil, 3, .5)
        timer.tween(0.4, self, {alpha = 255}, "linear")
    end)

end

function AnimCharacter:draw()
    love.graphics.setColor(1, 1, 1, self.alpha / 255)
    love.graphics.print(self._char, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end

function SplashScreen:new()
    SplashScreen.super.new(self)
    local seconds_until_start = .25
    self.wzid_image = love.graphics.newImage("assets/images/wzid.png")
    local wzid_grid = anim8.newGrid(16, 16, self.wzid_image:getWidth(), self.wzid_image:getHeight())

    self.wzid_animate = nil

    local text = "wzid studios"
    local text_table = {}
    for i = 1, #text do
        text_table[i] = text:sub(i, i)
    end

    local x, y = Window.half_screen_width, Window.half_screen_height

    local text_node = self:add_child(Node())
    local font = love.graphics.getFont()
    -- wzid is 10 off from text and 16 width * 1.5 scale
    x = x - ((font:getWidth(text) + 10 + (16 * 1.5)) / 2)
    y = y - font:getHeight() / 2

    local text_offset = 0

    for i = 1, #text_table do
        local char_x = x - 2
        local char_y = y - 10
        text_node:add_child(AnimCharacter(char_x + text_offset, char_y, text_table[i], seconds_until_start + i * 0.075))
        text_offset = text_offset + font:getWidth(text_table[i]) + 1
    end

    self.wzid_x = x + text_offset - 10
    self.wzid_y = y - (self.wzid_image:getHeight() / 2 + 4)
    self.wzid_alpha = 0

    timer.after(seconds_until_start + .5 + #text_table * .075, function ()
        self.wzid_animate = anim8.newAnimation(wzid_grid('1-2', 1), .3)
        timer.tween(.3, self, {wzid_alpha = 255}, "linear")
        timer.tween(1, self, {wzid_x = self.wzid_x + 10}, "linear", function ()
            self.wzid_animate:pauseAtEnd()
        end)
    end)

    timer.after(seconds_until_start + 3, function () self:die() end)
end

function SplashScreen:draw()
    if self.wzid_animate then
        love.graphics.setColor(1,1,1, self.wzid_alpha / 255)
        self.wzid_animate:draw(self.wzid_image, self.wzid_x, self.wzid_y)
        love.graphics.setColor(1,1,1,1)
    end
    self.super.draw(self)
end

function SplashScreen:update(dt)
    if self.wzid_animate then
        self.wzid_animate:update(dt)
    end
    self.super.update(self, dt)
end


return SplashScreen