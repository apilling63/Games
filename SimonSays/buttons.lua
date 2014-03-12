local utility = require "utility"
local math = require "math"

local t = {}

local greenButton
local redButton
local expectedButton = 1
local callback
local textObj

t.create = function(screenGroup, callbackFunc)
	greenButton = display.newImageRect( "images/greenButton.png", 200, 200 )
	redButton = display.newImageRect( "images/redButton.png", 200, 200 )

	utility.addObject(greenButton, screenGroup, 2000, 100)
	utility.addObject(redButton, screenGroup, 2000, 320)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty , text2)
	-- set expected button
	expectedButton = math.random(1, 2)

	text2.text = "touch "

	if expectedButton == 1 then
		text2.text = text2.text .. "green"
		
		if difficulty > 1 then
			text2:setFillColor(255,0,0)
		end
	elseif expectedButton == 2 then
		text2.text = text2.text .. "red"

		if difficulty > 1 then
			text2:setFillColor(0, 255,0)
		end
	end

	greenButton:translate(-2000, 0)
	redButton:translate(-2000, 0)
	textObj = text2
end

t.removeFromScreen = function()
	greenButton:translate(2000, 0)
	redButton:translate(2000, 0)
	textObj:setFillColor(0,0,0)
end

local function buttonPressed(buttonIndex, event)
	if buttonIndex == expectedButton then
		callback(true, event)
	else
		callback(false, event)
	end
end

local function redButtonPressed(event)
	buttonPressed(2, event)
end

local function greenButtonPressed(event)
	buttonPressed(1, event)
end

t.addEventListeners = function()
	greenButton:addEventListener("tap", greenButtonPressed)
	redButton:addEventListener("tap", redButtonPressed)
end

t.removeEventListeners = function()
	greenButton:removeEventListener("tap", greenButtonPressed)
	redButton:removeEventListener("tap", redButtonPressed)
end

return t