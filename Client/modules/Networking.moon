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



return NM
