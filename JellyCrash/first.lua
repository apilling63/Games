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
local background
local jelly
local floorPieces
local physics = require "physics"
local randoms1 = require "randoms1"
local randoms2 = require "randoms2"
local randoms3 = require "randoms3"
local randoms4 = require "randoms4"

local randomCounter

local spikes
local bumps
local puffers
local bubbles

local textObject
local inPlay
local spikeSpeed
local stopFlappingTime
local lowestSpike = 700
local spikeTimeGap
local spikeSpaceGap
local maxSpaceGap = 500
local started = false
local screenGroup
local lastSqueak
local whirl = nil
local nextTouchTime

local currentSpikeIndex = 1
local currentPufferIndex = 1
local currentBumpIndex = 1
local currentBubbleIndex = 1

local scoreCounter = 0
local foreground
local batSound = audio.loadSound("waterSound.mp3")
local batSqueak = audio.loadSound("jellySound.mp3")
local deadBatSqueak = audio.loadSound("splat.mp3")
local ding = audio.loadSound("ding.wav")

local function bounceJelly(speed)
	jelly:setLinearVelocity( 0, speed )
end

local function transitionComplete()

end

local function returnToMenu()
	print("do return")
	storyboard.gotoScene("levels")
end

local function addSplat(text)
	local splat = utility.addNewPicture("splat.png", screenGroup)
	utility.putInCentre(splat)

	textObject.text = text	
	textObject.y = splat.y - 20
	textObject.isVisible = true
	textObject:toFront()
	
	timer.performWithDelay(3000, returnToMenu)
end

local function hitSpike()
	physics:pause()
	jelly:pause()
	jelly:removeSelf()
	utility.stopSound()
	utility.playSound(deadBatSqueak)
	addSplat("TRY AGAIN!")
end

local function onCollision(event)
	if inPlay then
		inPlay = false
		timer.performWithDelay(1, hitSpike)
	end
end

local function gameComplete()
	jelly:removeSelf()
	utility.stopSound()
	utility.playSound(ding)
	
	if gameData.chosenLevel > utility.getLastCompletedLevel() then
		utility.setLastCompletedLevel(gameData.chosenLevel)
	end
	
	addSplat("WELL DONE!")
end

local function moveSpikes()
	if inPlay then
		jelly.rotation = 0
	
		scoreCounter = scoreCounter + 5
		
		for i=#spikes, 1, -1 do
			spikes[i].x = spikes[i].x - spikeSpeed
			
			if spikes[i].verticalSpeed ~= 0 then
				spikes[i].y = spikes[i].y + spikes[i].verticalSpeed
				
				if spikes[i].name == "spikeTop" and (spikes[i].y < -150 or spikes[i].y > (750 - spikes[i].gap)) then
					spikes[i].verticalSpeed = spikes[i].verticalSpeed * -1
				elseif spikes[i].name == "spikeBottom" and (spikes[i].y < (-150 + spikes[i].gap) or spikes[i].y > 750) then
					spikes[i].verticalSpeed = spikes[i].verticalSpeed * -1
				end
			end
		end
		
		for i=#bumps, 1, -1 do
			bumps[i].x = bumps[i].x - spikeSpeed
		end
		
		for i=#puffers, 1, -1 do
			puffers[i].x = puffers[i].x - spikeSpeed
			puffers[i].y = puffers[i].y + puffers[i].direction
			
			if puffers[i].y < 150 or puffers[i].y > 500 then
				puffers[i].direction = puffers[i].direction * -1
			end
		end
				
		for i=#floorPieces, 1, -1 do
			floorPieces[i]:toFront()
			floorPieces[i].x = floorPieces[i].x - spikeSpeed
			if (floorPieces[i].x < display.screenOriginX - floorPieces[i].width) then
				floorPieces[i].x = floorPieces[i].x + (3 * floorPieces[i].width)
			end
		end		
	
		for i=#bubbles, 1, -1 do
			bubbles[i].x = bubbles[i].x - spikeSpeed
						
			if math.abs(jelly.x - bubbles[i].x) < 10 then
				bounceJelly(-600)	
				nextTouchTime = system.getTimer() + 1000
				bubbles[1]:pause()
			end
			
		end	
				
		if whirl then
			whirl.rotation = whirl.rotation + 100
			
			if whirl.x < 500 then
				inPlay = false
				transition.to ( jelly,{ time= 600, x = (whirl.x),y = (whirl.y), rotation = (1000), onComplete = gameComplete} ) 
				physics:pause()
				jelly:pause()
			else
				whirl.x = whirl.x - spikeSpeed
			end	
		end
		
	end
	
	if whirl then
		whirl.rotation = whirl.rotation + 100
	end
