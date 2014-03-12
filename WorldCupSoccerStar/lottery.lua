local t = {}

local utility = require "utility"
local math = require "math"
local expiry

local function goBack(func, objects, returnValue)

	for i=#objects, 1, -1 do
		local thisOne = objects[i]
		table.remove(objects, i)
		thisOne:removeSelf()
	end
	
	func(returnValue)
	
end

local function spinLottery(objects, bg, func)

	if os.time() > expiry then	
		local rand = math.random(1, 100)
		local text
		
		for i=1, #objects do
			if rand > 50 and i == 1 then
				text = objects[i].string
				objects[i].isVisible = true
			elseif rand > 20 and rand < 50 and i == 2 then
				objects[i].isVisible = true
				text = objects[i].string
			elseif rand > 10 and rand < 20 and i == 3 then
				objects[i].isVisible = true
				text = objects[i].string
			elseif rand < 10 and i == 4 then
				objects[i].isVisible = true
				text = objects[i].string
			else
				objects[i].isVisible = false
			end
		end
		
		local textObject = display.newText(text, 0, 0, "Exo-DemiBoldItalic", 50)
		utility.centreObjectX(textObject)
		textObject.anchorY = 0
		textObject:translate(0, 600)
		textObject:setFillColor(0,0,0)
		
		table.insert(objects, bg)
		table.insert(objects, textObject)

		local closure = function()
			goBack(func, objects, rand)
		end
	
		timer.performWithDelay(3000, closure)
	else
		if objects[#objects].isVisible then
			objects[1].isVisible = true
			objects[#objects].isVisible = false
		else
	
			for i=1, #objects - 1 do
				if objects[i].isVisible then
					objects[i + 1].isVisible = true
					objects[i].isVisible = false
					break
				end
			end
		end
	
	
		local closure = function()
			spinLottery(objects, bg, func)
		end
		
		timer.performWithDelay(50, closure)
	end
end

local function doLottery(objects, func)
	expiry = os.time() + 5
	local opaqueBackground = display.newRect(0, 0, display.actualContentWidth, display.actualContentHeight)
	utility.putInMiddle(opaqueBackground)

	for i=#objects, 1, -1 do
		local thisOne = objects[i]
		utility.putInMiddle(thisOne)
		thisOne.isVisible = false
		thisOne:toFront()
	end
	
	objects[1].isVisible = true

	local closure = function()
		spinLottery(objects, opaqueBackground, func)
	end
	
	timer.performWithDelay(50, closure)
end



t.doInGameLottery = function(func)
	local obj = display.newImage("images/bronzeMedal.png", false)
	local obj2 = display.newImage("images/silverMedal.png", false)
	local obj3 = display.newImage("images/goldMedal.png", false)
	local obj4 = display.newImage("images/rescind.png", false) 
	obj.string = "bronzeMedal"
	obj2.string = "silverMedal"
	obj3.string = "goldMedal"
	obj4.string = "rescind"

	local objects = {}
	table.insert(objects, obj)
	table.insert(objects, obj2)
	table.insert(objects, obj3)
	table.insert(objects, obj4)
end


t.doFinalLottery = function(func)

	
	local obj = display.newImage("images/bronzeMedal.png", false)
	local obj2 = display.newImage("images/silverMedal.png", false)
	local obj3 = display.newImage("images/goldMedal.png", false)
	local obj4 = display.newImage("images/rescind.png", false) 
	obj.string = "bronzeMedal"
	obj2.string = "silverMedal"
	obj3.string = "goldMedal"
	obj4.string = "rescind"

	local objects = {}
	table.insert(objects, obj)
	table.insert(objects, obj2)
	table.insert(objects, obj3)
	table.insert(objects, obj4)
	
	doLottery(objects, func)

end

return t