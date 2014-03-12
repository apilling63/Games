-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- get the storyboard and start menu
local storyboard = require "storyboard"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
storyboard.gotoScene("menu")
