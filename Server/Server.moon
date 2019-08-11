require("../libs/TSerial")

Server = {}
Server.games = {}

OPCODES = {
  R: {
    [128]: "RECEIVED_DATA_FOR_PEER",
    [129]: "RECEIVED_DATA_FOR_SERVER"    
  }
  S: {
    "SEND_DATA_TO_MATCH": 128, -- from peer to peer
    "SEND_DATA_TO_USER": 129 -- from server to user
  }
}

export UUID = () ->
  fn = (x) ->
    r = math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef")\sub(r, r)
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", fn))

Server.functions = {
  RECEIVED_DATA_FOR_SERVER: (data, user) ->
    log.debug("Received: #{inspect(data)} from #{user.connection\getsockname()}")
    d = data
    switch d.type
      when "REQUESTING_MATCH"
        user.match = nil
        Server.attemptMakeMatches()

      when "USER_UNITSELECT_OVER"
        user.stillSelectingUnits = data.payload
        if (user.stillSelectingUnits and user.match.stillSelectingUnits) == true
          Server.sv\send(OPCODES.S["SEND_DATA_TO_MATCH"], TSerial.pack({
            type: "REQUEST_PEER_COMMANDS",
            payload: nil
          }), user)
          Server.sv\send(OPCODES.S["SEND_DATA_TO_MATCH"], TSerial.pack({
            type: "REQUEST_PEER_COMMANDS",
            payload: nil
          }), user.match)

      when "USER_COMMANDING_OVER"
        user.isCommanding = data.payload
        if (user.isCommanding and user.match.isCommanding) == false
          Server.distribute("PLAYERS_FINISHED_COMMANDING", true, user)
        if (user.isCommanding and user.match.isCommanding) == true
          Server.distribute("PLAYER_START_COMMANDING", nil, user)


      when "PING"
        Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "PONG"
          payload: data.payload
        }))


  RECEIVED_DATA_FOR_PEER: (data, user) ->
    if user.match
      log.trace("Relay: #{user.connection\getsockname()} #{inspect data} to #{user.match.connection\getsockname()}")
      -- Exchange client-side serialised data
      Server.sv\send(OPCODES.S["SEND_DATA_TO_MATCH"], TSerial.pack(data), user.match)
    else
      log.warn("User has no match!")

  USER_FULLY_CONNECTED: (user) ->
    user.match = {}
    
  SYNCHRONIZE: (usr) ->
  CUSTOM_DATA_CHANGED: (usr, value, key, previousValue) ->
  DISCONNECTED_USER: (usr, msg) ->
}

Server.load = () ->
  Server.sv = ANet\startServer(2, 22121)
  if Server.sv
    Server.sv.callbacks.received           = (cmd, data, usr) -> Server.functions[OPCODES.R[cmd]](TSerial.unpack(data), usr)
    Server.sv.callbacks.userFullyConnected = (...)            -> Server.functions["USER_FULLY_CONNECTED"](...)
    Server.sv.callbacks.synchronize        = (...)            -> Server.functions["SYNCHRONIZE"](...)
    Server.sv.callbacks.customDataChanged  = (...)            -> Server.functions["CUSTOM_DATA_CHANGED"](...)
    Server.sv.callbacks.disconnectedUser   = (...)            -> Server.functions["DISCONNECTED_USER"](...)

Server.update = (dt) ->
  ANet\update(dt)

Server.getUnmatched = () ->
  c = 0
  for k, user in pairs(Server.sv\getUsers())
    if user.match then c +=1
  return (Server.sv\getNumUsers() - c)

Server.attemptMakeMatches = () ->
  if Server.getUnmatched() >= 2
    log.debug("Attempting to match #{Server.getUnmatched()} users")
    Server.makeMatches()
  else
    log.info("#{Server.getUnmatched()} unmatched user(s)...")

Server.makeMatches = () ->
  if Server.getUnmatched() <= 1
    log.error("Not enough users left to make a game")
    return

  -- x = game members
  x = {}
  for k, user in pairs(Server.sv\getUsers())
    -- don't consider them apart of the possible match pool
    if user.matched then continue
    -- add user to possible game
    x[#x+1] = user
    user.matched = true
    -- we have a match!
    if #x == 2
      --link the matches
      x[1].match = x[2]
      x[2].match = x[1]

      uuid = UUID()

      log.info("Matched #{x[1].connection\getsockname()} with #{x[2].connection\getsockname()}")
      Server.distribute("RECEIVE_MATCH", {
        {match_name: user.match.playerName, side: 1, gameUUID: uuid}
        {match_name: user.match.playerName, side: 2, gameUUID: uuid}
      }, user)

      log.info("Created game: #{uuid}")
      Server.games[uuid] = {
        players: {
          x[1],
          x[2]
        }
      }

      -- Allow reference back to game
      Server.games[uuid].players[1].gameUUID = uuid
      Server.games[uuid].players[2].gameUUID = uuid
      break

  log.debug("Users remaining: #{Server.getUnmatched()}")
  if Server.getUnmatched() == 0
    log.info("Matched all users!")
    return
  --keep matching unmatched users
  Server.makeMatches()

Server.distribute = (actionType, payload, user) ->
  if type(payload) != "table"
    payload = {payload, payload}

  Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
    type: actionType,
    payload: payload[1]
  }), user)
  Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
    type: actionType,
    payload: payload[2]
  }), user.match)

Server.listGames = () ->
  for k,v in pairs(Server.games)
    print(k .. v)

return Server