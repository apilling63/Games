local utility = require "utility"
local math = require "math"

local t = {}

local dog
local cat
local cow

local callback

t.create = function(screenGroup, callbackFunc)
	dog = display.newImageRect( "images/dog.png", 181, 225 )
	cat = display.newImageRect( "images/cat.png", 160, 268 )
	cow = display.newImageRect( "images/cow.png", 259, 195 )

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
	cow:translate(2000, 100)
	screenGroup:insert(cow)
	cow.aname = "cow"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch the "

	dog.isCorrect = false
	cat.isCorrect = false
	cow.isCorrect = false

if difficulty == 1 then
	if expectedAnimal == 1 then
		cat.isCorrect = true
		text2.text = text2.text .. "cat"
	elseif expectedAnimal == 2 then
		dog.isCorrect = true
		text2.text = text2.text .. "dog"
	elseif expectedAnimal == 3 then
		cow.isCorrect = true
		text2.text = text2.text .. "cow"
	end
elseif difficulty == 2 then
	if expectedAnimal == 1 then
		cat.isCorrect = true
		text2.text = text2.text .. "feline"
	elseif expectedAnimal == 2 then
		dog.isCorrect = true
		text2.text = text2.text .. "canine"
	elseif expectedAnimal == 3 then
		cow.isCorrect = true
		text2.text = text2.text .. "bovine"
	end
else 
	if expectedAnimal == 1 then
		cat.isCorrect = true
		text2.text = text2.text .. "tabby"
	elseif expectedAnimal == 2 then
		dog.isCorrect = true
		text2.text = text2.text .. "labrador"
	elseif expectedAnimal == 3 then
		cow.isCorrect = true
		text2.text = text2.text .. "freisian"
	end
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