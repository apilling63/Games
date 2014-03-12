-----------------------------------------------------------------------------------------
--
-- leaderboard.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local utility = require "utility"
local gameData = require "gameData"
local ding = audio.loadSound("ding.wav")
local ads = require "ads"
local myRank = 0

local scene = storyboard.newScene()

local function returnToMenu()
	ads.show( "interstitial", { isBackButtonEnabled = true } )
	storyboard.gotoScene("menu")
end

local function checkAchievements()
	local runNumber = gameData.getOnlyRunNumber()
	
	if runNumber == 2 then	
		local message = "You didn't win a medal\
this time - keep trying!"
		local greyOutCover = display.newRect( screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )
		greyOutCover.alpha = 0.95	
				
		print("my rank is " .. myRank)
										
		if myRank < 4 then
			message = "Congratulations!\
You won a "
				
			local medal = "gold"
			
			if myRank == 3 then
				message = message .. "BRONZE medal"
				medal = "bronze"
				utility.addBronzeMedal()
			elseif myRank == 2 then
				message = message .. "SILVER medal"
				medal = "silver"
				utility.addSilverMedal()
			else
				message = message .. "GOLD medal"			
				utility.addGoldMedal()
			end
			
			local medalImage = utility.addNewPicture(medal .. "Medal.png", screenGroup)
			medalImage.x = display.contentWidth / 2
			medalImage.y = display.contentHeight / 2 - 225
		end 	
		
		local options = 
						{
						parent = screenGroup,
						text = message,     
						x = display.contentWidth / 2,
						y = display.contentHeight / 2,
						width = 350,     --required for multi-line and alignment  
						font = "Exo-DemiBoldItalic",   
						fontSize = 35,
						align = "center"
						}	
						
		local textObject = display.newText( options )
		utility.setColour(textObject, 145, 210, 144)
		
		timer.performWithDelay(5000, returnToMenu)

	else
		storyboard.gotoScene("first")
	end
end

local function addTextBox(textString, score, flag, screenGroup, rank)

	local myScore = gameData.getMyScore()
	
	if myScore > score and myRank == 0 then
		myRank = rank
		rank = addTextBox("YOU", myScore, "medals", screenGroup, rank)
	end

	local yLocation = 100 + (rank * 70)

	local closure = function()
		local textObject = display.newText(textString, 0, 0, "Exo-DemiBoldItalic", 30)
		screenGroup:insert(textObject)
		textObject.anchorX = 0				
		textObject.x = 50
		textObject.y = yLocation
		textObject:setFillColor(0,0,0)
		utility.setColour(textObject, 145, 210, 144)

		local textObject2 = display.newText(score, 0, 0, "Exo-DemiBoldItalic", 30)
		screenGroup:insert(textObject2)
		textObject2.anchorX = 1			
		textObject2.x = 500
		textObject2.y = yLocation
		textObject2:setFillColor(0,0,0)		
		utility.setColour(textObject2, 145, 210, 144)

		local image = display.newImageRect("images/" .. flag .. ".jpeg", 75, 50) 
		screenGroup:insert(image)
		image.anchorX = 0		
		image.x = 520
		image.y = yLocation
		
		utility.playSound(ding)
	end
		
	timer.performWithDelay(yLocation * 5, closure)
	
	return rank + 1
end



-- what to do when the screen loads
function scene:createScene(event)

	screenGroup = self.view
	myRank = 0
	
	local background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )
			
	local runNumber = gameData.getOnlyRunNumber()
			
	local textLine1 = utility.addCentredText("SCORES AFTER RUN " .. runNumber, 
								30, 
								screenGroup, 
								50, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine1, 111, 183, 214)

	local rank = 1				
	rank = addTextBox("YEVGENY DIMITROV", math.random(61000, 70000) * runNumber, "russian", screenGroup, rank)
	rank = addTextBox("BJORN SVENSSON", math.random(42000, 60000) * runNumber, "swedish", screenGroup, rank)
	rank = addTextBox("ANDERS MULLER", math.random(26000, 40000) * runNumber, "german", screenGroup, rank)
	rank = addTextBox("TIM WEST", math.random(15000, 25000) * runNumber, "british", screenGroup, rank)
	rank = addTextBox("SHAUN JOHNSON", math.random(10000, 14000) * runNumber, "american", screenGroup, rank)
	rank = addTextBox("BRAD ADAMS", math.random(3100, 3300) * runNumber, "canadian", screenGroup, rank)
	rank = addTextBox("GUNNAR FJORTOFT", math.random(1500, 1750) * runNumber, "norwegian", screenGroup, rank)
	rank = addTextBox("PETER KOHL", math.random(500, 550) * runNumber, "austrian", screenGroup, rank)
	rank = addTextBox("MASSIMO GENNARRO", math.random(10, 80) * runNumber, "italian", screenGroup, rank)

	timer.performWithDelay(8000, checkAchievements)
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("first")	
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