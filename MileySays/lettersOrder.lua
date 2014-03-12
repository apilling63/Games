local utility = require "utility"
local math = require "math"

local t = {}

local dots = {}
local letters = {"A", "B", "C"}

local oneClicked
local twoClicked
local simon

local callback

t.create = function(screenGroup, callbackFunc)
	for i = 1, 3 do
		local dot = display.newImageRect( "images/button" .. letters[i] .. ".png", 140, 127 )
		dot.index = i
		utility.centreObjectX(dot)
		utility.centreObjectY(dot)
		dot:translate(2000, 200)
		screenGroup:insert(dot)
		table.insert(dots, dot)
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

		local randX
		local randY
		local stayInLoop = true

		while stayInLoop do

			randX = math.random(-150, 200)
			randY = math.random(-150, 200)

			if i == 1 then
				break
			end

			stayInLoop = false

			for j = 1, i - 1 do
				if math.abs(dots[j].x - (dot.x + randX)) < 150 and math.abs(dots[j].y - (dot.y + randY)) < 150 then
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
	end

end

t.removeFromScreen = function()
	for i = 1, 3 do
		local dot = dots[i]
		dot:translate(2000, 0)
		dot:translate(-dot.randX, -dot.randY)
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