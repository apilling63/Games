-----------------------------------------------------------------------------------------
--
-- utility.lua
--
-----------------------------------------------------------------------------------------
local u = {}
local facebookSession = false

local persistent = require "persistent" 
local facebook = require "facebook"
local playSounds = true
local physics = require "physics" 

local staticMaterial = {density=1, friction=.4, bounce=.1}
local spikeShape = {
	47,-199,
	-32,199,
	-47,55,
	-47,-199,
}

local spikeMaterial = {density=2, friction=.4, bounce=.1, shape=spikeShape}

local jellyShape = {
	34,-32,
	34,0,
	-34,-22,
	-4,-47,
}

local bumpShape = {
	250,-300,
	500,300,
	-500,300,
	-250,-300,
}

local jellyMaterial = {density=1, friction=.4, bounce=.1, shape=jellyShape}

local bumpMaterial = {density=1, friction=.4, bounce=.1, shape=bumpShape}

function u.addSpike(screenGroup)
	local image = u.addNewPicture("spike.png", screenGroup) 
	physics.addBody(image, "static", spikeMaterial) 
	return image
end

function u.addPuffer(screenGroup)
	local image = u.addNewPicture("puffer.png", screenGroup) 
	physics.addBody(image, "static", staticMaterial) 
	return image
end

function u.addBump(screenGroup)
	local image = u.addNewPicture("bump.png", screenGroup) 
	physics.addBody(image, "static", bumpMaterial) 
	return image
end

function u.addJelly(screenGroup)
	local jellyData = { width=70, height=95, numFrames=3, sheetContentWidth=210, sheetContentHeight=95 }
 
	local jellySheet = graphics.newImageSheet( "images/jellies.png", jellyData )
 
	local jellyData = {
		{ name = "fly", start=1, count=3, time=100 },
	}
 
	local jelly = display.newSprite( jellySheet, jellyData )
	screenGroup:insert(jelly)

	physics.addBody(jelly, "dynamic", jellyMaterial) 

	return jelly
end

function u.addBubbles(screenGroup)
	local jellyData = { width=90, height=600, numFrames=4, sheetContentWidth=360, sheetContentHeight=600 }
 
	local jellySheet = graphics.newImageSheet( "images/bubbles.png", jellyData )
 
	local jellyData = {
		{ name = "fly", start=1, count=4, time=500 },
	}
 
	local jelly = display.newSprite( jellySheet, jellyData )
	screenGroup:insert(jelly)

	return jelly
end

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


function u.addNewStaticPicture(picture, screenGroup)
	local image = u.addNewPicture(picture, screenGroup) 
	physics.addBody(image, "static", staticMaterial) 
	return image
end

function u.addNewKinematicPicture(picture, screenGroup)
	local image = u.addNewPicture(picture, screenGroup) 
	physics.addBody(image, "kinematic", staticMaterial) 
	return image
end

function u.addNewDynamicPicture(picture, screenGroup)
	local image = u.addNewPicture(picture, screenGroup) 
	physics.addBody(image, "dynamic", staticMaterial) 
	return image
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

u.setLastCompletedLevel = function(level)
	persistent.saveModule("LEVEL", level)
end

u.getLastCompletedLevel = function()
	local value = persistent.getValue("LEVEL")
	
	if value then
		return value
	else
		return 0
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


function u.putInMiddle(obj)
	obj.x = display.contentWidth / 2
	obj.y = display.contentHeight / 2
end

u.setColour = function(object, red, green, blue)
	object:setFillColor(red/255, green/255, blue/255)
end


return u

