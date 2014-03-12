-----------------------------------------------------------------------------------------
--
-- playGame.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local gameData = require ("gameData")

local geog
local film
local sport
local history
local science


-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view
	local bg = display.newRect(320, 480, 900, 1200)
	utility.setColour(bg, 255, 255, 255)	
	screenGroup:insert(bg)
	geog = utility.addBlackCentredText("Geography", 50, screenGroup, 40)
	film = utility.addBlackCentredText("Film", 150, screenGroup, 40)
	sport = utility.addBlackCentredText("Sport", 250, screenGroup, 40)
	history = utility.addBlackCentredText("History", 350, screenGroup, 40)
	science = utility.addBlackCentredText("Science", 450, screenGroup, 40)
	
end

local function geogTap()
	gameData.category = "geography"
	storyboard.gotoScene("game")
end

local function filmTap()
	gameData.category = "film"
	storyboard.gotoScene("game")
end

local function sportTap()
	gameData.category = "sport"
	storyboard.gotoScene("game")
end

local function historyTap()
	gameData.category = "history"
	storyboard.gotoScene("game")
end

local function scienceTap()
	gameData.category = "science"
	storyboard.gotoScene("game")
end

-- add all the event listening
function scene:enterScene(event)
	geog:addEventListener("tap", geogTap)
	film:addEventListener("tap", filmTap)
	sport:addEventListener("tap", sportTap)
	history:addEventListener("tap", historyTap)
	science:addEventListener("tap", scienceTap)
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