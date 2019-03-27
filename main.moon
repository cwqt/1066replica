export M = require("../libs/moses")
export L = require("../libs/lume")
export inspect = require("../libs/inspect")
export lb      = require("../libs/lovebird")

io.stdout\setvbuf("no")

export Map = require("Map")
export RM  = require("RoundManager")
export Player = require("Player")
export Entity = require("Entity")

export GAME = require("GAME")

export copy2 = (obj) ->
  if type(obj) ~= 'table' then return obj
  res = setmetatable({}, getmetatable(obj))
  for k, v in pairs(obj) do res[copy2(k)] = copy2(v)
  return res



love.load = () ->
  Map.set(Map.generate(4, 10))

  for i=1, 6
    Map.current[3][i].object = Map.Object()
  for i=2, 3
    Map.current[i][7].object = Map.Object()

  Map.print(Map.current)

  a = Player()
  b = Player()

  b\addUnit(6,1,
    with Entity("x")
      .def = 5
  )
  a\addUnit(1,1,
    with Entity("i")
      .atk = 4
      .range = 10
  )

  RM.pushCmd(1, -> Map.current[1][1].object\move(6, 2))
  RM.executeCommands()

  Map.print(Map.current)
  love.event.quit()

love.update = (dt) ->
  lb.update()

love.draw = () ->
  love.graphics.print("hello", 10, 10)

love.keypressed = (key) ->
  switch key
    when "w"
      Map.moveObject({1,3}, {1,4})

love.errhand = (msg) ->
  print("\n\nERR: " .. string.rep("=", 30))
  print(msg)
  print(string.rep("=", 35).."\n")
  love.event.quit()
