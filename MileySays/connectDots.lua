local utility = require "utility"
local math = require "math"

local t = {}

local dots = {}

local oneClicked
local twoClicked
local simon

local callback

t.create = function(screenGroup, callbackFunc)
	for i = 1, 3 do
		local dot = display.newImageRect( "images/greenButton.png", 100, 100 )
		
		local number = i

		local dotText = display.newText(i, 0, 0, "Arial", 45)
		dotText:setFillColor(0,0,0)
		dot.dotText = dotText

		dot.index = i
		utility.centreObjectX(dot)
		utility.centreObjectY(dot)
		dot:translate(2000, 200)

		screenGroup:insert(dot)
		table.insert(dots, dot)
		utility.addObject(dotText, screenGroup, 0, 0)

		dotText.x = dot.x
		dotText.y = dot.y
	end

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2, simonSays)
	simon = simonSays
	oneClicked = false
	twoClicked = false
	text2.text = "press in order"

	for i = 1, 3 do
		local dot = dots[i]
		local number = i

		if difficulty == 2 then
			number = math.random(33 * (i - 1), 33 * i)
		elseif difficulty == 3 then
			number = math.random(33 * (i - 1), 33 * i) - 66
		end

		dot.dotText.text = number

		local randX
		local randY
		local stayInLoop = true

		while stayInLoop do

			randX = math.random(-200, 200)
			randY = math.random(-170, 200)

			if i == 1 then
				break
			end

			stayInLoop = false

			for j = 1, i - 1 do
				if math.abs(dots[j].x - (dot.x + randX)) < 100 and math.abs(dots[j].y - (dot.y + randY)) < 100 then
					stayInLoop = true
				end
			end
		end

		dot:translate(randX, randY)
		dot.randY = randY
		dot.randX = randX
		dot.alpha = 1
	end

	for i = 1, 3 do
		local dot = dots[i]
		dot:translate(-2000, 0)
		dot.dotText.x = dot.x
		dot.dotText.y = dot.y
	end

end

t.removeFromScreen = function()
	for i = 1, 3 do
		local dot = dots[i]
		dot:translate(2000, 0)
		dot:translate(-dot.randX, -dot.randY)
		dot.dotText.x = dot.x
		dot.dotText.y = dot.y
	end
end

local function tapped(self, event)
	print("tapped")

	if simon then
		if self.index == 3 and oneClicked and twoClicked then
			print("tapped 3")

			callback(true, event)
		elseif self.index == 2 and oneClicked then
			print("tapped 2")

			twoClicked = true
			self.alpha = 0.5
		elseif self.index == 1 and not twoClicked then
			print("tapped 1")

			oneClicked = true
			self.alpha = 0.5
		else
			print("tapped incorrect order")

			callback(false, event)
		end
	else
		print("tapped when simon false")
		callback(false, event)
	end

end

t.addEventListeners = function()
	for i = 1, 3 do
		local dot = dots[i]
		dot.tap = tapped
		dot:addEventListener("tap", dot)
	end
end

t.removeEventListeners = function()
	for i = 1, 3 do
		local dot = dots[i]
		dot:removeEventListener("tap", dot)
	end
end

return t