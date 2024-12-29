local fonts = {
	small = love.graphics.newFont("assets/fonts/04b_03.ttf", 12),
	regular = love.graphics.newFont("assets/fonts/04b_03.ttf", 16),
	big = love.graphics.newFont("assets/fonts/04b_03.ttf", 24),
}

fonts.small:setLineHeight(0.7)

return fonts
