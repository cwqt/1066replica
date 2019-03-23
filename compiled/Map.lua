local Map = { }
Map.current = { }
Map.set = function(map)
  Map.current = map
end
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
  local grid = Grid(Map.getSimplePFMap(Map.current))
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
    return t
  end
end
Map.moveObject = function(start, finish)
  local fromx, fromy = start[1], start[2]
  local tox, toy = finish[1], finish[2]
  if Map.current[toy][tox].object then
    print("moveObject: Object exists at " .. tostring(tox) .. ", " .. tostring(toy))
    return 
  end
  local copy = M.clone(Map.current[fromy][fromx].object)
  Map.current[toy][tox].object = copy
  Map.current[fromy][fromx].object = nil
end
Map.objectFollowPath = function(path)
  os.execute("clear")
  Map.print(Map.current)
  os.execute("sleep 1")
  os.execute("clear")
  print(M.isTable(path))
  for i = 1, #path do
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
    Map.print(Map.current)
    os.execute("sleep 1")
    os.execute("clear")
  end
end
return Map
