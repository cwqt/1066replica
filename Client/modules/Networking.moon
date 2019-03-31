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


--Matchmaking
NM.MMClient = () ->
  -- tcp on 0.0.0.0:22122
  -- connect to master server
  c = ANet\startClient("localhost", 22121)




-- Holepunch
socket = require("socket")

NM.holePunch = () ->
  Socks = {}
  Socks.Listen = socket.tcp()

  for k, sock in pairs(Socks)
    sock\setoption("reuseaddr", true)

  for k, sock in pairs(Socks)
    sock\bind("0.0.0.0", 22122)

  Socks.Listen\listen()
  NM.log("listen", "Listening on #{Socks.Listen\getsockname()}")

  Socks.Server\connect("178.62.42.106", 22121)





--P2P

return NM
