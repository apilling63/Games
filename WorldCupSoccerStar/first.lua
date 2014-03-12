-----------------------------------------------------------------------------------------
--
-- first.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local ads = require "ads"
local lottery = require "lottery"
local adder = require "objectAdder"
local checker = require "objectChecker"

local canMovePlayer = true
local movingObjects = {}
local lowObjects = {}
local highObjects = {}

local background
local player
local playerSliding
local playerJumping
local playerStanding
local playerSpeed = 20
local inPlay = true
local screenGroup
local counter
local distanceCounter
local scoreText
local distanceText
local lastHardObstacle
local obstacleYSpeed = 2
local ball
local timeToGoal
local timeStarted
local failText1
local failText2
local gameOverText
local hasYellow
local yellowCard
local redCard
local invincible
local transitionTime
local slowMultiplier
local addingObstacles
local gapBetweenObstacles
local textToFade = {}
local touchBegan = false
local scorePromptText
local scorePromptText2

local function finishSliding()
	if inPlay then
		playerSliding.isVisible = false
		playerStanding.isVisible = true
		canMovePlayer = true
		player.state = "running"
	end
end

local function finishJumping()
	if inPlay then
		playerJumping.isVisible = false
		playerStanding.isVisible = true
		canMovePlayer = true
		player.state = "running"
	end
end

local function fadeText()
	for i=#textToFade,1,-1 do
        local child = textToFade[i]

		if child.alpha < 0.1 then
			table.remove(textToFade, i)
			child:removeSelf()
		else
			child.alpha = child.alpha - 0.03
			child.y = child.y - 0.5
		end
	end
end

local function turnOffInvincible()
	player.alpha = 1
	invincible = false
end

local function restartObstacles()
	addingObstacles = true
	gameOverText.text = ""
end

local function makeFaster()

	if inPlay and gapBetweenObstacles > 600 then
		transitionTime = transitionTime * slowMultiplier
		gapBetweenObstacles = gapBetweenObstacles * slowMultiplier
		addingObstacles = false
		timer.performWithDelay(20000, makeFaster)
		gameOverText.text = "SPEEDING UP!"
		timer.performWithDelay(2000, restartObstacles)
	elseif hasYellow then
		timer.performWithDelay(20000, makeFaster)	
	end
end

local function returnToMenu()
	transition.cancel(transitions)
	storyboard.gotoScene("menu")
end

local function addPickup()

	if inPlay then
		if addingObstacles then
			adder.addPickup(screenGroup, background, movingObjects, transitionTime)
		end

		timer.performWithDelay(800, addPickup)

	elseif hasYellow then
		timer.performWithDelay(800, addPickup)	
	end
end

local function addObstacle()

	if inPlay then
		if addingObstacles then

			timer.performWithDelay(gapBetweenObstacles, addObstacle)	
			local random = math.random(1, 4)

			if random == 2 and os.time() > (lastHardObstacle + 2) then
				lastHardObstacle = os.time()

				local rand2 = math.random(1,3)
				if rand2 == 1 then
					adder.addHighObject(screenGroup, background, highObjects, transitionTime)
				elseif rand2 == 2 then
					adder.addLowObject(screenGroup, background, lowObjects, transitionTime)
				else
					adder.addWall(screenGroup, background, movingObjects, transitionTime)
				end
			else
				adder.addCone(screenGroup, background, movingObjects, transitionTime)
			end
		else
			timer.performWithDelay(gapBetweenObstacles, addObstacle)	
		end

	elseif hasYellow then
		timer.performWithDelay(gapBetweenObstacles, addObstacle)	
	end
end

local function countMeters()
	if inPlay then
		distanceCounter = distanceCounter + 1
		distanceText.text = distanceCounter .. "m"
		timer.performWithDelay(20, countMeters)
	elseif hasYellow then
		timer.performWithDelay(20, countMeters)	
	end
end

local function restart()

	local closure = function()
		timeStarted = os.time()
		inPlay = true
		timer.performWithDelay(20, countMeters)
		timer.performWithDelay(500, addObstacle)
		timer.performWithDelay(10000, makeFaster)
		timer.performWithDelay(700, addPickup)
		scorePromptText.text = ""
		scorePromptText2.text = ""
	end

	playerStanding:play()
	background:play()
	timer.performWithDelay(2000, closure)

end

