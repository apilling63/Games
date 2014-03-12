local utility = require "utility"
local math = require "math"

local t = {}

local buttonA
local buttonB
local touchedA
local touchedB
local line
local touchBegan

local simon

local callback

t.create = function(screenGroup, callbackFunc)
	buttonA = display.newImageRect( "images/greenButton.png", 200, 200 )
	utility.centreObjectX(buttonA)
	utility.centreObjectY(buttonA)
	buttonA:translate(1800, 150)
	screenGroup:insert(buttonA)

	buttonB = display.newImageRect( "images/greenButton.png", 200, 200 )
	utility.centreObjectX(buttonB)
	utility.centreObjectY(buttonB)
	buttonB:translate(2200, 150)
	screenGroup:insert(buttonB)
	line = display.newLine(0,0,0,0)

	local aText = display.newText("A", 0, 0, "Arial", 80)
	aText:setFillColor(0,0,0)
	utility.addObject(aText, screenGroup, 0, 0)

	local bText = display.newText("B", 0, 0, "Arial", 80)
	bText:setFillColor(0,0,0)
	utility.addObject(bText, screenGroup, 0, 0)

	buttonA.text = aText
	buttonB.text = bText

	aText.x = buttonA.x
	aText.y = buttonA.y
	bText.x = buttonB.x
	bText.y = buttonB.y

	callback = callbackFunc
end

local function touchAnywhere(event)
	if event.phase == "ended" and not touchedB and touchBegan then
		print("fail incomplete swipe")
		callback(false, event)
	end

	if not simon and event.phase == "began" then
		print("fail not simon")
		callback(false, event)
	elseif touchedA then
		line:removeSelf()
		line = display.newLine(buttonA.x, buttonA.y, event.x, event.y)
		line.strokeWidth = 10
		line:setColor(0,0,0)
	elseif event.phase == "began" then
		print("fail not touched A")
		callback(false, event)
	end
end

t.showOnScreen = function(difficulty, text2, simonSays)
	simon = simonSays

	if difficulty == 1 then
		buttonA.text.text = "A"
		buttonB.text.text = "B"
		text2.text = "swipe from A to B"
	else
		buttonA.text.text = "δ"
		buttonB.text.text = "λ"
		text2.text = "swipe from delta to lambda"

		local random = math.random(0,1)

		if random == 1 then
			local x1 = buttonA.x
			local y1 = buttonA.y

			buttonA.x = buttonB.x
			buttonA.y = buttonB.y
			buttonB.x = x1
			buttonB.y = y1

		end
	end


	buttonA:translate(-2000, 0)
	buttonB:translate(-2000, 0)
	buttonA.text.x = buttonA.x
	buttonA.text.y = buttonA.y
	buttonB.text.x = buttonB.x
	buttonB.text.y = buttonB.y

	line = display.newLine(buttonA.x,buttonA.y,buttonA.x,buttonA.y)

	Runtime:addEventListener("touch", touchAnywhere)

end

t.removeFromScreen = function()
	buttonA:translate(2000, 0)
	buttonB:translate(2000, 0)
	buttonA.text.x = buttonA.x
	buttonA.text.y = buttonA.y
	buttonB.text.x = buttonB.x
	buttonB.text.y = buttonB.y
	touchedA = false
	touchedB = false
	line:removeSelf()
	touchBegan = false
	Runtime:removeEventListener("touch", touchAnywhere)

end

local function touchA(event)
	if event.phase == "began" and simon then
		print("touched A")
		touchedA = true
		touchBegan = true
	end
end

local function touchB(event)
	if "began" ~= event.phase and touchBegan then
		if not touchedB and simon then
			print("touched B")
			touchedB = true
	
			if touchedA then
				print("success")
				callback(true, event)
			else
				print("fail not touched a touched b")
				callback(false, event)
			end
		end		
	else
		print("fail began touch at B")
		callback(false, event)
	end
end

t.addEventListeners = function()
	buttonA:addEventListener("touch", touchA)
	buttonB:addEventListener("touch", touchB)
end

t.removeEventListeners = function()
	greenButton:removeEventListener("tap", touchA)
	redButton:removeEventListener("tap", touchB)
end

return t