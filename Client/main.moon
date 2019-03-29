io.stdout\setvbuf("no")

export M         = require("../libs/moses")     -- table functions
export L         = require("../libs/lume")      -- lume maths
export inspect   = require("../libs/inspect")   -- table pretty print
export lb        = require("../libs/lovebird")  -- online debugger
export Gamestate = require("../libs/gamestate") -- gamestates, duh
export Timer     = require("../libs/timer")     -- " "
export LN        = require("../libs/lovernet")
export sock      = require("../libs/sock")


--export Steam     = require('luasteam')

export Map       = require("modules.Map")
export RM        = require("modules.RoundManager")
export Client    = require("modules.Client")
export P2P       = require("modules.P2P")


export Player    = require("components.Player")
export Entity    = require("components.Entity")

export GAME = require("GAME")

M.deepClone = (obj) ->
  if type(obj) ~= 'table' then return obj
  res = setmetatable({}, getmetatable(obj))
  for k, v in pairs(obj) do res[M.deepClone(k)] = M.deepClone(v)
  return res

love.load = () ->
--  Client.start()
  P2P.start("178.62.42.106")

  -- Map.set(Map.generate(4, 10))

  -- for i=1, 6
  --   Map.current[3][i].object = Map.Object()
  -- for i=2, 3
  --   Map.current[i][7].object = Map.Object()

  -- Map.print(Map.current)

  -- a = Player()
  -- b = Player()

  -- b\addUnit(6,1,
  --   with Entity("x")
  --     .def = 5
  -- )
  -- a\addUnit(1,1,
  --   with Entity("i")
  --     .atk = 4
  --     .range = 10
  -- )

  -- RM.pushCmd(1, -> Map.current[1][1].object\move(6, 2))
  -- RM.executeCommands()


  -- Map.print(Map.current)
  -- love.event.quit()

love.update = (dt) ->
  P2P.update(dt)
  --  Client.update(dt)
--  lb.update()

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
