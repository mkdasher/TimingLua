Program = {

}

function Program.checkCondition(conditions)
  -- If conditions are in array, check every condition as an OR
  local comparison = 'equal'
  if (#conditions > 0) then
    for i, condition in ipairs(conditions) do
      if Program.checkCondition(condition) then
        return true
      end
    end
    return false
  else
    for k, v in pairs(conditions) do
      mem = k
      if (mem:sub(0,3) == 'max') then
        comparison = 'less'
        mem = mem:sub(5)
      elseif (mem:sub(0,3) == 'max') then
        comparison = 'more'
        mem = mem:sub(5)
      end
      value = Memory.read(mem)
      if (comparison == 'less') then
        if value > v then return false end
      elseif (comparison == 'more') then
        if value < v then return false end
      elseif (type(v) == 'table') then
        if not Utils.contains(value, v) then
          return false
        end
      elseif value ~= v then
        return false
      end
    end
    return true
  end
end

function Program.checkStartCondition()
  return Program.checkCondition(Config.Settings.start_condition)
end

function Program.checkEndCondition()
  return Program.checkCondition(Config.Settings.end_condition)
end

function Program.checkDQCondition(condition)
  -- If conditions are in array, check every condition as an OR
  if (#condition > 0) then
    for i, c in ipairs(condition) do
      if Program.checkDQCondition(c) then
        return true
      end
    end
    return false
  -- DQ conditions empty
  elseif condition.condition == nil then
    return false
  -- Check DQ condition
  else
    if condition.check_before_timing == false and Time.currentState == Time.State.PENDING then
      return false
    end
    if Program.checkCondition(condition.condition) then
      Time.dq_reason = condition.reason
      return true
    end
    return false
  end
end

function Program.setup(path)
  if Config.Settings.m64_replay_file == "all" then
    File.readDirectory(path)
    Log.print(#State.m64List .. " m64 files found")
  else
    State.m64List = {Config.Settings.m64_replay_file}
  end
end

function Program.close()
  if Config.Settings.close_on_end then
    os.exit()
  end
end

function Program.main()
  if State.currentState == State.SETUP then
    Config.load()
    Program.setup(Config.Settings.m64_path)
    State.currentState = State.PENDING
  elseif State.currentState == State.PENDING then
    State.fileCounter = State.fileCounter + 1
    State.init()
    Time.init()
    State.currentState = State.LOAD_M64
  elseif State.currentState == State.LOAD_M64 then
    File.loadM64(Config.Settings.m64_path .. "\\" .. State.m64.m64Name)
    State.currentState = State.LOAD_ST
    if (#State.m64List > 1) then
      Log.print("")
      Log.print(State.fileCounter .. "/" .. #State.m64List)
    end
    Log.print("M64 loaded: " ..State.m64.m64Name)
    Log.print("Framecount: " .. State.m64.frameCount)
    Log.print("Rerec count: " .. State.m64.rerecords)
  elseif State.currentState == State.LOAD_ST then
    File.loadST(Config.Settings.m64_path .. "\\" .. State.m64.stName)
    Log.print("ST loaded: " .. State.m64.stName)
    State.currentState = State.RUN_M64
    State.counter = -1
    local inputFrame = File.readFrame(State.counter)
    joypad.set(1, inputFrame)
  elseif State.currentState == State.RUN_M64 then
    if Time.currentState == Time.State.FINISHED then
      State.currentState = State.FINISHED
      State.counter = 0
    end
    if State.counter >= State.m64.frameCount then
      State.currentState = State.FINISHED
      State.counter = 0
      Log.print("M64 file stopped playing")
    end
    if Time.currentState == Time.State.PENDING and Program.checkStartCondition() then
      Time.currentState = Time.State.TIMING
      Time.start = emu.framecount()
      Log.print("Start timing")
    end
    if Time.currentState == Time.State.TIMING and Program.checkEndCondition() then
      Time.currentState = Time.State.FINISHED
      Time.finish = emu.framecount() + Config.Settings.timing_correction * 2
      Log.print("Finish timing")
      Log.print("Time " .. Time.total())
    end
    if Time.currentState ~= Time.State.FINISHED and Program.checkDQCondition(Config.Settings.dq_condition) then
      State.currentState = State.FINISHED
      State.counter = 0
      Log.print("DQ: " .. Time.dq_reason)
    end
    local inputFrame = File.readFrame(State.counter)
    joypad.set(1, inputFrame)
  elseif State.currentState == State.FINISHED then
    currentEntry = {
      filename = State.m64.m64Name,
      rerecords = State.m64.rerecords,
      time = 9999,
      isDQ = true,
      DQreason = Time.dq_reason
    }
    if Time.currentState == Time.State.FINISHED then
      currentEntry.isDQ = false
      currentEntry.DQreason = ""
      currentEntry.time = Time.total()
    end

    if #State.m64List > 1 then
      table.insert(Result.entries, currentEntry)

      if #State.m64List > State.fileCounter then
        State.currentState = State.PENDING
      elseif Config.Settings.print_result then
        State.currentState = State.RESULTS
      else
        State.currentState = State.LUAEND
      end
    else
      if Config.Settings.print_result then
        Result.printResult(currentEntry)
        State.currentState = State.LUAEND
      end
    end

  elseif State.currentState == State.RESULTS then
    Result.sort()
    Result.printResults()
    Log.print('result.txt created.')
    State.currentState = State.LUAEND
  elseif State.currentState == State.LUAEND then
    Program.close()
  end

  State.counter = State.counter + 1

  if Config.Settings.timeout > 0 then
    if State.counter > Config.Settings.timeout then
      currentEntry = {
        filename = State.m64.m64Name,
        rerecords = State.m64.rerecords,
        time = "",
        isDQ = true,
        DQreason = "Timeout exceeded: " .. State.counter .. "."
      }
      if Config.Settings.print_result then
        Result.printResult(currentEntry)
      end
  	  Program.close()
    end
  end
end
