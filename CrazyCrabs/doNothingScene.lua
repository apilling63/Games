-----------------------------------------------------------------------------------------
--
-- transitionLevel.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local playButton
local gameData = require "gameData"

local hammerButton
local numHammers
local credits
local protectButton
local numProtect

local function changeScene()
	storyboard.gotoScene("first")
end

local function buyHammer()
	if gameData.numCredits >= gameData.hammerCost then
		gameData.numHammers = gameData.numHammers + 1
		gameData.numCredits = gameData.numCredits - gameData.hammerCost
		numHammers.text = gameData.numHammers
		credits.text = "CREDITS: " .. gameData.numCredits
	end
end

local function buyProtect()
	if gameData.numCredits >= gameData.protectCost then
		gameData.numProtects = gameData.numProtects + 1
		gameData.numCredits = gameData.numCredits - gameData.protectCost
		numProtect.text = gameData.numProtects
		credits.text = "CREDITS: " .. gameData.numCredits
	end
end

-- what to do when the screen loads
function scene:createScene(event)
	local screenGroup = self.view

	playButton = display.newText("PLAY", 400, 400, "GoodDog", 100)

	screenGroup:insert(playButton)


	hammerButton = display.newImage("images/hammer.png")
	hammerButton:translate(300, 100)
	screenGroup:insert(hammerButton)
	numHammers = display.newText(gameData.numHammersDefault, 330, 230, "GoodDog", 30)
	screenGroup:insert(numHammers)
	local hammerCost = display.newText(gameData.hammerCost .. " credits", 300, 280, "GoodDog", 30)
	screenGroup:insert(hammerCost)

	protectButton = display.newImage("images/stopBird.png")
	protectButton:translate(600, 100)
	screenGroup:insert(protectButton)
	numProtect = display.newText(gameData.numProtectsDefault, 630, 230, "GoodDog", 30)
	screenGroup:insert(numProtect)
	local protectCost = display.newText(gameData.protectCost .. " credits", 600, 280, "GoodDog", 30)
	screenGroup:insert(protectCost)

	credits = display.newText("CREDITS: " .. gameData.numCredits, 400, 10, "GoodDog", 50)
	screenGroup:insert(credits)

	gameData.numHammers = gameData.numHammersDefault
	gameData.numProtects = gameData.numProtectsDefault
end


-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("first")
	playButton:addEventListener("tap", changeScene)
	hammerButton:addEventListener("tap", buyHammer)
	protectButton:addEventListener("tap", buyProtect)

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