-- what to do when the screen loads
function scene:createScene(event)
	inPlay = false
	counter = 0
	distanceCounter = 0
	gapBetweenObstacles = 1200
	gapBetweenObstaclesStartValue = 1200

	lastHardObstacle = 0
	timeToGoal = 120
	hasYellow = false
	invincible = false
	transitionTime = 2500
	slowMultiplier = 0.9
	addingObstacles = true
	screenGroup = self.view

	background = utility.addBackgroundSprite()
	utility.putInMiddle(background)
	screenGroup:insert(background)

	player = display.newGroup()
	playerSliding = utility.addNewPicture("playerSliding.png", player)
	playerSliding.isVisible = false
	playerJumping = utility.addNewPicture("playerJumping.png", player)
	playerJumping.isVisible = false
	playerStanding = utility.addPlayerSprite()
	player:insert(playerStanding)

	player.anchorY = 1
 	player:translate(display.contentWidth / 2, 700)
	player.state = "running"
	player.movement = 0
	player.lastAlphaChange = 0
	screenGroup:insert(player)

	scoreText = utility.addBlackCentredTextWithFont("0", 70, screenGroup, 50, "Exo-DemiBoldItalic")
	scoreText:translate(-200, 0)

	distanceText = utility.addBlackCentredTextWithFont("0m", 70, screenGroup, 50, "Exo-DemiBoldItalic")
	distanceText:translate(200, 0)

	scorePromptText = utility.addBlackCentredTextWithFont("Score 50000", (display.contentHeight / 2) - 100, screenGroup, 50, "Exo-DemiBoldItalic")
	scorePromptText2 = utility.addBlackCentredTextWithFont("to Progress", (display.contentHeight / 2) - 30, screenGroup, 50, "Exo-DemiBoldItalic")

	yellowCard = utility.addNewPicture("yellowCard.png", screenGroup)
	utility.putInMiddle(yellowCard)
	yellowCard.isVisible = false

	redCard = utility.addNewPicture("redCard.png", screenGroup)
	utility.putInMiddle(redCard)
	redCard.isVisible = false

	failText1 = utility.addCentredText("", display.contentHeight / 2, screenGroup, 30, "Exo-DemiBoldItalic")
	failText2 = utility.addCentredText("", (display.contentHeight / 2) + 50, screenGroup, 30, "Exo-DemiBoldItalic")
	gameOverText = utility.addCentredText("", (display.contentHeight / 2) - 100, screenGroup, 50, "Exo-DemiBoldItalic")

end

local function restartAfterYellow()
	yellowCard.isVisible = false
	failText1.text = ""
	failText2.text = ""
	gameOverText.text = ""
	playerStanding:play()
	background:play()
	inPlay = true

	if player.state == "jumping" then
		finishJumping()
	elseif player.state == "sliding" then
		finishSliding()
	end

	transition.resume(transitions)
end

local function rescindResponse(event)
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
        	utility.setNumRescinds(utility.getNumRescinds() - 1)
        	
        	local closure = function()
    	 		restartAfterYellow()
	        	hasYellow = false
        	end

	        timer.performWithDelay(500, closure)

        elseif 2 == i then
	        timer.performWithDelay(500, restartAfterYellow)
        end
        

    end
end

local function promptRescind()
	native.showAlert("Rescind!", "Do you want to rescind this yellow card?", {"Yes", "No"}, rescindResponse)
end

local function hitObstacle(reason, tip)
	if invincible == false then
		playerStanding:pause()
		background:pause()
		inPlay = false
		transition.pause(transitions)

		if hasYellow then
			hasYellow = false
			redCard.isVisible = true

			if counter > utility.getHighScore() then
				gameOverText.text = "NEW HIGH SCORE!"
				utility.setHighScore(counter)
			else
				gameOverText.text = "RED CARD"
			end

			local totalDistance = utility.getTotalDistance()
			local newTotalDistance = totalDistance + distanceCounter
			utility.setTotalDistance(newTotalDistance)
			
			local closure = function()
				lottery.doFinalLottery(returnToMenu)
			end
			
			timer.performWithDelay(5000, closure)
		else
			gameOverText.text = "YELLOW CARD"
			hasYellow = true
			yellowCard.isVisible = true
			
			if utility.getNumRescinds() > 0 then
				promptRescind()
			else
				timer.performWithDelay(3000, restartAfterYellow)
			end
			
		end

		failText1.text = reason
		failText2.text = tip
	end


