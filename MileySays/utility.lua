-----------------------------------------------------------------------------------------
--
-- utility.lua
--
-----------------------------------------------------------------------------------------
local u = {}

local persistent = require "persistent" 
local playSounds = true 

function u.playSound(sound)
	if playSounds == true then
		audio.play(sound)
	end
end

function u.playSoundWithOptions(sound, options)
	if playSounds == true then
		audio.play(sound, options)
	end
end

function u.stopSound()
	if playSounds == true then
		print("stopping sounds")
		audio.stop()
	end
end

u.centreObjectX = function(object)
	object.anchorX = 0.5
	object.anchorY = 0
	object.x = display.contentWidth / 2
end

u.centreObjectY = function(object)
	object.anchorX = 0.5
	object.anchorY = 0.5
	object.y = display.contentHeight / 2
end

u.addObject = function(obj, screenGroup, xMove, yMove)
	u.centreObjectX(obj)
	u.centreObjectY(obj)
	obj:translate(xMove, yMove)
	screenGroup:insert(obj)
end

u.addCentredText = function(text, yLocation, screenGroup, size)
	local textObject = display.newText(text, 0, yLocation, "GoodDog", size)
	u.centreObjectX(textObject)
	screenGroup:insert(textObject)
	return textObject
end

u.addBlackCentredText = function(text, yLocation, screenGroup, size)
	local textObject = u.addCentredText(text, yLocation, screenGroup, size)
	textObject:setFillColor(0,0,0)
	return textObject
end

local function getBooleanValue(lookup)
	local value = persistent.getValue(lookup)
	
	if value then
		return true
	else
		return false
	end
end

local function split(pString, pPattern)
   local Table = {}
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
  end
 
   return Table
end



function u.doSounds(yesNo)
	playSounds = yesNo
	persistent.saveModule("sound", yesNo)
end

function u.willPlaySounds()
	print("should I play sound?")
	playSounds = persistent.getValue("sound")

	if playSounds == nil then
		print("playSounds is nil")
		playSounds = true
	end

	return playSounds

end

function u.getBestScore()
	local best = persistent.getValue("best")

	if best == nil then
		best = 0
	end

	return best
end

function u.setBestScore(score)
	persistent.saveModule("best", score)
end

function u.getAverageTime()
	local best = persistent.getValue("average")

	if best == nil then
		best = 2000
	end

	return best
end

function u.setAverageTime(timeTaken, numResponses)
	
	if numResponses > 49 then
		local average = timeTaken / numResponses
		persistent.saveModule("average", average)
	else
		local currentAverage = u.getAverageTime()
		local totalTime = currentAverage * 50
		local remainingTotal = totalTime - (currentAverage * numResponses)
		local newAverage =  (remainingTotal + timeTaken) / 50
		persistent.saveModule("average", newAverage)	
	end
end

function u.unlockedFractions()
	return getBooleanValue("fractions")
end

function u.unlockFractions()
	persistent.saveModule("fractions", true)
end

function u.unlockedFlowers()
	return getBooleanValue("flowers")
end

function u.unlockFlowers()
	persistent.saveModule("flowers", true)
end

function u.unlockedPresidents()
	return getBooleanValue("presidents")
end

function u.unlockPresidents()
	persistent.saveModule("presidents", true)
end

function u.unlockedLandmarks()
	return getBooleanValue("landmarks")
end

function u.unlockLandmarks()
	persistent.saveModule("landmarks", true)
end

return u

