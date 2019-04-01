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

NM.cmd = {
    ["connected"]: () ->
      NM.log('client', "Connected to Server")
      NM.Client\send(128, "hello")

    ["received"]: (command, msg) ->
      NM.log('client', msg)

    ["disconnected"]: () ->

    ["newUser"]: (user) ->
      NM.log("client", "Peer connect: #{user.playerName}")

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



NM.update = (dt) ->
  ANet\update(dt)


return NM
