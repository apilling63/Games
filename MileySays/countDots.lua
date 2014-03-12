local utility = require "utility"
local math = require "math"

local t = {}

local dots = {}

local simon
local numSelected

local callback

t.create = function(screenGroup, callbackFunc)
	for i = 1, 15 do
		local dot = display.newCircle(0,0,25)
		dot:setFillColor(0,0,255)
		utility.centreObjectX(dot)
		utility.centreObjectY(dot)
		dot:translate(2000, 200)
		screenGroup:insert(dot)
		table.insert(dots, dot)
	end

	answer1button = display.newImageRect( "images/greenButton.png", 200, 200 )
	answer1Text = display.newText("", 0, 0, "Arial", 45)
	screenGroup:insert(answer1button)
	screenGroup:insert(answer1Text)

	answer2button = display.newImageRect( "images/greenButton.png", 200, 200 )
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

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2, simonSays)
	simon = simonSays
	text2.text = "count the dots"

	local upperLimit = difficulty * #dots / 3

	numSelected = math.random(1, upperLimit)
	local incorrectAnswer = math.random(1, upperLimit)

	while numSelected == incorrectAnswer do
		incorrectAnswer = math.random(1, upperLimit)
	end

	for i = 1, numSelected do
		local dot = dots[i]

		local randX
		local randY
		local stayInLoop = true

		while stayInLoop do

			randX = math.random(-200, 200)
			randY = math.random(-170, -50)

			if i == 1 then
				break
			end

			stayInLoop = false

			for j = 1, i - 1 do
				if math.abs(dots[j].x - (dot.x + randX)) < 50 and math.abs(dots[j].y - (dot.y + randY)) < 50 then
					stayInLoop = true
				end
			end
		end

		dot:translate(randX, randY)
		dot.randY = randY
		dot.randX = randX
	end

	for i = 1, numSelected do
		local dot = dots[i]
		dot:translate(-2000, 0)
	end

	local correctButton = math.random(1,2)

	if correctButton == 1 then
		answer1Text.text = numSelected
		answer1button.isCorrect = true
	else
		answer1button.isCorrect = false
		answer1Text.text = incorrectAnswer
	end

	if correctButton == 2 then
		answer2button.isCorrect = true
		answer2Text.text = numSelected
	else
		answer2button.isCorrect = false
		answer2Text.text = incorrectAnswer
	end	

	answer1Text:translate(-2000, 0)
	answer2Text:translate(-2000, 0)
	answer1button:translate(-2000, 0)
	answer2button:translate(-2000, 0)
end

t.removeFromScreen = function()
	for i = 1, numSelected do
		local dot = dots[i]
		dot:translate(2000, 0)
		dot:translate(-dot.randX, -dot.randY)
	end

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