local utility = require "utility"
local math = require "math"

local t = {}

local spider
local ladybird
local frog

local callback

t.create = function(screenGroup, callbackFunc)
	spider = display.newImageRect( "images/spider.png", 263, 192 )
	ladybird = display.newImageRect( "images/ladybird.png", 204, 204 )
	frog = display.newImageRect( "images/frog.png", 239, 211 )

	utility.centreObjectX(spider)
	utility.centreObjectY(spider)
	spider:translate(1800, 320)
	screenGroup:insert(spider)
	spider.aname = "spider"

	utility.centreObjectX(ladybird)
	utility.centreObjectY(ladybird)
	ladybird:translate(2200, 280)
	screenGroup:insert(ladybird)
	ladybird.aname = "ladybird"

	utility.centreObjectX(frog)
	utility.centreObjectY(frog)
	frog:translate(2000, 100)
	screenGroup:insert(frog)
	frog.aname = "frog"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch "

	spider.isCorrect = false
	ladybird.isCorrect = false
	frog.isCorrect = false

if difficulty == 1 then
	if expectedAnimal == 1 then
		ladybird.isCorrect = true
		text2.text = text2.text .. "6"
	elseif expectedAnimal == 2 then
		spider.isCorrect = true
		text2.text = text2.text .. "8"
	elseif expectedAnimal == 3 then
		frog.isCorrect = true
		text2.text = text2.text .. "4"
	end

	text2.text = text2.text .. " legged animal"
elseif difficulty == 2 then 
	if expectedAnimal == 1 then
		ladybird.isCorrect = true
		text2.text = text2.text .. "the beetle"
	elseif expectedAnimal == 2 then
		spider.isCorrect = true
		text2.text = text2.text .. "the arachnid"
	elseif expectedAnimal == 3 then
		frog.isCorrect = true
		text2.text = text2.text .. "the amphibian"
	end
else 
	if expectedAnimal == 1 then
		ladybird.isCorrect = true
		text2.text = text2.text .. "the coccinellidae"
	elseif expectedAnimal == 2 then
		spider.isCorrect = true
		text2.text = text2.text .. "the arthropod"
	elseif expectedAnimal == 3 then
		frog.isCorrect = true
		text2.text = text2.text .. "the anura"
	end
end
	ladybird:translate(-2000, 0)
	spider:translate(-2000, 0)
	frog:translate(-2000, 0)

end

t.removeFromScreen = function()
	ladybird:translate(2000, 0)
	spider:translate(2000, 0)
	frog:translate(2000, 0)
end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	ladybird.tap = tapped
	spider.tap = tapped
	frog.tap = tapped

	frog:addEventListener("tap", frog)
	ladybird:addEventListener("tap", ladybird)
	spider:addEventListener("tap", spider)
end

t.removeEventListeners = function()
	frog:removeEventListener("tap", frog)
	ladybird:removeEventListener("tap", ladybird)
	spider:removeEventListener("tap", spider)
end

return t