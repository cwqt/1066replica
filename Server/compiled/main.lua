Timer = require("../libs/timer")
ANet = require("../libs/Affair/network")
M = require("../libs/moses")
inspect = require("../libs/inspect")
Server = require("Server")
GAME = { }
GAME.START_TIME = love.timer.getTime()
NM = { }
NM.log = function(tag, msg)
  if type(msg) == "table" then
    local m = ""
    for k, v in pairs(msg) do
      m = m .. " " .. tostring(v)
    end
    msg = m
  end
  local t = love.timer.getTime() - GAME.START_TIME
  t = tostring(t * 1000):sub(1, 6)
  return print(tostring(t) .. " [" .. tostring(string.upper(tag)) .. "]: " .. tostring(msg))
end
love.load = function()
  timer = Timer()
  return Server.load()
end
love.update = function(dt)
  Server.update(dt)
  return timer:update(dt)
end
