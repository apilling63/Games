-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local utility = require ("utility")
local math = require ("math")
local name = require ("name")
local personName = name.name

--[[local goPushIt = media.newEventSound("audio/" .. personName .. "/goPushIt.mp3")
local pushIt = media.newEventSound("audio/" .. personName .. "/pushIt.mp3")
local goSpinIt = media.newEventSound("audio/" .. personName .. "/goSpinIt.mp3")
local spinIt = media.newEventSound("audio/" .. personName .. "/spinIt.mp3")
local goSwitchIt = media.newEventSound("audio/" .. personName .. "/goSwitchIt.mp3")
local switchIt = media.newEventSound("audio/" .. personName .. "/switchIt.mp3")
local goRingIt = media.newEventSound("audio/" .. personName .. "/goRingIt.mp3")
local ringIt = media.newEventSound("audio/" .. personName .. "/ringIt.mp3")
local hiScoreSound = audio.loadSound("audio/" .. personName .. "/hiScore.mp3")
local hi = audio.loadSound("audio/" .. personName .. "/hi.mp3")
local onlyDo = audio.loadSound("audio/" .. personName .. "/onlyDo.mp3")
local play = audio.loadSound("audio/" .. personName .. "/play.mp3")]]--

local circus = audio.loadSound("audio/circus.mp3")
local tickTock = audio.loadSound("audio/tickTock.mp3")
local tickTock2 = audio.loadSound("audio/tickTock2.mp3")
local tickTock3 = audio.loadSound("audio/tickTock3.mp3")
local tickTock4 = audio.loadSound("audio/tickTock4.mp3")
local tickTock5 = audio.loadSound("audio/tickTock5.mp3")
local tickTock6 = audio.loadSound("audio/tickTock6.mp3")
local powerDown = audio.loadSound("audio/powerDown.mp3")
local powerUp = audio.loadSound("audio/powerUp.mp3")
local bellSound = media.newEventSound("audio/bell.mp3")
local switchSound = media.newEventSound("audio/switch.mp3")
local whirlSound = media.newEventSound("audio/whirl.mp3")
local buttonSound = media.newEventSound("audio/button.mp3")

local button
local spiral
local bell
local switch
local choices

local textBox
local textBox2
local taskNum
local saidGo
local inPlay
local readyToPlay	
local background
local awaitingNextTask
local score
local scoreBox
local gapBetween
local person
local speechBubble
local start
local scoreRect
	
local yMove = display.screenOriginY - 200
	
local function setReady()
	readyToPlay = true
end
	
local function showLetsPlay()
	textBox.text = personName .. " says"
	textBox2.text = "let's play!"
	transition.to(start, {x=(start.x + 850), time=1000, onComplete=setReady})	
	scoreBox.text = "HI-SCORE " .. utility.getBestScore()
	--utility.playSound(play)
	utility.setColour(scoreRect, 255, 255, 255)
	
end
	
local function showHowTo2()
	textBox.text = "when I say"
	textBox2.text = "'" .. personName .. " says'"
	timer.performWithDelay(3000, showLetsPlay)
	
end

local function showHowTo()
	textBox.text = "Remember, only"
	textBox2.text = "do something"
	--utility.playSound(onlyDo)
	
	timer.performWithDelay(3000, showHowTo2)
end	

local function showGameOver()
	textBox.text = "GAME OVER!!!"
	textBox2.text = ""
	--utility.playSound(hiScoreSound)
	
	timer.performWithDelay(3000, showHowTo)
end	

local function showHighScore()
	textBox.text = "You got a"
	textBox2.text = "new high score!"
	--utility.playSound(hiScoreSound)
	
	timer.performWithDelay(3000, showHowTo)
end	
	
local function getRandomNotPrevious(previous)
	local random = math.random(1, 4)
	
	if random == previous then
		random = getRandomNotPrevious(previous)
	end
	
	return random
end
	
local function restart()
	readyToPlay = true
	
	gapBetween = 2000

	utility.playSoundWithOptions(circus, {loops=-1})	
		
	awaitingNextTask = true		
	
	if score > utility.getBestScore() then
		utility.setBestScore(score)
		utility.setColour(scoreRect, 0, 255, 255)
		showHighScore()
	else
		showGameOver()
	end	
end
	
