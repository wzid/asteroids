---anim8 objects ready to use, mainly a player character.
---This module bundles atlases and animations together to avoid having to pass
---them around manually. To mess with their internal state, call methods on each
---animation's `data` field, which is just a raw anim8 object.

local anim8 = require("lib.anim8.anim8")
local player_atlas = love.graphics.newImage("assets/images/player.png")
local player_grid = anim8.newGrid(16, 16, player_atlas:getWidth(), player_atlas:getHeight())

---Draw this animation. All extra arguments, like position, size, offset, etc,
---are passed to this animation's `love.graphics.draw()`.
---@param ...any
local function draw_animation(self, ...)
	self.data:draw(self.atlas, ...)
end

local function create_animation(atlas, frames, durations)
	return {
		atlas = atlas,
		data = anim8.newAnimation(frames, durations),
		draw = draw_animation,
	}
end

local animations = {
	-- General-purpose and topdown-focused animations
	player_idle_down = create_animation(player_atlas, player_grid("1-1", 1), 0.2),
	player_idle_right = create_animation(player_atlas, player_grid("1-1", 2), 0.2),
	player_idle_left = create_animation(player_atlas, player_grid("1-1", 3), 0.2),
	player_idle_up = create_animation(player_atlas, player_grid("1-1", 4), 0.2),

	player_walk_down = create_animation(player_atlas, player_grid("1-4", 1), 0.2),
	player_walk_right = create_animation(player_atlas, player_grid("1-4", 2), 0.2),
	player_walk_left = create_animation(player_atlas, player_grid("1-4", 3), 0.2),
	player_walk_up = create_animation(player_atlas, player_grid("1-4", 4), 0.2),

	-- Sidescrolling-focused animations. To flip them, flip the underlying object.
	-- Example: `animations.player_run.data:flipH()`
	player_run = create_animation(player_atlas, player_grid("1-4", 5), 0.1),
	player_jump = create_animation(player_atlas, player_grid("1-1", 6), 0.1),
	player_fall = create_animation(player_atlas, player_grid("1-1", 7), 0.1),
	player_crouch = create_animation(player_atlas, player_grid("1-1", 8), 0.1),
	player_item = create_animation(player_atlas, player_grid("1-1", 9), 0.1),
}

---Update every registered animation. Should be called only once per frame.
---@param dt number
function animations:update(dt)
	for _, t in pairs(self) do
		if type(t) ~= "function" then t.data:update(dt) end
	end
end

return animations
