-----------------------------------------------------------------------------------------
--
-- first.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local buttons = require "buttons"
local shapes = require "shapes"
local shakeSalt = require "shakeSalt"
local numbers = require "numbers"
local connectDots = require "connectDots"
local slideDoor = require "slideDoor"
local turnOn = require "turnOn"
local jigsaw = require "jigsaw"
local face = require "face"
local stickman = require "stickman"
local join = require "join"
local countDots = require "countDots"
local animals = require "animals"
local fly = require "fly"
local flowers = require "flowers"
local legs = require "legs"
local planets = require "planets"
local royals = require "royals"
local flags = require "flags"
local buildings = require "buildings"
local presidents = require "presidents"
local islands = require "islands"
local religiousSymbols = require "religiousSymbols"
local chemicalHazards = require "chemicalHazards"
local chemicalSymbols = require "chemicalSymbols"
local paintings = require "paintings"
local mathSymbols = require "mathSymbols"
local musicSymbols = require "musicSymbols"
local chemicalEquipment = require "chemicalEquipment"
local animals2 = require "animals2"
local queens = require "queens"
local lettersOrder = require "lettersOrder"
local balls = require "balls"
local constants = require "constants"
local colours = require "colours"


local os = require "os"

local simonSpeech1
local simonSpeech2

local playGameButton
local apButton

local tasks
local timeOutTime = 10000000000
local playing
local currentTaskIndex
local previousTaskIndex
local timeAllowed = 5000
local tasksCompleted = 0
local timeLineCover
local bestScore
local bestScoreText
local gamesPlayed = 1
local difficulty = 1

local ads = require "ads"
--local analytics = require "analytics"

local tickTock = audio.loadSound("tickTock.wav")
local splat = audio.loadSound("blood_splat.mp3")

local function resetGame(event)
	--analytics.logEvent("next")

	if gamesPlayed % 2 == 0 then
		ads:setCurrentProvider("vungle")
		print("show ad")
		ads.show( "interstitial", { isBackButtonEnabled = true } )
		--analytics.logEvent("show ad")
	elseif ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
		ads:setCurrentProvider("iads")
		ads.show("banner", {x = 0, y = display.contentHeight - 66})
	end

	gamesPlayed = gamesPlayed + 1
	simonSpeech1.text = "Remember only act when"
	simonSpeech2.text = "'Simon says'.  Let's play!"
	playGameButton:translate(1500, 0)
	apButton:translate(1500, 0)

	timeAllowed = 5000
	tasksCompleted = 0
	thisScoreText.text = "This score: 0"
	timeLineCover.x = timeLineCover.startX
	difficulty = 1
	
end

local function showPutdown()
	simonSpeech1.text = "Oh dear,"
	simonSpeech2.text = "let's try that again"
end

local function endGame(reasonString)
	simonSpeech1.text = reasonString
	system.vibrate()
	utility.stopSound()
	utility.playSound(splat)

	if tasksCompleted > bestScore then
		bestScoreText.text = "Best score: " .. tasksCompleted
		bestScore = tasksCompleted
		utility.setBestScore(tasksCompleted)
		simonSpeech2.text = "New Best Score!"
	else
		simonSpeech2.text = "Game over"
	end

	timer.performWithDelay(3000, showPutdown)

	playing = false

	timer.performWithDelay(8000, resetGame)
end

local function startNextTask()
	print("start next task")

	previousTaskIndex = currentTaskIndex
	print("choosing task " .. currentTaskIndex)

	local say = math.random(0, 5)

	if say == 0 then
		simonSpeech1.text = ""
	else
		simonSpeech1.text = "Simon says"
	end

	print("Does simon say?")
	print(say ~= 0)
	playing = true

	timeOutTime = system.getTimer() + timeAllowed
	tasks[currentTaskIndex].showOnScreen(difficulty, simonSpeech2, say ~= 0)
end

