Client = {}

Client.start = () ->
  Client.LN = LN.new({type: LN.mode.client, ip:"178.62.42.106"})
  Client.LN\addOp('version')
  Client.LN\pushData('version')

  Client.LN\addOp('match')

  Client.timer = Timer()
  Client.timer\every(
    1,
    -> Client.requestMatch(),
    "match")

  Client.gotMatch = false
  
Client.requestMatch = () ->
  Client.LN\pushData('match')

Client.update = (dt) ->
  if Client.LN\getCache('version') then
    assert( Client.LN\getCache('version') == '1.0', 'Version Mismatch!' )

  if Client.LN\getCache('match') and not Client.gotMatch
    Client.gotMatch = true
    Client.timer\cancel("match")
    print("#{Client.LN\getPort()} connecting to #{Client.LN\getCache('match')}")

  Client.LN\update(dt)
  Client.timer\update(dt)

Client.stop = () ->
  print "Leaving network..."
  Client.LN\disconnect()

return Client
