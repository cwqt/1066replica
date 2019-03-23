M = require("../libs/moses")
inspect = require("../libs/inspect")
lovebird = require("../libs/lovebird")
io.stdout:setvbuf("no")
Map = require("Map")
Map.set(Map.generate(5, 10))
do
  local _class_0
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, icon)
      if icon == nil then
        icon = "█"
      end
      self.icon = icon
    end,
    __base = _base_0,
    __name = "Object"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Map.Object = _class_0
end
love.load = function()
  for i = 1, 6 do
    Map.current[3][i].object = Map.Object()
  end
  for i = 2, 4 do
    Map.current[i][7].object = Map.Object()
  end
  Map.print(Map.current)
  local z = Map.findPath({
    1,
    3
  }, {
    8,
    3
  })
  return Map.objectFollowPath(z)
end
love.update = function(dt)
  return lovebird.update()
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
