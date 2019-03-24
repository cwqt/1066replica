export M = require("../libs/moses")
export inspect = require("../libs/inspect")

io.stdout\setvbuf("no")

export Map = require("Map")
export RM  = require("RoundManager")

Map.set(Map.generate(5, 10))

class Map.Object
  new: (@icon="█") =>
  
  update: (dt) =>

  draw: () =>

class Entity extends Map.Object
  new: (@hp=10, ...) =>
    super(...)

  update: (dt) =>
    super\draw()

  draw: () =>
    super\draw()

export Entity

love.load = () ->
  for i=1, 6
    Map.current[3][i].object = Map.Object()
  for i=2, 4
    Map.current[i][7].object = Map.Object()

  z = Map.findPath({1,3}, {10,3})
  Map.objectFollowPath(z)
  
  x = Entity(3, "o")
  Map.current[5][8].object = x

  Map.print(Map.current)

  RM.pushCmd(1, -> Map.objectFollowPath(Map.findPath({8,5},{8,1})))
  RM.pushCmd(1, -> print("hello1"))
 -- RM.pushCmd(2, -> print("hello2"))
  RM.executeCommands()

love.update = (dt) ->

love.draw = () ->
  love.graphics.print("hello", 10, 10)

love.keypressed = (key) ->
  switch key
    when "w"
      Map.moveObject({1,3}, {1,4})

love.errhand = (msg) ->
  love.event.quit()
