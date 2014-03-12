-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- import it before other imports that use sockets, like "socket.http"
local ads = require "ads"
local name = require "name"

if name.name == "Miley" then
	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

		ads.init("vungle", "53066111e54551c04600011d") --ios

	else

		ads.init("vungle", "53066166e54551c046000120") --android

	end
else
	if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

		ads.init("vungle", "698237519") --ios

	else

		ads.init("vungle", "com.appappnaway.www.SimonSays") --android

	end
end


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("first")