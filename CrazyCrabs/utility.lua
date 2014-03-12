-----------------------------------------------------------------------------------------
--
-- utility.lua
--
-----------------------------------------------------------------------------------------
local u = {}
local facebookSession = false

staticMaterial = {density=.8, friction=.8, bounce=.01}

local persistent = require "persistent" 
local facebook = require "facebook"
local playSounds = true
local physics = require "physics"
--physics.start()  
--physics.setGravity(9.81, 0)
--physics.setScale(80)  -- 80 pixels per meter  

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
	object:setReferencePoint(display.TopCenterReferencePoint)
	object.x = display.contentWidth / 2
end

u.addCentredText = function(text, yLocation, screenGroup, size)
	local textObject = display.newText(text, 0, yLocation, "GoodDog", size)
	u.centreObjectX(textObject)
	screenGroup:insert(textObject)
	return textObject
end

u.addBlackCentredText = function(text, yLocation, screenGroup, size)
	local textObject = u.addCentredText(text, yLocation, screenGroup, size)
	textObject:setTextColor(0,0,0)
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

return u

