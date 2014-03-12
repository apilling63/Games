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
local math = require "math" 

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

local function fblistener( event )
    if ( "session" == event.type ) then
	print("successfully connected to Facebook")
        -- upon successful login
        if ( "login" == event.phase ) then
        	facebookSession = true
        end

    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        print( response )
    end
end

u.initialise = function()
	facebook.login( "1234567890", fblistener, {"publish_stream"} )
end


local function getBooleanValue(lookup)
	local value = persistent.getValue(lookup)
	
	if value then
		return true
	else
		return false
	end
end

u.getHighScore = function()
	local value = persistent.getValue("HIGHSCORE")
	
	if value then
		return value
	else
		return 0
	end
end

u.setHighScore = function(score)
	persistent.saveModule("HIGHSCORE", score)
end

u.getTotalDistance = function()
	local value = persistent.getValue("TOTALDISTANCE")
	
	if value then
		return value
	else
		return 0
	end
end

u.setTotalDistance = function(distance)
	persistent.saveModule("TOTALDISTANCE", distance)
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

function u.addBackgroundSprite()

	local bgData = { width=800, height=1100, numFrames=4, sheetContentWidth=3200, sheetContentHeight=1100 }
 
	local bgSheet = graphics.newImageSheet( "images/grassSprite.png", bgData )
 
	local bgSequenceData = {
		{ name = "normalRun", frames={4,3,2,1}, time=350 },
	}
 
	return display.newSprite( bgSheet, bgSequenceData )

end

function u.addPlayerSprite()
	local playerSheetData = { width=130, height=230, numFrames=6, sheetContentWidth=780, sheetContentHeight=230 }
 
	local playerSheet = graphics.newImageSheet( "images/playerSprite.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=6, time=250 },
	}
 
	return display.newSprite( playerSheet, playerSequenceData )
end

u.getDistancePercentage = function()
	local distance = u.getTotalDistance()
	local tenTimesPercentage = math.round((distance / 500) - 0.5)
	return tenTimesPercentage / 100
end

u.getSkillPercentage = function()
	local highScore = u.getHighScore()
	local tenTimesPercentage = math.round((highScore / 50) - 0.5)
	return tenTimesPercentage / 100
end

u.getRank = function()
	local value = persistent.getValue("RANK")
	
	if value then
		return value
	else
		return 0
	end
end

u.getNumRescinds = function()
	local value = persistent.getValue("RESCINDS")
	
	if value then
		return value
	else
		return 0
	end
end

u.setNumRescinds = function(rescinds)
	persistent.saveModule("RESCINDS", rescinds)
end

return u

