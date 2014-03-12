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

local animals = {}

local playing = true
local timeLineCover
local bg
local started = false
local screenGroup
local playButton
local correct = false
local timeLine
local binoculars
local example
local exampleCounter
local answers = {}

local function goToMenu()
	for i = 1, #answers do
		answers[#answers]:removeSelf()
		table.remove(answers)
	end

	timeLine:removeSelf()

	storyboard.gotoScene("menu")
end

local function addToScore()

	if (timeLineCover.x > timeLine.x + 10) then
		scoreCounter.score = scoreCounter.score + 100
		scoreCounter.text = scoreCounter.score
		timeLineCover.x = timeLineCover.x - 10
		timer.performWithDelay(10, addToScore)
	else
		scoreCounter.score = scoreCounter.score + ((timeLineCover.x - timeLine.x) * 10)
		scoreCounter.text = scoreCounter.score
		timer.performWithDelay(1000, goToMenu)
	end

end

local function restartGame()
	if correct then
		addToScore()
	else
		timer.performWithDelay(1000, goToMenu)
	end
end

local function onComplete()
	playing = false
	binoculars:toBack()
	example:toBack()
	exampleCounter:toBack()
	timeLineCover:setColor(255,255,255)
end

local function getDirection()
	local direction = math.random(-3, 3)

	if direction == 0 then
		direction = getDirection()
	end

	return direction
end

local function getXandY()
	local x = math.random(0, 960)
	local y = math.random(80, 500)

	local acceptable = true

	for i=1, #answers do
		local unallowedX = answers[i].x
		local unallowedY = answers[i].y

		if math.abs(x - unallowedX) < 10 and math.abs(y - unallowedY) < 50 then
			acceptable = false
			break
		end
	end

	if not acceptable then
		x, y = getXandY()
	end

	return x, y
end

local function addAnimal(pictureName, isAnswer)
	local zebra = utility.addNewPicture(pictureName, screenGroup)

	local x, y = getXandY()
	zebra.x = x
	zebra.y = y
	zebra.direction = getDirection()

	if (zebra.direction > 0) then
		zebra.xScale = -1
	end

	if isAnswer then
		table.insert(answers, zebra)
	else
		table.insert(animals, zebra)
	end

	return zebra
end

local function addZebra()
	return addAnimal("zebra.png")
end

local function addMoose()
	return addAnimal("moose.png")
end

local function addGiraffe()
	return addAnimal("giraffe.png", true)
end

local function addFlamingo()
	return addAnimal("flamingo.png")
end

local function addCamel()
	return addAnimal("camel.png")
end

local function addParrot()
	return addAnimal("parrot.png")
end

local function hitBg()
	print("bg")

	if started and playing then
		onComplete()
	end

	correct = false

	return true
end

local function hitTarget(self, event)
	print("target")

	if started and playing then
		if #answers == 1 then
			onComplete()
			timeLine:setColor(0,255,0)
		else
			for i = 1, #answers do
				if answers[i] == self then
					answers[i]:removeSelf()
					table.remove(answers, i)
					break
				end
			end
		end

		exampleCounter.text = #answers
	end

	correct = true

	return true
end

local function addAnswer()
	local answer = addGiraffe()
	answer.tap = hitTarget
	answer:addEventListener("tap", answer)
	answer:addEventListener("touch", function() return true end)
end

-- what to do when the screen loads
function scene:createScene(event)
	playing = false
	started = false
	screenGroup = self.view

	bg = display.newRect( -300, -300, 2000, 2000 )
	screenGroup:insert(bg)

	correct = false

	for i = 1, gameData.numAnswers do
		addAnswer()
	end

	for i = 1, gameData.difficulty do
		addZebra()
		addMoose()
		addFlamingo()
		addCamel()
		addParrot()
	end

	binoculars = utility.addNewPicture("binoculars.png", screenGroup)
	utility.centreObjectX(binoculars)
	binoculars:translate(0, 0)

	exampleCounter = utility.addCentredText("1", 50, screenGroup, 50)
	exampleCounter.x = 100
	exampleCounter:setTextColor(192, 192, 192)
	exampleCounter.count = #answers
	exampleCounter.text = exampleCounter.count

	scoreCounter = utility.addCentredText("0", 50, screenGroup, 50)
	scoreCounter.x = 850
	scoreCounter:setTextColor(192, 192, 192)
	scoreCounter.score = 0

	example = utility.addNewPicture("giraffe.png", screenGroup)
	example.x = 50
	example.y = 100

	timeLine = display.newLine(10, 600, 950, 600)
	screenGroup:insert(timeLine)
	timeLine.width = 35
	timeLine:setColor(255, 0, 0)

	timeLineCover = display.newLine(950, 600, 950 + 940, 600)
	screenGroup:insert(timeLineCover)
	timeLineCover.width = 35
	timeLineCover.startX = timeLineCover.x
	timeLineCover:setColor(0, 0, 0)

	playing = true
	started = true

end

local function moveTimer(event)
	if started and playing then
		if timeLineCover.x > 10 then
			timeLineCover.x = timeLineCover.x - 1
		else
			onComplete()
		end
	end
end

local function moveAnimal(animal)
	if animal.x > 940 then
		animal.x = 20
	elseif animal.x < 20 then
		animal.x = 940
	end

	animal.x = animal.x + animal.direction
end

local function moveAnimals(event)
	if started then
		if playing then
			for i = 1, #animals do
				local animal = animals[i]
				moveAnimal(animal)
			end

			for i = 1, #answers do
				local animal = answers[i]
				moveAnimal(animal)
			end
		elseif #animals > 0 then
			animals[#animals]:removeSelf()
			table.remove(animals)
		else
			started = false
			timer.performWithDelay(3000, restartGame)
		end
	end
end

-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("menu")

	Runtime:addEventListener( "enterFrame", moveAnimals )

	Runtime:addEventListener( "enterFrame", moveTimer )

	bg:addEventListener("tap", hitBg)

end

function scene:exitScene(event)

	Runtime:removeEventListener( "enterFrame", moveAnimals )
	Runtime:removeEventListener( "enterFrame", moveTimer )

	bg:removeEventListener("tap", hitBg)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene