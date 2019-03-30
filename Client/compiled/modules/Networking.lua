local NM = { }
NM.log = function(tag, msg)
  if type(msg) == "table" then
    local m = ""
    for k, v in pairs(msg) do
      m = m .. " " .. tostring(v)
    end
    msg = m
  end
  local t = love.timer.getTime() - GAME.START_TIME
  t = tostring(t * 1000):sub(1, 6)
  return print(tostring(t) .. " [" .. tostring(string.upper(tag)) .. "]: " .. tostring(msg))
end
NM.NATpassthrough = function(peerIP, privateIP) end
NM.getLocalIP = function()
  local ip = ""
  local _exp_0 = love.system.getOS()
  if "Linux" == _exp_0 then
    local handle = io.popen("hostname -I | awk '{print $2}' | tr -d '\\n'")
    ip = handle:read("*a")
    handle:close()
  elseif "OS X" == _exp_0 then
    local handle = io.popen("ifconfig  | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '192([0-9]*\\.){3}[0-9]*' | tr -d '\\n'")
    ip = handle:read("*a")
    handle:close()
  end
  return ip
end
return NM
