-----------------------------------------------------------------------------------------
--
-- skiShop.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local background
local q1
local q2
local q3
local greyOutCover
local screenGroup
local upgradeButton
local responsiveCost = 3000
local speedCost = 5000
local stabilityCost = 7000

local function addColorText(text, yLocation)
	local textObject = utility.addCentredText(text, 
								yLocation, 
								screenGroup, 
								50, 
								"Exo-DemiBoldItalic")
	textObject:translate(100, 0)							
	textObject:setFillColor(205/255, 127/255, 50/255)
end

local function addTextGroup(text, yLocation, questionMark, questionText, cost, level)
	local responsiveness = utility.addBlackCentredTextWithFont(text, 
								yLocation, 
								screenGroup, 
								30, 
								"Exo-DemiBoldItalic")
	responsiveness:translate(100, 0)
	questionMark:translate(575, responsiveness.y + 30)
	questionMark.qText = questionText
	addColorText(level, responsiveness.y + 50)
	questionMark.cost = cost

end

local function doTransition(object, timeTransition, xJump, yJump)
	object.x = object.x - xJump
	object.y = object.y - yJump
	
	transition.to ( object,{ time= timeTransition, x = (object.x + xJump),y = (object.y + yJump) } ) 
end

-- what to do when the screen loads
function scene:createScene(event)
	print("CREATE MENU")
	screenGroup = self.view

	responsiveCost = 3000
	speedCost = 5000
	stabilityCost = 7000

	local stab = utility.getStability()
	local spe = utility.getSpeed()
	local resp = utility.getResponsiveness()
	
	if stab == "ADVANCED" then
		stabilityCost = 1000000000000
	elseif stab == "INTERMEDIATE" then
		stabilityCost = 10000
	end

	if spe == "ADVANCED" then
		speedCost = 1000000000000
	elseif spe == "INTERMEDIATE" then
		speedCost = 7000
	end
	
	if resp == "ADVANCED" then
		responsiveCost = 1000000000000
	elseif resp == "INTERMEDIATE" then
		responsiveCost = 5000
	end	

	local numCoins = utility.getCoins()

	print("read coins " .. numCoins)

	local maxOptions = 
	{
		parent = screenGroup,
		text = "You have earned the\
maximum level.",
		x = display.contentWidth / 2,
		y = display.contentHeight / 2,
		width = 350,     --required for multi-line and alignment  
		font = "Exo-DemiBoldItalic",   
		fontSize = 35,
		align = "center"
	}
	
	local options = 
	{
		parent = screenGroup,
		text = "Move more quickly when avoiding obstacles.\
You need " .. responsiveCost .. " in coins to upgrade.\
You have " .. numCoins,     
		x = display.contentWidth / 2,
		y = display.contentHeight / 2,
		width = 350,     --required for multi-line and alignment  
		font = "Exo-DemiBoldItalic",   
		fontSize = 35,
		align = "center"
	}
	
	local q1Text
	
	if resp == "ADVANCED" then
		q1Text = display.newText( maxOptions )
	else
		q1Text = display.newText( options )
	end
	
	q1Text:setFillColor( 0, 0, 0 )
	q1Text.isVisible = false	
	
	options.text = "Cover more distance in the same amount of time.\
You need " .. speedCost .. " in coins to upgrade.\
You have " .. numCoins

	local q2Text
	
	if spe == "ADVANCED" then
		q2Text = display.newText( maxOptions )
	else
		q2Text = display.newText( options )
	end

	q2Text:setFillColor( 0, 0, 0 )
	q2Text.isVisible = false
	
	options.text = "Keep skiing even after hitting obstacles. \
You need " .. stabilityCost .. " in coins to upgrade.\
You have " .. numCoins

	local q3Text
	
	if stab == "ADVANCED" then
		q3Text = display.newText( maxOptions )
	else
		q3Text = display.newText( options )
	end
	
	q3Text:setFillColor( 0, 0, 0 )
	q3Text.isVisible = false
	
	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )

	greyOutCover = display.newRect( screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )
	greyOutCover.alpha = 0.95
	greyOutCover.isVisible = false

	local skis = utility.addNewPicture("skis.png", screenGroup)
	skis.x = display.contentWidth / 2 - 180
	skis.y = display.contentHeight / 2

	local textLine1 = utility.addCentredText("SKI SHOP", 
								30, 
								screenGroup, 
								70, 
								"Exo-DemiBoldItalic")
	utility.setColour(textLine1, 111, 183, 214)

	upgradeButton = utility.addCentredText("UPGRADE", 
								675, 
								screenGroup, 
								100, 
								"Exo-DemiBoldItalic")
	utility.setColour(upgradeButton, 111, 183, 214)
	upgradeButton.isVisible = false
			
	q1 = utility.addNewPicture("questionMark.png", screenGroup)
	addTextGroup("RESPONSIVENESS", 220, q1, q1Text, responsiveCost, utility.getResponsiveness())	

	q2 = utility.addNewPicture("questionMark.png", screenGroup)
	addTextGroup("SPEED", 395, q2, q2Text, speedCost, utility.getSpeed())	

	q3 = utility.addNewPicture("questionMark.png", screenGroup)
	addTextGroup("STABILITY", 570, q3, q3Text, stabilityCost, utility.getStability())	

	playText = utility.addBlackCentredTextWithFont("PLAY", 
							800, 
							screenGroup, 
							50, 
							"Exo-DemiBoldItalic")
	utility.setColour(playText, 145, 210, 144)
	
	doTransition(textLine1, 200, 0, 200)
	doTransition(skis, 400, 400, 0)
	doTransition(playText, 600, 0, -600)

end

local function playGame()
	storyboard.gotoScene("first")
end

local function hideQuestions()
	greyOutCover.isVisible = false
	q1.qText.isVisible = false
	q2.qText.isVisible = false
	q3.qText.isVisible = false
	upgradeButton.isVisible = false
end

local function showUpgradeButton(cost)
	if utility.getCoins() >= cost then
		upgradeButton.isVisible = true
		upgradeButton:toFront()
	end
end

local function showQ1()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q1.qText:toFront()
	q1.qText.isVisible = true
	showUpgradeButton(q1.cost)
end

local function showQ2()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q2.qText:toFront()
	q2.qText.isVisible = true
	showUpgradeButton(q2.cost)
end

local function showQ3()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q3.qText:toFront()
	q3.qText.isVisible = true
	showUpgradeButton(q3.cost)
end

local function doNothing()
end

local function doUpgrade()

	if q1.qText.isVisible then
		utility.setCoins(utility.getCoins() - q1.cost)
		utility.upgradeResponsiveness()
	elseif q2.qText.isVisible then
		utility.setCoins(utility.getCoins() - q2.cost)
		utility.upgradeSpeed()
	else 
		utility.setCoins(utility.getCoins() - q3.cost)
		utility.upgradeStability()	
	end
	
	storyboard.gotoScene("refreshSkiShop")
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("first")
	storyboard.purgeScene("menu")

	q1:addEventListener( "tap", showQ1 )
	q2:addEventListener( "tap", showQ2 )
	q3:addEventListener( "tap", showQ3 )
	upgradeButton:addEventListener( "tap", doUpgrade )

	q1:addEventListener( "touch", doNothing )
	q2:addEventListener( "touch", doNothing )
	q3:addEventListener( "touch", doNothing )
	upgradeButton:addEventListener( "touch", doNothing )
	playText:addEventListener( "tap", playGame )

	greyOutCover:addEventListener( "tap", hideQuestions )
end

function scene:exitScene(event)

	q1:removeEventListener( "tap", showQ1 )
	q2:removeEventListener( "tap", showQ2 )
	q3:removeEventListener( "tap", showQ3 )
	greyOutCover:removeEventListener( "tap", hideQuestions )
	playText:removeEventListener( "tap", playGame )

	q1:removeEventListener( "touch", doNothing )
	q2:removeEventListener( "touch", doNothing )
	q3:removeEventListener( "touch", doNothing )
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene