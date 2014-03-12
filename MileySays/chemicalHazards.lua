local utility = require "utility"
local math = require "math"

local t = {}

local dog
local cat
local cow

local dogText
local catText
local cowText

local callback

t.create = function(screenGroup, callbackFunc)
	dog = display.newImageRect( "images/harmful.png", 200, 200 )
	cat = display.newImageRect( "images/toxic.png", 200, 200 )
	cow = display.newImageRect( "images/flammable.png", 200, 200 )

	dogText = "the HARMFUL warning"
	catText = "the TOXIC warning"
	cowText = "the FLAMMABLE warning"

	utility.centreObjectX(dog)
	utility.centreObjectY(dog)
	dog:translate(1800, 210)
	screenGroup:insert(dog)
	dog.aname = "dog"

	utility.centreObjectX(cat)
	utility.centreObjectY(cat)
	cat:translate(2200, 320)
	screenGroup:insert(cat)
	cat.aname = "cat"

	utility.centreObjectX(cow)
	utility.centreObjectY(cow)
	cow:translate(2020, 100)
	screenGroup:insert(cow)
	cow.aname = "cow"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch "

	dog.isCorrect = false
	cat.isCorrect = false
	cow.isCorrect = false

	if expectedAnimal == 1 then
		cat.isCorrect = true
		text2.text = text2.text .. catText
	elseif expectedAnimal == 2 then
		dog.isCorrect = true
		text2.text = text2.text .. dogText
	elseif expectedAnimal == 3 then
		cow.isCorrect = true
		text2.text = text2.text .. cowText
	end

	cat:translate(-2000, 0)
	dog:translate(-2000, 0)
	cow:translate(-2000, 0)

end

t.removeFromScreen = function()
	cat:translate(2000, 0)
	dog:translate(2000, 0)
	cow:translate(2000, 0)
end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	cat.tap = tapped
	dog.tap = tapped
	cow.tap = tapped

	cow:addEventListener("tap", cow)
	cat:addEventListener("tap", cat)
	dog:addEventListener("tap", dog)
end

t.removeEventListeners = function()
	cow:removeEventListener("tap", cow)
	cat:removeEventListener("tap", cat)
	dog:removeEventListener("tap", dog)
end

return t