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
		return audio.play(sound)
	end
end

function u.playSoundWithOptions(sound, options)
	if playSounds == true then
		return audio.play(sound, options)
	end
end

function u.stopSound()
	if playSounds == true then
		print("stopping sounds")
		audio.stop()
	end
end

function u.addNewPicture(picture, screenGroup)
	local image = display.newImage("images/" .. picture, false) 
	screenGroup:insert(image)
	return image
end

function u.putInCentre(object)
	object.anchorX = 0.5
	object.anchorY = 0.5
	object.x = display.contentWidth / 2
	object.y = display.contentHeight / 2
end

u.centreObjectX = function(object)
	object.anchorX = 0.5
	object.x = display.contentWidth / 2
end

u.addCentredText = function(text, yLocation, screenGroup, size, font)
	local thisFont = "Arial"

	if font then
		thisFont = font
	end

	local textObject = display.newText(text, 0, 0, thisFont, size)
	u.centreObjectX(textObject)
	textObject.anchorY = 0
	textObject:translate(0, yLocation)
	screenGroup:insert(textObject)
	return textObject
end

u.addBlackCentredText = function(text, yLocation, screenGroup, size)
	local textObject = u.addCentredText(text, yLocation, screenGroup, size)
	textObject:setFillColor(0,0,0)
	return textObject
end

u.addBlackCentredTextWithFont = function(text, yLocation, screenGroup, size, font)
	local textObject = u.addCentredText(text, yLocation, screenGroup, size, font)
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

u.setColour = function(object, red, green, blue)
	object:setFillColor(red/255, green/255, blue/255)
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


function u.addSpiralSprite(screenGroup)
	local playerSheetData = { width=150, height=150, numFrames=8, sheetContentWidth=1200, sheetContentHeight=150 }
 
	local playerSheet = graphics.newImageSheet( "images/spiral.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=8, time=250, loopCount=3 },
	}
 
 	local ret = display.newSprite( playerSheet, playerSequenceData )
	screenGroup:insert(ret)
 
	return ret
end

function u.addButtonSprite(screenGroup)
	local playerSheetData = { width=175, height=175, numFrames=2, sheetContentWidth=350, sheetContentHeight=175 }
 
	local playerSheet = graphics.newImageSheet( "images/button.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=2, time=250, loopCount=3, loopDirection="bounce" },
	}
 
 	local ret = display.newSprite( playerSheet, playerSequenceData )
	screenGroup:insert(ret)
 
	return ret
end

function u.addBellSprite(screenGroup)
	local playerSheetData = { width=240, height=180, numFrames=4, sheetContentWidth=240, sheetContentHeight=720 }
 
	local playerSheet = graphics.newImageSheet( "images/bell.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=4, time=250, loopCount=3, loopDirection="bounce" },
	}
 
 	local ret = display.newSprite( playerSheet, playerSequenceData )
	screenGroup:insert(ret)
 
	return ret
end

function u.addSwitchSprite(screenGroup)
	local playerSheetData = { width=150, height=150, numFrames=2, sheetContentWidth=150, sheetContentHeight=300 }
 
	local playerSheet = graphics.newImageSheet( "images/switch.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=2, time=250, loopCount=1, loopDirection="bounce" },
	}
 
 	local ret = display.newSprite( playerSheet, playerSequenceData )
	screenGroup:insert(ret)
 
	return ret
end
return u

