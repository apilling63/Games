local utility = require "utility"
local math = require "math"

local t = {}

local triangle
local square
local circle
local hexagon
local heptagon
local octagon
local nonagon
local decagon
local dodecagon
local callback
local correctIndex
local diff

local active1
local active2
local active3

t.create = function(screenGroup, callbackFunc)
	circle = display.newImageRect( "images/greenButton.png", 200, 200 )
	triangle = display.newImageRect( "images/triangle.png", 137, 122 )
	square = display.newImageRect( "images/square.png", 137, 133 )

	hexagon = display.newImageRect( "images/hexagon.png", 130, 130 )
	heptagon = display.newImageRect( "images/heptagon.png", 130, 130 )
	octagon = display.newImageRect( "images/octagon.png", 130, 130 )

	nonagon = display.newImageRect( "images/nonagon.png", 130, 130 )
	decagon = display.newImageRect( "images/decagon.png", 130, 130)
	dodecagon = display.newImageRect( "images/dodecagon.png", 130, 130 )

	utility.addObject(circle, screenGroup, 2000, 100)
	utility.addObject(triangle, screenGroup, 2225, 250)
	utility.addObject(square, screenGroup, 1800, 300)

	utility.addObject(hexagon, screenGroup, 2000, 100)
	utility.addObject(heptagon, screenGroup, 2225, 250)
	utility.addObject(octagon, screenGroup, 1800, 300)

	utility.addObject(nonagon, screenGroup, 2000, 100)
	utility.addObject(decagon, screenGroup, 2225, 250)
	utility.addObject(dodecagon, screenGroup, 1800, 300)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	diff = difficulty
	correctIndex = math.random(1,3)

if diff == 1 then
	if correctIndex == 1 then
		text2.text = "touch the square"
	elseif correctIndex == 2 then
		text2.text = "touch the circle"
	else
		text2.text = "touch the triangle"
	end

	active1 = square
	active2 = circle
	active3 = triangle
elseif diff == 3 then
	if correctIndex == 1 then
		text2.text = "touch the nonagon"
	elseif correctIndex == 2 then
		text2.text = "touch the decagon"
	else
		text2.text = "touch the dodecagon"
	end

	active1 = nonagon
	active2 = decagon
	active3 = dodecagon

else
	if correctIndex == 1 then
		text2.text = "touch the hexagon"
	elseif correctIndex == 2 then
		text2.text = "touch the heptagon"
	else
		text2.text = "touch the octagon"
	end

	active1 = hexagon
	active2 = heptagon
	active3 = octagon
end

	active1:translate(-2000, 0)
	active2:translate(-2000, 0)
	active3:translate(-2000, 0)

end

t.removeFromScreen = function()
	active1:translate(2000, 0)
	active2:translate(2000, 0)
	active3:translate(2000, 0)
end

local function tappedSquare(event)
	callback(correctIndex == 1, event)
end

local function tappedCircle(event)
	callback(correctIndex == 2, event)
end

local function tappedTriangle(event)
	callback(correctIndex == 3, event)
end

t.addEventListeners = function()
	square:addEventListener("tap", tappedSquare)
	circle:addEventListener("tap", tappedCircle)
	triangle:addEventListener("tap", tappedTriangle)
	hexagon:addEventListener("tap", tappedSquare)
	heptagon:addEventListener("tap", tappedCircle)
	octagon:addEventListener("tap", tappedTriangle)
	nonagon:addEventListener("tap", tappedSquare)
	decagon:addEventListener("tap", tappedCircle)
	dodecagon:addEventListener("tap", tappedTriangle)
end

t.removeEventListeners = function()
	square:removeEventListener("tap", tappedSquare)
	circle:removeEventListener("tap", tappedCircle)
	triangle:removeEventListener("tap", tappedTriangle)
	hexagon:removeEventListener("tap", tappedSquare)
	heptagon:removeEventListener("tap", tappedCircle)
	octagon:removeEventListener("tap", tappedTriangle)
	nonagon:removeEventListener("tap", tappedSquare)
	decagon:removeEventListener("tap", tappedCircle)
	dodecagon:removeEventListener("tap", tappedTriangle)
end

return t