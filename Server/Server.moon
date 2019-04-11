Server = {}

Server.functions = {
  -- exchange data with peer
  [128]: (msg, user) ->
    if user.match
      log.trace("Relaying data from: #{user.connection\getsockname()} to #{user.match.connection\getsockname()} :: #{msg}")
      Server.sv\send(129, msg, user.match)
    else
      log.debug("User has no match!")

  -- Server receive data
  [129]: (msg, user) ->
    log.debug("I received: #{msg}")
}


Server.cmd = {
  ["received"]: (command, msg, user) ->
    Server.functions[command](msg, user)

  ["userFullyConnected"]: (user) ->
    Server.attemptMakeMatches()

  ["synchronize"]:        (user) ->
  ["customDataChanged"]:  (user, value, key, prevValue) ->
  ["disconnectedUser"]:   (user) ->
    if user.match
      Server.sv\send(131, "", user.match)
      user.match.matched = false
      user.match.match = nil

  ["authorize"]:          (user, authMsg) ->
}

Server.load = () ->
  Server.sv = ANet\startServer(2, 22121)
  Server.matches = {}
  if Server.sv
    Server.sv.callbacks.received           = (...) -> Server.cmd["received"](...)
    Server.sv.callbacks.userFullyConnected = (...) -> Server.cmd["userFullyConnected"](...)
    Server.sv.callbacks.synchronize        = (...) -> Server.cmd["synchronize"](...)
    Server.sv.callbacks.customDataChanged  = (...) -> Server.cmd["customDataChanged"](...)
    Server.sv.callbacks.disconnectedUser   = (...) -> Server.cmd["disconnectedUser"](...)

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

  p = Server.sv\getUsers()
  x = {}
  for k, client in pairs(p)
    if client.matched then continue
    x[#x+1] = client
    client.matched = true
    if #x == 2
      x[1].match = x[2]
      x[2].match = x[1]
      log.info("Matched #{x[1].connection\getsockname()} with #{x[2].connection\getsockname()}")
      Server.sv\send(128, "Got match: #{client.match.connection\getsockname()}", client)
      Server.sv\send(128, "Got match: #{client.connection\getsockname()}",       client.match)
      break

  log.debug("Users remaining: #{Server.getUnmatched()}")
  if Server.getUnmatched() == 0
    log.info("Matched all users!")
    return
  Server.makeMatches()



return Server