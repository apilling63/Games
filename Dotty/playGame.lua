-----------------------------------------------------------------------------------------
--
-- playGame.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local gameInputs = require ("gameInputs")

local screenGroup
local switches
local numBulbs
local bulbs
local numConnections
local numMoves
local numSwitches

local function changeBulbColour(bulb)

	if bulb.isWhite then
		bulb.isWhite = false
		utility.setColour(bulb, 255, 255, 0)
	else
		bulb.isWhite = true
		utility.setColour(bulb, 255, 255, 255)
	end
end

local function checkComplete()
	local complete = true
	
	for i = 1, #bulbs do
		local bulb = bulbs[i]
		
		if bulb.isWhite == false then
			complete = false
		end	
	end	
	
	return complete
end

local function changeBulbs(theseBulbs)
	for i=1, #theseBulbs do
		changeBulbColour(bulbs[theseBulbs[i]])
	end	
end

local function switchClicked(self, event)
	self.yScale = -1 * self.yScale
	
	changeBulbs(self.bulbs)
	
	local complete = checkComplete()
	
	if complete then
		local textObject2 = utility.addBlackCentredText("WINNER", 500, screenGroup, 30)
	end
	
end

local function setDefaults()
	bulbs = {}
	switches = {}
	numBulbs = 4
	numSwitches = 3
end

-- what to do when the screen loads
function scene:createScene(event)
	setDefaults()
	screenGroup = self.view	
	
	local background = display.newRect(display.contentWidth / 2, display.contentHeight / 2, 1000, 1000)
	utility.setColour(background, 105, 105, 105)
	screenGroup:insert(background)
	
	for i=1, #gameInputs[1].bulbs do
		local bulb = utility.addNewPicture("lightbulb.png", screenGroup)
		bulb.x = 100 + ((i - 1) % 3) * 150
		bulb.y = 100 + (math.ceil(i / 3) - 1) * 200
		
		local textObject = utility.addBlackCentredText(i, bulb.y - 50, screenGroup, 30)
		textObject.x = bulb.x
		utility.setColour(textObject, 0, 0, 255)
				
		bulb:setFillColor(255,255,255)
		bulb.isWhite = true
		
		if gameInputs[1].bulbs[i] then
			changeBulbColour(bulb)
		end
		
		bulbs[i] = bulb
	end
	
	for i = 1, #gameInputs[1].switches do
		local switch = utility.addNewPicture("switchOn.png", screenGroup)
		switches[i] = switch
		switch.x = 650 + ((i - 1) % 2) * 175
		switch.y = 100 + (math.ceil(i / 2) - 1) * 200		

		switch.bulbs = gameInputs[1].switches[i]
		local str = ""
		
		for j = 1, #switch.bulbs do
			str = str .. switch.bulbs[j] .. " "
		end
		
		local textObject = utility.addBlackCentredText(str, switch.y + 80, screenGroup, 30)
		textObject.x = switch.x
		utility.setColour(textObject, 150, 150, 150)
	end	

end



-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("menu")

	for i=1, #switches do
		local switch = switches[i]
		switch.tap = switchClicked
		switch:addEventListener("tap", switch)
	end
end

function scene:exitScene(event)

end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene