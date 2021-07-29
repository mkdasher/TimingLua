File = {
	LUA_PATH = ""
}

function File.setLuaPath(path)
	File.LUA_PATH = path
end

function File.loadST(path)
	savestate.loadfile(path)
end

function File.readFrameCount()
	return Utils.bytesToInt(State.m64.rawInput:byte(0x18 + 1, 0x18 + 4))
end

function File.readRerecords()
	return Utils.bytesToInt(State.m64.rawInput:byte(0x10 + 1, 0x10 + 4))
end

function File.readFrame(index)
	b1,b2,b3,b4 = State.m64.rawInput:byte(0x400 + index * 4 + 1, 0x400 + index * 4 + 4)
	inputFrame = joypad.get(1)
	inputFrame['A'] = Utils.bitAND(b1,0x80) > 0
	inputFrame['B'] = Utils.bitAND(b1,0x40) > 0
	inputFrame['Z'] = Utils.bitAND(b1,0x20) > 0
	inputFrame['start'] = Utils.bitAND(b1,0x10) > 0
	inputFrame['up'] = Utils.bitAND(b1,0x08) > 0
	inputFrame['down'] = Utils.bitAND(b1,0x04) > 0
	inputFrame['left'] = Utils.bitAND(b1,0x02) > 0
	inputFrame['right'] = Utils.bitAND(b1,0x01) > 0
	inputFrame['L'] = Utils.bitAND(b2,0x20) > 0
	inputFrame['R'] = Utils.bitAND(b2,0x10) > 0
	inputFrame['Cup'] = Utils.bitAND(b2,0x08) > 0
	inputFrame['Cdown'] = Utils.bitAND(b2,0x04) > 0
	inputFrame['Cleft'] = Utils.bitAND(b2,0x02) > 0
	inputFrame['Cright'] = Utils.bitAND(b2,0x01) > 0
	if (b3 > 127) then
		b3 = b3 - 256
	end
	if (b4 > 127) then
		b4 = b4 - 256
	end
	inputFrame['X'] = b3
	inputFrame['Y'] = b4
	return inputFrame
end

function File.loadM64(path)
	file = io.open(path, "rb")
	State.m64.fileSize = file:seek("end")
	file:seek("set", 0)
	State.m64.rawInput = file:read("*all")
	file:close()
	State.m64.frameCount = File.readFrameCount()
	State.m64.rerecords = File.readRerecords()
	-- Check if fileSize is bigger than frameCount
	--if State.m64.frameCount > State.m64.fileSize / 4 - 0x100 then
	--	State.m64.frameCount = State.m64.fileSize / 4 - 0x100
	--end
end

function File.readDirectory(dir)
	local i, t, popen = 0, {}, io.popen
  local pfile = popen('dir "'..dir..'" /b')
  for filename in pfile:lines() do
			if string.sub(filename:lower(), -4) == ".m64" then
	      i = i + 1
	      t[i] = filename
			end
  end
	State.m64List = t
  pfile:close()
end

function File.loadJSON(filename)
	local path = File.LUA_PATH .. "\\" .. filename
  local contents = ""
  local myTable = {}
  local file = io.open( path, "r" )
  if file then
      --print("trying to read ", filename)
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      myTable = json.parse(contents);
      io.close( file )
      --print("Loaded file")
      return myTable
  end
  print(filename, "file not found")
  return nil
end
