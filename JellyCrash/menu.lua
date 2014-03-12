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

local background
local playText
local achieveText
local apButton
local counter = 0
local isApple = true
local adCounter = 1

-- what to do when the screen loads
function scene:createScene(event)
	local screenGroup = self.view
	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentHeight,
					display.actualContentWidth)
	utility.setColour(background, 0,186,225)

	local fan = utility.addNewPicture("jelly.png", screenGroup)
	fan.x = display.contentWidth / 2 - 1400
	fan.y = display.contentHeight / 2 - 20
								
	local textLine2 = utility.addBlackCentredTextWithFont("SPLASHING FISH", 
								-190, 
								screenGroup, 
								100, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine2, 175, 0, 175)

	playText = utility.addCentredText("PLAY", 
							fan.y + (fan.height / 2) + 400, 
							screenGroup, 
							50, 
							"Exo-DemiBoldItalic")				
	utility.setColour(playText, 175, 0, 175)
		
	achieveText = utility.addBlackCentredTextWithFont("ACHIEVEMENTS", 
							playText.y + 75, 
							screenGroup, 
							50, 
							"Exo-DemiBoldItalic")
	utility.setColour(achieveText, 145, 210, 144)
	achieveText.isVisible = false
							
	apButton = utility.addNewPicture("freeGames.png", screenGroup)
	apButton.x = 1400
	apButton.y = 300 
		
	timer.performWithDelay(200, flipButtonColour)
	utility.stopSound()

	transition.to ( textLine2,{ time= 200, x = (textLine2.x),y = (textLine2.y + 200) } ) 
	transition.to ( playText,{ time= 400, x = (playText.x),y = (playText.y - 400) } ) 
	transition.to ( achieveText,{ time= 400, x = (achieveText.x),y = (achieveText.y - 400) } ) 
	transition.to ( fan,{ time= 1200, x = (fan.x + 1400),y = (fan.y) }) 	
	transition.to ( apButton,{ time= 600, x = (apButton.x - 600),y = (apButton.y) } ) 

end

local function showAPGames()
	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
		system.openURL("https://itunes.apple.com/us/artist/app-app-n-away/id604407181")
	else
		system.openURL("https://play.google.com/store/apps/developer?id=AP%20SOFTWARE%20DEVELOPMENT")
	end
end

local function playGame()
	storyboard.gotoScene("levels")
end

local function goToAchievements()
	storyboard.gotoScene("achievements")
end


-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("achievements")
	storyboard.purgeScene("first")

	playText:addEventListener( "tap", playGame )
	achieveText:addEventListener( "tap", goToAchievements )
	apButton:addEventListener("tap", showAPGames)
	
end

function scene:exitScene(event)
	counter = counter + 1
	achieveText:removeEventListener( "tap", goToAchievements )
	playText:removeEventListener( "tap", playGame )
	apButton:removeEventListener("tap", showAPGames)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene