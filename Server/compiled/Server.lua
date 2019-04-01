local Server = { }
Server.functions = {
  [128] = function(msg, user)
    return print("testudo")
  end
}
Server.cmd = {
  ["received"] = function(command, msg, user)
    return Server.functions[command](msg, user)
  end,
  ["userFullyConnected"] = function(user)
    return Server.attemptMakeMatches()
  end,
  ["synchronize"] = function(user) end,
  ["customDataChanged"] = function(user, value, key, prevValue) end,
  ["disconnectedUser"] = function(user) end,
  ["authorize"] = function(user, authMsg) end
}
Server.load = function()
  Server.sv = ANet:startServer(2, 22121)
  Server.matches = { }
  if Server.sv then
    Server.sv.callbacks.received = function(...)
      return Server.cmd["received"](...)
    end
    Server.sv.callbacks.userFullyConnected = function(...)
      return Server.cmd["userFullyConnected"](...)
    end
    Server.sv.callbacks.synchronize = function(...)
      return Server.cmd["synchronize"](...)
    end
    Server.sv.callbacks.customDataChanged = function(...)
      return Server.cmd["customDataChanged"](...)
    end
    Server.sv.callbacks.disconnectedUser = function(...)
      return Server.cmd["disconnectedUser"](...)
    end
  end
end
Server.update = function(dt)
  return ANet:update(dt)
end
Server.getUnmatched = function()
  local c = 0
  for k, client in pairs(Server.sv:getUsers()) do
    if client.match then
      c = c + 1
    end
  end
  return (Server.sv:getNumUsers() - c)
end
Server.attemptMakeMatches = function()
  if Server.getUnmatched() >= 2 then
    print("Attempting to match " .. tostring(Server.getUnmatched()) .. " users")
    return Server.makeMatches()
  else
    return print(tostring(Server.getUnmatched()) .. " unmatched user(s)...")
  end
end
Server.makeMatches = function()
  if Server.getUnmatched() <= 1 then
    print("Not enough users left to make a game")
    return 
  end
  local p = Server.sv:getUsers()
  local x = { }
  for k, client in pairs(p) do
    local _continue_0 = false
    repeat
      if client.matched then
        _continue_0 = true
        break
      end
      x[#x + 1] = client
      client.matched = true
      if #x == 2 then
        x[1].match = x[2]
        x[2].match = x[1]
        print("Matched " .. tostring(x[1].connection:getsockname()) .. " with " .. tostring(x[2].connection:getsockname()))
        Server.sv:send(128, "yeet", client)
        break
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  print("Users remaining: " .. tostring(Server.getUnmatched()))
  return Server.makeMatches()
end
return Server
