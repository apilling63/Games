-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"
local ads = require "ads"
local name = require "name"

local isApple = ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" )
local personName = name.name

if personName == "Miley" then
	if isApple then
		ads.init("vungle", "53119ae63694373b10000184") --ios
	else
		ads.init("vungle", "53119bb63694373b10000187") --android
	end
elseif personName == "Simon" then
	if isApple then
		ads.init("vungle", "53119c043694373b10000189") --ios
	else
		ads.init("vungle", "53119c293694373b1000018c") --android
	end
end

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")
