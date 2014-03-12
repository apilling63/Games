-----------------------------------------------------------------------------------------
--
-- levels.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local utility = require "utility"
local gameData = require "gameData"
local ads = require "ads"

local lastCompletedLevel = 0
local scene = storyboard.newScene()
local jellies
local leftButton
local rightButton
local leftVisible = true
local adCounter = 1
local canPress = true

local function enablePress()
	canPress = true
end

local function moveLeft()

	if canPress and leftVisible == false then
		canPress = false
	
		for i = 1, #jellies do
			transition.to ( jellies[i],{ time= 500, x = (jellies[i].x + 1500) } ) 
			transition.to ( jellies[i].text,{ time= 500, x = (jellies[i].text.x + 1500), onComplete = enablePress} ) 
		end
		leftVisible = true
		rightButton.alpha = 1
		leftButton.alpha = 0.3
	end
end

local function moveRight()
	if canPress and leftVisible then
		canPress = false
	
		for i = 1, #jellies do
			transition.to ( jellies[i],{ time= 500, x = (jellies[i].x - 1500) } ) 
			transition.to ( jellies[i].text,{ time= 500, x = (jellies[i].text.x - 1500) , onComplete = enablePress} ) 			
		end

		leftVisible = false
		rightButton.alpha = 0.3
		leftButton.alpha = 1
	end

end

local function playGame(self, event)
	gameData.chosenLevel = self.index
	storyboard.gotoScene("first")
end

local function addButton(index, screenGroup)
	local jelly = utility.addNewPicture("jelly.png", screenGroup)
	utility.putInCentre(jelly)
	jelly:scale(0.5, 0.5)
	
	local textLine1 = utility.addBlackCentredTextWithFont(index, 
								0, 
								screenGroup, 
								40, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine1, 175, 0, 175)	
	utility.putInCentre(textLine1)
	
	local xValue = 80 + ((index - 1) % 6) * 160	
	local yValue = 75 + math.floor((index - 1)/ 6) * 140
	
	if index > 24 then
		xValue = xValue + 1500
		yValue = 75 + math.floor((index - 25)/ 6) * 140		
	end
	
	jelly.x = xValue
	jelly.y = yValue
	
	textLine1.x = xValue
	textLine1.y = yValue - 30

	jelly.text = textLine1

	if index <= (lastCompletedLevel + 1) then
		jelly.index = index
		jelly.tap = playGame
		jelly:addEventListener("tap", jelly)
	else
		jelly.alpha = 0.3
	end
	
	table.insert(jellies, jelly)
end

-- what to do when the screen loads
function scene:createScene(event)
	leftVisible = true
	jellies = {}
	lastCompletedLevel = utility.getLastCompletedLevel()
	
	local screenGroup = self.view
	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentHeight,
					display.actualContentWidth)
	utility.setColour(background, 0,186,225)
			
	for i = 1, 48 do
		addButton(i, screenGroup)
	end
	
	rightButton = utility.addNewPicture("right.png", screenGroup)
	utility.putInCentre(rightButton)
	
	rightButton.x = 530
	rightButton.y = jellies[#jellies].y + 100	

	leftButton = utility.addNewPicture("right.png", screenGroup)
	utility.putInCentre(leftButton)
	
	leftButton.x = 430
	leftButton.rotation = 180
	leftButton.y = jellies[#jellies].y + 100
	leftButton.alpha = 0.3
	
	if lastCompletedLevel > 23 then
		moveRight()		
	else
		canPress = true
	end
	
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("menu")
	storyboard.purgeScene("first")
	
	rightButton:addEventListener("tap", moveRight)
	leftButton:addEventListener("tap", moveLeft)

		print("entering")

	if (adCounter % 4) == 0 then
		print("show ad")
		ads.show( "interstitial", { isBackButtonEnabled = true } )
	end
	
	adCounter = adCounter + 1
	
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