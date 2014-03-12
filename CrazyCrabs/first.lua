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
local physics = require "physics"
local gameData = require "gameData"

physics.start()
physics.setGravity(0, 9.81)
physics.setScale(80)  -- 80 pixels per meter
local crabs
local ledges
local barriers
local objectInMotion
local ladders
local behindForeground
local foreground
local eggs
local bird
local gameOver = false
local touchDelta
local overlay
local hammerButton
local numHammers
local score
local protectButton
local numProtect
local germ
local totalPopulation
local maxPopulation
local currentPopulation

local staticMaterial = {density=.8, friction=0, bounce=.01}
--local crabShape = {-10,-10, 10, -10, 25, 20, -25, 20}
local crabShape = {-46, -30, 46, -30, 40, 30, -40, 30 }
local crabMaterial = {density=.8, friction=0, bounce=.01, shape= crabShape}


local function ensureOrdering()
	behindForeground:toFront()
	foreground:toFront()
	overlay:toFront()
end

local function respawnGerm()
	if germ.isVisible == false and germ.next < system.getTimer() then
		local rand = math.random(1, #ledges)	
		local ledge = ledges[rand]
	
		germ.x = ledge.x
		germ.y = ledge.y - 50
		germ.isVisible = true
		germ.next = system.getTimer() + math.random(30000, 60000)

	end
end


local function addGerm()
	if gameOver == false then
		germ = display.newImage("images/germ.png");
		behindForeground:insert(germ)
		germ.isVisible = false
		germ.next = system.getTimer() + math.random(30000, 60000)
	end
end

local function protectEgg(self, event)
	if self.protected then
		print("already protected")
	elseif numProtect.current > 0 then
		print("protecting")
		numProtect.current = numProtect.current - 1
		numProtect.text = numProtect.current 
		self.protected = true
		self:setFillColor(100,100,255)
	end

end

local function addBird()
	bird = display.newImage("images/bird.png")
	bird.x = 10
	bird.y = 50
	bird.isSwooping = false
	bird.direction = 4
	foreground:insert(bird)
end

local function moveBird(event)

	if bird.isReturning then
		bird.y = bird.y - 6

		if bird.y < 50 then
			bird.isReturning = false
		end

	elseif bird.isSwooping then

		if bird.targetEgg.protected then
			bird.isReturning = true
			bird.isSwooping = false
		else
			bird.y = bird.y + 6
	
			if bird.y > bird.targetEgg.y then
				bird.targetEgg.isEaten = true
				bird.isSwooping = false
				bird.isReturning = true
			end
		end
	else

		bird.x = bird.x + bird.direction

		if (bird.x < -400) or (bird.x > 1100) then
			bird.direction = bird.direction * -1

		end

		for i=1, #eggs do
			local egg = eggs[i]
			if egg.protected == false and math.abs(egg.x - bird.x) < 2 then
				print("swooping")
				bird.isSwooping = true
				bird.targetEgg = egg
				bird.targetEgg.isSwooping = true
			end
		end
	end
end

local function addLadder(foreground, xLocation, yLocation, length)
	local ladder = display.newRect(xLocation, yLocation, 30, length)
	ladder:setFillColor(255, 0, 0)
	behindForeground:insert(ladder)
	ladder.name = "ladder"
	table.insert(ladders, ladder)
end

local function addBarrier(foreground, xLocation, yLocation, unmoved)
	local barrier1 = display.newRect(0, 0, 50, 50)
	barrier1:setReferencePoint(display.CenterReferencePoint)
	behindForeground:insert(barrier1)
	barrier1.name = "barrier"
	barrier1.unmoved = true
	table.insert(barriers, barrier1)
	barrier1:translate(xLocation, yLocation)
	barrier1.hits = 0
	barrier1:setFillColor(0, 255, 0)

	if unmoved == false then
		barrier1.unmoved = unmoved
		physics.addBody(barrier1, "static", staticMaterial)
	end

	return barrier1

end

local function addLedge(foreground, xLocation, yLocation, xLength, yLength)

	local ledge = display.newRect(xLocation, yLocation, xLength, yLength)
	table.insert(ledges, ledge)
	behindForeground:insert(ledge)
	physics.addBody(ledge, "static", staticMaterial) 

end

local function touchCrab(self, event)
	if event.phase == "began" and self.turnover > 0 then
		self.turnover = 0
		self.rotation = 0
	end
end

local function addCrab(xLocation, yLocation, isMale)

	totalPopulation.current = totalPopulation.current + 1
	totalPopulation.text = "Total pop: " .. totalPopulation.current

	currentPopulation.current = currentPopulation.current + 1
	currentPopulation.text = "Current pop: " .. currentPopulation.current

	if (currentPopulation.current > maxPopulation.current) then
		maxPopulation.current = currentPopulation.current
		maxPopulation.text = "Max pop: " .. maxPopulation.current
	end

	local crab

	if isMale then
		crab = display.newImage("images/crab4.png")
		crab.eggs = 0
		crab:setFillColor(255, 0, 0)
	else
		crab = display.newImage("images/crab4.png")
		crab.eggs = 2
		crab:setFillColor(255, 150, 150)
	end

	foreground:insert(crab)
	crab:translate(xLocation, yLocation)

	physics.addBody(crab, "dynamic", crabMaterial) 

	crab.lastLay = 0
	crab.direction = 2
	crab.name = "crab"
	crab.lastCollision = 0
	crab.turnover = 0
	crab.isMale = isMale
	crab.isInfected = false
	crab.infectedTime = 0
	--crab:setReferencePoint(display.BottomCenterReferencePoint)

	crab.touch = touchCrab
	crab:addEventListener( "touch", crab )
	crab.timeBorn = system.getTimer()
	crab.age = math.random(30000, 180000)
	table.insert(crabs, crab)
end

local function checkBothSexes(event)

	local foundMale = false
	local foundFemale = false

			--print("num crabs " .. #crabs)


	for i = 1, #crabs do
		local crab = crabs[i]
		
		if foundMale == false and crab.isMale then
			--print("found male")
			foundMale = true
		end

		if foundFemale == false and crab.isMale == false then
			--print("found female")
			foundFemale = true
		end
	end

	if foundMale == false or foundFemale == false then
		local textObject = display.newText("GAME OVER", 200, 200, "GoodDog", 100)
		gameOver = true
		overlay:insert(textObject)
		gameData.numCredits = gameData.numCredits + score.current

		local closure = function()
			storyboard.gotoScene("doNothingScene")
		end
		
		timer.performWithDelay(3000, closure)


	end
end

local function infect(crab)
	crab.isInfected = true
	crab:setFillColor(0, 150, 0)
	crab.infectedTime = system.getTimer()
end

local function removeCrab(crab, index)
	currentPopulation.current = currentPopulation.current - 1
	currentPopulation.text = "Current pop: " .. currentPopulation.current

	table.remove(crabs, index)
	crab:removeEventListener( "touch", crab )
	crab:removeSelf()
end

local function moveCrabs(event)

	for j = 1, #crabs do
		local i = #crabs - j + 1
		local crab = crabs[i]

		if crab ~= nil and crab.isVisible then
			score.current = score.current + 1
			score.text = score.current
		local rotation = crab.rotation % 360

		if crab.y > display.contentHeight - display.screenOriginY then
			print("crab oob")
			removeCrab(crab, i)
		elseif crab.turnover ~= 0 and crab.turnover + 3000 < system.getTimer() then
			print("crab upside down dead")
			removeCrab(crab, i)
		elseif crab.onLadder then
			crab.turnover = 0
			if (crab.onLadder.y - (crab.onLadder.height / 2)) > (crab.y + (crab.height / 2)) then
				print("crab at top of ladder")
				physics.addBody(crab, "dynamic", crabMaterial) 
				crab.onLadder = nil
			else
				crab.y = crab.y - 2
			end
		

		elseif rotation < 5 or rotation > 355 then
			if germ.isVisible and math.abs(crab.x - germ.x) < 30 and math.abs(crab.y - germ.y) < 30 then
				infect(crab)
				germ.isVisible = false
			end

			crab.turnover = 0
			local onLadder = false

			local rand = math.random(1, 2)

			if rand == 1 then
				for i = 1, #ladders do
					local ladder = ladders[i]

					if math.abs(crab.x - ladder.x) < 1 and crab.y > ladder.y then
						onLadder = true
						crab.onLadder = ladder
						break
					end
				end
			end	

			if onLadder then
				
				print("crab found ladder")
				crab.y = crab.y - 2
				physics.removeBody(crab)
			elseif crab.lastCollision + 100 < system.getTimer() then
				crab.x = crab.x + crab.direction

				local rand = math.random(1, 50)
	
				if rand == 1 then
					crab.direction = crab.direction * -1
				end
			end
		else 
			local xs, ys = crab:getLinearVelocity()

			if (crab.turnover == 0 and math.abs(xs) < 0.1 and math.abs(ys) < 0.1) then
				print("crab upside down and stationary")
				crab.turnover = event.time
			end

			crab:setLinearVelocity(0, ys)
		end

		end
	end

end

local function layEgg(xLocation, yLocation)
	local egg = display.newImage("images/waterBalloon.png")
	behindForeground:insert(egg)
	ensureOrdering()
	egg:translate(xLocation, yLocation - 35)
	egg.timeLaid = system.getTimer()
	egg.touch = protectEgg
	egg:addEventListener( "touch", egg )
	table.insert(eggs, egg)
	egg.protected = false
end

local function crabHitCrab(crab1, crab2)

	if crab1.isInfected and crab2.isInfected == false then
		infect(crab2)
	elseif crab2.isInfected and crab1.isInfected == false then
		infect(crab1)
	elseif crab1.isInfected == false and crab2.isInfected == false and (crab1.isMale ~= crab2.isMale) then
		local time = system.getTimer()

		if crab1.lastLay + 5000 < time and crab2.lastLay + 5000 < time then
			crab1.eggs = crab1.eggs - 1
			crab2.eggs = crab2.eggs - 1
			crab1.lastLay = time
			crab2.lastLay = time
			layEgg(((crab1.x + crab2.x) / 2), ((crab1.y + crab2.y) / 2))
		end
	end
end

local function changeCrabDirection(crab, event)
	crab.lastCollision = system.getTimer()
	crab.direction = crab.direction * -1 
end

local function removeBarrier(barrier)
	physics.removeBody(barrier)
	barrier:setFillColor(255, 0, 0)
end

local function crabHitBarrier(crab, barrier)	

	barrier.hits = barrier.hits + 1

	print("crab hit barrier")

	if (barrier.hits == 10) then
		print("ten hits")
		barrier:setFillColor(0, 0, 255)

	elseif (barrier.hits == 15) then
		local closure = function()
			removeBarrier(barrier)
		end
	
		timer.performWithDelay(1, closure)
	end
end

local function onCollision(event)


	if (event.object1.name == "crab" and event.object2.name == "barrier" and event.object2.unmoved == false and math.abs(event.object1.y - event.object2.y) < 50) then

		if event.object1.x < event.object2.x and event.object1.direction > 0 or event.object1.x > event.object2.x and event.object1.direction < 0 then
			changeCrabDirection(event.object1, event)
			crabHitBarrier(event.object1, event.object2)

		end
	end

	if (event.object2.name == "crab" and event.object1.name == "barrier" and event.object1.unmoved == false and math.abs(event.object1.y - event.object2.y) < 20) then
		
		if event.object2.x < event.object1.x and event.object2.direction > 0 or event.object2.x > event.object1.x and event.object2.direction < 0 then
			changeCrabDirection(event.object2, event)
			crabHitBarrier(event.object2, event.object1)

		end
	end

	if (event.object1.name == "crab" and event.object2.name == "crab" and math.abs(event.object1.y - event.object2.y) < 1) then

		if event.object2.x < event.object1.x and event.object2.direction > 0 or event.object2.x > event.object1.x and event.object2.direction < 0 then
			changeCrabDirection(event.object2, event)
			crabHitCrab(event.object1, event.object2)
		end

		if event.object1.x < event.object2.x and event.object1.direction > 0 or event.object1.x > event.object2.x and event.object1.direction < 0 then
			changeCrabDirection(event.object1, event)
			crabHitCrab(event.object1, event.object2)
		end
	end
end

local function touchBarrier(self, event)
	if self.hits > 9 and numHammers.current > 0 then
		self:setFillColor(0, 255, 0)
		self.hits = 0
		numHammers.current = numHammers.current - 1
		numHammers.text = numHammers.current

		if self.hits > 14 then
			physics.addBody(self, "static", staticMaterial)
			self.hits = 0
		end
	end

end


local function touched(event)

	if gameOver == false then
		if ("began" == event.phase) then 
			touchDelta = foreground.x - event.x

		else
			foreground.x = event.x + touchDelta
			behindForeground.x = event.x + touchDelta
		end
	end
end

local function monitorEggs(event)
	local time = system.getTimer()

	for i = 1, #eggs do
		local egg = eggs[i]

		if time - egg.timeLaid > 10000 or egg.isEaten then
			table.remove(eggs, i)

			if egg.isEaten then

			else
				local rand = math.random(1, 2)
				addCrab(egg.x, egg.y - 20, rand == 1)

				if egg.isSwooping then
					bird.isSwooping = false
				end
			end

			egg:removeSelf()
			break
		end 
	end


end


-- what to do when the screen loads
function scene:createScene(event)

	print("create")
	local screenGroup = self.view
	behindForeground = display.newGroup()
	gameOver = false
	foreground = display.newGroup()
	overlay = display.newGroup()


	ledges = {}
	barriers = {}
	crabs = {}
	ladders = {}
	eggs = {}

	addBird()

	local ledge1 = addLedge(foreground, 200, 200, 550, 10)
	local ledge2 = addLedge(foreground, 20, 450, 300, 10)
	local ledge3 = addLedge(foreground, 600, 500, 500, 10)
	local ledge4 = addLedge(foreground, -250, 600, 900, 10)
	local ledge5 = addLedge(foreground, -400, 300, 500, 10)

	--local barrier1 = addBarrier(foreground, 20, 400, false)
	local barrier2 = addBarrier(foreground, 1050, 450, false)
	local barrier3 = addBarrier(foreground, -250, 550, false)
	local barrier4 = addBarrier(foreground, 600, 550, false)
	local barrier5 = addBarrier(foreground, -400, 250, false)

	local ladder1 = addLadder(foreground, 700, 200, 300)
	local ladder2 = addLadder(foreground, 360, 200, 400)
	local ladder3 = addLadder(foreground, -150, 300, 300)
	local ladder4 = addLadder(foreground, 150, 450, 150)

	currentPopulation = display.newText("", 850, 100, "GoodDog", 30)
	currentPopulation.current = 0
	overlay:insert(currentPopulation)

	maxPopulation = display.newText("", 850, 170, "GoodDog", 30)
	maxPopulation.current = 0
	overlay:insert(maxPopulation)

	totalPopulation = display.newText("", 850, 240, "GoodDog", 30)
	totalPopulation.current = 0
	overlay:insert(totalPopulation)

	local crab1 = addCrab(200, 100, true)
	local crab2 = addCrab(275, 100, true)
	local crab3 = addCrab(450, 100, false)
	local crab4 = addCrab(525, 100, false)
	local crab5 = addCrab(200, 500, true)
	local crab6 = addCrab(-100, 500, false)

	hammerButton = display.newImage("images/hammer.png")
	hammerButton:translate(10, 10)
	overlay:insert(hammerButton)
	numHammers = display.newText(gameData.numHammers, 100, 30, "GoodDog", 30)
	numHammers.current = gameData.numHammers
	overlay:insert(numHammers)

	protectButton = display.newImage("images/stopBird.png")
	protectButton:translate(150, 10)
	overlay:insert(protectButton)
	numProtect = display.newText(gameData.numProtects, 240, 30, "GoodDog", 30)
	numProtect.current = gameData.numProtects
	overlay:insert(numProtect)

	score = display.newText("0", 900, 10, "GoodDog", 50)
	score.current = 0
	overlay:insert(score)
	score:setTextColor(255, 255, 255)

	addGerm()
end

local function onEnterFrame(event)
	if gameOver == false then

		moveCrabs(event)
		checkBothSexes(event)
		moveBird(event)
		respawnGerm()

		if #eggs > 0 then
			monitorEggs(event)
		end	
	end
end

local function dismissScreenGroup(group)
	for i=group.numChildren,1,-1 do
		print("hello")
		group[i].parent:remove(group[i]);
 	end

	--group:removeSelf()
end

local function buyProtect(event)
	if true then
		numProtect.current = numProtect.current + 1
		numProtect.text = numProtect.current
	end
end

local function buyHammer(event)
	if true then
		numHammers.current = numHammers.current + 1
		numHammers.text = numHammers.current
	end
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("doNothingScene")
	print("enter")

	Runtime:addEventListener( "collision", onCollision )

	for i=1, #barriers do
		local barrier1 = barriers[i]
		barrier1.touch = touchBarrier
		barrier1:addEventListener( "touch", barrier1 )
	end

	hammerButton:addEventListener("tap", buyHammer)
	protectButton:addEventListener("tap", buyProtect)

	Runtime:addEventListener( "enterFrame", onEnterFrame )
	Runtime:addEventListener( "touch", touched )

end

function scene:exitScene(event)

	Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener( "enterFrame", onEnterFrame )
	Runtime:removeEventListener( "touch", touched )
	dismissScreenGroup(foreground)
	dismissScreenGroup(behindForeground)
	dismissScreenGroup(overlay)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene