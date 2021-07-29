Result = {
  entries = {}
}

function Result.sort()
  table.sort (Result.entries, function (k1, k2) return k1.time < k2.time end)
end

function Result.getAuthor(m64Name)
  name = Utils.stringsplit(m64Name, "%.")[1]
  local t = {}
  for s in string.gmatch(name, "%d[Bb][Yy].+") do
    table.insert(t, s)
  end
  if #t > 0 then
    name = t[1]:sub(4)
  end
  return name
end

function Result.printResults()
  file = io.open(File.LUA_PATH .. "\\" .. Config.Settings.results_file_name, "w")
  previousTime = 0
  previousPosition = 1
  position = 1

  for i = 1, #Result.entries, 1 do
    if (Result.entries[i].isDQ) then
      file:write("DQ: " ..  Result.getAuthor(Result.entries[i].filename) .. " (" .. Result.entries[i].DQreason .. ")\n")
    else
      if Result.entries[i].time > previousTime then
        position = i
      end
      file:write(position)
      if (position%10 == 1 and position ~= 11) then
        file:write("st. ")
      elseif (position%10 == 2 and position ~= 12) then
        file:write("nd. ")
      elseif (position%10 == 3 and position ~= 13) then
        file:write("rd. ")
      else
        file:write("th. ")
      end
      timestring = string.format("%.2f", Result.entries[i].time):gsub("%.",'"')
      file:write(Result.getAuthor(Result.entries[i].filename) .. " " .. timestring .. "\n")
      previousTime = Result.entries[i].time
      previousPosition = position
    end
  end

  file:close()
end
