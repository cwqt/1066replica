Server = {}

Server.start = () ->
  Server.matches = {}
  
  Server.LN = LN.new({type: LN.mode.server, ip:"82.18.185.11"})
  Server.LN\addOp('version')
  Server.LN\addProcessOnServer 'version', (peer, arg, storage) =>
    return '1.0'

  Server.LN\addOp('match')
  Server.LN\addProcessOnServer 'match', (peer, arg, storage) =>
    k = Server.LN\_getUserIndex(peer)
    print("Peer #{Server.LN\_getUserIndex(peer)} requesting their match: #{Server.matches[k]}")
    match = Server.matches[k]
    if match
      Server.matches[k] = nil
      Server.LN\_removeUser(peer)
      return match

  Server.timer = Timer()
  Server.LN\onAddUser( -> Server.timer\after(1, -> Server.attemptMatchUsers!))

Server.update = (dt) ->
  Server.LN\update(dt)
  Server.timer\update(dt)

Server.attemptMatchUsers = () ->
  if Server.getDelta() >= 2
    print("Attempting to match #{Server.getDelta()} users")
    Server.matchUsers()
  else
    print("#{Server.getDelta()} unmatched user(s)...")


Server.getDelta = () ->
  return M.size(Server.LN\getUsers()) - M.size(Server.matches)

Server.matchUsers = () ->
  if Server.getDelta() <= 1
    print "Not enough users left to make a game"
    return

  p = Server.LN\getUsers()
 
  -- Find a pair of unmatched clients
  x = {}
  for k,v in pairs(p)
    if v.matched then continue
    x[#x+1] = k
    v.matched = true
    if #x == 2
      break
  
  if #x == 2
    Server.matches[x[1]] = x[2]
    Server.matches[x[2]] = x[1]
    print("Matched #{inspect x}")
  
  print("Users remaining: #{Server.getDelta()}")
  Server.matchUsers()

return Server
