-----------------------------------------------------------------------------------------
--
-- playGame.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local textObject
local gn = require( "gameNetwork")
local matchId

local function loadLocalPlayerListener(loadLocalPlayerEvent)
	textObject.text = loadLocalPlayerEvent.data.playerID .. " " .. matchId
end

local function createGameCallback(roomEvent)
	textObject.text = "CREATED MATCH"

	matchId = roomEvent.data.matchID
	gn.request("loadLocalPlayer", {listener = loadLocalPlayerListener})
end

local function createGame()

	local iOSVersion = system.getInfo( "platformVersion" )
	if iOSVersion == "6.0" or iOSVersion == "6.0.1" or iOSVersion == "6.0.2" then
		textObject.text = "CREATING MATCH FOR IOS 6"
		request("createMatch", {
				listener = createGameCallback,
				playerIDs = {},
				minPlayers = 2,
				maxPlayers = 2,
			})
	else
		textObject.text = "CREATING MATCH"

		gn.show("createMatch", {
				listener = createGameCallback,
				playerIDs = {},
				minPlayers = 2,
				maxPlayers = 2,
			})
	end

end

local function playersListener(playersLoadedEvent)
	textObject.text = "GOT FRIEND DATA"
	friendsArray = playersLoadedEvent.data
	
	if friendsArray == nil then
		textObject.text = "YOU HAVE NO FRIENDS - CLICK TO PLAY"
	else
	textObject.text = #friendsArray .. " FRIENDS"
		for i=1, #friendsArray do
			local textObjectRow = utility.addBlackCentredText(friendsArray[i].alias, (i + 1) * 100, self.view, 30)
			utility.setColour(textObjectRow, 255, 255, 255)	
		end
	end
	
			textObject:addEventListener("tap", createGame)

	--storyboard.gotoScene("playGame")
	
end


local function friendsListener(friendsLoadedEvent)
		textObject.text = "WAITING TO LOAD FRIEND DATA"
		gn.request("loadPlayers", {listener = playersListener, playerIDs = friendsLoadedEvent.data})
end

local function initCallback(event)
	if event.data == true then
		textObject.text = "WAITING TO LOAD FRIENDS"
		gn.request("loadFriends", {listener = friendsListener})
	else
		textObject.text = "GAME CENTER LOGIN FAILED"
	end
end


-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view
	textObject = utility.addBlackCentredText("WAITING FOR GAME CENTER LOGIN", 100, self.view, 30)
	utility.setColour(textObject, 255, 255, 255)
end



-- add all the event listening
function scene:enterScene(event)
	gn.init( "gamecenter", initCallback)	
end

function scene:exitScene(event)

end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene