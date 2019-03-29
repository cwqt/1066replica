local Server = { }
Server.start = function()
  Server.matches = { }
  Server.LN = LN.new({
    type = LN.mode.server,
    ip = "82.18.185.11"
  })
  Server.LN:addOp('version')
  Server.LN:addProcessOnServer('version', function(self, peer, arg, storage)
    return '1.0'
  end)
  Server.LN:addOp('match')
  Server.LN:addProcessOnServer('match', function(self, peer, arg, storage)
    local k = Server.LN:_getUserIndex(peer)
    print("Peer " .. tostring(Server.LN:_getUserIndex(peer)) .. " requesting their match: " .. tostring(Server.matches[k]))
    local match = Server.matches[k]
    if match then
      Server.matches[k] = nil
      Server.LN:_removeUser(peer)
      return match
    end
  end)
  Server.timer = Timer()
  return Server.LN:onAddUser(function()
    return Server.timer:after(1, function()
      return Server.attemptMatchUsers()
    end)
  end)
end
Server.update = function(dt)
  Server.LN:update(dt)
  return Server.timer:update(dt)
end
Server.attemptMatchUsers = function()
  if Server.getDelta() >= 2 then
    print("Attempting to match " .. tostring(Server.getDelta()) .. " users")
    return Server.matchUsers()
  else
    return print(tostring(Server.getDelta()) .. " unmatched user(s)...")
  end
end
Server.getDelta = function()
  return M.size(Server.LN:getUsers()) - M.size(Server.matches)
end
Server.matchUsers = function()
  if Server.getDelta() <= 1 then
    print("Not enough users left to make a game")
    return 
  end
  local p = Server.LN:getUsers()
  local x = { }
  for k, v in pairs(p) do
    local _continue_0 = false
    repeat
      if v.matched then
        _continue_0 = true
        break
      end
      x[#x + 1] = k
      v.matched = true
      if #x == 2 then
        break
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  if #x == 2 then
    Server.matches[x[1]] = x[2]
    Server.matches[x[2]] = x[1]
    print("Matched " .. tostring(inspect(x)))
  end
  print("Users remaining: " .. tostring(Server.getDelta()))
  return Server.matchUsers()
end
return Server
