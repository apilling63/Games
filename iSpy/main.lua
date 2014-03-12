-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- import it before other imports that use sockets, like "socket.http"
local ads = require "ads"

if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

ads.init("vungle", "52f15d0f89fc34162d00000c") --ios
else
ads.init("vungle", "52ee6ff4c29ba9d309000009") --android
end

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")