end

local function incrementIndex(currentIndex, relevantTable)
	local retVal = currentIndex + 1
	
	if retVal > #relevantTable then
		retVal = 1
	end
	
	return retVal

end

local function addSpike(screenGroup)

	if inPlay and whirl == nil then
	
		if scoreCounter > (3000 + (500 * gameData.chosenLevel)) then
			whirl = utility.addNewPicture("whirl.png", screenGroup)
			utility.putInCentre(whirl)
			whirl.x = display.actualContentHeight + whirl.width 
			whirlAdded = true
		else
			local randomIndex = ((gameData.chosenLevel - 1) * 100) + randomCounter
			randomCounter = randomCounter + 1
			
			local randomChoice = randoms1[randomIndex]
		
			local closure = function()
				addSpike(screenGroup)
			end	
						
			if gameData.chosenLevel > 2 and randomChoice == 5 then
				local puffer = puffers[currentPufferIndex]
				currentPufferIndex = incrementIndex(currentPufferIndex, puffers)
				puffer.x = display.actualContentHeight + puffer.width 
				puffer.y = randoms2[randomIndex]
				puffer.direction = 3		
				timer.performWithDelay(spikeTimeGap, closure)
					
			elseif gameData.chosenLevel > 6 and randomChoice == 3 then
				local bubs = bubbles[currentBubbleIndex]
				currentBubbleIndex = incrementIndex(currentBubbleIndex, bubbles)
				bubs:play()
				bubs.x = display.actualContentHeight + bubs.width 
				bubs.y = 320	
				timer.performWithDelay(spikeTimeGap * 1.75, closure)					
			elseif gameData.chosenLevel > 10 and randomChoice == 2 then
				local bump = bumps[currentBumpIndex]
				currentBumpIndex = incrementIndex(currentBumpIndex, bumps)
				bump.x = display.actualContentHeight + (bump.width /2)
				bump.y = 475 + (randoms1[randomIndex + 1] * 75)
				
				local bump2 = bumps[currentBumpIndex]
				currentBumpIndex = incrementIndex(currentBumpIndex, bumps)
				bump2.x = display.actualContentHeight + (bump.width /2)
				bump2.y = bump.y - 800	
				bump2.rotation = 180
											
				timer.performWithDelay(spikeTimeGap * 3.5, closure)					
			else		
				local spike = spikes[currentSpikeIndex]
				currentSpikeIndex = incrementIndex(currentSpikeIndex, spikes)
				
				local randomGap = randoms3[randomIndex]
		
				if randomGap < 600 then
					randomGap = randoms3[randomIndex + 1]
				end
				
				spike.y = randoms4[(randomGap-549) * 100 + randomIndex]
				spike.x = display.actualContentHeight + spike.width 
	
				local spike2 = spikes[currentSpikeIndex]
				currentSpikeIndex = incrementIndex(currentSpikeIndex, spikes)
				
				spike2.rotation = 180
				spike2.y = spike.y + randomGap
				spike2.x = display.actualContentHeight + spike2.width 

				spike.name = "spikeTop"
				spike2.name = "spikeBottom"
				
				spike.verticalSpeed = 0
				spike2.verticalSpeed = 0				
		
				print(gameData.chosenLevel .. " " .. randomChoice)
		
				if gameData.chosenLevel > 6 and randomChoice == 4 then
					spike.verticalSpeed = 2
					spike2.verticalSpeed = 2
					spike.gap = randomGap
					spike2.gap = randomGap					
				end
				
				timer.performWithDelay(spikeTimeGap, closure)
				
			end
		end
	end
end

