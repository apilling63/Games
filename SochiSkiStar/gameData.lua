-----------------------------------------------------------------------------------------
--
-- gameData.lua
--
-----------------------------------------------------------------------------------------

local t = {}

local runNumber = 1
local myScore = 0

t.getRunNumber = function()
	if runNumber == 3 then
		runNumber = 1
		myScore = 0
	end

	runNumber = runNumber + 1
	return runNumber - 1
end

t.getOnlyRunNumber = function()
	return runNumber - 1
end

t.addMyScore = function(score)
	myScore = myScore + score
end

t.getMyScore = function()
	return myScore
end

return t