end

local function isObjectInRange(obj)
	return math.abs(obj.y - player.y - 60) < 15
end

local function isObjectBeyondRange(obj)
	return (obj.y - player.y - 60) > 15
end

local function startInvincible()
	invincible = true
	timer.performWithDelay(7500, turnOffInvincible)
end

local function decreaseGap()
	if gapBetweenObstacles < gapBetweenObstaclesStartValue then
		transitionTime = transitionTime / slowMultiplier
		gapBetweenObstacles = gapBetweenObstacles / slowMultiplier
	end
end

local function pickup(value)
	local textToShow = utility.addBlackCentredTextWithFont("+" .. value, 
								scoreText.y - 20, 
								screenGroup, 
								50, 
								"Exo-DemiBoldItalic")
	textToShow:translate(-200, 0)
	table.insert(textToFade, textToShow)
	counter = counter + value
	scoreText.text = counter
end

local function checkObstacles(context)
	if inPlay then
		checker.checkMovingObstacles(movingObjects, hitObstacle, pickup, startInvincible, decreaseGap, player)		
		checker.checkHighObstacles(highObjects, hitObstacle, player)
		checker.checkLowObstacles(lowObjects, hitObstacle, player)
	end
end

local function movePlayer()

	if inPlay then
		if (player.x == 200) or (player.x == 440) or (player.x == 320) then
			player.movement = 0
			canMovePlayer = true
		else
			player.x = player.movement + player.x
		end

		if invincible then
			local time = system.getTimer()

			if player.lastAlphaChange + 100 < time then
				player.lastAlphaChange = time

				if player.alpha < 1 then
					player.alpha = 1.0
				else
					player.alpha = 0.3
				end
			end
		end

	end
end


local function swipeAction(direction)	
	touchBegan = false
	
	if inPlay then
		if canMovePlayer then
			if player.state == "running" then
				if direction == "left" and player.x >= 320 then
					print("moving left")
					canMovePlayer = false
					player.movement = -1 * playerSpeed
					player.x = player.movement + player.x
				elseif direction == "right" and player.x <= 320 then
					print("moving right")
					canMovePlayer = false
					player.movement = 1 * playerSpeed
					player.x = player.movement + player.x
				elseif direction == "down" then
					canMovePlayer = false
					player.state = "sliding"
					playerSliding.isVisible = true
					playerStanding.isVisible = false
					timer.performWithDelay(500, finishSliding)
				elseif direction == "up" then
					canMovePlayer = false
					player.state = "jumping"
					playerJumping.isVisible = true
					playerStanding.isVisible = false
					timer.performWithDelay(500, finishJumping)
				end
			end
		end
	end
end


local function touchedScreen( event )
	if event.phase == "began" then
		touchBegan = true
	elseif touchBegan == true then
		if event.yStart > event.y and (event.yStart - event.y) >= 120 then
			swipeAction("up")
		elseif event.yStart < event.y and (event.y - event.yStart) >= 120 then
			swipeAction("down")
		elseif event.xStart < event.x and (event.x - event.xStart) >= 120 then
			swipeAction("right")
		elseif event.xStart > event.x and (event.xStart - event.x) >= 120 then
			swipeAction("left")
		end
	end
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("menu")

	Runtime:addEventListener( "enterFrame", checkObstacles )
	Runtime:addEventListener( "enterFrame", movePlayer )
	Runtime:addEventListener( "enterFrame", fadeText )

	background:addEventListener( "touch", touchedScreen )
	restart()
end

function scene:exitScene(event)
	for i=#movingObjects, 1, -1 do
		local thisOne = movingObjects[i]
		table.remove(movingObjects, i)
		thisOne:removeSelf()
	end

	for i=#lowObjects, 1, -1 do
		local thisOne = lowObjects[i]
		table.remove(lowObjects, i)
		thisOne:removeSelf()
	end

	for i=#highObjects, 1, -1 do
		local thisOne = highObjects[i]
		table.remove(highObjects, i)
		thisOne:removeSelf()
	end

	for i=player.numChildren,1,-1 do
        local child = player[i]
        child.parent:remove( child )
	end

	Runtime:removeEventListener( "enterFrame", checkObstacles )
	Runtime:removeEventListener( "enterFrame", movePlayer )
	Runtime:removeEventListener( "enterFrame", fadeText )
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene