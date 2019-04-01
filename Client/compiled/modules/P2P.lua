local P2P = { }
P2P.cmd = {
  Server = {
    ["received"] = function(command, msg, user)
      return NM.log("p2p_server", {
        command,
        message,
        user
      })
    end,
    ["userFullyConnected"] = function(user) end,
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
end
P2P.Disconnect = function() end
return P2P
