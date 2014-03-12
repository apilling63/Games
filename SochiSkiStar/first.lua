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
local gameData = require "gameData"
local cheer = audio.loadSound("crowd_cheer.wav")
local cowbell = audio.loadSound("cowbell_ringing.wav")
local ooh = audio.loadSound("ooh_.mp3")
local ping = audio.loadSound("ping.mp3")
local beeps = audio.loadSound("beeps.mp3")

local canMovePlayer = true
local movingObjects = {}
local lowObjects = {}
local highObjects = {}

local background
local player
local playerSliding
local playerJumping
local playerStanding
local playerSpeed = 10
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
local countdownText
local failText1
local failText2
local gameOverText
local hasYellow
local invincible
local transitionTime
local slowMultiplier
local addingObstacles
local gapBetweenObstacles
local textToFade = {}
local touchBegan = false
local crashRecovers = 0
local cowbellChannel = 0
local coinsCollected = 0
local distanceSpeed = 1
local startTime = 0

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
	
	if gameOverText.text == "SPEEDING UP!" or gameOverText.text == "YOU ALMOST FELL!" then
		gameOverText.text = ""
	end
end

local function makeFaster()

	if inPlay and (os.time() - 9) > startTime and gapBetweenObstacles > 500 then
		transitionTime = transitionTime * slowMultiplier
		gapBetweenObstacles = gapBetweenObstacles * slowMultiplier
		addingObstacles = false
		timer.performWithDelay(20000, makeFaster)
		timer.performWithDelay(2000, restartObstacles)

		gameOverText.text = "SPEEDING UP!"
	end
end

local function goToLeaderboard()
	utility.stopSound()
	transition.cancel(transitions)
	storyboard.gotoScene("leaderboard")
end

local function transitionComplete(obj)
	obj.isVisible = false
end

local function prepareAnyObject(toPrepare)
	utility.centreObjectX(toPrepare)
	toPrepare.anchorX = 0.5
	toPrepare.anchorY = 1
	toPrepare.x = toPrepare.x + (toPrepare.final * 20)
	utility.anchorY = 1
	toPrepare:translate(0, 250)
	toPrepare.anchorX = 0.5
	toPrepare:toBack()
	background:toBack()
	local middleX = display.contentWidth / 2
	local endX = middleX + (toPrepare.final * 200)
	transition.to ( toPrepare,{  time= transitionTime, alpha=1,x = (endX),y = 1060,width =(toPrepare.width * 5),height =(toPrepare.height * 5), onComplete=transitionComplete, tag=transitions}  ) 
end

local function prepareObject(toPrepare)
	table.insert(movingObjects, toPrepare)
	
	if toPrepare.final then
	else
		toPrepare.final = math.random(-1, 1)
	end
	
	if toPrepare.collectValue then
	else
		toPrepare.collectValue = 0
	end

	prepareAnyObject(toPrepare)

end

local function addLowObject()
	local bather = utility.addNewPicture("wideSkiGateLow.png", screenGroup)
	bather:scale(0.15, 0.15)
	bather.final = 0
	table.insert(lowObjects, bather)
	prepareAnyObject(bather)
end

local function addHighObject()
	local bather = utility.addNewPicture("wideSkiGate.png", screenGroup)
	bather:scale(0.15, 0.15)
	bather.final = 0
	table.insert(highObjects, bather)
	prepareAnyObject(bather)
end

local function addPickup()
	if inPlay then
		if addingObstacles then
			local rand = math.random(1, 100)
			local pickup

			if rand > 90 then
				pickup = utility.addNewPicture("goldMedal.png", screenGroup)
				pickup.collectValue = 100
	
			elseif rand > 70 then
				pickup = utility.addNewPicture("silverMedal.png", screenGroup)
				pickup.collectValue = 25
	
			elseif rand > 2 then
				pickup = utility.addNewPicture("bronzeMedal.png", screenGroup)
				pickup.collectValue = 10
	
			else
				pickup = utility.addNewPicture("purplePatch.png", screenGroup)
				pickup.collectValue = -1
			end

			pickup:scale(0.08, 0.08)
			prepareObject(pickup)
		end

		timer.performWithDelay(800, addPickup)

	end
end

local function addUmbrella()
	local umbrella = utility.addNewPicture("skiGate.png", screenGroup)
	umbrella:scale(0.2, 0.2)
	prepareObject(umbrella)
	
		local rand = math.random(1,4)
		
		if rand == 1 then
			local umbrella2 = utility.addNewPicture("skiGate.png", screenGroup)
			umbrella2:scale(0.2, 0.2)
			local rand2 = math.random(0,1)

			if umbrella.final == 0 then

				if rand2 == 1 then
					umbrella2.final = rand2
				else
					umbrella2.final = -1			
				end
			else
				umbrella2.final = rand2 * umbrella.final * -1
			end
			
			prepareObject(umbrella2)		
		end

