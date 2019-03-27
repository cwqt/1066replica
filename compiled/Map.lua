local Map = { }
Map.current = { }
Map.set = function(map)
  Map.current = map
end
Map.generate = function(height, width)
  local t = { }
  Map.height = height
  Map.width = width
  for y = 1, height do
    t[y] = { }
    for x = 1, width do
      t[y][x] = { }
    end
  end
  return t
end
Map.addObject = function(x, y, obj)
  if Map.current[y][x].object == nil then
    Map.current[y][x].object = obj
    obj.x, obj.y = x, y
    return print("Inserted " .. tostring(obj.__class.__name) .. " at " .. tostring(x) .. ", " .. tostring(y))
  else
    return print("Object already exists at " .. tostring(x) .. ", " .. tostring(y))
  end
end
Map.print = function(map)
  local yl = "  "
  for i = 1, #Map.current[1] do
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
local Grid = require("../libs/jumper.grid")
local Pathfinder = require("../libs/jumper.pathfinder")
Map.findPath = function(a, b)
  local pathFinderMap = Map.getSimplePFMap(Map.current)
  pathFinderMap[a[2]][a[1]] = 0
  local grid = Grid(pathFinderMap)
  local myFinder = Pathfinder(grid, 'JPS', 0)
  myFinder:setMode("ORTHOGONAL")
  local startx, starty = unpack(a)
  local endx, endy = unpack(b)
  local path, length = myFinder:getPath(startx, starty, endx, endy)
  if path then
    path:filter()
    print(('Path found! Length: %.2f'):format(length))
    for node, count in path:iter() do
      print(('x: %d, y: %d'):format(node.x, node.y))
    end
    local t = { }
    path:fill()
    for node, _ in path:iter() do
      t[#t + 1] = {
        node.x,
        node.y
      }
    end
    return t, length
  else
    print("No path found")
    return nil
  end
end
Map.updateObjectPos = function(object, newx, newy)
  object.x = newx
  object.y = newy
end
Map.moveObject = function(start, finish)
  local fromx, fromy = start[1], start[2]
  local tox, toy = finish[1], finish[2]
  if Map.current[toy][tox].object then
    print("moveObject: Object exists at " .. tostring(tox) .. ", " .. tostring(toy))
    return 
  end
  local copy = copy2(Map.current[fromy][fromx].object)
  Map.current[toy][tox].object = copy
  Map.updateObjectPos(copy, tox, toy)
  Map.current[fromy][fromx].object = nil
end
Map.getDirection = function(path)
  local sx, sy = path[1][1], path[1][2]
  local ex, ey = path[2][1], path[2][2]
  local dx = ex - sx
  local dy = ey - sy
  return {
    dx,
    dy
  }
end
Map.deleteStack = { }
Map.removeObject = function(x, y)
  return table.insert(Map.deleteStack, {
    x = x,
    y = y
  })
end
Map.removeObjects = function()
  if #Map.deleteStack >= 1 then
    local _list_0 = Map.deleteStack
    for _index_0 = 1, #_list_0 do
      local obj = _list_0[_index_0]
      print("Removed object " .. tostring(obj))
      Map.current[obj.y][obj.x].object = nil
    end
  end
end
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
return Map
