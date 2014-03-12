local utility = require "utility"
local math = require "math"

local t = {}

local jigsaw
local jigsawPiece
local callback
local simon
local touchStarted = false

t.create = function(screenGroup, callbackFunc)
	jigsaw = display.newImageRect( "images/jigsaw.png", 224, 224 )
	jigsawPiece = display.newImageRect( "images/jigsawPiece.png", 118, 130 )

	utility.addObject(jigsaw, screenGroup, 1900, 250)
	utility.addObject(jigsawPiece, screenGroup, 2100, 250)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2, simonSays)
	text2.text = "finish the jigsaw"
	simon = simonSays

	jigsaw:translate(-2000, 0)
	jigsawPiece:translate(-2000, 0)
	jigsawPiece.returnX = jigsawPiece.x
	jigsawPiece.returnY = jigsawPiece.y

end

t.removeFromScreen = function()
	jigsawPiece.x = jigsawPiece.returnX
	jigsawPiece.y = jigsawPiece.returnY
	jigsawPiece:translate(2000, 0)
	jigsaw:translate(2000, 0)
	touchStarted = false
end

local function tapped(event)
	callback(true, event)
end

local function touched(event)
	if not touchStarted and event.phase == "began" then
		touchStarted = true
	elseif touchStarted then
		if not simon then
			callback(false, event)
		else
			jigsawPiece.x = event.x
			jigsawPiece.y = event.y

			if math.abs(event.x - jigsaw.x -50) < 20 and math.abs(event.y - jigsaw.y) < 20 then
				callback(true, event)
			end
		end
	end
end

t.addEventListeners = function()
	jigsawPiece:addEventListener("touch", touched)
end

t.removeEventListeners = function()
	jigsawPiece:removeEventListener("touch", touched)
end

return t