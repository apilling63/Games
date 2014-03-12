local utility = require "utility"
local math = require "math"

local t = {}

local door
local hole
local simon
local lastTouchPoint = 100

t.create = function(screenGroup, callbackFunc)
	hole = display.newRect( 0, 0, 200, 252 )
	hole:setFillColor(0,0,0)
	utility.centreObjectX(hole)
	utility.centreObjectY(hole)
	hole:translate(2000, 200)
	screenGroup:insert(hole)

	door = display.newImageRect( "images/door.png", 200, 252 )
	utility.centreObjectX(door)
	utility.centreObjectY(door)
	door.startX = door.x
	door:translate(2000, 200)
	screenGroup:insert(door)

	door.offScreenX = door.x



	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2, simonSays)
	text2.text = "open the door"
	simon = simonSays

	hole:translate(-2000, 0)
	door:translate(-2000, 0)

end

t.removeFromScreen = function()
	door.x = door.offScreenX
	hole:translate(2000, 0)
	lastTouchPoint = 100
end

local function slide(event)
	if simon then
		if "began" == event.phase then
			lastTouchPoint = event.x
		elseif lastTouchPoint ~= 100 then
			local diff = lastTouchPoint - event.x
			door.x = math.min(door.startX, door.x - diff)

			if door.x < door.startX - 170 then
				callback(true, event)
			end

			lastTouchPoint = event.x
		end
	elseif event.phase == "began" then
		callback(false, event)
	end
end

t.addEventListeners = function()
	door:addEventListener("touch", slide)
end

t.removeEventListeners = function()
	door:removeEventListener("touch", slide)
end

return t