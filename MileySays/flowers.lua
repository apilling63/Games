local utility = require "utility"
local math = require "math"

local t = {}

local daffodil
local daisy
local sunflower

local callback

t.create = function(screenGroup, callbackFunc)
	daffodil = display.newImageRect( "images/daffodil.png", 229, 220 )
	daisy = display.newImageRect( "images/daisy.png", 225, 224 )
	sunflower = display.newImageRect( "images/sunflower.png", 224, 224 )

	utility.centreObjectX(daffodil)
	utility.centreObjectY(daffodil)
	daffodil:translate(1800, 100)
	screenGroup:insert(daffodil)
	daffodil.aname = "daffodil"

	utility.centreObjectX(daisy)
	utility.centreObjectY(daisy)
	daisy:translate(2200, 210)
	screenGroup:insert(daisy)
	daisy.aname = "daisy"

	utility.centreObjectX(sunflower)
	utility.centreObjectY(sunflower)
	sunflower:translate(2000, 320)
	screenGroup:insert(sunflower)
	sunflower.aname = "sunflower"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedFlower = math.random(1, 3)

	text2.text = "touch the "

	daffodil.isCorrect = false
	daisy.isCorrect = false
	sunflower.isCorrect = false

if difficulty == 1 then
	if expectedFlower == 1 then
		daisy.isCorrect = true
		text2.text = text2.text .. "daisy"
	elseif expectedFlower == 2 then
		daffodil.isCorrect = true
		text2.text = text2.text .. "daffodil"
	elseif expectedFlower == 3 then
		sunflower.isCorrect = true
		text2.text = text2.text .. "sunflower"
	end
else
	if expectedFlower == 1 then
		daisy.isCorrect = true
		text2.text = text2.text .. "Bellis"
	elseif expectedFlower == 2 then
		daffodil.isCorrect = true
		text2.text = text2.text .. "Narcissus"
	elseif expectedFlower == 3 then
		sunflower.isCorrect = true
		text2.text = text2.text .. "Helianthus"
	end
end

	daisy:translate(-2000, 0)
	daffodil:translate(-2000, 0)
	sunflower:translate(-2000, 0)

end

t.removeFromScreen = function()
	daisy:translate(2000, 0)
	daffodil:translate(2000, 0)
	sunflower:translate(2000, 0)
end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	daisy.tap = tapped
	daffodil.tap = tapped
	sunflower.tap = tapped

	sunflower:addEventListener("tap", sunflower)
	daisy:addEventListener("tap", daisy)
	daffodil:addEventListener("tap", daffodil)
end

t.removeEventListeners = function()
	sunflower:removeEventListener("tap", sunflower)
	daisy:removeEventListener("tap", daisy)
	daffodil:removeEventListener("tap", daffodil)
end

return t