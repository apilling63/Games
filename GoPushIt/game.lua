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
local goPushIt = audio.loadSound("audio/goPushIt.mp3")
local pushIt = audio.loadSound("audio/pushIt.mp3")
local goLeft = audio.loadSound("audio/goLeft.mp3")
local left = audio.loadSound("audio/left.mp3")
local goRight = audio.loadSound("audio/goRight.mp3")
local right = audio.loadSound("audio/right.mp3")
local goUp = audio.loadSound("audio/goUp.mp3")
local up = audio.loadSound("audio/up.mp3")
local goDown = audio.loadSound("audio/goDown.mp3")
local down = audio.loadSound("audio/down.mp3")
local goShakeIt = audio.loadSound("audio/goShakeIt.mp3")
local shakeIt = audio.loadSound("audio/shakeIt.mp3")
local tickTock = audio.loadSound("audio/tickTock.mp3")
local tickTock2 = audio.loadSound("audio/tickTock2.mp3")
local tickTock3 = audio.loadSound("audio/tickTock3.mp3")
local tickTock4 = audio.loadSound("audio/tickTock4.mp3")
local tickTock5 = audio.loadSound("audio/tickTock5.mp3")
local tickTock6 = audio.loadSound("audio/tickTock6.mp3")
local powerDown = audio.loadSound("audio/powerDown.mp3")
local powerUp = audio.loadSound("audio/powerUp.mp3")

local button
local textBox
local rightArrow
local leftArrow
local downArrow
local upArrow
local taskNum
local saidGo
local inPlay
local readyToPlay	
local background
local awaitingNextTask
local reminderBox
local reminderBox2
local score
local gapBetween
	
local function showArrows()
	if rightArrow.alpha < 0.5 then
		rightArrow.alpha = rightArrow.alpha + 0.01
		leftArrow.alpha = leftArrow.alpha + 0.01
		upArrow.alpha = upArrow.alpha + 0.01
		downArrow.alpha = downArrow.alpha + 0.01
		
		timer.performWithDelay(10, showArrows)	
	end
end
	
local function hideArrows()
	if rightArrow.alpha > 0.01 then
		rightArrow.alpha = rightArrow.alpha - 0.01
		leftArrow.alpha = leftArrow.alpha - 0.01
		upArrow.alpha = upArrow.alpha - 0.01
		downArrow.alpha = downArrow.alpha - 0.01
		
		timer.performWithDelay(10, hideArrows)			
	end
end
	
local function resetArrows()
	utility.setColour(rightArrow, 255, 255, 255)
	utility.setColour(leftArrow, 255, 255, 255)
	utility.setColour(upArrow, 255, 255, 255)
	utility.setColour(downArrow, 255, 255, 255)
	utility.setColour(background, 255, 255, 255)
	utility.setColour(button, 255, 255, 255)
	
end
	
local function getRandomNotPrevious(previous)
	local random = math.random(1, 5)
	
	if random == previous then
		random = getRandomNotPrevious(previous)
	end
	
	return random
end
		
local function endGame()
	inPlay = false
	utility.setColour(textBox, 255, 0, 0)
	utility.stopSound()		
	utility.playSound(powerDown)
	hideArrows()
	
end
	
local function restart()
	resetArrows()
	readyToPlay = true
	textBox.text = "GO PUSH IT"
	utility.playSound(goPushIt)	
	gapBetween = 2500
	
	if score > utility.getBestScore() then
		utility.setBestScore(score)
	end
	
	score = 0
	scoreBox.text = "SCORE 0"
	utility.setColour(textBox, 0, 0, 0)		
	awaitingNextTask = true	
end
	
