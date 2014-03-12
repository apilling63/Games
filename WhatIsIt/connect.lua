local storyboard = require "storyboard"
local scene = storyboard.newScene()
local first = require "first"
local client
local server
local isServer = false
local isClient = false
local pictureInfo
local mappings = require "answerMappings"
local currentPictureNum = 1
local serverFinishedQuestion
local clientFinishedQuestion

local numberOfServers = 0

local menuGroup

local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local function getARandomNumber(previousNumbers)
	local rand = math.random(1,#mappings)
	local foundSamePrevious = false

	for i = 1, #previousNumbers do
		if previousNumbers[i] == rand then
			foundSamePrevious = true
			break
		end
	end

	if foundSamePrevious then
		rand = getARandomNumber(previousNumbers)
	end

	return rand

end
local function addPlayer(event)
	print("add player")

	if client == nil then
		menuGroup:removeSelf()

		client = event.client --this is the client object, used to send messages
		print("player joined",client)

		pictureInfo = {}
		local selections = {}

		for i=1, 5 do
			local rand = getARandomNumber(selections)
			selections[i] = rand
			print("rand is " .. rand)
			pictureInfo[i] = mappings[rand]
			print("picture is " .. pictureInfo[i][1])

		end


		client:sendPriority({1, pictureInfo}) --initialization packet
	else
		client:sendPriority({4,"bogus"})
	end
	--server:setCustomBroadcast(numPlayers.." Players")
end


local function makeClient() 
	if client == nil and server == nil then
		print("making client")
		client = require("Client") 
		client:start() 
		client:scanServersInternet() 
		isClient = true
		Runtime:addEventListener("autolanReceived", clientReceived)
	endend

local function makeServer()
	if client == nil and server == nil then

		print("making server")		server = require("Server") 
		server:setCustomBroadcast("1 Player") 
		server:startInternet()		isServer = true 
		Runtime:addEventListener("autolanReceived", serverReceived)
	endend

local function spawnMenu()
	currentPictureNum = 1
	--functions to handle button events
	local joinText 
	local hostText 

	local function joinPressed()
		joinText.text = "Scanning..."
		 makeClient()
	end

	local function hostPressed()
		hostText.text = "Waiting..."
		 makeServer()
	end

	menuGroup = display.newGroup()
	local title = display.newRoundedRect(menuGroup, 0, 0, screenW*.8,60,20)
	title:setReferencePoint(display.CenterReferencePoint)
	title.x,title.y = halfW, 50
	title:setFillColor(100,100,100)
	local titleText = display.newText(menuGroup, "Multiplayer Pic Pop", 0, 0, native.systemFont, 24)
	titleText:setReferencePoint(display.CenterReferencePoint)
	titleText.x, titleText.y = halfW, 50
	--host button
	local host = display.newRoundedRect(menuGroup, 20, 100, 120,60,20)
	host:setFillColor(100,100,100)
	host:addEventListener("tap", hostPressed)
	hostText = display.newText(menuGroup, "Host", 50, 115, native.systemFont, 24)
	--join button
	local join = display.newRoundedRect(menuGroup, 160, 100, 120,60,20)
	join:addEventListener("tap", joinPressed)
	join:setFillColor(100,100,100)	
	joinText = display.newText(menuGroup, "Join", 195, 115, native.systemFont, 24)

end




local function createListItem(event) --displays found servers

	print("hello")	local item = display.newGroup()	item.background = display.newRoundedRect(item,20,0,screenW- 50,60,20)	item.background.strokeWidth = 3 
	item.background:setFillColor(70, 70, 70) 
	item.background:setStrokeColor(180, 180, 180) 
	item.text = display.newText(item,event.serverName.." "..event.customBroadcast, 50, 30, "Helvetica-Bold", 18 ) 
	item.text:setTextColor( 255 )	item.serverIP = event.serverIP --attach a touch listener 
	
	function item:tap(e)		client:connect(self.serverIP) 
		menuGroup:removeSelf() 
		menuGroup = nil	end
	item:addEventListener("tap", item)	item.y = numberOfServers*70+180 
	numberOfServers = numberOfServers+1 
	menuGroup:insert(item)end

local function connectionAttemptFailed(event) 
	print("connection failed, redisplay menu") 
	numberOfServers = 0	menuGroup = display.newGroup() 
	spawnMenu()end
local function connectedToServer(event)	print("connected") 
end

local function gameCallback(message)

	if (message[1] == "answer") then
		print(message[2])
		client:sendPriority({2, message[2], message[3]})
	elseif (message[1] == "next") then
		print("next callback")
		if isServer or serverFinishedQuestion then
			print("sending message")
			client:sendPriority({3,"finished"})

			if serverFinishedQuestion then
				print("on client and server has also finished")
				serverFinishedQuestion = false
				clientFinishedQuestion = false

				local closure = function()
					first.startNext()
				end
		
				timer.performWithDelay(10, closure)
			end
	
		else
			print("on client and server has not finished")
			clientFinishedQuestion = true
		end

		currentPictureNum = currentPictureNum + 1
		return pictureInfo[currentPictureNum]
	elseif (message[1] == "complete") then


		if isClient then
			print("shut down client")
			client:disconnect()
			client:stop()
			Runtime:removeEventListener("autolanReceived", clientReceived)
			server = nil
			client = nil
			isClient = false
			isServer = false
			numberOfServers = 0
		else
			print("shut down server")
			server:disconnect()
			server:stop()
			--server:disconnect()
			Runtime:removeEventListener("autolanReceived", serverReceived)
			server = nil
			client = nil
			isClient = false
			isServer = false
			numberOfServers = 0
		end

		first.exitScene()
		spawnMenu()
	end
end

local function startGame()
	print("do start game")
	serverFinishedQuestion = false
	clientFinishedQuestion = false
	first.setUp(gameCallback, pictureInfo[1])
end

function clientReceived(event)
	local message = event.message
	if (message[1] == 1) then
		print("got init packet")
		print(message[2])
		pictureInfo = message[2]
		client:sendPriority({1,"begin"})
		startGame()
	elseif (message[1] == 2) then
		print("opponent selected " .. message[2])
		first.opponentSelection(message[2], message[3])
	elseif (message[1] == 3) then
		print("server has finished")

		serverFinishedQuestion = true

		if clientFinishedQuestion then
			print("client has also finished")
			serverFinishedQuestion = false
			clientFinishedQuestion = false
			first.startNext()
			client:sendPriority({3,"finished"})
		end
	elseif (message[1] == 4) then
		client:disconnect()
	end
end


function serverReceived(event)
	local message = event.message
	if (message[1] == 1) then
		print("received ack from client")
		startGame()
	elseif (message[1] == 2) then
		print("opponent selected " .. message[2])
		first.opponentSelection(message[2], message[3])
	elseif (message[1] == 3) then
		serverFinishedQuestion = false
		clientFinishedQuestion = false
		first.startNext()
	end

end

function scene:createScene(event)		
end

function scene:enterScene(event)
	Runtime:addEventListener("autolanServerFound", createListItem)
	Runtime:addEventListener("autolanConnectionFailed", connectionAttemptFailed)
	Runtime:addEventListener("autolanConnected", connectedToServer)
	Runtime:addEventListener("autolanPlayerJoined", addPlayer)

	spawnMenu()
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