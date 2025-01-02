local baton = require("lib.baton.baton")

---An instance of baton with some common defaults for easy prototyping.
---Left/right/up/down (movement): Arrow keys, WASD, IJKL and left gamepad stick
---Confirm/cancel/menu (actions): Z/X/C, N/M/,, A/B/Start, left/right click
---Control modifier: Shift keys, gamepad shoulder buttons
return baton.new({
	controls = {
		turn_left = {"key:left", "key:a", "key:j", "axis:leftx-"},
		turn_right = {"key:right", "key:d", "key:l", "axis:leftx+"},
		forward = {"key:up", "key:w", "key:i", "axis:lefty-"},
		shoot = {"key:space", "mouse:1", "button:a"},

		debug_restart = {"key:r"},
		debug_quit = {"key:q"},
		debug_decrease_window_size = {"key:1"},
		debug_increase_window_size = {"key:2"},
		debug_enable_debug_mode = {"key:lctrl", "key:rctrl"},
	},
})

