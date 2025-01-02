local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local colors = require("src.collections.colors")
local Window = require("engine.singleton.Window")
local Input = require("engine.singleton.Input")
local Node
local root


function love.load()
	Window:setup(3)
	love.window.setTitle("asteroids")
	push:setBorderColor(colors.black_23:unpack())

	Node = require("engine.Node")
	root = Node()

	require("src")(root)
end

function love.update(dt)
	Input:update()

	if Input:pressed("debug_quit") then love.event.quit() end
	if Input:pressed("debug_restart") then love.event.quit("restart") end
	if Input:pressed("debug_increase_window_size") then Window:resize(Window.scale + 1) end
	if Input:pressed("debug_decrease_window_size") then Window:resize(Window.scale - 1) end
	if Input:pressed("debug_enable_debug_mode") then debug.debug() end

	timer.update(dt)
	root:update(dt)
end

function love.draw()
	push:start()
	root:draw()
	push:finish()
end
