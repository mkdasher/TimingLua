Utils = {

}

function Utils.bitAND(a, b)
	if (a == nil) then Program.close() end
	if (b == nil) then Program.close() end
	local p,c=1,0
	while a>0 and b>0 do
	    local ra,rb=a%2,b%2
	    if ra+rb>1 then c=c+p end
	    a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c
end

function Utils.bytesToInt(b1, b2, b3, b4)
    local n = b1 + b2*256 + b3*65536 + b4*16777216
    n = (n > 2147483647) and (n - 4294967296) or n
    return n
end

function Utils.contains(val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function Utils.stringsplit(str, sep)
  local t = {}
  for s in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, s)
  end
  return t
end