local function endGame(text1, text2)
	for i=1, #choices do
		local choice = choices[i]
		transition.to(choice, {alpha=0.5, time=1000})	
	end	
	
	inPlay = false
	utility.stopSound()		
	utility.playSound(powerDown)	
	textBox.text = text1
	textBox2.text = text2
	
	timer.performWithDelay(3000, restart)
end
	
local function nextTask()
	print("next")

	if inPlay then
		print("in play")
	
		if awaitingNextTask or saidGo == false then
			print("good")
			
			
			for i=1, #choices do
				local choice = choices[i]
				choices[i].illuminated.isVisible = false
				choices[i].isVisible = true
			end	
					
			score = score + 1
			scoreBox.text = "SCORE " .. score
			
			if score % 10 == 0 then
				gapBetween = gapBetween * 0.95
				utility.stopSound()
				
				if score == 10 then
					utility.playSoundWithOptions(tickTock2, {loops=-1})
				elseif score == 20 then
					utility.playSoundWithOptions(tickTock3, {loops=-1})
				elseif score == 30 then
					utility.playSoundWithOptions(tickTock4, {loops=-1})
				elseif score == 40 then
					utility.playSoundWithOptions(tickTock5, {loops=-1})
				end				
			end			
			
			awaitingNextTask = false
			taskNum = getRandomNotPrevious(taskNum)
			local saidGoRandom = math.random(1, 4)
			saidGo = (saidGoRandom > 1) or score < 3
			
			if saidGo then
				textBox.text = personName .. " says "
			else
				textBox.text = ""	
			end
			
			local choice = choices[taskNum]
			textBox2.text = choice.text
	
			--[[if saidGo then
				media.playEventSound(choice.goSound)
			else
				media.playEventSound(choice.noGoSound)
			end	]]--
			
			choice.illuminated.isVisible = true
			choice.isVisible = false	
			
			timer.performWithDelay(gapBetween, nextTask)
			
		else
			print("not good")
			endGame("TOO SLOW!!", "")				
		end
	end
end

	
local function correctAction()
	print("correct")

	if saidGo then

		print("go")	
		awaitingNextTask = true
	else
		print("not go")
		endGame("I didn't say", "'" .. personName .. " says'!!")		
	end
end

local function incorrectAction()
	print("incorrect")
	endGame("WRONG ACTION!", "")
end

local function doFirstTask()
	inPlay = true		
	nextTask()
	utility.playSoundWithOptions(tickTock, {loops=-1})
end

local function startGame()
	if readyToPlay then
		score = 0
		scoreBox.text = "SCORE 0"		
		readyToPlay = false		
		utility.stopSound()		
		
		utility.playSound(powerUp)	
		
		transition.to(start, {x=(start.x - 850), time=1000, onComplete = doFirstTask})	

		for i=1, #choices do
			local choice = choices[i]
			transition.to(choice, {alpha=1, time=1000})	
		end	
			
	end
end

local function showTextInBubble()
	--display.captureScreen(true)

	textBox.x = speechBubble.x
	textBox2.x = speechBubble.x

	textBox.text = "Hi there!"	
	textBox2.text = "I'm " .. personName .. "!"
	
	--utility.playSound(hi)
	
	timer.performWithDelay(3000, showHowTo)
end

local function showBubble()
	transition.to(speechBubble, {x=(speechBubble.x - 600), time=1000, onComplete=showTextInBubble})
end

local function checkCorrect(toCheck, sound)
	print("checking")

	if inPlay and awaitingNextTask == false then
		media.playEventSound(sound)	
	
		toCheck.isVisible = true
		
		for i=1, #choices do
			local choice = choices[i]
			choices[i].illuminated.isVisible = false
			choices[i].isVisible = true
		end
		
		toCheck:play()

		if toCheck.index == taskNum then	
			correctAction()
		else
			incorrectAction()
		end	
	end
end

local function bellPressed(event)
	if event.phase == "began" then
		checkCorrect(bell, bellSound)
	end
end

local function buttonPressed(event)
	if event.phase == "began" then
		checkCorrect(button, buttonSound)
	end
end

local function spiralPressed(event)
	if event.phase == "began" then
		checkCorrect(spiral, whirlSound)
	end
end

local function switchPressed(event)
	if event.phase == "began" then
		checkCorrect(switch, switchSound)
	end
end

local function prepareChoice(toPrepare, text, index, goSound, noGoSound, illuminated)
	choices[index] = toPrepare
	toPrepare.text = text
	toPrepare.index = index
	toPrepare.goSound = goSound
	toPrepare.noGoSound = noGoSound
	toPrepare.illuminated = illuminated
	illuminated.x = toPrepare.x
	illuminated.y = toPrepare.y
	illuminated.isVisible = false
	toPrepare.alpha = 0.5
end

-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view
	taskNum = 1
	saidGo = true
	inPlay = false
	awaitingNextTask = true	
	score = 0
	gapBetween = 2000 
	choices = {}
	
	print("create game")

	local prebackground = display.newImageRect("images/background.png", 1200, 900)
	screenGroup:insert(prebackground)
	utility.putInCentre(prebackground)

	background = utility.addNewPicture("stall.png", screenGroup)
	utility.putInCentre(background)
		
	button = utility.addButtonSprite(screenGroup)
	local button2 = utility.addNewPicture("button2.png", screenGroup)
	button.x = 790
	button.y = 270
	prepareChoice(button, "PUSH IT!", 1, goPushIt, pushIt, button2)
	
	spiral = utility.addSpiralSprite(screenGroup)
	local spiral2 = utility.addNewPicture("spiral2.png", screenGroup)	
	spiral.x = 170
	spiral.y = 270
	prepareChoice(spiral, "SPIN IT!", 2, goSpinIt, spinIt, spiral2)
		
	bell = utility.addBellSprite(screenGroup)
	local bell2 = utility.addNewPicture("bell2.png", screenGroup)
	bell.x = 335
	bell.y = 380
	prepareChoice(bell, "RING IT!", 3, goRingIt, ringIt, bell2)
	
	switch = utility.addSwitchSprite(screenGroup)
	local switch2 = utility.addNewPicture("switch2.png", screenGroup)	
	switch.x = 650
	switch.y = 400
	prepareChoice(switch, "SWITCH IT!", 4, goSwitchIt, switchIt, switch2)
	
	scoreRect = utility.addNewPicture("score.png", screenGroup)
	scoreRect:translate(225, 80)
	
	scoreBox = utility.addBlackCentredTextWithFont("HI-SCORE " .. utility.getBestScore(), 55, screenGroup, 30, "Quicksand")
	scoreBox.x = scoreRect.x
	
	person = utility.addNewPicture(personName .. ".png", screenGroup)
	person:translate(480, 220)
		
	speechBubble = utility.addNewPicture("speech.png", screenGroup)
	speechBubble:translate(1270, 120)	
		
	textBox = utility.addBlackCentredTextWithFont("", speechBubble.y - 65, screenGroup, 35, "Quicksand")	
	textBox2 = utility.addBlackCentredTextWithFont("", speechBubble.y - 20, screenGroup, 35, "Quicksand")
							
	start = utility.addNewPicture("start.png", screenGroup)
	
	start:translate(-560, 550)		
	showBubble()

end



-- add all the event listening
function scene:enterScene(event)
	print("enter game")
	utility.playSoundWithOptions(circus, {loops=-1})
	start:addEventListener("tap", startGame)

	button:addEventListener("touch", buttonPressed)
	spiral:addEventListener("touch", spiralPressed)
	bell:addEventListener("touch", bellPressed)
	switch:addEventListener("touch", switchPressed)
	button.illuminated:addEventListener("touch", buttonPressed)
	spiral.illuminated:addEventListener("touch", spiralPressed)
	bell.illuminated:addEventListener("touch", bellPressed)
	switch.illuminated:addEventListener("touch", switchPressed)	
	storyboard.purgeScene("menu")	
	
end

function scene:exitScene(event)
	start:removeEventListener("tap", startGame)

	spiral:removeEventListener("touch", spiralPressed)
	button:removeEventListener("touch", buttonPressed)
	bell:removeEventListener("touch", bellPressed)
	switch:removeEventListener("touch", switchPressed)
	
	spiral.illuminated:removeEventListener("touch", spiralPressed)
	button.illuminated:removeEventListener("touch", buttonPressed)
	bell.illuminated:removeEventListener("touch", bellPressed)
	switch.illuminated:removeEventListener("touch", switchPressed)	
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene