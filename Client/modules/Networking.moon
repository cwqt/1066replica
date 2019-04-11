NM = {}

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
  -- print
  [128]: (msg) -> log.trace(msg)

  -- recieve data from peer
  [129]: (msg, user) ->
    log.trace("Server relayed: #{msg} from #{inspect user}")

  [131]: () ->
    log.error("Peer lost.")
    NM.Client\close()
}

NM.cmd = {
    ["received"]: (command, msg) ->
      log.client("NM.cmd::RECEIVED: #{command}")
      NM.functions[command](msg, user)

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
    NM.Client\send(128, data)
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
