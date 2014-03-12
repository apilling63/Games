local utility = require "utility"
local math = require "math"

local t = {}

local equationText
local answer1button
local answer2button
local answer1Text
local answer2Text


local callback

t.create = function(screenGroup, callbackFunc)
	print("creating numbers")
	equationText = display.newText("", 0, 0, "Arial", 45)
	equationText:setFillColor(0,0,0)
	utility.addObject(equationText, screenGroup, 0, 100)

	utility.centreObjectX(equationText)
	utility.centreObjectY(equationText)
	screenGroup:insert(equationText)

	answer1button = display.newImageRect( "images/greenButton.png", 200, 200 )
	answer1button.isCorrect = false

	answer1Text = display.newText("", 0, 0, "Arial", 45)
	screenGroup:insert(answer1button)
	screenGroup:insert(answer1Text)

	answer2button = display.newImageRect( "images/greenButton.png", 200, 200 )
	answer2button.isCorrect = false

	answer2Text = display.newText("", 0, 0, "Arial", 45)
	

	screenGroup:insert(answer2button)
	screenGroup:insert(answer2Text)

	utility.centreObjectX(answer1button)
	utility.centreObjectY(answer1button)
	utility.centreObjectX(answer2button)
	utility.centreObjectY(answer2button)
	utility.centreObjectX(answer1Text)
	utility.centreObjectY(answer1Text)
	utility.centreObjectX(answer2Text)
	utility.centreObjectY(answer2Text)
	answer1button:translate(1800, 300)
	answer2button:translate(2200, 300)
	answer1Text:translate(1800, 300)
	answer2Text:translate(2200, 300)
	equationText:translate(2000, 100)

	print(equationText.x .. " " .. equationText.y)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	local num1 = math.random(1, 9)
	local num2 = math.random(1, 9)

if difficulty == 2 then
	num1 = math.random(1, 99)
	num2 = math.random(1, 99)

end

	local correctAnswer = num1 + num2

if difficulty == 3 then
	correctAnswer = num1 * num2
end

	local incorrectAnswer = correctAnswer + math.random(1, 3)

	local correctButton = math.random(1,2)

	equationText.text = num1 .. " + " .. num2 .. " ="

if difficulty == 3 then
	equationText.text = num1 .. " * " .. num2 .. " ="
end

	if correctButton == 1 then
		answer1Text.text = correctAnswer
		answer2Text.text = incorrectAnswer
		answer1button.isCorrect = true

	else
		answer2Text.text = correctAnswer
		answer1Text.text = incorrectAnswer
		answer2button.isCorrect = true

	end

	print("show numbers")
	text2.text = "solve"
	equationText:translate(-2000, 0)
	answer1Text:translate(-2000, 0)
	answer2Text:translate(-2000, 0)
	answer1button:translate(-2000, 0)
	answer2button:translate(-2000, 0)

end

t.removeFromScreen = function()
	print("hide numbers")

	equationText:translate(2000, 0)
	answer1Text:translate(2000, 0)
	answer2Text:translate(2000, 0)
	answer1button:translate(2000, 0)
	answer2button:translate(2000, 0)
end

local function tapped(self, event)
	callback(self.isCorrect, event)
end


t.addEventListeners = function()
	answer1button.tap = tapped
	answer2button.tap = tapped

	answer1button:addEventListener("tap", answer1button)
	answer2button:addEventListener("tap", answer2button)

end

t.removeEventListeners = function()
	answer1button:removeEventListener("tap", answer1button)
	answer2button:removeEventListener("tap", answer1button)

end

return t