end

local function onCollision(event)

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
					addHighObject()
				elseif rand2 == 2 then
					addLowObject()
				end
			else
				addUmbrella()
			end
		else
			timer.performWithDelay(gapBetweenObstacles, addObstacle)	
		end

	end
end

local function countMeters()
	if inPlay then
		distanceCounter = distanceCounter + (distanceSpeed * 4)
		distanceText.text = distanceCounter .. "m"
		timer.performWithDelay(20, countMeters)
	end
end

local function countdown()

	if countdownText.text == "" then
		countdownText.text = "RUN " .. runNumber
		timer.performWithDelay(2000, countdown)
	elseif countdownText.text == "RUN " .. runNumber then
		utility.playSound(beeps)
		countdownText.text = "3"
		timer.performWithDelay(800, countdown)
	elseif countdownText.text == "3" then
		countdownText.text = "2"
		timer.performWithDelay(800, countdown)
	elseif countdownText.text == "2" then
		countdownText.text = "1"
		timer.performWithDelay(800, countdown)
	elseif countdownText.text == "1" then
		timer.performWithDelay(800, countdown)
		countdownText.text = "GO!"
		cowbellChannel = utility.playSoundWithOptions(cowbell, {loops=-1})

	else
		countdownText.text = ""
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
	end

	countdown()
	timer.performWithDelay(6000, closure)
end

-- what to do when the screen loads
function scene:createScene(event)
	startTime = os.time()
	inPlay = false
	counter = utility.getCoins()
	playerSpeed = utility.getResponsivenessNumber()
	crashRecovers = utility.getStabilityNumber()
	distanceSpeed = utility.getSpeedNumber()
	coinsCollected = 0

	distanceCounter = 0
	gapBetweenObstacles = 1200
	gapBetweenObstaclesStartValue = 1200

	lastHardObstacle = 0
	timeToGoal = 120
	invincible = false
	transitionTime = 2500
	slowMultiplier = 0.9
	addingObstacles = true
	runNumber = gameData.getRunNumber()

	screenGroup = self.view

	background = utility.addNewPicture("skiBackground.png", screenGroup)
	utility.putInMiddle(background)
	screenGroup:insert(background)

	player = display.newGroup()
	playerSliding = utility.addNewPicture("skierCrouch.png", player)
	playerSliding.isVisible = false
	playerJumping = utility.addNewPicture("skierJump.png", player)
	playerJumping.isVisible = false
	playerStanding = utility.addNewPicture("skierCentre.png", player)
	player:insert(playerStanding)

	player.anchorY = 1
 	player:translate(display.contentWidth / 2, 700)
	player.state = "running"
	player.movement = 0
	player.lastAlphaChange = 0
	screenGroup:insert(player)

	local medals = utility.addNewPicture("medals.png", screenGroup)

	scoreText = utility.addBlackCentredTextWithFont(counter, 70, screenGroup, 40, "Exo-DemiBoldItalic")
	scoreText:translate(-200, 0)
	medals.x = scoreText.x
	medals.y = scoreText.y

	distanceText = utility.addBlackCentredTextWithFont("0m", 70, screenGroup, 40, "Exo-DemiBoldItalic")
	distanceText:translate(200, 0)

	countdownText = utility.addBlackCentredTextWithFont("", (display.contentHeight / 2) - 100, screenGroup, 100, "Exo-DemiBoldItalic")

	failText1 = utility.addBlackCentredTextWithFont("", display.contentHeight / 2, screenGroup, 30, "Exo-DemiBoldItalic")
	failText2 = utility.addBlackCentredTextWithFont("", (display.contentHeight / 2) + 50, screenGroup, 30, "Exo-DemiBoldItalic")
	gameOverText = utility.addBlackCentredTextWithFont("", (display.contentHeight / 2) - 100, screenGroup, 50, "Exo-DemiBoldItalic")

	utility.stopSound()
	utility.playSoundWithOptions(cheer, {loops=-1})
end

