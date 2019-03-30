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
      handle = io.popen("hostname -I | awk '{print $2}'")
      ip = handle\read("*a")
      handle\close()
    when "OS X"
      handle = io.popen("ifconfig  | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '192([0-9]*\\.){3}[0-9]*'")
      ip = handle\read("*a")
      handle\close()
  return ip

return NM
