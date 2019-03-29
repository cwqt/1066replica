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
    end,
    move = function(self, tox, toy)
      local path, length = Map.findPath({
        self.x,
        self.y
      }, {
        tox,
        toy
      })
      if length <= self.range then
        if length > self.chargeDistance then
          print("Charge!")
        end
        if path then
          print("Moving " .. tostring(self.__class.__name) .. " from " .. tostring(inspect(path[1])) .. " to " .. tostring(inspect(path[#path])))
          for i = 1, #path do
            self.x, self.y = path[i][1], path[i][2]
            local xub = L.clamp(self.x + 1, 1, Map.width)
            local xlb = L.clamp(self.x - 1, 1, Map.width)
            for i = xlb, xub do
              local o = Map.current[self.y][i].object
              if o and o ~= self then
                if o.isPlayer ~= self.isPlayer and o.isPlayer ~= nil then
                  print("Enemy infront of curent position (" .. tostring(self.x) .. ", " .. tostring(self.y) .. ") at " .. tostring(o.x) .. ", " .. tostring(o.y) .. ", attacking!")
                  self:attack(o)
                  return 
                end
              end
            end
            if i == #path then
              return 
            end
            Map.moveObject({
              path[i][1],
              path[i][2]
            }, {
              path[i + 1][1],
              path[i + 1][2]
            })
          end
        end
      else
        return print("Path out of range: " .. tostring(length) .. " > " .. tostring(self.range))
      end
    end,
    attack = function(self, object)
      print("Attacking " .. tostring(object.__class.__name) .. " at " .. tostring(object.x) .. ", " .. tostring(object.y))
      local dmg = math.ceil((self.atk ^ 2) / (self.atk + object.def))
      print("Dealing " .. tostring(dmg) .. " damage")
      object.hp = object.hp - dmg
      print(tostring(object.__class.__name) .. " has " .. tostring(object.hp) .. "HP remaining")
      if object.hp <= 0 then
        return object:die()
      end
    end,
    die = function(self)
      print("Unit " .. tostring(self.__class.__name) .. " lost at " .. tostring(self.x) .. ", " .. tostring(self.y))
      return Map.removeObject(self.x, self.y)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.atk = 1
      self.def = 10
      self.mrl = 10
      self.hp = 10
      self.range = 5
      self.chargeDistance = 4
      self.charging = false
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
return Entity