local function nextTask()

	if inPlay then
		if awaitingNextTask or saidGo == false then
			score = score + 1
			scoreBox.text = "SCORE " .. score
			
			if score % 10 == 0 then
				gapBetween = gapBetween * 0.9
				utility.stopSound()
				
				if score == 10 then
					utility.playSoundWithOptions(tickTock2, {loops=-1})
				elseif score == 20 then
					utility.playSoundWithOptions(tickTock3, {loops=-1})
				elseif score == 30 then
					utility.playSoundWithOptions(tickTock4, {loops=-1})
				elseif score == 40 then
					utility.playSoundWithOptions(tickTock5, {loops=-1})
				elseif score == 40 then
					utility.playSoundWithOptions(tickTock6, {loops=-1})
				end				
			end			
			
			awaitingNextTask = false
			resetArrows()
			utility.setColour(textBox, 0,0,0)

			taskNum = getRandomNotPrevious(taskNum)
			local saidGoRandom = math.random(1, 5)
	
			saidGo = (saidGoRandom > 1)
	
			if saidGo then
				textBox.text = "Go "
			else
				textBox.text = ""	
			end
	
			if taskNum == 1 then
				textBox.text = textBox.text .. "RIGHT!"
				utility.setColour(rightArrow, 255, 255, 0)
				
				if saidGo then
					utility.playSound(goRight)
				else
					utility.playSound(right)
				end
			elseif taskNum == 2 then
				textBox.text = textBox.text .. "LEFT!"
				utility.setColour(leftArrow, 255, 255, 0)
				if saidGo then
					utility.playSound(goLeft)
				else
					utility.playSound(left)
				end				
			elseif taskNum == 3 then
				textBox.text = textBox.text .. "UP!"
				utility.setColour(upArrow, 255, 255, 0)	
				
				if saidGo then
					utility.playSound(goUp)
				else
					utility.playSound(up)
				end					
			elseif taskNum == 4 then
				textBox.text = textBox.text .. "DOWN!"
				utility.setColour(downArrow, 255, 255, 0)
				
				if saidGo then
					utility.playSound(goDown)
				else
					utility.playSound(down)
				end				
			elseif taskNum == 5 then
				textBox.text = textBox.text .. "PUSH IT!"
				utility.setColour(button, 255, 255, 0)
				
				if saidGo then
					utility.playSound(goPushIt)
				else
					utility.playSound(pushIt)
				end				
			elseif taskNum == 6 then
				textBox.text = textBox.text .. "SHAKE IT!"
				utility.setColour(background, 255, 255, 0)
				
				if saidGo then
					utility.playSound(goShakeIt)
				else
					utility.playSound(shakeIt)
				end				
			end	
			
			timer.performWithDelay(gapBetween, nextTask)
			
		else
			endGame()
			textBox.text = "TOO SLOW"
			timer.performWithDelay(2500, restart)			
		end
	end
end
		
local function showReminder()
	reminderBox.isVisible = true
	reminderBox2.isVisible = true
	
	timer.performWithDelay(2500, restart)
end
	
local function correctAction()
	if saidGo then
		utility.setColour(textBox, 0, 255, 0)
		awaitingNextTask = true
	else
		endGame()		
		showReminder()
	end
end

local function incorrectAction()
	endGame()
	timer.performWithDelay(2500, restart)
end

local function returnButtonToCentre()
	button.y = button.startY
	button.x = button.startX
end

local function movedLeft()
	if taskNum == 2 then
		correctAction()
	else
		incorrectAction()
	end
	
	returnButtonToCentre()
end
	
local function movedRight()

	if taskNum == 1 then
		correctAction()
	else
		incorrectAction()
	end
	
	returnButtonToCentre()
end

local function movedUp()
	if taskNum == 3 then
		correctAction()
	else
		incorrectAction()
	end
	
	returnButtonToCentre()
end

local function movedDown()
	if taskNum == 4 then
		correctAction()
	else
		incorrectAction()
	end
	
	returnButtonToCentre()
end

local function pressedButton()
	if taskNum == 5 then
		correctAction()
	else
		incorrectAction()
	end
	
	returnButtonToCentre()
end

local function shook()
	if taskNum == 6 then
		correctAction()
	else
		incorrectAction()
	end
end
	
local function failedSwipe()
	incorrectAction()
