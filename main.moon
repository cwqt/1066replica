export M = require("../libs/moses")
export inspect = require("../libs/inspect")
export lovebird = require("../libs/lovebird")

io.stdout\setvbuf("no")

export Map = require("Map")

Map.set(Map.generate(5, 10))

class Map.Object
  new: (@icon="█") =>
  
  update: (dt) =>

  draw: () =>

love.load = () ->
  for i=1, 6
    Map.current[3][i].object = Map.Object()
  for i=2, 4
    Map.current[i][7].object = Map.Object()

  Map.print(Map.current)
  z = Map.findPath({1,3}, {8,3})
  Map.objectFollowPath(z)

love.update = (dt) ->
  lovebird.update()

love.draw = () ->
  love.graphics.print("hello", 10, 10)

love.keypressed = (key) ->
  switch key
    when "w"
      Map.moveObject({1,3}, {1,4})


