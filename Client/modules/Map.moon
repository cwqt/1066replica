Map = {}
Map.current = {}

Map.set = (map) ->
  Map.current = map

Map.generate = (width, height) ->
  t = {}
  Map.height = height
  Map.width  = width
  for y=1, height do
    t[y] = {}
    for x=1, width do
      t[y][x] = {}
  return t

Map.addObject = (x, y, obj) ->
  if Map.current[y][x].object == nil
    Map.current[y][x].object = obj
    obj.x, obj.y = x, y
    log.info("Inserted #{obj.__class.__name}(#{obj.player}) at #{x}, #{y}")
  else
    log.error("Object already exists at #{x}, #{y}")

Map.print = (map) ->
  yl = "  "
  -- We can assume it's a square map
  for i=1, #Map.current[1] do yl = yl..i.." "
  print(yl)
  ys = string.rep("+-", #map[1]) .. "+"
  for y=1, #map do
    xs = ""
    for x=1, #map[y] do
      icon = " "
      if map[y][x].object
        icon = map[y][x].object.icon
      xs = xs.."|"..icon
    xs = xs .. "|"
    print(" "..ys.."\n"..y..xs)
  print(" "..ys)

Map.getSimplePFMap = (map) ->
  tt = M.clone(map)
  for y=1, #tt do
    for x=1, #tt[y] do
      if tt[y][x].object != nil
        tt[y][x] = 1
      else
        tt[y][x]= 0
  return tt

--Map.update = (dt) ->
  
Grid = require("../libs/jumper.grid")
Pathfinder = require("../libs/jumper.pathfinder")

Map.findPath = (a, b) ->
  pathFinderMap = Map.getSimplePFMap(Map.current)
  -- Allow movement from start position (e.g. if object at start)
  pathFinderMap[a[2]][a[1]] = 0
  
  grid = Grid(pathFinderMap)
  myFinder = Pathfinder(grid, 'JPS', 0)
  myFinder\setMode("ORTHOGONAL")
  startx, starty = unpack(a)
  endx, endy = unpack(b)
  path, length = myFinder\getPath(startx, starty, endx, endy)
  
  if path then
    path\filter()
    log.debug(('Path found! Length: %.2f')\format(length))
    for node, count in path\iter() do
      log.debug(('x: %d, y: %d')\format(node.x, node.y))
    
    t = {}
    path\fill()
    for node, _ in path\iter() do
      t[#t+1] = {node.x, node.y}
    return t, length
  else
    log.error("No path found!")
    return nil

Map.updateObjectPos = (object, newx, newy) ->
  object.x = newx
  object.y = newy

Map.copyObject = (x, y) ->
  k = Map.current[y][x].object
  c = M.deepClone(k)
  return c

Map.moveObject = (start, finish) ->
  fromx, fromy = start[1], start[2]
  tox, toy = finish[1], finish[2]
  
  if Map.current[toy][tox].object
    log.error("moveObject: Object exists at #{tox}, #{toy}")
    return false
  
  copy = Map.copyObject(fromx, fromy)
  Map.current[toy][tox].object = copy
  Map.updateObjectPos(copy, tox, toy)
  Map.current[fromy][fromx].object = nil
  log.debug("Moved #{Map.current[toy][tox].object.__class.__name} from #{inspect start} to #{inspect finish}")
  return true

Map.getDirection = (path) ->
  --     |0,-1|
  -- ----+----+---
  -- -1,0|0,0 |1,0
  -- ----+----+---            
  --     |0, 1|
  --path = {current, next}
  --path = {{1,1}, {1,2}}
  sx, sy = path[1][1], path[1][2]
  ex, ey = path[2][1], path[2][2]
  dx = ex - sx
  dy = ey - sy
  return {dx, dy}

Map.deleteStack = {}
Map.removeObject = (x, y) ->
  table.insert(Map.deleteStack, {x:x, y:y})

Map.removeObjects = () ->
  if #Map.deleteStack >= 1
    for obj in *Map.deleteStack
      log.debug("Removed object #{obj.__class.__name}")
      Map.current[obj.y][obj.x].object = nil


class Map.Object
  new: (@icon="█") =>
  update: (dt) =>
  draw: () =>

return Map
