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
local gameData = require "gameData"
local sequences = require "sequence"
local foreground
local background
local squares
local sequence
local sequenceIndex
local person
local finish
local start
local inPlay
local currentLevel
local touchSquare
local text
local isFirstMove

local function showText(toShow)
	text.text = toShow
	text.alpha = 1
	transition.to(text, {time = 2000, alpha = 0})
end

local function loseALife()
	person:scale(5, 5)
	start.isVisible = true
	person.isVisible = true
	person.x = start.x
	person.y = start.y
	person.currentIndex = 0
	showText("LOSE A LIFE")
	sequenceIndex = 1
	isFirstMove = true
end

local function removePerson()
	person.isVisible = false
	loseALife()
end

local function dropDead()
	person.currentIndex = -2
	transition.to(person, {time = 2000, xScale = (0.1), yScale = (0.1), onComplete = removePerson})
end

local function moveSquares()
	if inPlay then

		if isFirstMove == false then
			start.isVisible = false
			
			if person.currentIndex == 0 then
				dropDead()
			end

			timer.performWithDelay(2000, moveSquares)			
		else
			timer.performWithDelay(4000, moveSquares)
			isFirstMove = false			
		end
		
		for i = 1, #squares do
			squares[i].isVisible = false
		end

		for i = 1, #sequence[sequenceIndex] do
			squares[sequence[sequenceIndex][i]].isVisible = true	
		end
	
		if person.currentIndex > 0 and squares[person.currentIndex].isVisible == false then
			dropDead()
		else
			sequenceIndex = sequenceIndex + 1
	
			if sequenceIndex > #sequence then
				sequenceIndex = 1
			end
	
		end
	end
end

local function resetSquares()
	for i=#squares,1,-1 do
		squares[i]:removeSelf()
	end

	sequence = sequences[currentLevel].squares
	local width = sequences[currentLevel].size

	local scalar = 4 / width
	local gridWidth = 640 / width
	local movement = -0.5 * (width - 1)
	
	for i = 1, width * width do
		local whiteSquare = utility.addNewPicture("whitesquare.png", foreground)
		utility.putInCentre(whiteSquare)
		whiteSquare.x = whiteSquare.x + (gridWidth * (movement + ((i - 1) % width)))
		whiteSquare.y = whiteSquare.y + (gridWidth * (movement - 1 + (math.ceil(i / width))))
				
		squares[i] = whiteSquare
		whiteSquare.index = i
		whiteSquare:scale(scalar, scalar)
		whiteSquare.isVisible = false
		whiteSquare.touch = touchSquare
		whiteSquare:addEventListener("touch", whiteSquare)
	end
end

local function insertFinishSquare()
	finish = utility.addNewPicture("whiteRect.png", foreground)
	finish.touch = touchSquare
	finish:addEventListener("touch", finish)	
	finish.x = 320
	finish.y = 100
	finish.index = -1
	inPlay = true	
	isFirstMove = true	
	person:toFront()
	moveSquares()
end

local function levelComplete()
	inPlay = false
	currentLevel = currentLevel + 1
	sequenceIndex = 1
	
	if currentLevel > #sequences then
		currentLevel = 1
	end
	
	finish.index = 0
	start:removeSelf()
	person.currentIndex = 0
	transition.to(finish, {time = 2000, y = (start.y), onComplete=insertFinishSquare})
	transition.to(person, {time = 2000, y = (start.y)})
	start = finish
	resetSquares()
	showText("LEVEL " .. currentLevel)
end

local function areSquaresAdjacent(squareIndex1, squareIndex2)
	print("comparing " .. squareIndex1 .. " " .. squareIndex2)

	local difference = math.abs(squareIndex1 - squareIndex2)
	local width = sequences[currentLevel].size
	
	if squareIndex1 ~= -1 and (difference == 1 or difference == width) then
		return true
	end
	
	local startLimit = (width * width) - width
	
	if squareIndex1 ~= -1 and squareIndex2 == 0 and squareIndex1 > startLimit then
		return true		
	end
	
	if squareIndex1 == -1 and squareIndex2 <= width and squareIndex2 ~= 0 then
		return true		
	end
	
	return false
end

touchSquare = function(self, event)
	if event.phase == "began" and inPlay then
		print(self.index)
	
		if areSquaresAdjacent(self.index, person.currentIndex) then
			person.currentIndex = self.index
			person.x = self.x
			person.y = self.y
			
			if self.index == -1 then
				levelComplete()
			end
		end
	end
end

local function webListener( event )
	text.text = "hello"

    if event.url then
        text.text =  "You are visiting: " .. event.url 
    end

    if event.type then
        text.text =  "The event.type is " .. event.type -- print the type of request
    end

    if event.errorCode then
        text.text =  "Error!"
    end
        
    return false
end

-- what to do when the screen loads
function scene:createScene(event)
	local level = gameData.chosenLevel
	local screenGroup = self.view
	whiteSquares = {}
	squares = {}
	
	currentLevel = 4
		
	sequenceIndex = 1

	background = utility.addNewPicture("clouds.png", screenGroup)
	utility.putInCentre(background)
	
	foreground = display.newGroup()

	start = utility.addNewPicture("whiteRect.png", foreground)
	start.x = 320
	start.y = 880
	start.index = 0
		
	person = utility.addNewPicture("person.png", foreground)
	person.x = start.x
	person.y = start.y
	person.currentIndex = 0
	person:scale(0.5, 0.5)
	resetSquares()
	
	insertFinishSquare()
	
	text = utility.addBlackCentredText("", 600, foreground, 50)
	--showText("LEVEL " .. currentLevel)
	
	--[[local saveData = 
	"<!DOCTYPE html>\
<html>	\
	<body style=\"padding:0px; margin:0px; width:100%; height:100%;\">\
		<iframe id=\"playerId\" width=\"480\" height=\"390\" src=\"http://www.youtube.com/embed/RBumgq5yVrA?html5=1\"></iframe>\
		</body></html>"	
	
local path = system.pathForFile( "youtube.html", system.ResourceDirectory )

local file = io.open( path, "w" )
file:write( saveData )

io.close( file )
file = nil]]--
	
	
	
	local webView = native.newWebView( 300, 400, 640, 390 )
webView:addEventListener( "urlRequest", webListener )
	
--webView:request( "http://www.coronalabs.com/" )
-- or
webView:request( "youtube.html", system.ResourceDirectory )
	
end


-- add all the event listening
function scene:enterScene(event)
	storyboard.purgeScene("levels")

	start.touch = touchSquare
	start:addEventListener("touch", start)	
end

function scene:exitScene(event)
	for i = 1, #squares do
		squares[i]:removeEventListener("touch", squares[i])
	end

	for i=foreground.numChildren,1,-1 do
        local child = foreground[i]
	    child.parent:remove( child )
	end

end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene