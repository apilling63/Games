local utility = require "utility"
local math = require "math"

local t = {}

local uk
local us
local france
local holland
local italy
local brazil
local thai
local russia
local portugal
local callback
local diff

t.create = function(screenGroup, callbackFunc)
	uk = display.newImageRect( "images/uk.png", 100, 100 )
	us = display.newImageRect( "images/us.png", 100, 100 )
	france = display.newImageRect( "images/france.png", 100, 100 )

	holland = display.newImageRect( "images/holland.png", 100, 100 )
	italy = display.newImageRect( "images/italy.png", 100, 100 )
	brazil = display.newImageRect( "images/brazil.png", 100, 100 )

	thai = display.newImageRect( "images/thai.png", 100, 100 )
	russia = display.newImageRect( "images/cambodia.png", 100, 100 )
	portugal = display.newImageRect( "images/portugal.png", 100, 100 )

	utility.addObject(uk, screenGroup, 1800, 210)
	uk.aname = "uk"

	utility.addObject(us, screenGroup, 2200, 320)
	us.aname = "us"

	utility.addObject(france, screenGroup, 2000, 100)
	france.aname = "france"

	utility.addObject(holland, screenGroup, 1800, 210)
	holland.aname = "holland"

	utility.addObject(italy, screenGroup, 2200, 320)
	italy.aname = "italy"

	utility.addObject(brazil, screenGroup, 2000, 100)
	brazil.aname = "brazil"

	utility.addObject(thai, screenGroup, 1800, 210)
	thai.aname = "thai"

	utility.addObject(portugal, screenGroup, 2200, 320)
	portugal.aname = "portugal"

	utility.addObject(russia, screenGroup, 2000, 100)
	russia.aname = "russia"

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	-- set expected button
	local expectedAnimal = math.random(1, 3)

	text2.text = "touch the "

	uk.isCorrect = false
	us.isCorrect = false
	brazil.isCorrect = false
	france.isCorrect = false
	italy.isCorrect = false
	portugal.isCorrect = false
	holland.isCorrect = false
	thai.isCorrect = false
	russia.isCorrect = false


if difficulty == 1 then
	if expectedAnimal == 1 then
		us.isCorrect = true
		text2.text = text2.text .. "US flag"
	elseif expectedAnimal == 2 then
		uk.isCorrect = true
		text2.text = text2.text .. "UK flag"
	elseif expectedAnimal == 3 then
		france.isCorrect = true
		text2.text = text2.text .. "France flag"
	end

	us:translate(-2000, 0)
	uk:translate(-2000, 0)
	france:translate(-2000, 0)
elseif difficulty == 2 then
	if expectedAnimal == 1 then
		holland.isCorrect = true
		text2.text = text2.text .. "Holland flag"
	elseif expectedAnimal == 2 then
		italy.isCorrect = true
		text2.text = text2.text .. "Italy flag"
	elseif expectedAnimal == 3 then
		brazil.isCorrect = true
		text2.text = text2.text .. "Brazil flag"
	end

	holland:translate(-2000, 0)
	italy:translate(-2000, 0)
	brazil:translate(-2000, 0)
else 
	if expectedAnimal == 1 then
		thai.isCorrect = true
		text2.text = text2.text .. "Thailand flag"
	elseif expectedAnimal == 2 then
		russia.isCorrect = true
		text2.text = text2.text .. "Cambodia flag"
	elseif expectedAnimal == 3 then
		portugal.isCorrect = true
		text2.text = text2.text .. "Portugal flag"
	end

	thai:translate(-2000, 0)
	russia:translate(-2000, 0)
	portugal:translate(-2000, 0)
end

	diff = difficulty

end

t.removeFromScreen = function()
	
if diff == 1 then
	us:translate(2000, 0)
	uk:translate(2000, 0)
	france:translate(2000, 0)
elseif diff == 2 then
	holland:translate(2000, 0)
	italy:translate(2000, 0)
	brazil:translate(2000, 0)
else
	thai:translate(2000, 0)
	russia:translate(2000, 0)
	portugal:translate(2000, 0)
end

end

local function tapped(self, event)
	print("tapped " .. self.aname)
	callback(self.isCorrect, event)
end

t.addEventListeners = function()
	us.tap = tapped
	uk.tap = tapped
	brazil.tap = tapped
	france.tap = tapped
	portugal.tap = tapped
	italy.tap = tapped
	holland.tap = tapped
	thai.tap = tapped
	russia.tap = tapped

	brazil:addEventListener("tap", brazil)
	us:addEventListener("tap", us)
	uk:addEventListener("tap", uk)
	france:addEventListener("tap", france)
	portugal:addEventListener("tap", portugal)
	italy:addEventListener("tap", italy)
	holland:addEventListener("tap", holland)
	thai:addEventListener("tap", thai)
	russia:addEventListener("tap", russia)
end

t.removeEventListeners = function()
	brazil:removeEventListener("tap", brazil)
	us:removeEventListener("tap", us)
	uk:removeEventListener("tap", uk)
	france:removeEventListener("tap", france)
	portugal:removeEventListener("tap", portugal)
	italy:removeEventListener("tap", italy)
	holland:removeEventListener("tap", holland)
	thai:removeEventListener("tap", thai)
	russia:removeEventListener("tap", russia)
end

return t