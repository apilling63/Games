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

local isApple = ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" )

if isApple then
	ads.init("vungle", "53119ae63694373b10000184") --ios
else
	ads.init("vungle", "53119bb63694373b10000187") --android
end

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")
