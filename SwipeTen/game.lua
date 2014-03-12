-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local gameData = require ("gameData")

local answers

local yesStrip
local noStrip
local answer
local yesAnswers
local noAnswers
local unanswered
local tooSlowFunction
local currentQuestionIndex
local previousCorrectIndexes
local previousIncorrectIndexes
local yesAlignment = 160
local noAlignment = 480
local awaitingAnswer

local function getRandomNotPrevious(limit, previousTable)
	local random = math.random(1, limit)
	
	for i = 1, #previousTable do
		if previousTable[i] == random then
			return getRandomNotPrevious(limit, previousTable)
		end
	end
	
	table.insert(previousTable, random)
	
	return random

end

local function addColourStrip(isGreen, xLocation, screenGroup)
	local strip = display.newRect(0, 0, 320, 650)
	utility.putInCentre(strip)
	strip.x = xLocation
	strip.y = strip.y + 50
	
	if isGreen then
		utility.setColour(strip, 0, 255, 0)
	else
		utility.setColour(strip, 255, 0, 0)	
	end
	
	screenGroup:insert(strip)
	
	return strip
end

local function tooSlow()
	if awaitingAnswer then
		table.insert(unanswered, answer)
		answer:removeSelf()	
		awaitingAnswer = false
	end

end

local function showAnswerScore(thisAnswer, expectingYes)
	if thisAnswer.isYes == expectingYes then
		thisAnswer.text = "+100"
	else
		thisAnswer.text = "0"
	end
end

local function gameComplete()
	for i=1, #yesAnswers do
		local closure = function()
			showAnswerScore(yesAnswers[i], true)
		end
		
		timer.performWithDelay(i * 500, closure)
	end
	
	for i=1, #noAnswers do
		local closure = function()
			showAnswerScore(noAnswers[i], false)
		end
		
		timer.performWithDelay((i + #yesAnswers) * 500, closure)
	end	
end

local function addNewAnswer()
	awaitingAnswer = true

	if (#yesAnswers + #noAnswers + #unanswered) < 10 then
		local random = math.random(1,2)
		local answerText = ""
		local isYes = true
		
		if random == 1 then
			local answerIndex = getRandomNotPrevious(#answers[currentQuestionIndex].correctAnswers, previousCorrectIndexes)
			answerText = answers[currentQuestionIndex].correctAnswers[answerIndex]
		else
			isYes = false
			local answerIndex = getRandomNotPrevious(#answers[currentQuestionIndex].incorrectAnswers, previousIncorrectIndexes)
			answerText = answers[currentQuestionIndex].incorrectAnswers[answerIndex]		
		end
	
		answer = utility.addBlackCentredText(answerText, 125, screenGroup, 30)
		answer.isYes = isYes
		transition.to(answer, {time = 2000, alpha = 0.1, onComplete = tooSlow})
		timer.performWithDelay(2500, addNewAnswer)
	else
		gameComplete()
	end
end

-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view

	yesAnswers = {}
	noAnswers = {}
	unanswered = {}
	previousCorrectIndexes = {}
	previousIncorrectIndexes = {}
	awaitingAnswer = false
	answers = require (gameData.category)
	
	currentQuestionIndex = math.random(1, #answers)
	local bg = display.newRect(320, 480, 900, 1200)
	utility.setColour(bg, 255, 255, 255)
	screenGroup:insert(bg)
	local title = utility.addBlackCentredText(answers[currentQuestionIndex].question, 50, screenGroup, 40)
	yesStrip = addColourStrip(true, yesAlignment, screenGroup)
	noStrip = addColourStrip(false, noAlignment, screenGroup)
	
	
	local yes = utility.addBlackCentredText("Yes", 225, screenGroup, 40)
	yes.x = yesAlignment
	local no = utility.addBlackCentredText("No", 225, screenGroup, 40)
	no.x = noAlignment
	
	addNewAnswer()
	
end

local function shouldActOnTouch(event)
	return event.phase == "began" and awaitingAnswer
end

local function touchCommon()
		awaitingAnswer = false
		transition.cancel()
		answer.alpha = 1
		
		if #answer.text > 18 then
			answer.text = answer.text:sub(1, 15) .. "..."
		end
end

local function yesTouched(event)
	if shouldActOnTouch(event) then
		touchCommon()	
		transition.to(answer, {time = 200, x = yesStrip.x, y = 300 + (#yesAnswers * 50)})
		table.insert(yesAnswers, answer)
	end
end

local function noTouched(event)
	if shouldActOnTouch(event) then
		touchCommon()	
		transition.to(answer, {time = 200, x = noStrip.x, y = 300 + (#noAnswers * 50)})		
		table.insert(noAnswers, answer)
	end
end

-- add all the event listening
function scene:enterScene(event)
	print("enter game")
	yesStrip:addEventListener("touch", yesTouched)
	noStrip:addEventListener("touch", noTouched)
	storyboard.purgeScene("menu")	
end

function scene:exitScene(event)
	yesStrip:removeEventListener("touch", yesTouched)
	noStrip:removeEventListener("touch", noTouched)
	
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene