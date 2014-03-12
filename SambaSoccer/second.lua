-----------------------------------------------------------------------------------------
--
-- second.lua
--
-----------------------------------------------------------------------------------------
local storyboard = require "storyboard"
local scene = storyboard.newScene()

local utility = require ("utility")
local math = require ("math")
local gameData = require ("gameData")
local physics = require ("physics")

local background
local inPlay
local balls

local boot

local counter
local scoreText

local screenGroup

local function moveBoot(event)
	boot.x = event.x
end

local function onCollision(event)
	if event.phase == "began" and inPlay then
		counter = counter + 1
		scoreText.text = counter

		if counter == 100 then
			scoreText.text = "YOU DID IT!"
		end
	end
end

local function returnToMenu()

	storyboard.gotoScene("menu")
end

local function checkGameOver()
	if inPlay then
		for i=1, #balls do
			local ball = balls[i]
		
			if ball.x < -50 or ball.x > display.contentWidth + 50 or ball.y > display.contentHeight then
				inPlay = false
				boot:removeEventListener( "touch", moveBoot )
				physics.removeBody(boot)
				timer.performWithDelay(2000, returnToMenu)
			end
		end
	end
end

local s = {}

local function addBall()
	local ball = utility.addBallSprite()
	ball.x = display.contentWidth / 2
	ball.y = 200
	screenGroup:insert(ball)
	ball:play()
	ball:scale(2, 2)
	dynamicMaterial = {density=.8, friction=.1, bounce=1}
	ball.name = "ball"
	return ball
end

local function addBallToPhysics(dynamicMaterial, ball)
	if inPlay then
		physics.addBody(ball, "dynamic", dynamicMaterial)
	end
end

function scene:createScene(event)
	inPlay = true
	counter = 0
	balls = {}

	screenGroup = self.view
	background = utility.addBackgroundSprite()
	screenGroup:insert(background)
	utility.putInCentre(background)
	background:translate(20, 0)

	local ball = addBall()
	ball.x = 400

	local closure1 = function()
		addBallToPhysics(dynamicMaterial , ball)
	end

	timer.performWithDelay(800, closure1)

	local ball2 = addBall()
	ball2.x = 200

	local closure2 = function()
		addBallToPhysics(dynamicMaterial , ball2)
	end

	timer.performWithDelay(1600, closure2)

	table.insert(balls, ball)
	table.insert(balls, ball2)

	boot = utility.addNewPicture("boot.png", screenGroup)
	boot.x = display.contentWidth / 2
	boot.y = 300 + (display.contentHeight / 2)
	screenGroup:insert(boot)

	local bootShape = {-140,-50, 0,-120, 41,-120, 140,1}
	local bootMaterial = {density=2, friction=.15, bounce=.4, shape=bootShape}
	boot.rotation = 26.6
	physics.addBody(boot, "static", bootMaterial)
	boot.name = "boot"

	scoreText = utility.addBlackCentredText("100 KICK UPS", 50, screenGroup, 100)
	

end

function scene:enterScene(event)
	storyboard.purgeScene("first")
	boot:addEventListener( "touch", moveBoot )
	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener( "enterFrame", checkGameOver )
end

function scene:exitScene(event)
	Runtime:removeEventListener( "enterFrame", checkGameOver )
	Runtime:removeEventListener( "collision", onCollision )
end


function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene