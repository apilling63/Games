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
physics.start()  
physics.setGravity(0, 9.81)
physics.setScale(80)  -- 80 pixels per meter  

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


u.postToFacebook = function(givenMessage, identifierForPersistence)
	if facebookSession then
		print("posting to Facebook")
		local attachment = {
        		name = "Come and play Tiddly Flicks too!",
        		link = "http://www.appappnaway.co.uk/tiddly-flicks",
	        	description = "What do you get if you cross a retro platform video game with a classic board game?  TIDDLY FLICKS! Play it now on Android, iPhone and iPad",
	        	picture = "http://www.appappnaway.co.uk/images/Icon290.png",
         		message = givenMessage
        	}
                
		facebook.request( "me/feed", "POST", attachment )
		persistent.saveModule("posted" .. identifierForPersistence, true)
	else
		print("no Facebook session")
	end
end

u.hasPosted = function(identifierForPersistence)
	return getBooleanValue("posted" .. identifierForPersistence)
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

function u.addPlayerSprite()
	local playerSheetData = { width=130, height=230, numFrames=6, sheetContentWidth=780, sheetContentHeight=230 }
 
	local playerSheet = graphics.newImageSheet( "images/playerSprite.png", playerSheetData )
 
	local playerSequenceData = {
		{ name = "normalRun", start=1, count=6, time=250 },
	}
 
	return display.newSprite( playerSheet, playerSequenceData )
end

function u.addBallSprite()
	local ballData = { width=50, height=50, numFrames=4, sheetContentWidth=100, sheetContentHeight=100 }
 
	local ballSheet = graphics.newImageSheet( "images/soccerBallSprite.png", ballData )
 
	local ballSequenceData = {
		{ name = "normalRun", start=1, count=4, time=350 },
	}
 
	return display.newSprite( ballSheet, ballSequenceData )
end

function u.addBackgroundSprite()

	local bgData = { width=800, height=1100, numFrames=4, sheetContentWidth=3200, sheetContentHeight=1100 }
 
	local bgSheet = graphics.newImageSheet( "images/beach5.png", bgData )
 
	local bgSequenceData = {
		{ name = "normalRun", start=1, count=4, time=350 },
	}
 
	return display.newSprite( bgSheet, bgSequenceData )

end


return u

