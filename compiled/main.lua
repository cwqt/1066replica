M = require("../libs/moses")
inspect = require("../libs/inspect")
io.stdout:setvbuf("no")
Map = require("Map")
RM = require("RoundManager")
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
local Entity
do
  local _class_0
  local _parent_0 = Map.Object
  local _base_0 = {
    update = function(self, dt)
      return _class_0.__parent.draw(self)
    end,
    draw = function(self)
      return _class_0.__parent.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, hp, ...)
      if hp == nil then
        hp = 10
      end
      self.hp = hp
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Entity",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Entity = _class_0
end
love.load = function()
  for i = 1, 6 do
    Map.current[3][i].object = Map.Object()
  end
  for i = 2, 4 do
    Map.current[i][7].object = Map.Object()
  end
  local z = Map.findPath({
    1,
    3
  }, {
    10,
    3
  })
  Map.objectFollowPath(z)
  local x = Entity(3, "o")
  Map.current[5][8].object = x
  Map.print(Map.current)
  RM.pushCmd(1, function()
    return Map.objectFollowPath(Map.findPath({
      8,
      5
    }, {
      8,
      1
    }))
  end)
  RM.pushCmd(1, function()
    return print("hello1")
  end)
  return RM.executeCommands()
end
love.update = function(dt) end
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
