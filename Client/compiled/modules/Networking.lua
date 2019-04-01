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
NM.cmd = {
  ["connected"] = function()
    NM.log('client', "Connected to Server")
    return NM.Client:send(128, "hello")
  end,
  ["received"] = function(command, msg)
    return NM.log('client', msg)
  end,
  ["disconnected"] = function() end,
  ["newUser"] = function(user)
    return NM.log("client", "Peer connect: " .. tostring(user.playerName))
  end,
  ["authorized"] = function(auth, reason) end
}
NM.startClient = function()
  NM.Client = ANet:startClient("localhost", "Anon", 22121)
  if NM.Client then
    NM.Client.callbacks.connected = function(...)
      return NM.cmd["connected"](...)
    end
    NM.Client.callbacks.received = function(...)
      return NM.cmd["received"](...)
    end
    NM.Client.callbacks.disconnected = function(...)
      return NM.cmd["disconnected"](...)
    end
    NM.Client.callbacks.newUser = function(...)
      return NM.cmd["newUser"](...)
    end
  end
end
NM.update = function(dt)
  return ANet:update(dt)
end
return NM
