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
    log.debug("I received: #{inspect(data)} from #{user.connection\getsockname()}")
    d = data
    switch d.type
      when "PING"
        Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "PONG"
          payload: data.payload
        }))

  RECEIVED_DATA_FOR_PEER: (data, user) ->
    if user.match
      log.trace("Relay: #{user.connection\getsockname()} to #{user.match.connection\getsockname()} :: #{inspect data}")
      -- Exchange client-side serialised data
      Server.sv\send(OPCODES.S["SEND_DATA_TO_MATCH"], TSerial.pack({msg, user.match}))
    else
      log.warn("User has no match!")

  USER_FULLY_CONNECTED: (usr) ->
    Server.attemptMakeMatches()

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
  for k, client in pairs(Server.sv\getUsers())
    if client.match then c+=1
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

      log.info("Matched #{x[1].connection\getsockname()} with #{x[2].connection\getsockname()}")
      Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "ECHO",
          payload: "Got match: #{user.match.connection\getsockname()} #{user.playerName}"
        }), user )

      Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "ECHO",
          payload: "Got match: #{user.match.connection\getsockname()} #{user.match.playerName}"
        }), user.match )

      Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "SET_PLAYER_SIDE",
          payload: 1,
        }), user )

      Server.sv\send(OPCODES.S["SEND_DATA_TO_USER"], TSerial.pack({
          type: "SET_PLAYER_SIDE",
          payload: 2
        }), user.match )

      uuid = UUID()
      log.info("Created game: #{uuid}")
      Server.games[uuid] = {
        players: {
          x[1],
          x[2]
        }
      }

      break

  log.debug("Users remaining: #{Server.getUnmatched()}")
  if Server.getUnmatched() == 0
    log.info("Matched all users!")
    return
  --keep matching unmatched users
  Server.makeMatches()

Server.listGames = () ->
  for k,v in pairs(Server.games)
    print(k .. v)

return Server