local function addFloorPiece(screenGroup)
	local floorPiece = utility.addNewStaticPicture("floor.png", screenGroup)
	floorPiece.anchorY = 0
	floorPiece.y = 750
	
	local thisXMultiplier = math.floor(#floorPieces / 2)
	
	floorPiece.x = display.screenOriginX + thisXMultiplier * floorPiece.width
	table.insert(floorPieces, floorPiece)
	floorPiece.anchorY = 0.5
	
	local ceilingPiece = utility.addNewStaticPicture("floor.png", screenGroup)
	ceilingPiece.anchorY = 0
	ceilingPiece.y = -100
		
	ceilingPiece.x = display.screenOriginX + thisXMultiplier * ceilingPiece.width
	table.insert(floorPieces, ceilingPiece)
	ceilingPiece.anchorY = 0.5	
end

local function addCeilingPiece(screenGroup)
	local piece = addFloorPiece(screenGroup)
	piece.y = -250
	return piece
end

local function captureWithDelay()
    local capture = display.captureScreen( true )
end


-- what to do when the screen loads
function scene:createScene(event)

	physics.start()
	physics.setGravity(0, 10)
	physics.setScale(80)  -- 80 pixels per meter 

	math.randomseed(gameData.chosenLevel)
	screenGroup = self.view
	floorPieces = {}
	spikes = {}
	puffers = {}
	bubbles = {}
	bumps = {}
	inPlay = false
	spikeSpeed = 4
	stopFlappingTime = 0
	spikeSpaceGap = 300
	spikeTimeGap = 1250
	scoreCounter = 0
	started = false
	lastSqueak = 0
	whirl = nil
	randomCounter = 1
	nextTouchTime = 0
	
	background = display.newRect( 	screenGroup, 
					display.contentWidth / 2, 
					display.contentHeight / 2, 
					display.actualContentHeight,
					display.actualContentWidth)

	utility.setColour(background, 0,186,225)
	
	foreground = display.newGroup()

	addFloorPiece(screenGroup)
	addFloorPiece(screenGroup)
	addFloorPiece(screenGroup)
		
	jelly = utility.addJelly(screenGroup)
	jelly.x = 300
	jelly.y = 400
	jelly.name = "jelly"
	
	textObject = utility.addBlackCentredTextWithFont("TAP TO START", 
															250, 
															screenGroup, 
															50, 
															"Exo-DemiBoldItalic")
	utility.setColour(textObject, 175, 0, 175)

	physics:pause()
	utility.stopSound()
	utility.playSoundWithOptions(batSound, {loops=-1})

	for i = 1, 12 do
		local spike = utility.addSpike(screenGroup)
		spike.x = -1000 - (i * 100)	
		spike.verticalSpeed = 0		
		table.insert(spikes, spike)
	end

	for i = 1, 3 do
		local bubs = utility.addBubbles(screenGroup)
		table.insert(bubbles, bubs)
		bubs.x = -3500 - (i * 300)
	end

	for i = 1, 6 do
		local puffer = utility.addPuffer(screenGroup)
		table.insert(puffers, puffer)
		puffer.x = -5000 - (i * 200)
		puffer.direction = 1
	end

	for i = 1, 4 do
		local bump = utility.addBump(screenGroup)
		bump.x = -10000 - (i * 1000)
		table.insert(bumps, bump)
	end

end

local function touchedScreen(event)
	if started == false then		
		textObject.isVisible = false
		
		started = true
		inPlay = true
		physics:start()
		addSpike(screenGroup)
	end
	
	if inPlay and event.phase == "began" and system.getTimer() > nextTouchTime then
		jelly.rotation = 0
		jelly:play()	
		bounceJelly(-400)
		utility.playSound(batSqueak)

		local currentTime = system.getTimer()
		stopFlappingTime = currentTime + 500
	end
end

local function stopFlapping()
	if inPlay then
		if system.getTimer() > stopFlappingTime then
			jelly:pause()
		end
	
		if jelly.y < -200 then
			onCollision()
		end
	end
end



-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("levels")

	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener( "touch", touchedScreen )
	Runtime:addEventListener( "enterFrame", moveSpikes )
	Runtime:addEventListener( "enterFrame", stopFlapping )

end

function scene:exitScene(event)
	for i=foreground.numChildren,1,-1 do
        	local child = foreground[i]
	        child.parent:remove( child )
	end
	
	physics:stop()
	
	print("exiting first")
	Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener( "touch", touchedScreen )
	Runtime:removeEventListener( "enterFrame", moveSpikes )
	Runtime:removeEventListener( "enterFrame", stopFlapping )

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene