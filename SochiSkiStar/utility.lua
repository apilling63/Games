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

u.getCoins = function()
	local value = persistent.getValue("COIN")
	
	if value then
		print(value .. " coins")
		return value
	else
			print(0 .. " coins")

		return 0
	end
end

u.setSpeed = function(score)
	persistent.saveModule("SPEED", score)
end

u.getSpeed = function()
	local value = persistent.getValue("SPEED")
	
	if value then
		return value
	else
		return 10
	end
end

u.setCoins = function(score)
	print("setting coins as" .. score)

	persistent.saveModule("COIN", score)
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

u.getCoinTotal = function()
	local value = persistent.getValue("COINTOTAL")
	
	if value then
		return value
	else
		return 0
	end
end

u.addToCoinTotal = function(coins)
	local value = u.getCoinTotal()

	persistent.saveModule("COINTOTAL", value + coins)
end

u.getDistanceTotal = function()
	local value = persistent.getValue("DISTANCETOTAL")
	
	if value then
		return value
	else
		return 0
	end
end

u.addToDistanceTotal = function(distance)

	persistent.saveModule("DISTANCETOTAL", distance)
end

u.getResponsiveness = function()
	local value = persistent.getValue("RESPONSIVENESS")

	if value then
		return value
	else
		return "BASIC"
	end
end

u.upgradeResponsiveness = function()
	local current = u.getResponsiveness()

	if current == "BASIC" then
		persistent.saveModule("RESPONSIVENESS", "INTERMEDIATE")
	else
		persistent.saveModule("RESPONSIVENESS", "ADVANCED")
	end
end

u.getSpeed = function()
	local value = persistent.getValue("SPEED")
	
	if value then
		return value
	else
		return "BASIC"
	end
end

u.upgradeSpeed = function()
	local current = u.getSpeed()

	if current == "BASIC" then
		persistent.saveModule("SPEED", "INTERMEDIATE")
	else
		persistent.saveModule("SPEED", "ADVANCED")
	end
end

u.getStability = function()
	local value = persistent.getValue("STABILITY")
	
	if value then
		return value
	else
		return "BASIC"
	end
end

u.upgradeStability = function()
	local current = u.getStability()

	if current == "BASIC" then
		persistent.saveModule("STABILITY", "INTERMEDIATE")
	else
		persistent.saveModule("STABILITY", "ADVANCED")
	end
end

u.getSpeedNumber = function()

	local current = u.getSpeed()
	
	local retVal = 1
	
	if current == "INTERMEDIATE" then
		retVal = 2
	elseif current == "ADVANCED" then
		retVal = 3
	end
	
	return retVal
	
end

u.getResponsivenessNumber = function()

	local current = u.getResponsiveness()
	
	local retVal = 10
	
	if current == "INTERMEDIATE" then
		retVal = 20
	elseif current == "ADVANCED" then
		retVal = 40
	end
	
	return retVal
	
end

u.getStabilityNumber = function()

	local current = u.getStability()
	
	local retVal = 1
	
	if current == "INTERMEDIATE" then
		retVal = 2
	elseif current == "ADVANCED" then
		retVal = 4
	end
	
	return retVal
	
end

u.getBronzeMedals = function()
	local value = persistent.getValue("BRONZE")
	
	if value then
		return value
	else
		return 0
	end
end

u.addSilverMedal = function()
	persistent.saveModule("SILVER", u.getSilverMedals() + 1)
end

u.getSilverMedals = function()
	local value = persistent.getValue("SILVER")
	
	if value then
		return value
	else
		return 0
	end
end

u.addBronzeMedal = function()
	persistent.saveModule("BRONZE", u.getBronzeMedals() + 1)
end

u.getGoldMedals = function()
	local value = persistent.getValue("GOLD")
	
	if value then
		return value
	else
		return 0
	end
end

u.addGoldMedal = function()
	persistent.saveModule("GOLD", u.getGoldMedals() + 1)
end

return u

