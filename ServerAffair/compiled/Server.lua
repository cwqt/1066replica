local Server = { }
Server.cmd = {
  ["received"] = function(command, msg, user) end,
  ["userFullyConnected"] = function(user) end,
  ["synchronize"] = function(user) end,
  ["customDataChanged"] = function(user, value, key, prevValue) end,
  ["disconnectedUser"] = function(user) end,
  ["authorize"] = function(user, authMsg) end
}
Server.load = function()
  Server.sv = ANet:startServer(2, 22121)
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
Server.makeMatches = function() end
return Server
