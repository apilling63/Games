-----------------------------------------------------------------------------------------
--
-- achievements.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local utility = require "utility"
local gameData = require "gameData"
local ding = audio.loadSound("ding.wav")

local scene = storyboard.newScene()

local function addTextBox(textString, screenGroup, yLocation, earned)
	
	local closure = function()
		local textObject = display.newText(textString, 0, 0, "Exo-DemiBoldItalic", 30)
		screenGroup:insert(textObject)
		textObject.anchorX = 0				
		textObject.x = 80
		textObject.y = yLocation
		textObject:setFillColor(0,0,0)
		utility.setColour(textObject, 145, 210, 144)
			
		local image = display.newImageRect("images/medals.png", 90, 50) 
		screenGroup:insert(image)
		image.anchorX = 0		
		image.x = 460
		image.y = yLocation
		
		if earned == false then
			image.alpha = 0.5
		else
			utility.playSound(ding)
		end
	end
	
	timer.performWithDelay(yLocation * 5, closure)
	
	return yLocation + 70
end



-- what to do when the screen loads
function scene:createScene(event)

	screenGroup = self.view

	local background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )
			
	local textLine1 = utility.addCentredText("ACHIEVEMENTS", 
								30, 
								screenGroup, 
								70, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine1, 111, 183, 214)

	local yLocation = 200				
	local bronzes = utility.getBronzeMedals()
	local silvers = utility.getSilverMedals()
	local golds = utility.getGoldMedals()
	yLocation = addTextBox("WIN A BRONZE MEDAL", screenGroup, yLocation, bronzes > 0)
	yLocation = addTextBox("WIN A SILVER MEDAL", screenGroup, yLocation, silvers > 0)
	yLocation = addTextBox("WIN A GOLD MEDAL", screenGroup, yLocation, golds > 0)
	yLocation = addTextBox("WIN 10 BRONZE MEDALS", screenGroup, yLocation, bronzes > 9)
	yLocation = addTextBox("WIN 10 SILVER MEDALS", screenGroup, yLocation, silvers > 9)
	yLocation = addTextBox("WIN 10 GOLD MEDALS", screenGroup, yLocation, golds > 9)
	
	local distanceTotal = utility.getDistanceTotal()
	
	yLocation = addTextBox("SKI 500000m OVERALL", screenGroup, yLocation, distanceTotal > 499999)
	yLocation = addTextBox("SKI 1000000m OVERALL", screenGroup, yLocation, distanceTotal > 999999)
	
	local numCoins = utility.getCoinTotal()
	
	yLocation = addTextBox("COLLECT 1000 COINS", screenGroup, yLocation, numCoins > 999)
	yLocation = addTextBox("COLLECT 10000 COINS", screenGroup, yLocation, numCoins > 9999)

	print(bronzes)
	print(silvers)
	print(golds)
	print(distanceTotal)
	print(numCoins)

end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("menu")
	
	local closure = function()
		storyboard.gotoScene("menu")
	end
	
	timer.performWithDelay(12000, closure)
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