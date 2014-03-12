local utility = require "utility"
local math = require "math"

local t = {}

local harry
local charles
local william

local callback

t.create = function(screenGroup, callbackFunc)
	harry = display.newImageRect( "images/harry.png", 191, 262 )
	charles = display.newImageRect( "images/charles.png", 169, 194 )
	william = display.newImageRect( "images/william.png", 166, 229 )

	utility.centreObjectX(harry)
	utility.centreObjectY(harry)
	harry:translate(1800, 210)
	screenGroup:insert(harry)
	harry.aname = "harry"

	utility.centreObjectX(charles)
	utility.centreObjectY(charles)
	charles:translate(2200, 320)
	screenGroup:insert(charles)
	charles.aname = "charles"

	utility.centreObjectX(william)
	utility.centreObjectY(william)
	william:translate(2000, 100)
	screenGroup:insert(william)
	william.aname = "william"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch "

	harry.isCorrect = false
	charles.isCorrect = false
	william.isCorrect = false

if difficulty == 1 then
	if expectedAnimal == 1 then
		charles.isCorrect = true
		text2.text = text2.text .. "Charles"
	elseif expectedAnimal == 2 then
		harry.isCorrect = true
		text2.text = text2.text .. "Harry"
	elseif expectedAnimal == 3 then
		william.isCorrect = true
		text2.text = text2.text .. "William"
	end
elseif difficulty == 2 then
	if expectedAnimal == 1 then
		charles.isCorrect = true
		text2.text = text2.text .. "first in line"
	elseif expectedAnimal == 2 then
		harry.isCorrect = true
		text2.text = text2.text .. "fourth in line"
	elseif expectedAnimal == 3 then
		william.isCorrect = true
		text2.text = text2.text .. "second in line"
	end
else 
	if expectedAnimal == 1 then
		charles.isCorrect = true
		text2.text = text2.text .. "Duke of Rothesay"
	elseif expectedAnimal == 2 then
		harry.isCorrect = true
		text2.text = text2.text .. "Henry of Wales"
	elseif expectedAnimal == 3 then
		william.isCorrect = true
		text2.text = text2.text .. "Duke of Cambridge"
	end
end

	charles:translate(-2000, 0)
	harry:translate(-2000, 0)
	william:translate(-2000, 0)

end

t.removeFromScreen = function()
	charles:translate(2000, 0)
	harry:translate(2000, 0)
	william:translate(2000, 0)
end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	charles.tap = tapped
	harry.tap = tapped
	william.tap = tapped

	william:addEventListener("tap", william)
	charles:addEventListener("tap", charles)
	harry:addEventListener("tap", harry)
end

t.removeEventListeners = function()
	william:removeEventListener("tap", william)
	charles:removeEventListener("tap", charles)
	harry:removeEventListener("tap", harry)
end

return t