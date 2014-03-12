-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- import it before other imports that use sockets, like "socket.http"
local ads = require "ads"
--ads.init("vungle", "52c81eb70c256f4447000008") --ios
ads.init("vungle", "com.appappnaway.sochi") --android

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")