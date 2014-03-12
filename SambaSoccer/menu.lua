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
local background
local playText

-- what to do when the screen loads
function scene:createScene(event)
	print("CREATE MENU")
	local screenGroup = self.view

	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )

	local fan = utility.addNewPicture("soccerFan.png", screenGroup)
	fan.x = display.contentWidth / 2
	fan.y = display.contentHeight / 2

	local textLine1 = utility.addBlackCentredTextWithFont("WORLD CUP", 50, screenGroup, 70, "Exo-DemiBoldItalic")
	local textLine2 = utility.addBlackCentredTextWithFont("SUPERSTAR", textLine1.y + (textLine1.height / 2) + 30, screenGroup, 70, "Exo-DemiBoldItalic")

	playText = utility.addBlackCentredTextWithFont("PLAY", fan.y + (fan.height / 2) + 30, screenGroup, 70, "Exo-DemiBoldItalic")


end

local function playGame()
	print("GO TO FIRST")
	storyboard.gotoScene("first")
end

-- add all the event listening
function scene:enterScene(event)
	print("ENTER MENU")

	storyboard.purgeScene("first")
	storyboard.purgeScene("second")

	playText:addEventListener( "tap", playGame )

end

function scene:exitScene(event)
	print("EXIT MENU")

	playText:removeEventListener( "tap", playGame )


end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene