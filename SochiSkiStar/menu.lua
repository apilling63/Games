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
local intro = audio.loadSound("intro.wav")

-- what to do when the screen loads
function scene:createScene(event)

	local screenGroup = self.view
	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )

	local fan = utility.addNewPicture("skiLogo.png", screenGroup)
	fan.x = display.contentWidth / 2 - 1000
	fan.y = display.contentHeight / 2 - 50

	local textLine1 = utility.addBlackCentredTextWithFont("WINTER", 
								-170, 
								screenGroup, 
								60, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine1, 192, 186, 153)				
								
	local textLine2 = utility.addBlackCentredTextWithFont("SKI STAR", 
								textLine1.y + (textLine1.height / 2), 
								screenGroup, 
								100, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine2, 111, 183, 214)

	playText = utility.addCentredText("PLAY", 
							fan.y + (fan.height / 2) + 410, 
							screenGroup, 
							50, 
							"Exo-DemiBoldItalic")				
	utility.setColour(playText, 145, 210, 144)

	achieveText = utility.addBlackCentredTextWithFont("ACHIEVEMENTS", 
							playText.y + 75, 
							screenGroup, 
							50, 
							"Exo-DemiBoldItalic")
	utility.setColour(achieveText, 145, 210, 144)
							
	apButton = utility.addNewPicture("apButton.png", screenGroup)
	apButton.x = display.contentWidth / 2
	apButton.y = achieveText.y + 175 
	timer.performWithDelay(200, flipButtonColour)
	utility.stopSound()
	utility.playSoundWithOptions(intro, {loops=-1})

	transition.to ( textLine1,{ time= 200, x = (textLine1.x),y = (textLine1.y + 200) } ) 
	transition.to ( textLine2,{ time= 200, x = (textLine2.x),y = (textLine2.y + 200) } ) 
	transition.to ( playText,{ time= 400, x = (playText.x),y = (playText.y - 400) } ) 
	transition.to ( achieveText,{ time= 400, x = (achieveText.x),y = (achieveText.y - 400) } ) 
	transition.to ( apButton,{ time= 400, x = (apButton.x),y = (apButton.y - 400) } ) 
	transition.to ( fan,{ time= 1000, x = (fan.x + 1000),y = (fan.y) } ) 



end

local function showAPGames()
	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
		system.openURL("https://itunes.apple.com/us/artist/app-app-n-away/id604407181")
	else
		system.openURL("https://play.google.com/store/apps/developer?id=AP%20SOFTWARE%20DEVELOPMENT")
	end
end

local function playGame()
	storyboard.gotoScene("skiShop")
end

local function goToAchievements()
	storyboard.gotoScene("achievements")
end


-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("leaderboard")
	storyboard.purgeScene("achievements")

	playText:addEventListener( "tap", playGame )
	achieveText:addEventListener( "tap", goToAchievements )
	apButton:addEventListener("tap", showAPGames)
end

function scene:exitScene(event)
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