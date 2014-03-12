local utility = require "utility"
local math = require "math"

local t = {}

local salt
local callback
local active = false

t.create = function(screenGroup, callbackFunc)
	salt = display.newImageRect( "images/salt.png", 133, 201 )
	utility.centreObjectX(salt)
	utility.centreObjectY(salt)
	salt:translate(2000, 100)
	screenGroup:insert(salt)
	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	expectedButton = math.random(1, 2)

	text2.text = "shake"

	salt:translate(-2000, 0)
	active = true
end

t.removeFromScreen = function()
	active = false
	salt:translate(2000, 0)
end

local function onShake (event)
	if active and event.isShake then
		-- Device was shaken
		callback(true, event)
	end
end

t.addEventListeners = function()
	Runtime:addEventListener("accelerometer", onShake)
end

t.removeEventListeners = function()
	Runtime:removeEventListener("accelerometer", onShake)
end

return t