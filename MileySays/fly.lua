local utility = require "utility"
local math = require "math"

local t = {}

local fly

local callback
local difficulty

t.create = function(screenGroup, callbackFunc)
	fly = display.newImageRect( "images/fly.png", 200, 200 )
	utility.centreObjectX(fly)
	utility.centreObjectY(fly)
	fly:translate(2000, 100)
	screenGroup:insert(fly)
	fly.startX = fly.x
	fly.startY = fly.y
	fly.directionX = 10
	fly.directionY = 10

	callback = callbackFunc
end

local function moveFly(event)

	fly.x = fly.x + fly.directionX
	fly.y = fly.y + fly.directionY

	local rand = math.random(1, 100)

	if fly.x < 100 or fly.x > 480 or rand > 95 then
		fly.directionX = fly.directionX * -1
	end

	if fly.y < (100 + (display.contentHeight / 2)) or fly.y > (display.contentHeight - 100) or rand < 6 then
		fly.directionY = fly.directionY * -1
	end
end

t.showOnScreen = function(diff, text2)
	-- set expected button
	expectedButton = math.random(1, 2)

	text2.text = "swat the fly"

	fly:translate(-2000, 0)
	fly.directionX = diff * 10
	fly.directionY = diff * 10

	Runtime:addEventListener("enterFrame", moveFly)
end

t.removeFromScreen = function()
	fly.x = fly.startX
	fly.y = fly.startY
	Runtime:removeEventListener("enterFrame", moveFly)
end

local function swatted(event)
	callback(true, event)
end

t.addEventListeners = function()
	fly:addEventListener("tap", swatted)
end

t.removeEventListeners = function()
	fly:removeEventListener("tap", swatted)
end

return t