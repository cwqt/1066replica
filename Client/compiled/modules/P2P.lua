local P2P = { }
P2P.cmd = {
  Server = {
    ["received"] = function(command, msg, user) end,
    ["userFullyConnected"] = function(user)
      return NM.log("p2p_server", tostring(inspect(user)))
    end,
    ["synchronize"] = function(user)
      return NM.log("p2p_server", "Synched user: " .. tostring(user.playerName))
    end,
    ["customDataChanged"] = function(user, value, key, prevValue) end,
    ["disconnectedUser"] = function(user) end,
    ["authorize"] = function(user, authMsg) end
  },
  Client = {
    ["connected"] = function()
      return NM.log('p2p_client', "Connected to Server")
    end,
    ["received"] = function(command, msg) end,
    ["disconnected"] = function() end,
    ["newUser"] = function(user)
      return NM.log("p2p_client", "Peer connect: " .. tostring(user.playerName))
    end,
    ["authorized"] = function(auth, reason) end
  }
}
P2P.start = function(peerIP)
  P2P.Server = ANet:startServer(10, 22121)
  if P2P.Server then
    P2P.Server.callbacks.received = function(...)
      return P2P.cmd.Server["received"](...)
    end
    P2P.Server.callbacks.userFullyConnected = function(...)
      return P2P.cmd.Server["userFullyConnected"](...)
    end
    P2P.Server.callbacks.synchronize = function(...)
      return P2P.cmd.Server["synchronize"](...)
    end
    P2P.Server.callbacks.customDataChanged = function(...)
      return P2P.cmd.Server["customDataChanged"](...)
    end
    P2P.Server.callbacks.disconnectedUser = function(...)
      return P2P.cmd.Server["disconnectedUser"](...)
    end
  end
  if P2P.Client then
    P2P.Client.callbacks.connected = function(...)
      return P2P.cmd.Client["connected"](...)
    end
    P2P.Client.callbacks.received = function(...)
      return P2P.cmd.Client["received"](...)
    end
    P2P.Client.callbacks.disconnected = function(...)
      return P2P.cmd.Client["disconnected"](...)
    end
    P2P.Client.callbacks.newUser = function(...)
      return P2P.cmd.Client["newUser"](...)
    end
  end
end
P2P.update = function(dt)
  if P2P.Server then
    P2P.Server:update(dt)
  end
  if P2P.Client then
    return P2P.Client:update(dt)
  end
end
P2P.sendDataToPeer = function(data)
  return P2P.Client:send(unpack(data))
end
P2P.Disconnect = function() end
return P2P
