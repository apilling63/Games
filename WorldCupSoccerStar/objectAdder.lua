-----------------------------------------------------------------------------------------
--
-- objectAdder.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local utility = require ("utility")
local math = require ("math")

local t = {}

local function transitionComplete(obj)
	obj.isVisible = false
end

local function prepareAnyObject(toPrepare, background, transitionTime)
	utility.centreObjectX(toPrepare)
	toPrepare.anchorX = 0.5
	toPrepare.anchorY = 1
	toPrepare.isAtFront = false
	toPrepare.x = toPrepare.x + (toPrepare.final * 20)
	utility.anchorY = 1
	toPrepare:translate(0, 250)
	toPrepare.anchorX = 0.5
	toPrepare:toBack()
	background:toBack()
	local middleX = display.contentWidth / 2
	local endX = middleX + (toPrepare.final * 200)
	transition.to ( toPrepare,{  time= transitionTime, alpha=1,x = (endX),y = (display.contentHeight + 100),width =(toPrepare.width * 5),height =(toPrepare.height * 5), onComplete=transitionComplete, tag=transitions}  ) 
end

local function prepareObject(toPrepare, background, objects, transitionTime)
	table.insert(objects, toPrepare)
	toPrepare.final = math.random(-1, 1)

	if toPrepare.collectValue then
	else
		toPrepare.collectValue = 0
	end

	prepareAnyObject(toPrepare, background, transitionTime)

end

t.addLowObject = function(screenGroup, bg, allObjects, transitionTime)
	local bather = utility.addNewPicture("lowBarrier.png", screenGroup)
	bather:scale(0.15, 0.15)
	bather.final = 0
	table.insert(allObjects, bather)
	prepareAnyObject(bather, bg, transitionTime)
end

t.addHighObject = function(screenGroup, bg, allObjects, transitionTime)
	local bather = utility.addNewPicture("wideSkiGate.png", screenGroup)
	bather:scale(0.15, 0.15)
	bather.final = 0
	table.insert(allObjects, bather)
	prepareAnyObject(bather, bg, transitionTime)
end

t.addWall = function(screenGroup, bg, allObjects, transitionTime)
	local wall = utility.addNewPicture("wall.png", screenGroup)
	wall:scale(0.2, 0.2)
	table.insert(allObjects, wall)

	local random = math.random(0, 1)

	if random == 0 then
		random = -1
	end

	wall.final = random * 0.5
	wall.collectValue = 0
	prepareAnyObject(wall, bg, transitionTime)
end

t.addPickup = function(screenGroup, bg, allObjects, transitionTime)

	local rand = math.random(1, 100)
	local pickup

	if rand > 90 then
		pickup = utility.addNewPicture("goldMedal.png", screenGroup)
		pickup.collectValue = 1000
	
	elseif rand > 70 then
		pickup = utility.addNewPicture("silverMedal.png", screenGroup)
		pickup.collectValue = 250
	
	elseif rand > 8 then
		pickup = utility.addNewPicture("bronzeMedal.png", screenGroup)
		pickup.collectValue = 100
	
	elseif rand > 3 then
		pickup = utility.addNewPicture("purplePatch.png", screenGroup)
		pickup.collectValue = -1
	else
		pickup = utility.addNewPicture("stopwatch.png", screenGroup)
		pickup.collectValue = -2
	end

	pickup:scale(0.08, 0.08)
	prepareObject(pickup, bg, allObjects, transitionTime)

end

t.addCone = function(screenGroup, bg, allObjects, transitionTime)
	local cone = utility.addNewPicture("cone.png", screenGroup)
	cone:scale(0.2, 0.2)
	prepareObject(cone, bg, allObjects, transitionTime)
	return cone
end


return t