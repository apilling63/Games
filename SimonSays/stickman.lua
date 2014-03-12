local utility = require "utility"
local math = require "math"

local t = {}

local man
local armTouch
local legTouch
local headTouch
local callback

t.create = function(screenGroup, callbackFunc)
	armTouch = display.newRect( 0, 0, 240, 60 )

	legTouch = display.newRect( 0, 0, 120, 130 )

	headTouch = display.newRect( 0, 0, 90, 90 )


	man = display.newImageRect( "images/stickman.png", 344, 400 )
	utility.centreObjectX(man)
	utility.centreObjectY(man)
	man:translate(2000, 200)

	utility.centreObjectX(armTouch)
	utility.centreObjectY(armTouch)
	armTouch:translate(2000, 130)

	utility.centreObjectX(legTouch)
	utility.centreObjectY(legTouch)
	legTouch:translate(2000, 270)

	utility.centreObjectX(headTouch)
	utility.centreObjectY(headTouch)
	headTouch:translate(2000, 50)

	screenGroup:insert(armTouch)
	screenGroup:insert(legTouch)
	screenGroup:insert(headTouch)
	screenGroup:insert(man)

	callback = callbackFunc
end

t.showOnScreen = function(difficulty, text2)
	print("showing stickman")
	correctIndex = math.random(1,3)

if difficulty == 1 then
	if correctIndex == 1 then
		text2.text = "touch the head"
	elseif correctIndex == 2 then
		text2.text = "touch an arm"
	else
		text2.text = "touch a leg"
	end
elseif difficulty == 2 then
	if correctIndex == 1 then
		text2.text = "touch la tête"
	elseif correctIndex == 2 then
		text2.text = "touch un bras"
	else
		text2.text = "touch une jambe"
	end
else 
	if correctIndex == 1 then
		text2.text = "touch la cabeza"
	elseif correctIndex == 2 then
		text2.text = "touch un brazo"
	else
		text2.text = "touch una pierna"
	end
end

	man:translate(-2000, 0)
	headTouch:translate(-2000, 0)
	legTouch:translate(-2000, 0)
	armTouch:translate(-2000, 0)

end

t.removeFromScreen = function()
	print("removing stickman")

	man:translate(2000, 0)
	headTouch:translate(2000, 0)
	legTouch:translate(2000, 0)
	armTouch:translate(2000, 0)
end

local function tappedHead(event)
	print("tapped head")
	callback(correctIndex == 1, event)
end

local function tappedArm(event)
	print("tapped arm")
	callback(correctIndex == 2, event)
end

local function tappedLeg(event)
	print("tapped leg")
	callback(correctIndex == 3, event)
end

t.addEventListeners = function()
	headTouch:addEventListener("tap", tappedHead)
	armTouch:addEventListener("tap", tappedArm)
	legTouch:addEventListener("tap", tappedLeg)
end

t.removeEventListeners = function()
	headTouch:removeEventListener("tap", tappedHead)
	armTouch:removeEventListener("tap", tappedArm)
	legTouch:removeEventListener("tap", tappedLeg)
end

return t