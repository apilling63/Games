local utility = require "utility"
local math = require "math"

local t = {}

local earth
local saturn
local mars

local callback

t.create = function(screenGroup, callbackFunc)
	earth = display.newImageRect( "images/earth.png", 225, 225 )
	saturn = display.newImageRect( "images/saturn.png", 289, 174 )
	mars = display.newImageRect( "images/mars.png", 200, 150 )

	utility.centreObjectX(earth)
	utility.centreObjectY(earth)
	earth:translate(1800, 210)
	screenGroup:insert(earth)
	earth.aname = "earth"

	utility.centreObjectX(saturn)
	utility.centreObjectY(saturn)
	saturn:translate(2150, 320)
	screenGroup:insert(saturn)
	saturn.aname = "saturn"

	utility.centreObjectX(mars)
	utility.centreObjectY(mars)
	mars:translate(2000, 100)
	screenGroup:insert(mars)
	mars.aname = "mars"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch "

	earth.isCorrect = false
	saturn.isCorrect = false
	mars.isCorrect = false

if difficulty == 1 then
	if expectedAnimal == 1 then
		saturn.isCorrect = true
		text2.text = text2.text .. "saturn"
	elseif expectedAnimal == 2 then
		earth.isCorrect = true
		text2.text = text2.text .. "earth"
	elseif expectedAnimal == 3 then
		mars.isCorrect = true
		text2.text = text2.text .. "mars"
	end
elseif difficulty == 2 then
	if expectedAnimal == 1 then
		saturn.isCorrect = true
		text2.text = text2.text .. "sixth from sun"
	elseif expectedAnimal == 2 then
		earth.isCorrect = true
		text2.text = text2.text .. "third from sun"
	elseif expectedAnimal == 3 then
		mars.isCorrect = true
		text2.text = text2.text .. "fourth from sun"
	end
else 
	if expectedAnimal == 1 then
		saturn.isCorrect = true
		text2.text = text2.text .. "62 moon planet"
	elseif expectedAnimal == 2 then
		earth.isCorrect = true
		text2.text = text2.text .. "1 moon planet"
	elseif expectedAnimal == 3 then
		mars.isCorrect = true
		text2.text = text2.text .. "2 moon planet"
	end
end

	saturn:translate(-2000, 0)
	earth:translate(-2000, 0)
	mars:translate(-2000, 0)

end

t.removeFromScreen = function()
	saturn:translate(2000, 0)
	earth:translate(2000, 0)
	mars:translate(2000, 0)
end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	saturn.tap = tapped
	earth.tap = tapped
	mars.tap = tapped

	mars:addEventListener("tap", mars)
	saturn:addEventListener("tap", saturn)
	earth:addEventListener("tap", earth)
end

t.removeEventListeners = function()
	mars:removeEventListener("tap", mars)
	saturn:removeEventListener("tap", saturn)
	earth:removeEventListener("tap", earth)
end

return t