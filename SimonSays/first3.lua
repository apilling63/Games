-----------------------------------------------------------------------------------------
--
-- first.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
--local buttons = require "buttons"
--local shapes = require "shapes"

local simonSpeech1
local simonSpeech2

local playGameButton
local bestScore
local bestScoreText
local thisScoreText
local tasks = {}

local function onCallback(trueOrFalse, event)

end

-- what to do when the screen loads
function scene:createScene(event)


	local screenGroup = self.view
	--tasks = {}

	local whiteBG = display.newRect( -300, -300, 2000, 2000 )
	--[[utility.centreObjectX(whiteBG)
	utility.centreObjectY(whiteBG)

	screenGroup:insert(whiteBG)

	local speechBubble = display.newImageRect( "images/speechBubble.png", 644, 306 )
	utility.addObject(speechBubble, screenGroup, 0, -350)
	speechBubble.y = 130]]--

	--[[local simon = display.newImageRect( "images/simon.png", 218, 249 )
	utility.addObject(simon, screenGroup, -170, -180)
	simon.y = 300]]--

	--[[simonSpeech1 = display.newText("Remember only act when", 0, 0, "Futura", 30)
	simonSpeech1:setFillColor(0,0,0)
	utility.addObject(simonSpeech1, screenGroup, 0, -400)
	simonSpeech1.y = 80

	simonSpeech2 = display.newText("'Simon says'.  Let's play!", 0, 0, "Futura", 30)
	simonSpeech2:setFillColor(0,0,0)
	utility.addObject(simonSpeech2, screenGroup, 0, -350)
	simonSpeech2.y = 130

	thisScoreText = display.newText("This score: 0", 0, 0, "Futura", 45)
	thisScoreText:setFillColor(0,0,0)
	utility.addObject(thisScoreText, screenGroup, 100, -180)
	thisScoreText.y = 300]]--

	--[[bestScore = utility.getBestScore()

	bestScoreText = display.newText("Best score: " .. bestScore, 0, 0, "Futura", 45)
	bestScoreText:setFillColor(0,0,0)
	utility.addObject(bestScoreText, screenGroup, 100, -120)
	bestScoreText.y = 360

	playGameButton = display.newImageRect( "images/playButton.png", 200, 200 )
	utility.addObject(playGameButton, screenGroup, 0, 100) ]]--

	--[[table.insert(tasks, buttons)

	table.insert(tasks, shapes)
	
	for i = 1, #tasks do
		tasks[i].create(screenGroup, onCallback)
	end]]--

end



-- add all the event listening
function scene:enterScene(event)
	for i = 1, #tasks do
		tasks[i].addEventListeners()
	end


end

function scene:exitScene(event)
	for i = 1, #tasks do
		tasks[i].removeEventListeners()
	end



end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene
