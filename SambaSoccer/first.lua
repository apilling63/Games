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
local gameData = require ("gameData")
local gameData = require ("lottery")

local canMovePlayer = true
local movingObjects = {}
local highObjects = {}
local lowObjects = {}

local background
local player
local playerAnimation
local playerSliding
local playerDown
local playerSpeed = 20
local inPlay = true
local screenGroup
local counter
local scoreText
local lastHardObstacle
local obstacleYSpeed = 2
local ball
local timeToGoal
local timeStarted

local gapBetweenObstacles


local function makeFaster()

	if inPlay and gapBetweenObstacles > 400 then
		gapBetweenObstacles = gapBetweenObstacles * 0.9
		timer.performWithDelay(10000, makeFaster)
	end
end

local function returnToMenu()
	transition.cancel(transitions)

	if gameData.bestScore < counter then
		gameData.bestScore = counter
	end

	storyboard.gotoScene("menu")
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
	backgroundGroup:toBack()
	local middleX = display.contentWidth / 2
	local endX = middleX + (toPrepare.final * 200)
	transition.to ( toPrepare,{  time=2500, alpha=1,x = (endX),y = (display.contentHeight + 100),width =(toPrepare.width * 5),height =(toPrepare.height * 5), onComplete=transitionComplete, tag=transitions}  ) 
end

local function prepareObject(toPrepare)
	table.insert(movingObjects, toPrepare)
	toPrepare.final = math.random(-1, 1)
	toPrepare.collectValue = 0
	prepareAnyObject(toPrepare)

end

local function addNet()
	local net = utility.addNewPicture("volleyballNet.png", screenGroup)
	net:scale(0.15, 0.15)
	net.final = 0
	table.insert(highObjects, net)
	prepareAnyObject(net)
end

local function addSunbather()
	local bather = utility.addNewPicture("sunbather.png", screenGroup)
	bather:scale(0.15, 0.15)
	bather.final = 0
	table.insert(lowObjects, bather)
	prepareAnyObject(bather)
end


local function addTree()
	local tree = utility.addNewPicture("palmTree.png", screenGroup)
	tree:scale(0.2, 0.2)
	prepareObject(tree)
end

local function addBeachball()
	if inPlay then
		local rand = math.random(1, 10)
		local beachball = utility.addNewPicture("beachball.png", screenGroup)
		beachball.isGolden = false

		beachball:scale(0.08, 0.08)
		prepareObject(beachball)
		beachball.collectValue = 1
		timer.performWithDelay(800, addBeachball)
	end


end

local function addUmbrella()
	local umbrella = utility.addNewPicture("beachUmbrella.png", screenGroup)
	umbrella:scale(0.2, 0.2)
	prepareObject(umbrella)
end

local function onCollision(event)

end

local function addObstacle()
	if inPlay then
		timer.performWithDelay(gapBetweenObstacles, addObstacle)	
		local random = math.random(1, 4)

		if random == 1 then
			addTree()
		elseif random == 3 then
			addUmbrella()
		elseif random == 2 and os.time() > (lastHardObstacle + 2) then
			lastHardObstacle = os.time()
			local random2 = math.random(1, 2)

			if random2 == 1 then
				addNet()
			else
				addSunbather()
			end
		end

	end
end

local function restart()
	backgroundGroup:toBack()

	local closure = function()
		backgroundGroup:toBack()
		background:play()
		timeStarted = os.time()
		inPlay = true
		playerAnimation:play()
		timer.performWithDelay(500, addObstacle)
		timer.performWithDelay(10000, makeFaster)
		timer.performWithDelay(700, addBeachball)
	end

	timer.performWithDelay(1000, closure)
end

local function addGoalSlider()
	local slider = utility.addNewPicture("goalSlider.png", screenGroup)

	slider:translate(100, 300)

	return slider
end

local function addBallToSlider(slider)
	local ball = utility.addNewPicture("ball.png", screenGroup)

	ball.x = slider.x
	ball.y = slider.y + (slider.height / 2) - 50
	ball.startY = ball.y
	ball.endY = slider.y - (slider.height / 2) + 50
	return ball
end

-- what to do when the screen loads
function scene:createScene(event)
	print("CREATE FIRST")
	inPlay = false
	counter = 0
	gapBetweenObstacles = 1200
	lastHardObstacle = 0
	screenGroup = self.view
	timeToGoal = 120

	local goalSlider = addGoalSlider()
	ball = addBallToSlider(goalSlider)

	background = utility.addBackgroundSprite()
	utility.putInCentre(background)
	background:translate(20, 0)
	background:play()
	screenGroup:insert(background)

	backgroundGroup = display.newGroup()
	backgroundGroup:insert(background)
	backgroundGroup:insert(goalSlider)


	playerSliding = display.newImage("images/playerSliding.png", false) 
	playerSliding.isVisible = false
	playerSliding:translate(0, 50)

	playerDown = display.newImage("images/playerDown.png", false) 
	playerDown.isVisible = false
	playerDown:translate(0, 50)

	scoreText = utility.addBlackCentredText(0, 50, screenGroup, 100)
 
	playerAnimation = utility.addPlayerSprite()
	playerAnimation:play()

	player = display.newGroup()
	player:insert(playerAnimation)
	player:insert(playerSliding)
	player:insert(playerDown)
	player.anchorY = 1

 	player:translate(display.contentWidth / 2, 700)

	player.state = "running"

	player.movement = 0
	
	screenGroup:insert(player)

