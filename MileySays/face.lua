local utility = require "utility"
local math = require "math"

local t = {}

local ear
local eye
local nose
local callback
local correctIndex

t.create = function(screenGroup, callbackFunc)
	ear = display.newImageRect( "images/ear.png", 177, 225 )
	eye = display.newImageRect( "images/eye.png", 204, 142 )
	nose = display.newImageRect( "images/nose.png", 155, 240 )

	utility.centreObjectX(ear)
	utility.centreObjectY(ear)
	ear:translate(2000, 100)

	utility.centreObjectX(eye)
	utility.centreObjectY(eye)
	eye:translate(2225, 250)

	utility.centreObjectX(nose)
	utility.centreObjectY(nose)
	nose:translate(1800, 300)

	screenGroup:insert(ear)
	screenGroup:insert(eye)
	screenGroup:insert(nose)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	correctIndex = math.random(1,3)
if difficulty > 1 then
	if correctIndex == 1 then
		text2.text = "touch the olfactory"
	elseif correctIndex == 2 then
		text2.text = "touch the aural"
	else
		text2.text = "touch the ocular"
	end
else
	if correctIndex == 1 then
		text2.text = "touch the nose"
	elseif correctIndex == 2 then
		text2.text = "touch the ear"
	else
		text2.text = "touch the eye"
	end
end

	nose:translate(-2000, 0)
	eye:translate(-2000, 0)
	ear:translate(-2000, 0)

end

t.removeFromScreen = function()
	nose:translate(2000, 0)
	eye:translate(2000, 0)
	ear:translate(2000, 0)
end

local function tappedNose(event)
	callback(correctIndex == 1, event)
end

local function tappedEar(event)
	callback(correctIndex == 2, event)
end

local function tappedEye(event)
	callback(correctIndex == 3, event)
end

t.addEventListeners = function()
	nose:addEventListener("tap", tappedNose)
	ear:addEventListener("tap", tappedEar)
	eye:addEventListener("tap", tappedEye)
end

t.removeEventListeners = function()
	nose:removeEventListener("tap", tappedNose)
	ear:removeEventListener("tap", tappedEar)
	eye:removeEventListener("tap", tappedEye)
end

return t