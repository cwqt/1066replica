Map = {}
Map.current = {}

Map.set = (map) ->
  Map.current = map

Map.generate = (length, width) ->
  t = {}
  for y=1, length do
    t[y] = {}
    for x=1, width do
      t[y][x] = {}
  return t

Map.print = (map) ->
  yl = "  "
  for i=1, 10 do yl = yl..i.." "
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
  grid = Grid(Map.getSimplePFMap(Map.current))
  myFinder = Pathfinder(grid, 'JPS', 0)
  myFinder\setMode("ORTHOGONAL")
  startx, starty = unpack(a)
  endx, endy = unpack(b)

  path, length = myFinder\getPath(startx, starty, endx, endy)
  if path then
    path\filter()
    print(('Path found! Length: %.2f')\format(length))
    for node, count in path\iter() do
      print(('x: %d, y: %d')\format(node.x, node.y))
    
    t = {}
    path\fill()
    for node, _ in path\iter() do
      t[#t+1] = {node.x, node.y}
    return t
  

Map.moveObject = (start, finish) ->
  fromx, fromy = start[1], start[2]
  tox, toy = finish[1], finish[2]
  
  if Map.current[toy][tox].object
    print("moveObject: Object exists at #{tox}, #{toy}")
    return

  copy = M.clone(Map.current[fromy][fromx].object)
  Map.current[toy][tox].object = copy
  Map.current[fromy][fromx].object = nil

Map.objectFollowPath = (path) ->
  print("Moving #{Map.current[path[1][2]][path[1][1]].object.__class.__name} from #{inspect(path[1])} to #{inspect(path[#path])}")
  for i=1, #path do
    if i == #path then return
    Map.moveObject({path[i][1], path[i][2]},{path[i+1][1], path[i+1][2]})












return Map
