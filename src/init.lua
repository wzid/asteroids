local Game = require("src.game")
local fonts = require("assets.collections.fonts")
local SplashScreen = require("src.splashscreen")

return function(root)
	love.graphics.setFont(fonts.splash)
	local splash = root:add_child(SplashScreen())

    splash.died:subscribe(root, function()
		love.graphics.setFont(fonts.small)
		fonts.splash:release()
		root:add_child(Game())
    end)
end
