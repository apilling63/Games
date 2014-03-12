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
local crosshair
local objectToHide
local bottomLeftSquare
local playButton
local background
local seekX
local seekY
local screenGroup

local function flashCrosshair()

	if crosshair.isVisible then
		if crosshair.isBlack then
			utility.setColour(crosshair, 244, 244, 244)
			crosshair.isBlack = false
		else
			utility.setColour(crosshair, 2, 2, 2)
			crosshair.isBlack = true
		end
		
		timer.performWithDelay(100, flashCrosshair)
	end
end

local function seekChoice(event)
	playButton.isVisible = false
	crosshair.isVisible = false
	local textObject
	
	if math.abs(event.x - seekX) < 30 and math.abs(event.y - seekY) < 50 then
		textObject = utility.addBlackCentredText("WELL DONE", 0, screenGroup, 100)
	else
		textObject = utility.addBlackCentredText("UNLUCKY!!!", 0, screenGroup, 100)	
	end
	
	utility.putInCentre(textObject)
	textObject.y = playButton.y
	utility.setColour(textObject, 255, 255, 255)
	crosshair.isVisible = true
	flashCrosshair()
	
	local closure = function()
		storyboard.gotoScene("doNothing")	
	end
	
	timer.performWithDelay(3000, closure)
	
end

local function startSeek()
	playButton.isVisible = false
	crosshair.isVisible = false
	seekX = objectToHide.x
	seekY = objectToHide.y
	
	local closure = function()
		background:addEventListener("tap", seekChoice)
	end
	
	timer.performWithDelay(500, closure)
end


local function moveTarget(event)
	if crosshair.isVisible and event.x > 30 and event.y > 50 and event.y < 590 and event.x < 930 then
		playButton.isVisible = false
		crosshair.x = event.x
		crosshair.y = event.y

		objectToHide.x = event.x
		objectToHide.y = event.y	
		
		if bottomLeftSquare.isVisible then
			if event.x > 150 or event.y < 490 then
				bottomLeftSquare.isVisible = false
			end
		end
	end
	
	if event.phase == "ended" and bottomLeftSquare.isVisible == false then
		playButton.isVisible = true
		
		if event.y < 320 then
			playButton.y = 490
		else
			playButton.y = 150
		end
	end
end

-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view

	background = utility.addNewPicture("camels.png", screenGroup)
	utility.putInCentre(background)

	bottomLeftSquare = display.newCircle(0,0,100)
	screenGroup:insert(bottomLeftSquare)
	bottomLeftSquare.x = 75
	bottomLeftSquare.y = 565
	
	objectToHide = utility.addNewPicture("camel.png", screenGroup)
	utility.putInCentre(objectToHide)

	objectToHide.x = 75
	objectToHide.y = 565
	
	crosshair = utility.addNewPicture("crosshair.png", screenGroup)
	utility.putInCentre(crosshair)

	crosshair.x = 75
	crosshair.y = 565
		
	playButton = utility.addNewPicture("playButton.png", screenGroup)
	utility.putInCentre(playButton)
	playButton.isVisible = false

	timer.performWithDelay(100, flashCrosshair)
end



-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("doNothing")

	crosshair:addEventListener("touch", moveTarget)
	playButton:addEventListener("tap", startSeek)
	
	local gn = require( "gameNetwork" )

	gn.init( "gamecenter" )	
end

function scene:exitScene(event)
	crosshair:removeEventListener("touch", moveTarget)
	playButton:removeEventListener("tap", startSeek)
	background:removeEventListener("tap", seekChoice)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene