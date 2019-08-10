NM = {}

-- received data
OPCODES = {
  R: {
    [128]: "RECEIVED_DATA_FROM_PEER"
    [129]: "RECEIVED_DATA_FROM_SERVER"
  }
  S: {
    "SEND_DATA_TO_PEER": 128,
    "SEND_DATA_TO_SERVER": 129
  }
}

NM.functions = {
  RECEIVED_DATA_FROM_SERVER: (data) ->
    log.trace("Reducer got: #{data.type}")
    switch data.type
      when "PONG"
        f = socket.gettime() - data.payload
        log.trace("ping RTT: " .. string.format("%.3f", f*1000) .. "ms")
      when "ECHO"
        log.info(data.payload)
      when "SET_PLAYER_SIDE"
        i = tonumber(data.payload)
        GAME.self = i
        GAME.opponent = i >= 2 and 1 or 2
        log.debug("self: #{GAME.self}, opponent: #{GAME.opponent}")

  RECEIVED_DATA_FROM_PEER: (data) ->
    d = data
    switch d.type
      when "RECEIVE_MY_COMMANDS"
        for _, action in pairs(d)
          Map.getObjAtPos(action.x, action.y).Reducer(action.type, action.payload)

  CONNECTED: () ->
    log.client("Connected to Server.")

  DISCONNECTED: () ->

  NEW_USER: (user) ->

  AUTHORIZED: (auth, reason) ->
}

NM.startClient = (ip) ->
  -- tcp on 0.0.0.0:22122
  NM.Client = ANet\startClient(ip, "Anon", 22121)
  if NM.Client
    NM.Client.callbacks.received           = (cmd, data) -> NM.functions[OPCODES.R[cmd]](TSerial.unpack(data))
    NM.Client.callbacks.connected          = (...)       -> NM.functions["CONNECTED"](...)
    NM.Client.callbacks.disconnected       = (...)       -> NM.functions["DISCONNECTED"](...)
    NM.Client.callbacks.newUser            = (...)       -> NM.functions["NEW_USER"](...)
    NM.Client.callbacks.authorized         = (...)       -> NM.functions["AUTHORIZED"](...)

NM.sendDataToPeer = (data) ->
  if NM.Client
    NM.Client\send(OPCODES.S["SEND_DATA_TO_PEER"], TSerial.pack(data))
  else
    log.error("Not connected.")

NM.sendDataToServer = (data) ->
  if NM.Client
    NM.Client\send(OPCODES.S["SEND_DATA_TO_SERVER"], TSerial.pack(data))
  else
    log.error("Not connected.")

NM.update = (dt) ->
  ANet\update(dt)

return NM
