NM = {}

NM.log = (tag, msg) ->
  if type(msg) == "table"
    m = ""
    for k,v in pairs(msg) do
      m = m .. " " .. tostring(v)
    msg = m

  t = love.timer.getTime()-GAME.START_TIME
  t = tostring(t * 1000)\sub(1, 6)
  print("#{t} [#{string.upper tag}]: #{msg}")

NM.getLocalIP = () ->
  ip = ""
  switch love.system.getOS()
    when "Linux"
      handle = io.popen("hostname -I | awk '{print $2}' | tr -d '\\n'")
      ip = handle\read("*a")
      handle\close()
    when "OS X"
      handle = io.popen("ifconfig  | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '192([0-9]*\\.){3}[0-9]*' | tr -d '\\n'")
      ip = handle\read("*a")
      handle\close()
  return ip




NM.functions = {
  -- send data to peer
  [128]: (msg) ->
    print("Sending to peer: #{msg}")

  -- recieve data from server
  [129]: (msg) ->
    print("Server sent: #{msg}")

}

NM.cmd = {
    ["received"]: (command, msg) ->
      Server.functions[command](msg, user)

    ["connected"]: () ->
      NM.log('client', "Connected to Server")
      NM.Client\send(128, "hello")

    ["disconnected"]: () ->

    ["newUser"]: (user) ->

    ["authorized"]: (auth, reason) ->
}

NM.startClient = () ->
  -- tcp on 0.0.0.0:22122
  NM.Client = ANet\startClient("localhost", "Anon", 22121)
  if NM.Client
    NM.Client.callbacks.connected          = (...) -> NM.cmd["connected"](...)
    NM.Client.callbacks.received           = (...) -> NM.cmd["received"](...)
    NM.Client.callbacks.disconnected       = (...) -> NM.cmd["disconnected"](...)
    NM.Client.callbacks.newUser            = (...) -> NM.cmd["newUser"](...)
    --NM.Client.callbacks.authorized         = (...) -> NM.cmd[""](...)

NM.sendDataToPeer = (data) ->
  NM.Client\send(128, data)

NM.sendDataToServer = (data) ->
  NM.Client\send(129, data)























NM.update = (dt) ->
  ANet\update(dt)


return NM
