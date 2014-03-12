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
local gameData = require ("gameData")
local keepyUppy = require ("second")

local canMovePlayer = true
local movingObjects = {}
local highObjects = {}
local lowObjects = {}

local background
local player
local playerAnimation
local playerSliding
local playerDown
local playerSpeed = 20
local inPlay = true
local screenGroup
local counter
local scoreText
local bestScoreText
local lastHardObstacle
local obstacleYSpeed = 2

local gapBetweenObstacles

-- what to do when the screen loads
function scene:createScene(event)
	local screenGroup = self.view

	local beachball = utility.addNewPicture("goldenBeachball.png", screenGroup)

	transition.to ( beachball,{  time=500, alpha=1,x = 300,y = 800,width =200,height =200}  ) 


end


-- add all the event listening
function scene:enterScene(event)

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