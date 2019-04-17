NM = {}

NM.functions = {
  -- print
  [128]: (msg) ->log.trace(msg)

  -- recieve data from peer
  [129]: (msg) ->
    x = TSerial.unpack(msg)
    log.trace("Server relayed: #{inspect x}")
    -- {Peer command, data}
    -- {200, {1,2,3,4}}
    NM.functions[x[1]](x[2])

  -- Set what player I am
  [130]: (msg) ->
    msg = tonumber(msg)
    GAME.self = msg
    GAME.opponent = msg>=2 and 1 or 2
    log.debug("self: #{GAME.self}, opponent: #{GAME.opponent}")

  [131]: () ->
    log.error("Peer lost.")
    NM.Client\close()

  -- Peer commands >200
  -- Set peer ready
  [200]: () ->
    UnitSelect.peerReady = true
    log.debug("peerReady: #{UnitSelect.peerReady}")
  [201]: () ->
  [202]: () ->
}

NM.cmd = {
    ["received"]: (command, msg) ->
      log.client("NM.cmd::RECEIVED: #{command}")
      NM.functions[command](msg)

    ["connected"]: () ->
      log.client("NM.cmd::CONNECTED")

    ["disconnected"]: () ->
    ["newUser"]: (user) ->
    ["authorized"]: (auth, reason) ->
}

NM.startClient = (ip) ->
  -- tcp on 0.0.0.0:22122
  NM.Client = ANet\startClient(ip, "Anon", 22121)
  if NM.Client
    NM.Client.callbacks.connected          = (...) -> NM.cmd["connected"](...)
    NM.Client.callbacks.received           = (...) -> NM.cmd["received"](...)
    NM.Client.callbacks.disconnected       = (...) -> NM.cmd["disconnected"](...)
    NM.Client.callbacks.newUser            = (...) -> NM.cmd["newUser"](...)
    --NM.Client.callbacks.authorized         = (...) -> NM.cmd[""](...)

NM.sendDataToPeer = (data) ->
  if NM.Client
    NM.Client\send(128, TSerial.pack(data))
  else
    log.error("Not connected.")

NM.sendDataToServer = (data) ->
  if NM.Client
    NM.Client\send(129, data)
  else
    log.error("Not connected.")

NM.update = (dt) ->
  ANet\update(dt)


return NM
