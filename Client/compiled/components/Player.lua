local Player
do
  local _class_0
  local _base_0 = {
    addUnit = function(self, x, y, object)
      object.isPlayer = self.player
      return Map.addObject(x, y, object)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.moral = 100
      self.player = #GAME.PLAYERS + 1
      print("Created new Player " .. tostring(self.player))
      return table.insert(GAME.PLAYERS, self.__class)
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
end
return Player
