local t = {}

local numBulbs = 9
local numSwitches = 12
local numConnections = 3
local numPresses = 50

local function getRandomNotPrevious(previousChoices, limit)

	local rand = math.random(1, limit)
	
	for i = 1, #previousChoices do
		if rand == previousChoices[i] then
			return getRandomNotPrevious(previousChoices, limit)
		end
	end
	
	return rand
end

local function putInNumbericalOrder(toSort)
	local ordered = {}
	local previous = 0
	
	for j = 1, #toSort do
		ordered[j] = 10000
	
		for k = 1, #toSort do
			if toSort[k] < ordered[j] and toSort[k] > previous then
				ordered[j] = toSort[k]
			end
		end		
		
		previous = ordered[j]
	end		
	
	return ordered
end

local function findMatchingConnections(orderedConnections, switches)
	local foundMatch = false

	if #switches > 1 then
		for i = 1, #switches - 1 do
			local thisMatches = true
				
			if #orderedConnections == #switches[i].connections then
				for j = 1, #orderedConnections do
				
					if orderedConnections[j] ~= switches[i].connections[j] then
						thisMatches = false
					end
				end
			else 
				thisMatches = false
			end
				
			if thisMatches then
				foundMatch = true
			end
		end
	end
	
	return foundMatch
end

local function generateConnections(switches)
	local connections = {}
	
	local connectionTotal = math.random(1, numConnections)

	for i = 1, connectionTotal do
		connections[i] = getRandomNotPrevious(connections, numBulbs)
	end
	
	local orderedConnections = putInNumbericalOrder(connections)	
	local foundMatch = findMatchingConnections(orderedConnections, switches)
		
	if foundMatch then	
		return generateConnections(switches)
	else	
		return orderedConnections
	end
end

local function copyState(inArray, out)
	for i = 1, #inArray do
		out[i] = inArray[i]
	end
end

local function countTrue(toTest)
	local count = 0
	
	for i = 1, #toTest do		
		if toTest[i] then
			count = count + 1
		end
	end 
	
	return count
end

function t.start()

	local bulbs = {}
	local switches = {}

	for a = 1, 100 do
	for i = 1, numBulbs do
		bulbs[i] = false
	end

	for i = 1, numSwitches do
		switches[i] = {}
		switches[i].connections = {}
		switches[i].connections = generateConnections(switches)
	end
	
	local random = 0
	
	for i = 1, numPresses do
		random = getRandomNotPrevious({random}, numSwitches)
				
		for j = 1, #switches[random].connections do
			bulbs[switches[random].connections[j]] = not bulbs[switches[random].connections[j]] 
		end
	end
		
	local countOn = countTrue(bulbs)
	
	if countOn == 0 then
	else
		
		local bestScore = 100
		local solutions = {}
		
		for i = 1, 100 do
			local bulbsCopy = {}
			copyState(bulbs, bulbsCopy)
	
			random = 0
			local randoms = {}
	
			for i = 1, 100 do
				random = getRandomNotPrevious({random}, numSwitches)
				randoms[i] = random
		
				for j = 1, #switches[random].connections do
					bulbsCopy[switches[random].connections[j]] = not bulbsCopy[switches[random].connections[j]] 
				end		
			
				if countTrue(bulbsCopy) == 0 then
					if i == bestScore then
						table.insert(solutions, randoms)
					elseif i < bestScore then
						bestScore = i
						solutions = {}
						table.insert(solutions, randoms)					
					end
				
					break
				end
			end
		end
		
	
		print("")
		print("")
		
		local str = ","
	
		for i = 1, numBulbs do
			str = str .. tostring(bulbs[i]) .. ","
		end 	
	
		str = str .. ","			
		
		for i = 1, numSwitches do
			for j = 1, #switches[i].connections do
				str = str .. switches[i].connections[j] .. ";"
			end
			
			str = str .. ","			
		end 	
	
		str = str .. ","			
			
		for i = 1, #solutions do
			for j = 1, #solutions[i] do
				str = str .. solutions[i][j] .. ";"
			end
			
			print(str)
			break
		end 				
	end
	
	end
	
end

return t