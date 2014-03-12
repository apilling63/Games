-----------------------------------------------------------------------------------------
--
-- objectChecker.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards

local utility = require ("utility")
local math = require ("math")
local t = {}

local function isObjectInRange(obj, player)
	return math.abs(obj.y - player.y - 60) < 15
end

local function isObjectBeyondRange(obj, player)
	return (obj.y - player.y - 60) > 15
end

t.checkMovingObstacles = function(movingObjects, hitObstacle, pickupFunc, invincibleFunc, timeFunc, player)
		for i=#movingObjects, 1, -1 do
			local thisOne = movingObjects[i]
			local objectInRange = isObjectInRange(thisOne, player)
			local objectHitCentre = (thisOne.final == 0 or thisOne.final == 0.5 or thisOne.final == -0.5) and player.x > 290 and player.x < 350
			local objectHitLeft = (thisOne.final < 0) and player.x < 230
			local objectHitRight = (thisOne.final > 0) and player.x > 410

			if (thisOne.isVisible and objectInRange and (objectHitCentre or objectHitLeft or objectHitRight)) then
				if thisOne.collectValue == 0 then
					hitObstacle("You hit an obstacle", "Swipe left and right to avoid them")
					thisOne.isVisible = false
				elseif player.state ~= "jumping" then
					if thisOne.collectValue > 0 then
						pickupFunc(thisOne.collectValue)
					elseif thisOne.collectValue == -1 then
						invincibleFunc()
					else
						timeFunc()
					end

					thisOne.isVisible = false
				end
			elseif thisOne.isAtFront == false and isObjectBeyondRange(thisOne, player) then
				thisOne:toFront()
				thisOne.isAtFront = true
			end

			if thisOne.isVisible == false then
				table.remove(movingObjects, i)
			end
		end
end

local function checkLowOrHigh(objects, hitObstacle, player, state, str1, str2)
		for i=#objects, 1, -1 do
			local thisOne = objects[i]
			local objectInRange = isObjectInRange(thisOne, player)

			if (objectInRange and player.state ~= state) then
				hitObstacle(str1, str2)
				thisOne.isVisible = false
			elseif thisOne.isAtFront == false and isObjectBeyondRange(thisOne, player) then
				thisOne:toFront()
				thisOne.isAtFront = true
			end

			if thisOne.isVisible == false then
				table.remove(objects, i)
			end
		end

end


t.checkHighObstacles = function(highObjects, hitObstacle, player)
	checkLowOrHigh(highObjects, hitObstacle, player, "sliding", "You hit a high bar", "Swipe down to crouch under them")
end

t.checkLowObstacles = function(lowObjects, hitObstacle, player)
	checkLowOrHigh(lowObjects, hitObstacle, player, "jumping", "You hit a low bar", "Swipe up to jump over them")
end

return t