end

local function onShake()
	if inPlay then
		shook()
	end
end

local function startGame()
	readyToPlay = false		
	utility.playSound(powerUp)
	showArrows()
	reminderBox.isVisible = false
	reminderBox2.isVisible = false

	local closure = function()
		inPlay = true		
		nextTask()
		utility.playSoundWithOptions(tickTock, {loops=-1})
	end
	
	timer.performWithDelay(1500, closure)
end
	
local function buttonTouched(event)

	if event.phase == "ended" then
		if inPlay then
		
			if math.abs(event.x - button.startX) < 50 and math.abs(event.y - button.startY) < 50 then		
				pressedButton()
			else
				failedSwipe()
			end

			returnButtonToCentre()		
		elseif readyToPlay then
			startGame()
		end
	elseif inPlay then
		local xMove = event.x - button.startX
		local yMove = event.y - button.startY
		
		if math.abs(xMove) >= math.abs(yMove) then
			button.x = event.x
			button.y = button.startY
		else
			button.x = button.startX
			button.y = event.y
		end
		
		if button.x < (button.startX - 200) then
			movedLeft()
		elseif button.x > (button.startX + 200) then
			movedRight()
		elseif button.y < (button.startY - 200) then
			movedUp()
		elseif button.y > (button.startY + 200) then
			movedDown()
		end
	end

end
	
local function addArrow(xOffset, yOffset, rotation, screenGroup)
	local arrow = utility.addNewPicture("arrow.png", screenGroup)
	utility.putInCentre(arrow)
	arrow:translate(xOffset, yOffset)
	arrow.alpha = 0.01
	arrow.rotation = rotation
	return arrow
end

-- what to do when the screen loads
function scene:createScene(event)
	screenGroup = self.view
	taskNum = 0
	saidGo = true
	inPlay = false
	readyToPlay = true
	awaitingNextTask = true	
	score = 0
	gapBetween = 2500 
	
	background = display.newRect(display.contentWidth/2,display.contentHeight/2,1000,1000)
	screenGroup:insert(background)	
	
	local robot = utility.addNewPicture("robot.png", screenGroup)
	robot:translate(150, 100)
	
	rightArrow = addArrow(200, 0, 0, screenGroup)
	leftArrow = addArrow(-200, 0, 180, screenGroup)
	downArrow = addArrow(0, 200, 90, screenGroup)
	upArrow = addArrow(0, -200, 270, screenGroup)
		
	button = utility.addNewPicture("button.png", screenGroup)
	utility.putInCentre(button)
	button.startX = button.x
	button.startY = button.y
	textBox = utility.addBlackCentredTextWithFont("GO PUSH IT", 75, screenGroup, 45, "Digital tech")
	textBox:translate(75, 0)
	
	reminderBox = utility.addBlackCentredTextWithFont("ONLY ACT WHEN", 750, screenGroup, 50, "Digital tech")
	utility.setColour(reminderBox, 255, 0, 0)
	reminderBox2 = utility.addBlackCentredTextWithFont("RILEY SAYS 'GO'", 800, screenGroup, 50, "Digital tech")
	utility.setColour(reminderBox2, 255, 0, 0)	
	
	scoreBox = utility.addBlackCentredTextWithFont("SCORE 0", 875, screenGroup, 60, "Digital tech")
	scoreBox:translate(-150, 0)
	hiScoreBox = utility.addBlackCentredTextWithFont("HI " .. utility.getBestScore(), 875, screenGroup, 60, "Digital tech")
	hiScoreBox:translate(150, 0)

end



-- add all the event listening
function scene:enterScene(event)
	button:addEventListener("touch", buttonTouched)
	--Runtime:addEventListener("accelerometer", onShake)
	utility.playSound(goPushIt)
	storyboard.purgeScene("menu")		
end

function scene:exitScene(event)
	button:removeEventListener("touch", buttonTouched)
	--Runtime:removeEventListener("accelerometer", onShake)	
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene