M = require("../libs/moses")
inspect = require("../libs/inspect")
lb = require("../libs/lovebird")
io.stdout:setvbuf("no")
Map = require("Map")
RM = require("RoundManager")
Player = require("Player")
Entity = require("Entity")
GAME = require("GAME")
love.load = function()
  Map.set(Map.generate(4, 10))
  for i = 1, 6 do
    Map.current[3][i].object = Map.Object()
  end
  for i = 2, 4 do
    Map.current[i][7].object = Map.Object()
  end
  local a = Player()
  local b = Player()
  b:addUnit(8, 1, (function()
    do
      local _with_0 = Entity("x")
      _with_0.def = 5
      return _with_0
    end
  end)())
  a:addUnit(1, 1, (function()
    do
      local _with_0 = Entity("i")
      _with_0.range = 10
      return _with_0
    end
  end)())
  RM.pushCmd(1, function()
    return Map.objectFollowPath(Map.findPath({
      1,
      1
    }, {
      7,
      1
    }))
  end)
  RM.executeCommands()
  return Map.print(Map.current)
end
love.update = function(dt)
  return lb.update()
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
  return love.event.quit()
end
