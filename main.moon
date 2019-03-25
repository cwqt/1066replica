export M = require("../libs/moses")
export inspect = require("../libs/inspect")
export lb      = require("../libs/lovebird")

io.stdout\setvbuf("no")

export Map = require("Map")
export RM  = require("RoundManager")
export Player = require("Player")
export Entity = require("Entity")

export GAME = require("GAME")

love.load = () ->
  Map.set(Map.generate(4, 10))

  for i=1, 6
    Map.current[3][i].object = Map.Object()
  for i=2, 4
    Map.current[i][7].object = Map.Object()

  a = Player()
  b = Player()

  b\addUnit(8,1,
    with Entity("x")
      .def = 5
  )
  a\addUnit(1,1, 
    with Entity("i")
      .range = 10
  )

  RM.pushCmd(1, -> Map.objectFollowPath(Map.findPath({1,1},{7,1})))
  RM.executeCommands()

  Map.print(Map.current)
  --love.event.quit()

love.update = (dt) ->
  lb.update()

love.draw = () ->
  love.graphics.print("hello", 10, 10)

love.keypressed = (key) ->
  switch key
    when "w"
      Map.moveObject({1,3}, {1,4})

love.errhand = (msg) ->
  love.event.quit()
