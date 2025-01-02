---@class Color rgb color class for converting values to float values
Color = { r = 0, g = 0, b = 0, a = 255 }
Color.__index = Color

--- Creates a new instance of the Color class and returns it
---@param r number red: 0 - 255
---@param g number green: 0 - 255
---@param b number blue: 0 - 255
---@param a? number alpha: 0 - 255
---@return Color
local new = function (r, g, b, a)
	local color = {}
	setmetatable(color, Color)
	color.r = math.min(255, r)
	color.g = math.min(255, g)
	color.b = math.min(255, b)
	color.a = a or 255
	color.a = math.min(255, color.a)
	return color
end

---Sets the alpha value of the color and returns the color for a builder structure
---@param val number 0 - 255 value
---@return Color
function Color:alpha(val)
	return new(self.r, self.g, self.b, val)
end


---Sets the alpha value of the color
---@param val number 0 - 255 value
function Color:set_alpha(val)
	self.a = val
end

---Returns a new color making the color darker or lighter
---@param val number any value from 0 onwards
---@return Color
function Color:change_percentage(val)
	return new(self.r * val, self.g * val, self.b * val, self.a)
end



---Unpacks the Color class to the rgba components
---@return number r # Red color component in 0..1 range.
---@return number g # Green color component in 0..1 range.
---@return number b # Blue color component in 0..1 range.
---@return number b # Blue color component in 0..1 range.
function Color:unpack()
    return love.math.colorFromBytes(self.r, self.g, self.b, self.a)
end

-- https://lospec.com/palette-list/yperocha-chromata
return {
	new = new,
	white = new(255, 255, 255),
	black = new(0, 0, 0),
	black_23 = new(23, 23, 23),
	black_35 = new(35, 35, 35),
	dark_blue = new(14, 84, 128),
	blue = new(23, 120, 153),
	red = new(255, 85, 85),
	faded_white = new(221, 221, 221),
	green = new(38, 128, 67), --#55FF55
}