local function hitObstacle(reason, tip)

	if invincible == false then
		utility.playSound(ooh)

		if crashRecovers > 0 then
			crashRecovers = crashRecovers - 1
			timer.performWithDelay(500, restartObstacles)
			gameOverText.text = "YOU ALMOST FELL!"
		else
			inPlay = false
			transition.pause(transitions)
			gameOverText.text = "YOU FELL!"
			gameData.addMyScore(distanceCounter)
			utility.addToCoinTotal(coinsCollected)
			utility.setCoins(counter)
			utility.addToDistanceTotal(distanceCounter)
			audio.stop(cowbellChannel)
			timer.performWithDelay(1500, closure)
			timer.performWithDelay(5000, goToLeaderboard)

			failText1.text = reason
			failText2.text = tip
		end
	end


end

local function isObjectInRange(obj)
	return math.abs(obj.y - player.y - 60) < 15
end

local function isObjectBeyondRange(obj)
	return (obj.y - player.y - 60) > 15
end

local function checkObstacles(context)
	if inPlay then
		for i=#movingObjects, 1, -1 do
			local thisOne = movingObjects[i]
			local objectInRange = isObjectInRange(thisOne)
			local objectHitCentre = (thisOne.final == 0 or thisOne.final == 0.5 or thisOne.final == -0.5) and player.x > 290 and player.x < 350
			local objectHitLeft = (thisOne.final < 0) and player.x < 230
			local objectHitRight = (thisOne.final > 0) and player.x > 410

			if (thisOne.isVisible and objectInRange and (objectHitCentre or objectHitLeft or objectHitRight)) then
				if thisOne.collectValue == 0 then
					hitObstacle("You hit an obstacle", "Swipe left and right to avoid them")
					thisOne.isVisible = false
				elseif player.state ~= "jumping" then

					if thisOne.collectValue > 0 then
						utility.playSound(ping)
						local textToShow = utility.addBlackCentredTextWithFont("+" .. thisOne.collectValue, 
													scoreText.y - 20, 
													screenGroup, 
													50, 
													"Exo-DemiBoldItalic")
						textToShow:translate(-200, 0)
						table.insert(textToFade, textToShow)
						counter = counter + thisOne.collectValue
						scoreText.text = counter
						coinsCollected = coinsCollected + 1
					elseif thisOne.collectValue == -1 then
						invincible = true
						timer.performWithDelay(7500, turnOffInvincible)
					elseif gapBetweenObstacles < gapBetweenObstaclesStartValue then
						transitionTime = transitionTime / slowMultiplier
						gapBetweenObstacles = gapBetweenObstacles / slowMultiplier
					end

					thisOne.isVisible = false
				end
			elseif isObjectBeyondRange(thisOne) then
				thisOne:toFront()
			end

			if thisOne.isVisible == false then
				table.remove(movingObjects, i)
			end
		end

		for i=#highObjects, 1, -1 do
			local thisOne = highObjects[i]
			local objectInRange = isObjectInRange(thisOne)

			if (objectInRange and player.state ~= "sliding") then
				hitObstacle("You hit a high bar", "Swipe down to crouch under them")
				thisOne.isVisible = false
			elseif isObjectBeyondRange(thisOne) then
				thisOne:toFront()
			end

			if thisOne.isVisible == false then
				table.remove(highObjects, i)
			end
		end

		for i=#lowObjects, 1, -1 do
			local thisOne = lowObjects[i]
			local objectInRange = isObjectInRange(thisOne)

			if (objectInRange and player.state ~= "jumping") then
				hitObstacle("You hit a low bar", "Swipe up to jump over them")
				thisOne.isVisible = false
			elseif isObjectBeyondRange(thisOne) then
				thisOne:toFront()
			end

			if thisOne.isVisible == false then
				table.remove(lowObjects, i)
			end
		end
	end
end

local function finished()

end


local function movePlayer()

	if inPlay then
		if (player.x == 200) or (player.x == 440) or (player.x == 320) then
			player.movement = 0
			canMovePlayer = true
		else
			player.x = player.movement+ player.x
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
			else
				if direction == "left" and player.x >= 320 then
					print("moving left")
					utility.playSound(skiSound)
					canMovePlayer = false
					player.movement = -1 * playerSpeed
					player.x = player.movement + player.x
				elseif direction == "right" and player.x <= 320 then
					print("moving right")
					utility.playSound(skiSound)
					canMovePlayer = false
					player.movement = 1 * playerSpeed
					player.x = player.movement + player.x
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
	print("ENTER FIRST")

	storyboard.purgeScene("skiShop")
	storyboard.purgeScene("leaderboard")

	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener( "enterFrame", checkObstacles )
	Runtime:addEventListener( "enterFrame", movePlayer )
	Runtime:addEventListener( "enterFrame", fadeText )

	background:addEventListener( "touch", touchedScreen )
	restart()
end

function scene:exitScene(event)
	print("EXIT FIRST")

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

	Runtime:removeEventListener( "collision", onCollision )
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