-- SM64 Timing Script v1.0
-- Author: MKDasher

PATH = debug.getinfo(1).source:sub(2):match("(.*\\)") .. "\\scripts\\"
dofile (PATH .. "Program.lua")
dofile (PATH .. "Utils.lua")
dofile (PATH .. "Config.lua")
dofile (PATH .. "Log.lua")
dofile (PATH .. "Actions.lua")
dofile (PATH .. "Animations.lua")
dofile (PATH .. "File.lua")
dofile (PATH .. "Memory.lua")
dofile (PATH .. "State.lua")
dofile (PATH .. "Time.lua")
dofile (PATH .. "Result.lua")
dofile (PATH .. "json.lua")
File.setLuaPath(debug.getinfo(1).source:sub(2):match("(.*\\)")) --Lua modules will use File.LUA_PATH instead of this function.-

function main()
  Program.main()
end

function drawing()
	--TODO
end

emu.atinput(main)
emu.atvi(drawing,false)