end

local function hitObstacle()
	inPlay = false
	playerAnimation.isVisible = false
	playerDown.isVisible = true
	background:pause()
	transition.pause(transitions)
	local lotteryResult = lottery.doLottery()
	--timer.performWithDelay(2000, returnToMenu)
end

local function isObjectInRange(obj)
	return math.abs(obj.y - player.y - (player.height / 2) + 30) < 15
end

local function isObjectBeyondRange(obj)
	return (obj.y - player.y - (player.height / 2) + 30) > 15
end

local function checkObstacles(context)
	if inPlay then
		for i=#movingObjects, 1, -1 do
			local thisOne = movingObjects[i]
			local objectInRange = isObjectInRange(thisOne)
			local objectHitCentre = thisOne.final == 0 and player.x > 290 and player.x < 350
			local objectHitLeft = thisOne.final == -1 and player.x < 230
			local objectHitRight = thisOne.final == 1 and player.x > 410

			if (thisOne.isVisible and objectInRange and (objectHitCentre or objectHitLeft or objectHitRight)) then
				if thisOne.collectValue == 0 then
					hitObstacle()
				elseif player.state == "running" then
					counter = counter + thisOne.collectValue
					scoreText.text = counter
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
				hitObstacle()
			elseif objectInRange then
				thisOne:toFront()
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
				hitObstacle()
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
			player.x = player.movement + player.x
		end
	end
end

local function finishSliding()
	if inPlay then
		playerAnimation.isVisible = true
		playerSliding.isVisible = false
		canMovePlayer = true
		player.state = "running"
	end
end

local function finishJumping()
	if inPlay then
		player.y = player.y + 150
		canMovePlayer = true
		player.state = "running"
		playerAnimation:play()
	end
end

local function swipeAction(direction)
	print("touched screen")
	if inPlay then
		if canMovePlayer then
			print("can move player")
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
					playerAnimation.isVisible = false
					timer.performWithDelay(500, finishSliding)
				elseif direction == "up" then
					canMovePlayer = false
					playerAnimation:pause()
					player.state = "jumping"
					player.y = player.y - 150
					timer.performWithDelay(500, finishJumping)
				end
			end
		end
	end
end

local function touchedScreen( event )
	if event.phase == "ended" then
		if event.xStart < event.x and (event.x - event.xStart) >= 100 then
			swipeAction("right")
		elseif event.xStart > event.x and (event.xStart - event.x) >= 100 then
			swipeAction("left")
		elseif event.yStart > event.y and (event.yStart - event.y) >= 100 then
			swipeAction("up")
		elseif event.yStart < event.y and (event.y - event.yStart) >= 100 then
			swipeAction("down")
		end
	end
end

local function moveSlider()
	if inPlay then
		local ballProgressFraction = (os.time() - timeStarted) / timeToGoal
		local ballY = ball.startY + ((ball.endY - ball.startY) * ballProgressFraction)
		ball.y = ballY

		if ball.y == ball.endY then
			inPlay = false
			playerAnimation:pause()
			background:pause()
			ball.isVisible = false
			background:removeEventListener( "touch", touchedScreen )

			local closure = function()
				storyboard.gotoScene("second")
			end
			
			timer.performWithDelay(100, closure)
		end
	end
end

-- add all the event listening
function scene:enterScene(event)
	print("ENTER FIRST")

	storyboard.purgeScene("menu")

	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener( "enterFrame", checkObstacles )
	Runtime:addEventListener( "enterFrame", movePlayer )
	Runtime:addEventListener( "enterFrame", moveSlider )

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

	for i=#highObjects, 1, -1 do
		local thisOne = highObjects[i]
		table.remove(highObjects, i)
		thisOne:removeSelf()
	end

	for i=#lowObjects, 1, -1 do
		local thisOne = lowObjects[i]
		table.remove(lowObjects, i)
		thisOne:removeSelf()
	end

	for i=player.numChildren,1,-1 do
        	local child = player[i]
	        child.parent:remove( child )
	end

	for i=backgroundGroup.numChildren,1,-1 do
        	local child = backgroundGroup[i]
	        child.parent:remove( child )
	end

	Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener( "enterFrame", checkObstacles )
	Runtime:removeEventListener( "enterFrame", movePlayer )
	Runtime:removeEventListener( "enterFrame", moveSlider )

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene