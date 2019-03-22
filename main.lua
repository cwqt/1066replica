require("moonscript")
local M = require("moses")
local inspect = require("inspect")
local Map = { }
Map.generate = function(length, width)
  local t = { }
  for y = 1, length do
    t[y] = { }
    for x = 1, width do
      t[y][x] = { }
    end
  end
  return t
end
local t = Map.generate(5, 10)
Map.print = function(map)
  local yl = "  "
  for i = 1, 10 do
    yl = yl .. i .. " "
  end
  print(yl)
  local ys = string.rep("+-", #map[1]) .. "+"
  for y = 1, #map do
    local xs = ""
    for x = 1, #map[y] do
      local icon = " "
      if map[y][x].object then
        icon = map[y][x].object.icon
      end
      xs = xs .. "|" .. icon
    end
    xs = xs .. "|"
    print(" " .. ys .. "\n" .. y .. xs)
  end
  return print(" " .. ys)
end
do
  local _class_0
  local _base_0 = { }
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
for i = 1, 6 do
  t[3][i].object = Map.Object()
end
for i = 2, 4 do
  t[i][7].object = Map.Object()
end
Map.print(t)
Map.getSimplePFMap = function(map)
  local tt = M.clone(map)
  for y = 1, #tt do
    for x = 1, #tt[y] do
      if tt[y][x].object ~= nil then
        tt[y][x] = 1
      else
        tt[y][x] = 0
      end
    end
  end
  return tt
end
local Grid = require("jumper.grid")
local Pathfinder = require("jumper.pathfinder")
Map.findPath = function(a, b)
  local grid = Grid(Map.getSimplePFMap(t))
  local myFinder = Pathfinder(grid, 'JPS', 0)
  myFinder:setMode("ORTHOGONAL")
  local startx, starty = a[1], a[2]
  local endx, endy = b[1], b[2]
  local path, length = myFinder:getPath(startx, starty, endx, endy)
  if path then
    path:filter()
    print(('Path found! Length: %.2f'):format(length))
    for node, count in path:iter() do
      print(('x: %d, y: %d'):format(node.x, node.y))
    end
  end
end
return Map.findPath({
  1,
  4
}, {
  1,
  2
})
