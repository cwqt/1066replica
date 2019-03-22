require("moonscript")
M = require("moses")
inspect = require("inspect")


Map = {}

Map.generate = (length, width) ->
  t = {}
  for y=1, length do
    t[y] = {}
    for x=1, width do
      t[y][x] = {}
  return t

t = Map.generate(5, 10)

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


class Map.Object
  new: (@icon="█") =>

for i=1, 6
  t[3][i].object = Map.Object()
for i=2, 4
  t[i][7].object = Map.Object()

Map.print(t)

Map.getSimplePFMap = (map) ->
  tt = M.clone(map)
  for y=1, #tt do
    for x=1, #tt[y] do
      if tt[y][x].object != nil
        tt[y][x] = 1
      else
        tt[y][x]= 0
  return tt


Grid = require("jumper.grid")
Pathfinder = require("jumper.pathfinder")

Map.findPath = (a, b) ->
  grid = Grid(Map.getSimplePFMap(t))
  myFinder = Pathfinder(grid, 'JPS', 0)
  myFinder\setMode("ORTHOGONAL")
  startx, starty = a[1], a[2]
  endx, endy = b[1], b[2]

  path, length = myFinder\getPath(startx, starty, endx, endy)
  if path then
    path\filter()
    print(('Path found! Length: %.2f')\format(length))
    for node, count in path\iter() do
      print(('x: %d, y: %d')\format(node.x, node.y))

Map.findPath({1,4}, {1,2})


