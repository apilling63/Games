local utility = require "utility"
local math = require "math"

local t = {}

local switchTouch
local switch
local callback

t.create = function(screenGroup, callbackFunc)
	switchTouch = display.newRect( 0, 0, 138, 128 )
	switch = display.newImageRect( "images/switch.png", 276, 128 )
	utility.centreObjectX(switchTouch)
	utility.centreObjectY(switchTouch)
	switchTouch:translate(2069, 150)

	utility.centreObjectX(switch)
	utility.centreObjectY(switch)
	switch:translate(2000, 150)
	screenGroup:insert(switchTouch)
	screenGroup:insert(switch)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	text2.text = "switch it on"

	switch:translate(-2000, 0)
	switchTouch:translate(-2000, 0)
end

t.removeFromScreen = function()
	switch:translate(2000, 0)
	switchTouch:translate(2000, 0)
end

local function tapped(event)
	callback(true, event)
end

t.addEventListeners = function()
	switchTouch:addEventListener("tap", tapped)
end

t.removeEventListeners = function()
	switchTouch:removeEventListener("tap", tapped)

end

return t