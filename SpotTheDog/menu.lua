-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local gameData = require ("gameData")

local buttonsLayer
local previousX
local playButtons

local function startGame(self, event)
	gameData.difficulty = self.difficulty
	gameData.numAnswers = self.numAnswers

	print("answers " .. gameData.numAnswers)

	storyboard.gotoScene("first")

end

local function moveLayer(event)

	if event.phase == "began" then
		previousX = event.x
	elseif event.phase == "moved" then
		local diff = event.x - previousX
		buttonsLayer.x = buttonsLayer.x + diff
		buttonsLayer.x = math.max(-700, buttonsLayer.x)
		buttonsLayer.x = math.min(0, buttonsLayer.x)
		previousX = event.x
	end

end

local function addPlayButton(difficulty, numToFind, xLocation, yLocation)
	local playButton = utility.addNewPicture("playButton.png", buttonsLayer)
	playButton:translate(xLocation, yLocation)
	playButton.numAnswers = numToFind
	playButton.difficulty = difficulty
	table.insert(playButtons, playButton)
end

-- what to do when the screen loads
function scene:createScene(event)

	screenGroup = self.view

	buttonsLayer = display.newGroup()

	local path = utility.addNewPicture("path.png", buttonsLayer)
	utility.centreObjectY(path)

	playButtons = {}

	addPlayButton(1, 1, 100, 120)
	addPlayButton(1, 2, 200, 180)
	addPlayButton(2, 2, 300, 185)
	addPlayButton(2, 3, 400, 195)
	addPlayButton(3, 3, 500, 155)
	addPlayButton(4, 3, 600, 165)
	addPlayButton(8, 3, 600, 165)

end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("first")
	buttonsLayer:addEventListener("touch", moveLayer)

	for i = 1, #playButtons do
		local button = playButtons[i]
		button.tap = startGame
		button:addEventListener("tap", button)
	end

end

function scene:exitScene(event)
	buttonsLayer:removeEventListener("touch", buttonsLayer)

	for i = 1, #playButtons do
		local button = playButtons[i]
		button:removeEventListener("tap", button)
	end

	for i = buttonsLayer.numChildren,1,-1 do
	        local child = buttonsLayer[i]
        	child.parent:remove( child )
	end
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene