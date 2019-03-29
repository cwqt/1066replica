io.stdout:setvbuf("no")
M = require("../libs/moses")
L = require("../libs/lume")
inspect = require("../libs/inspect")
lb = require("../libs/lovebird")
Gamestate = require("../libs/gamestate")
Timer = require("../libs/timer")
LN = require("../libs/lovernet")
sock = require("../libs/sock")
Map = require("modules.Map")
RM = require("modules.RoundManager")
Client = require("modules.Client")
Player = require("components.Player")
Entity = require("components.Entity")
GAME = require("GAME")
M.deepClone = function(obj)
  if type(obj) ~= 'table' then
    return obj
  end
  local res = setmetatable({ }, getmetatable(obj))
  for k, v in pairs(obj) do
    res[M.deepClone(k)] = M.deepClone(v)
  end
  return res
end
love.load = function()
  return Client.start()
end
love.update = function(dt)
  return Client.update(dt)
end
love.draw = function()
  return love.graphics.print("hello", 10, 10)
end
love.keypressed = function(key)
  local _exp_0 = key
  if "w" == _exp_0 then
    return Map.moveObject({
      1,
      3
    }, {
      1,
      4
    })
  end
end
love.errhand = function(msg)
  print("\n\nERR: " .. string.rep("=", 30))
  print(msg)
  print(string.rep("=", 35) .. "\n")
  return love.event.quit()
end
