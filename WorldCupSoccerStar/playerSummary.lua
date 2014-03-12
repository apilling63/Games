-----------------------------------------------------------------------------------------
--
-- playerSummary.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local background
local playText
local screenGroup
local greyOutCover
local q1
local q2
local q3

local function mapRankToText(rank)
	return "PARK PLAYER"
end

local function addText(text, yLocation, percentage)
	local textObj = utility.addBlackCentredTextWithFont(	text, 
								yLocation, 
								screenGroup, 
								40, 
								"Exo-DemiBoldItalic")
	textObj:translate(150, 0)

	local textObjPercent = utility.addBlackCentredTextWithFont(	percentage .. "%", 
								textObj.y + 45, 
								screenGroup, 
								40, 
								"Exo-DemiBoldItalic")
	textObjPercent:translate(150, 0)

	return textObj
end

-- what to do when the screen loads
function scene:createScene(event)
	print("CREATE MENU")
	screenGroup = self.view

	greyOutCover = display.newRect( screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )
	greyOutCover.alpha = 0.9
	greyOutCover.isVisible = false

	local options = 
	{
		parent = screenGroup,
		text = "The better your high score, the higher the skill percentage",     
		x = display.contentWidth / 2,
		y = display.contentHeight / 2,
		width = 350,     --required for multi-line and alignment  
		font = "Exo-DemiBoldItalic",   
		fontSize = 35,
		align = "center"
	}

	local q1Text = display.newText( options )
	q1Text:setFillColor( 0, 0, 0 )
	
	options.text = "The more you play, the higher your fitness"
	local q2Text = display.newText( options )
	q2Text:setFillColor( 0, 0, 0 )
	
	options.text = "The more you post, the higher your popularity"
	local q3Text = display.newText( options )
	q3Text:setFillColor( 0, 0, 0 )

	options.text = "All three attributes but reach the next limit before you can trial for the next rank"
	local q4Text = display.newText( options )
	q4Text:setFillColor( 0, 0, 0 )

	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentWidth, 
					display.actualContentHeight )

	local fan = utility.addNewPicture("soccerFan.png", screenGroup)
	fan.x = (display.contentWidth / 2) - 100
	fan.y = (display.contentHeight / 2) - 200

	local skillPercent = utility.getSkillPercentage()
	local skill = addText("SKILL", 65, skillPercent)
	local fitnessPercent = utility.getDistancePercentage()
	local fitness = addText("FITNESS", skill.y + (skill.height / 2) + 100, fitnessPercent)
	local popPercent = 100
	local pop = addText("POPULARITY", fitness.y + (fitness.height / 2) + 100, popPercent)

	local rank = utility.getRank()
	local rankString = mapRankToText(rank)

	local rankText = utility.addBlackCentredTextWithFont(	"Your rank is " .. rankString, 
								fan.y + (fan.height / 2) + 30, 
								screenGroup, 
								40, 
								"Exo-DemiBoldItalic")

	local nextRankPercent = (rank + 1) * 10
	local playString = "TRAIN"

	if (popPercent > nextRankPercent) and 
		(fitnessPercent > nextRankPercent) and 
		(skillPercent > nextRankPercent) then

		playString = "DO TRIAL!!"
	else

	local adviceText1 = utility.addBlackCentredTextWithFont("You need to reach ".. nextRankPercent .. "%", 
							rankText.y + 80, 
							screenGroup, 
							30, 
							"Exo-DemiBoldItalic")
	local adviceText2 = utility.addBlackCentredTextWithFont("to trial for the next rank", 
							rankText.y + 125, 
							screenGroup, 
							30, 
							"Exo-DemiBoldItalic")


	end

	playText = utility.addBlackCentredTextWithFont(playString, 
							fan.y + (fan.height / 2) + 225, 
							screenGroup, 
							70, 
							"Exo-DemiBoldItalic")


	q1 = utility.addNewPicture("questionMark.png", screenGroup)
	q1:translate(575, 150)
	q1.qText = q1Text
	q2 = utility.addNewPicture("questionMark.png", screenGroup)
	q2:translate(575, 285)
	q2.qText = q2Text
	q3 = utility.addNewPicture("questionMark.png", screenGroup)
	q3:translate(575, 420)
	q3.qText = q3Text
	q4 = utility.addNewPicture("questionMark.png", screenGroup)
	q4:translate(575, 630)
	q4.qText = q4Text
end

local function hideQuestions()
	print("HIDE")
	greyOutCover.isVisible = false
	q1.qText:toBack()
	q2.qText:toBack()
	q3.qText:toBack()
	q4.qText:toBack()

end

local function showQ1()
	print("Hello Q1")
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q1.qText:toFront()
end

local function showQ2()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q2.qText:toFront()
end

local function showQ3()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q3.qText:toFront()
end

local function showQ4()
	greyOutCover.isVisible = true
	greyOutCover:toFront()
	q4.qText:toFront()
end

local function playGame()
	print("GO TO FIRST")
	storyboard.gotoScene("first")
end

local function doNothing()
end


-- add all the event listening
function scene:enterScene(event)
	print("ENTER MENU")

	storyboard.purgeScene("menu")

	playText:addEventListener( "tap", playGame )
	q1:addEventListener( "tap", showQ1 )
	q2:addEventListener( "tap", showQ2 )
	q3:addEventListener( "tap", showQ3 )
	q4:addEventListener( "tap", showQ4 )

	q1:addEventListener( "touch", doNothing )
	q2:addEventListener( "touch", doNothing )
	q3:addEventListener( "touch", doNothing )

	greyOutCover:addEventListener( "tap", hideQuestions )

end

function scene:exitScene(event)
	print("EXIT MENU")

	playText:removeEventListener( "tap", playGame )
	q1:removeEventListener( "tap", showQ1 )
	q2:removeEventListener( "tap", showQ2 )
	q3:removeEventListener( "tap", showQ3 )
	q4:removeEventListener( "tap", showQ4 )
	greyOutCover:removeEventListener( "tap", hideQuestions )

	q1:removeEventListener( "touch", doNothing )
	q2:removeEventListener( "touch", doNothing )
	q3:removeEventListener( "touch", doNothing )
	q4:removeEventListener( "touch", doNothing )

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene