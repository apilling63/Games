-----------------------------------------------------------------------------------------
--
-- first.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards

local scene = {}

local utility = require ("utility")
local math = require ("math")
local zip = require ("plugin.zip")
local lfs = require "lfs"
local playerData = require "playerData"

local pic
local currentScale
local answer1
local answer2
local answer3
local answer4
local answers
local finished
local scoreText
local score
local selectionMade
local correctSelection
local totalScore
local countdownText
local correctIndex
local opponentCurrent
local opponentSelection
local opponentScoreText
local opponentScore

local opponentCurrentScore

local answersGroup
local frameGroup
local picGroup

local connectionCallBack
local calledBefore


local function countdown()
	print("countdown")
	if countdownText.text == "1" then
		pic.isVisible = true
		answersGroup.isVisible = true
		countdownText.text = ""
	elseif countdownText.text == "2" then
		countdownText.text = "1"
		timer.performWithDelay(1000, countdown)
	else
		countdownText.text = "2"
		timer.performWithDelay(1000, countdown)
	end
end

local function addNewText(text, size, xLocation, yLocation, screenGroup)
	local textObject = display.newText(text, 0, 0, Arial, size)
	textObject:setTextColor(0,0,0)
	textObject.x = xLocation
	textObject.y = yLocation
	screenGroup:insert(textObject)
	return textObject
end

local function prepareForNext()
		print("starting next")
		playerData.round = playerData.round + 1
		pic:removeSelf()

		local answersText = connectionCallBack({"next"})
		pic = utility.addNewPicture(answersText[1], picGroup)
		--utility.centreObjectX(pic)
		pic:setReferencePoint(display.CenterReferencePoint)
		pic:scale(30, 30)
		pic.x = 560 - (display.screenOriginX / 2)
		pic.y = 250 + (display.screenOriginY / 2)
		currentScale = 30
		pic.isVisible = false

		countdownText.text = "Waiting"
		opponentCurrent.text = "waiting to select"
		opponentCurrent:setTextColor(0,0,0)

		answer1.text = answersText[2]
		answer1:setTextColor(0,0,0)

		answer2.text = answersText[3]
		answer2:setTextColor(0,0,0)

		answer3.text = answersText[4]
		answer3:setTextColor(0,0,0)

		answer4.text = answersText[5]
		answer4:setTextColor(0,0,0)


		correctIndex = answersText[6]

		finished = false
		selectionMade = false
		correctSelection = false

		answersGroup.isVisible = false
		score = 15000
		opponentCurrentScore = 0
end

local function nextPicture()
	if calledBefore then
		calledBefore = false

		if playerData.round == 5 then
			playerData.round = 1
			pic.isVisible = false

			if playerData.total > opponentScore then
				countdownText.text = "YOU WON!"
			elseif playerData.total < opponentScore then
				countdownText.text = "YOU LOST!"
			else
				countdownText.text = "A DRAW!"
			end

			local closure = function()
				connectionCallBack({"complete"})
			end

			timer.performWithDelay(3000, closure)
		else
			prepareForNext()
		end
	else 
		calledBefore = true
	end
end

local function doOpponentScore()
	if opponentSelection == correctIndex then

		opponentCurrentScore = opponentCurrentScore - 50

		opponentScore = opponentScore + 50

		if score > 0 then
			timer.performWithDelay(1, doOpponentScore)
		else
			opponentScore = opponentScore + opponentCurrentScore
			opponentCurrentScore = 0 
			timer.performWithDelay(1, nextPicture)
		end

		opponentCurrent.text = opponentCurrentScore
		opponentScoreText.text = opponentScore

	else
		opponentCurrentScore = opponentCurrentScore + 20

		opponentScore = opponentScore - 20

		if opponentCurrentScore < 0 then
			timer.performWithDelay(1, doOpponentScore)
		else
			timer.performWithDelay(1, nextPicture)
		end

		opponentCurrent.text = opponentCurrentScore
		opponentScoreText.text = opponentScore
	end
end


