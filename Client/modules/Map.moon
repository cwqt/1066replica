Grid        = require("../libs/jumper.grid")
Pathfinder  = require("../libs/jumper.pathfinder")

Map = {}
Map.current = {}
Map.deleteStack = {}

Map.Object = require("../components/Object")

Map.generate = (width, height) ->
  t = {}
  t.height = height
  t.width  = width
  for y=1, height do
    t[y] = {}
    for x=1, width do
      t[y][x] = {}
  log.info("Generated map #{width}:#{height}")
  return t

Map.set = (map) ->
  Map.height  = map.height
  Map.width   = map.width
  Map.current = map
  log.info("Set map #{map}")

Map.addObject = (x, y, obj) ->
  if Map.current[y][x].object == nil
    Map.current[y][x].object = obj
    obj.x, obj.y = x, y
    log.info("Inserted #{obj.__class.__name}(#{obj.player}) at #{x}, #{y}")
  else
    log.error("Object already exists at #{x}, #{y}")

Map.getObjAtPos = (x, y) ->
  return Map.current[y][x].object

Map.copyObject = (x, y) ->
  return M.deepClone(Map.getObjAtPos(x, y))

Map.moveObject = (sx, sy, ex, ey) ->
  if Map.current[ey][ex].object
    log.error("moveObject: Object exists at #{ex}, #{ey}")
    return false
  
  copy = Map.copyObject(sx, sy)
  Map.current[ey][ex].object = copy
  Map.updateObjectPos(copy, ex, ey)
  Map.current[sy][sx].object = nil
  log.debug("Moved #{Map.current[ey][ex].object.__class.__name} from #{inspect start} to #{inspect finish}")
  return true

Map.updateObjectPos = (object, newx, newy) ->
  object.x = newx
  object.y = newy

Map.removeObject = (x, y) ->
  table.insert(Map.deleteStack, {x:x, y:y})

Map.removeObjects = () ->
  if #Map.deleteStack >= 1
    for obj in *Map.deleteStack
      log.debug("Removed object #{obj.__class.__name}")
      Map.current[obj.y][obj.x].object = nil

Map.print = (map) ->
  yl = "  "
  -- We can assume it's a square map
  for i=1, #map[1] do yl = yl..i.." "
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

return Map
