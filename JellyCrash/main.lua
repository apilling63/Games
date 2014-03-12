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
--[[
local math = require("math")

local wfilePath = system.pathForFile( "random", system.DocumentsDirectory )
    local wfh = io.open( wfilePath, "wb" )
	print(wfilePath)
    if  not wfh then
        print( "writeFileName open error!" )
        results = false                 -- error
    else
		for j = 550, 700 do
			for i = 1, 100 do
				local data = math.random(-150, 750 - j)
				if not data then
					print( "read error!" )
					results = false     -- error
				else
					if not wfh:write( data .. "," ) then
						print( "write error!" ) 
						results = false -- error
					end
				end
			end
			
					if not wfh:write( "\n" ) then
						print( "write error!" ) 
						results = false -- error
					end			
		end
    end

        -- Clean up our file handles
        wfh:close()

--]]