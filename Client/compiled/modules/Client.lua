local Client = { }
Client.start = function()
  Client.LN = LN.new({
    type = LN.mode.client,
    ip = "178.62.42.106"
  })
  Client.LN:addOp('version')
  Client.LN:pushData('version')
  Client.LN:addOp('match')
  Client.timer = Timer()
  Client.timer:every(1, function()
    return Client.requestMatch()
  end, "match")
  Client.gotMatch = false
end
Client.requestMatch = function()
  return Client.LN:pushData('match')
end
Client.update = function(dt)
  if Client.LN:getCache('version') then
    assert(Client.LN:getCache('version') == '1.0', 'Version Mismatch!')
  end
  if Client.LN:getCache('match') and not Client.gotMatch then
    Client.gotMatch = true
    Client.timer:cancel("match")
    print(tostring(Client.LN:getPort()) .. " connecting to " .. tostring(Client.LN:getCache('match')))
  end
  Client.LN:update(dt)
  return Client.timer:update(dt)
end
Client.stop = function()
  print("Leaving network...")
  return Client.LN:disconnect()
end
return Client
