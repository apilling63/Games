-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- import it before other imports that use sockets, like "socket.http"
local ads = require "ads"

if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

ads.init("vungle", "52c81eb70c256f4447000008") --ios

else
ads.init("vungle", "com.appappnaway.sochi") --android
end

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")