local function doScore()

	if correctSelection then
		score = score - 50

		playerData.total = playerData.total + 50

		if score > 0 then
			timer.performWithDelay(1, doScore)
		else
			playerData.total = playerData.total + score
			score = 0 
			timer.performWithDelay(1, nextPicture)
		end

		scoreText.text = score
		totalScore.text = playerData.total

	else
		score = score + 20

		playerData.total = playerData.total - 20

		if score < 0 then
			timer.performWithDelay(1, doScore)
		else
			timer.performWithDelay(1, nextPicture)
		end

		scoreText.text = score
		totalScore.text = playerData.total
	end
end


local function makeSmaller(event)

	--print("current scale " .. currentScale)
	if pic.isVisible then

		if currentScale > 0.5 or (pic.rotation % 720 > 1) then

			if selectionMade or score == 0 or score == -3000 then

				if selectionMade == false and score == 0 then
					score = -3000
					scoreText.text = -3000
					connectionCallBack({"answer", 0, -3000})
				end
			else 
				score = math.max(0, score - 20)
				scoreText.text = score
			end

			currentScale = currentScale * 0.99 
			pic:scale(0.9953, 0.9953)
			pic.rotation = pic.rotation + 1
		elseif finished == false then
			finished = true

			if answers[correctIndex].selected then
				answers[correctIndex]:setTextColor(0, 255, 0)
				correctSelection = true
				countdownText.text = "Correct!"
			else
				answers[correctIndex]:setTextColor(255, 0, 0)
				countdownText.text = "Wrong!"
				score = -3000
				scoreText.text = score
			end

			if opponentSelection == correctIndex then
				opponentCurrent:setTextColor(0, 255, 0)
			else
				opponentCurrentScore = -3000
				opponentCurrent.text = opponentCurrentScore
				opponentCurrent:setTextColor(255, 0, 0)
			end

			timer.performWithDelay(1000, doScore)
			timer.performWithDelay(1000, doOpponentScore)

		end
	end
end

local function answerSelected(event, index)
	if event.phase == "began" and selectionMade == false and finished == false then
		answers[index]:setTextColor(0, 0, 255) 
		answers[index].selected = true
		selectionMade = true
		connectionCallBack({"answer", index, score})
	end
end

local function selectAnswer1(event)
	answerSelected(event, 1)
end

local function selectAnswer2(event)
	answerSelected(event, 2)
end
local function selectAnswer3(event)
	answerSelected(event, 3)
end
local function selectAnswer4(event)
	answerSelected(event, 4)
end

scene.opponentSelection = function(index, potentialScore)
	opponentCurrent.text = potentialScore
	opponentSelection = index
	opponentCurrentScore = potentialScore
end	


scene.startNext = function(cb)	
	print("start next")
	countdownText.text = "3"
	timer.performWithDelay(1000, countdown)
end

-- what to do when the screen loads
scene.setUp = function(cb, answersText)	

	connectionCallBack = cb
	--screenGroup = self.view
	answers = {}
	print("back in first")
	picGroup = display.newGroup()
	frameGroup = display.newGroup()
	answersGroup = display.newGroup()
	score = 15000
	opponentCurrentScore = 0
	opponentScore = 0

	--deletePrevious()

	pic = utility.addNewPicture(answersText[1], picGroup)
	--utility.centreObjectX(pic)
	pic:setReferencePoint(display.CenterReferencePoint)
	pic:scale(30, 30)
	pic.x = 560 - (display.screenOriginX / 2)
	pic.y = 250 + (display.screenOriginY / 2)
	currentScale = 30
	pic.isVisible = false

	countdownText = display.newText("3", 0, 0, Arial, 150)
	countdownText:setReferencePoint(display.CenterReferencePoint)
	countdownText.x = 560 - (display.screenOriginX / 2)
	countdownText.y = 250 + (display.screenOriginY / 2)
	picGroup:insert(countdownText)

	local shift = (800 - display.screenOriginX) / 3
	answer1 = addNewText(answersText[2], 50, 160 + shift, 525, answersGroup)
	answer2 = addNewText(answersText[3], 50, 160 + shift + shift, 525, answersGroup)
	answer3 = addNewText(answersText[4], 50, 160 + shift, 600, answersGroup)
	answer4 = addNewText(answersText[5], 50, 160 + shift + shift, 600, answersGroup)

	correctIndex = answersText[6]

	local rectLeft = display.newRect(display.screenOriginX, display.screenOriginY, 160 - display.screenOriginX, display.contentHeight - ( 2 * display.screenOriginY))
	frameGroup:insert(rectLeft)
	
	local rectBottom = display.newRect(display.screenOriginX, 500, display.contentWidth - (2 * display.screenOriginX), 140 - display.screenOriginY)
	frameGroup:insert(rectBottom)

	local shift2 = (160 + display.screenOriginX) / 2
	playerData.total = 0
	local roundText = addNewText("Round", 30, shift2, 20, frameGroup)
	local roundNumber = addNewText(playerData.round, 30, shift2, 70, frameGroup)
	local totalText = addNewText("TOTAL", 40, shift2, 130, frameGroup)
	local youTotal = addNewText("You", 30, shift2, 180, frameGroup)
	totalScore = addNewText(playerData.total, 30, shift2, 220, frameGroup)
	local opponentTotal = addNewText("Opponent", 30, shift2, 260, frameGroup)
	opponentScoreText = addNewText("0", 30, shift2, 300, frameGroup)
	local currentText = addNewText("CURRENT", 40, shift2, 400, frameGroup)
	local youCurrent = addNewText("You", 30, shift2, 450, frameGroup)
	scoreText = addNewText("0", 30, shift2, 490, frameGroup)
	local opponentCurrentText = addNewText("Opponent", 30, shift2, 530, frameGroup)
	opponentCurrent = addNewText("Waiting to select", 30, shift2, 570, frameGroup)

	finished = false
	selectionMade = false
	correctSelection = false

	table.insert(answers, answer1)
	table.insert(answers, answer2)
	table.insert(answers, answer3)
	table.insert(answers, answer4)

	answersGroup.isVisible = false

	Runtime:addEventListener( "enterFrame", makeSmaller )
	answer1:addEventListener( "touch", selectAnswer1 )
	answer2:addEventListener( "touch", selectAnswer2 )
	answer3:addEventListener( "touch", selectAnswer3 )
	answer4:addEventListener( "touch", selectAnswer4 )

	timer.performWithDelay(1000, countdown)
end


function scene:exitScene(event)

	Runtime:removeEventListener( "enterFrame", makeSmaller )
	answer1:removeEventListener( "touch", selectAnswer1 )
	answer2:removeEventListener( "touch", selectAnswer2 )
	answer3:removeEventListener( "touch", selectAnswer3 )
	answer4:removeEventListener( "touch", selectAnswer4 )

	for i = #answers, 1, -1 do
		table.remove(answers)
	end


	answersGroup:removeSelf()
	frameGroup:removeSelf()
	picGroup:removeSelf()

end



--[[

local options = {
    zipFile="Archive.zip",
    zipBaseDir = system.ResourceDirectory,
    dstBaseDir = system.ResourceDirectory,
    files = { "eggs.jpg","baby.jpg","man.jpg" },
    listener = zipListener, }

zip.uncompress( options )

]]--


local function zipListener( event )
        if ( event.isError ) then
                print( "Unzip Error")
        else
                print ( "event.name: " .. event.name )
                print ( "event.type: " .. event.type )
                print ( "event.response[1]: " .. event.response[1] )

		pic = utility.addNewPicture(event.response[1], screenGroup)
		utility.centreObjectX(pic)
		pic:setReferencePoint(display.CenterReferencePoint)
		pic:scale(30, 30)
		pic:toBack()


		table.insert(answers, answer1)
		table.insert(answers, answer2)
		table.insert(answers, answer3)
		table.insert(answers, answer4)

        end
end


local function deletePrevious() 
	local doc_dir = system.ResourceDirectory
	local doc_path = system.pathForFile(nil, doc_dir)
	local resultOK, errorMsg
	print("doc path " .. doc_path)

	for file in lfs.dir(doc_path) do

		print(file .." found");

		if (lfs.attributes(file, "mode") ~= "directory") and string.find(file, "jpg") then
			resultOK, errorMsg = os.remove(file)

			if (resultOK) then
				print(file .." removed");
			else

				print("Error removing file: ".. file ..":"..errorMsg);
			end
		end
	end
end 

return scene

