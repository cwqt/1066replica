P2P = {}
P2P.cmd = {
  Server: {
    ["received"]: (command, msg, user) ->
      NM.log("p2p_server", {command, message, user})

    ["userFullyConnected"]: (user) ->
--      NM.log("p2p_server", "#{inspect(user)}")
    
    ["synchronize"]: (user) ->
      NM.log("p2p_server", "Synched user: #{user.playerName}")

    ["customDataChanged"]: (user, value, key, prevValue) ->
    
    ["disconnectedUser"]: (user) ->

    ["authorize"]: (user, authMsg) ->
  }

  Client: {
    ["connected"]: () ->
      NM.log('p2p_client', "Connected to Server")

    ["received"]: (command, msg) ->
   
    ["disconnected"]: () ->
    
    ["newUser"]: (user) ->
      NM.log("p2p_client", "Peer connect: #{user.playerName}")

    ["authorized"]: (auth, reason) ->
  }
}

P2P.start = (peerIP) ->
--  P2P.Server = ANet\startServer(10, 22121)

  if P2P.Server
    P2P.Server.callbacks.received           = (...) -> P2P.cmd.Server["received"](...)
    P2P.Server.callbacks.userFullyConnected = (...) -> P2P.cmd.Server["userFullyConnected"](...)
    P2P.Server.callbacks.synchronize        = (...) -> P2P.cmd.Server["synchronize"](...)
    P2P.Server.callbacks.customDataChanged  = (...) -> P2P.cmd.Server["customDataChanged"](...)
    P2P.Server.callbacks.disconnectedUser   = (...) -> P2P.cmd.Server["disconnectedUser"](...)
    --P2P.Server.callbacks.authorize          = (...) -> P2P.cmd.Server[""](...)

  if P2P.Client
    P2P.Client.callbacks.connected          = (...) -> P2P.cmd.Client["connected"](...)
    P2P.Client.callbacks.received           = (...) -> P2P.cmd.Client["received"](...)
    P2P.Client.callbacks.disconnected       = (...) -> P2P.cmd.Client["disconnected"](...)
    P2P.Client.callbacks.newUser            = (...) -> P2P.cmd.Client["newUser"](...)
    --P2P.Client.callbacks.authorized         = (...) -> P2P.cmd.Client[""](...)

P2P.update = (dt) ->
  if P2P.Server
    P2P.Server\update(dt)
  if P2P.Client
    P2P.Client\update(dt)

P2P.sendDataToPeer = (data) ->
  P2P.Client\send(unpack(data))

P2P.Disconnect = () ->

return P2P