local function doAnotherTask(event)
	print("choosing next task")

	if playing then
		tasksCompleted = tasksCompleted + 1

		thisScoreText.text = "This score: " .. tasksCompleted
	end

	while true do
		currentTaskIndex = math.random(1, #tasks) 

		print(currentTaskIndex .. "?")

		if currentTaskIndex ~= previousTaskIndex then
			break
		end
	end

	if tasksCompleted % 5 == 0 and tasksCompleted ~= 0 then
		timeAllowed = timeAllowed * 0.95
		simonSpeech1.text = "Well done, this is level " .. ((tasksCompleted / 5) + 1)
		simonSpeech2.text = "Let's speed things up a bit"
		playing = false
		timer.performWithDelay(3000, startNextTask)

	else
		startNextTask()
	end

end

local function checkTimeout(event)

	if playing then
		local timeLeft = timeOutTime - system.getTimer()

		if  timeLeft < 0 then
			tasks[currentTaskIndex].removeFromScreen()

			if simonSpeech1.text == "Simon says" then
				endGame("TOO SLOW!!")
			else
				doAnotherTask(event)
			end
		else
			timeLineCover.x = timeLineCover.startX - (580 * (1 - (timeLeft / timeAllowed)))
		end
	end
end

local function onCallback(trueOrFalse, event)

	tasks[currentTaskIndex].removeFromScreen()

	if simonSpeech1.text == "Simon says" then
		if trueOrFalse then
			doAnotherTask(event)
		else
			endGame("WRONG!!")
		end

	else
		endGame("I didn't say 'Simon says'!")
	end

end

-- what to do when the screen loads
function scene:createScene(event)
	--analytics.logEvent("start")

	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

		ads.show("banner", {x = 0, y = display.contentHeight - 100})
	end
	
	local screenGroup = self.view
	tasks = {}

	local whiteBG = display.newRect( -300, -300, 2000, 2000 )
	utility.centreObjectX(whiteBG)
	utility.centreObjectY(whiteBG)

	screenGroup:insert(whiteBG)

	local speechBubble = display.newImageRect( "images/speechBubble.png", 644, 306 )
	utility.addObject(speechBubble, screenGroup, 0, -350)
	speechBubble.y = 130

	local simon = display.newImageRect( "images/simon.png", 218, 249 )
	utility.addObject(simon, screenGroup, -170, -180)
	simon.y = 300

	simonSpeech1 = display.newText("Remember only act when", 0, 0, "Futura", 30)
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
	thisScoreText.y = 300

	bestScore = utility.getBestScore()

	bestScoreText = display.newText("Best score: " .. bestScore, 0, 0, "Futura", 45)
	bestScoreText:setFillColor(0,0,0)
	utility.addObject(bestScoreText, screenGroup, 100, -120)
	bestScoreText.y = 360

	playGameButton = display.newImageRect( "images/playButton.png", 200, 200 )
	utility.addObject(playGameButton, screenGroup, 0, 150)

	apButton = display.newImageRect( "images/apButton.png", 150, 150 )
	utility.addObject(apButton, screenGroup, 0, 350)
	
	table.insert(tasks, buttons)
	table.insert(tasks, animals2)
	table.insert(tasks, constants)
	table.insert(tasks, colours)

	table.insert(tasks, animals)

	table.insert(tasks, shapes)
	table.insert(tasks, flags)
	table.insert(tasks, royals)
	table.insert(tasks, planets)
	table.insert(tasks, numbers)
	table.insert(tasks, legs)
	table.insert(tasks, join)
	table.insert(tasks, fly)
	table.insert(tasks, flowers)
	table.insert(tasks, face)
	table.insert(tasks, connectDots)
	table.insert(tasks, countDots)
	table.insert(tasks, animals)
	table.insert(tasks, jigsaw)
	--table.insert(tasks, shakeSalt)
	table.insert(tasks, turnOn)
	table.insert(tasks, slideDoor)
	table.insert(tasks, stickman)
	table.insert(tasks, lettersOrder)
	table.insert(tasks, buildings)
	table.insert(tasks, presidents)
	table.insert(tasks, islands)
	table.insert(tasks, religiousSymbols)
	table.insert(tasks, chemicalHazards)
	table.insert(tasks, chemicalSymbols)
	table.insert(tasks, chemicalEquipment)

	table.insert(tasks, mathSymbols)
	table.insert(tasks, musicSymbols)
	table.insert(tasks, paintings)
	table.insert(tasks, queens)
	table.insert(tasks, balls)

	for i = 1, #tasks do
		tasks[i].create(screenGroup, onCallback)
	end

	local timeLine = display.newLine(30, 400, 610, 400)
		screenGroup:insert(timeLine)

	utility.centreObjectX(timeLine)	

	timeLine.strokeWidth = 35
	timeLine:setStrokeColor(255, 0, 0)
	timeLine.y = 400

	timeLineCover = display.newLine(610, 400, 1190, 400)
		screenGroup:insert(timeLineCover)
	utility.centreObjectX(timeLineCover)	
	timeLineCover.x = timeLine.x + 580
	timeLineCover.strokeWidth = 35
	timeLineCover.startX = timeLineCover.x
	timeLineCover.y = 400

end

local function playGame(event)
	utility.playSoundWithOptions(tickTock, {loops=-1})

	doAnotherTask(event)
	playing = true
	playGameButton:translate(-1500, 0)
	apButton:translate(-1500, 0)

	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
		ads.hide()
	end	
end

local function showAPGames()

	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
		system.openURL("https://itunes.apple.com/us/artist/app-app-n-away/id604407181")

	else
		system.openURL("https://play.google.com/store/apps/developer?id=AP%20SOFTWARE%20DEVELOPMENT")

	
	end
end

-- add all the event listening
function scene:enterScene(event)
	for i = 1, #tasks do
		tasks[i].addEventListeners()
	end

	Runtime:addEventListener("enterFrame", checkTimeout)
	playGameButton:addEventListener("tap", playGame)
	apButton:addEventListener("tap", showAPGames)

end

function scene:exitScene(event)
	for i = 1, #tasks do
		tasks[i].removeEventListeners()
	end

	Runtime:removeEventListener("enterFrame", checkTimeout)
	playGameButton:removeEventListener("tap", playGame)
	apButton:removeEventListener("tap", showAPGames)

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene
