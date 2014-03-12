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

local numPoliticians = 10
local numProjectiles = 3
local numPolice = 3
local politicians
local projectiles
local police
local lastStart = 0
local resetWait = 1500
local lastResetTime = 0
local lastPoliceResetTime = 0
local score = 0
local scoreText

local function makePoliticianInvisible(politician)
	politician.isVisible = false
	politician.body.isVisible = false
	politician.x = -1000
	politician.body.x = -1000
	politician:setLinearVelocity(0,0)

end

local function makeProjectileInvisible(projectile)
	projectile.isVisible = false
	projectile.x = -500
	projectile:setLinearVelocity(0,0)
end

local function onCollision(event)
	local goodHit = false
	local badHit = false
	local projectile
	local politician
	local policeman

	if event.object1.isVisible and event.object2.isVisible and event.object2.x > 0 and event.object1.x > 0 then
		if (event.object1.name == "projectile" and event.object2.name == "politician") then
			event.object1.isVisible = false
			event.object2.isVisible = false
			projectile = event.object1
			politician = event.object2
			goodHit = true
		end

		if (event.object2.name == "projectile" and event.object1.name == "politician") then
			event.object2.isVisible = false
			event.object1.isVisible = false
			projectile = event.object2
			politician = event.object1
			goodHit = true
		end

		if (event.object1.name == "projectile" and event.object2.name == "police") then
			event.object1.isVisible = false
			projectile = event.object1
			policeman = event.object2
			badHit = true
		end

		if (event.object2.name == "projectile" and event.object1.name == "police") then
			event.object2.isVisible = false
			projectile = event.object2
			policeman = event.object1
			badHit = true
		end
	end

	if goodHit then
		local closure = function()
			print("collision!!")
			score = score + (math.round(math.sqrt(politician.x)) * 10)
			scoreText.text = score
			makeProjectileInvisible(projectile)
			makePoliticianInvisible(politician)
		end
		timer.performWithDelay(1, closure)
	elseif badHit then
		local closure = function()
			print("bad collision!!")
			score = 0
			scoreText.text = score
			makeProjectileInvisible(projectile)
		end

		timer.performWithDelay(1, closure)

	end
end

-- what to do when the screen loads
function scene:createScene(event)
	local screenGroup = self.view
	politicians = {}
	projectiles = {}
	police = {}

	scoreText = display.newText("0", display.contentWidth / 2, 10, "Arial", 50)
	scoreText:setTextColor(0,0,0)
	local background = utility.addNewPicture("testBackground.png", screenGroup)
	local crowd = utility.addNewPicture("crowd.png", screenGroup)
	crowd:translate(0, 590)

	for i = 1, numPoliticians do
		local politician = utility.addNewKinematicPicture("head.png", screenGroup)
		politician.collision = onCollision
		politician.name = "politician"
		local politicianBody = utility.addNewPicture("body.png", screenGroup)

		politician.body = politicianBody
		politician.body.name = "body"

		table.insert(politicians, politician)
		makePoliticianInvisible(politician)
	end

	for i = 1, numProjectiles do
		local balloon = utility.addNewDynamicPicture("waterBalloon.png", screenGroup)
		table.insert(projectiles, balloon)
		balloon.name = "projectile"
		balloon.collision = onCollision
		makeProjectileInvisible(balloon)
	end

	for i = 1, numPolice do
		local policeman = utility.addNewKinematicPicture("policeHead.png", screenGroup)
		policeman.collision = onCollision
		policeman.name = "police"
		local policeBody = utility.addNewPicture("body.png", screenGroup)

		policeman.body = policeBody
		policeman.body.name = "body"

		table.insert(police, policeman)
		makePoliticianInvisible(policeman)
	end
end

local function movePolice(event)
	for i = 1, numPolice do
		local policeman = police[i]
		policeman.rotation = 0
		policeman.body.x = policeman.x

		if (policeman.x < display.screenOriginX or policeman.x > display.contentWidth - display.screenOriginX) and policeman.isVisible then
			policeman.isVisible = false
			policeman.x = -2000
			policeman.body.x = -2000
			policeman.body.isVisible = false
			policeman:setLinearVelocity(0,0)
		end 
	end

end


local function movePoliticians(event)

	-- move all the visible politicians to the left
	for i = 1, numPoliticians do
		local politician = politicians[i]

		if politician.isVisible then
			politician.rotation = 0
			politician.body.x = politician.x
			politician.body.y = politician.y + 50


			if politician.x < display.screenOriginX then
				makePoliticianInvisible(politician)
			end
		end

	end


	-- only set off another politician every second
	if event.time > (lastStart + resetWait) then
		lastStart = event.time
		-- time to set another one off
		for i = 1, numPoliticians do
			local politician = politicians[i]
	
			-- find the first invisible politician to reuse
			if politician.isVisible == false then
				-- set the politician as visible and put at edge of screen
				politician.isVisible = true
				politician.x = display.contentWidth - display.screenOriginX - 20
				politician.body.x = politician.x
				politician.body.isVisible = true
				local yLocation = math.random(20, 400)
				politician.y = yLocation
				politician.body.y = politician.y + 50
				local yVelocity = math.random(20 - yLocation, 480 - yLocation) * 0.2

    	    			politician:setLinearVelocity(-200, yVelocity) 
				break
			end
		end
	end
end

local function resetProjectiles(event)
	for i = 1, numProjectiles do
		local projectile = projectiles[i]
		
		if projectile.y < 0 then
			makeProjectileInvisible(projectile)
		end
	end
end


local function shoot(event)
	if event.phase == "began" then
		for i = 1, numProjectiles do
			local projectile = projectiles[i]
			
			if projectile.isVisible == false then
				projectile.isVisible = true
				projectile.y = 590
				projectile.x = event.x
    	    			projectile:setLinearVelocity(0, -400) 
				break
			end
		end
	end
end

local function reduceResetWait(event)
	if resetWait > 500 and (lastResetTime + 30000 < event.time) then
		resetWait = resetWait * 0.9
		lastResetTime = event.time
	end
end

local function sendPoliceman(event)
	if (lastPoliceResetTime + 6000 < event.time) then
		for i = 1, numPolice do
			local policeman = police[i]
			
			if policeman.isVisible == false then
				local direction = math.random(0, 1)

				if direction == 0 then
					direction = -1
					policeman.x = display.screenOriginX
				else 
					policeman.x = display.contentWidth - display.screenOriginX

				end
				policeman.isVisible = true
				policeman.y = 500
				policeman.body.isVisible = true
				policeman.body.y = policeman.y + 60
				local xVelocity = math.random(-200, -50)
    	    			policeman:setLinearVelocity(xVelocity * direction, 0) 
				lastPoliceResetTime = event.time
				break
			end
		end
	end
end


-- add all the event listening
function scene:enterScene(event)
	Runtime:addEventListener("enterFrame", movePoliticians)
	Runtime:addEventListener("enterFrame", movePolice)

	Runtime:addEventListener("enterFrame", resetProjectiles)
	Runtime:addEventListener("touch", shoot)
	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener("enterFrame", reduceResetWait)
	Runtime:addEventListener("enterFrame", sendPoliceman)


end

function scene:exitScene(event)
	Runtime:removeEventListener("enterFrame", movePoliticians)
	Runtime:removeEventListener("enterFrame", movePolice)

	Runtime:removeEventListener("enterFrame", resetProjectiles)
	Runtime:removeEventListener("touch", shoot)
	Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener("enterFrame", reduceResetWait)
	Runtime:removeEventListener("enterFrame", sendPoliceman)

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene