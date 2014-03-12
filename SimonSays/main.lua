-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- import it before other imports that use sockets, like "socket.http"
local ads = require "ads"
local analytics = require "analytics"

if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

ads.init("vungle", "698237519") --ios
--ads.init("iads", "com.appapnaway.simonsays")
--ads:setCurrentProvider("iads")
--analytics.init( "585P5VMQKGVBX6W23QXH" ) -- iOS

else

ads.init("vungle", "com.appappnaway.www.SimonSays") --android
--analytics.init( "6DMVG77JPQ3XBX8RFFC9" ) -- android

end


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("first")