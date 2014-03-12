-----------------------------------------------------------------------------------------
--
-- transitionLevel.lua
--
-----------------------------------------------------------------------------------------

-- allow this lua file to be used with storyboards
local storyboard = require "storyboard"
local scene = storyboard.newScene()

local function changeScene()
	print("go to first")
	storyboard.gotoScene("first")
end

-- what to do when the screen loads
function scene:createScene(event)
end

-- add all the event listening
function scene:enterScene(event)
	print("purge first")
	storyboard.purgeScene("first")
	changeScene()
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


