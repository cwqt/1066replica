io.stdout\setvbuf("no")
export GAME      = require("GAME")

export M         = require("../libs/moses")     -- table functions
export L         = require("../libs/lume")      -- lume maths
export inspect   = require("../libs/inspect")   -- table pretty print
export lb        = require("../libs/lovebird")  -- online debugger
export Gamestate = require("../libs/gamestate") -- gamestates, duh
export Timer     = require("../libs/timer")     -- " "
export ANet      = require("../libs/Affair/network")
--export Steam     = require('luasteam')

export Map       = require("modules.Map")
export RM        = require("modules.RoundManager")
export NM        = require("modules.Networking")

export Player    = require("components.Player")
export Entity    = require("components.Entity")

export MainMenu  = require("states.MainMenu")
export Game      = require("states.Game")

love.load         = () ->
  Gamestate.registerEvents()
  Gamestate.switch(MainMenu)

love.update       = (dt) ->
  Gamestate.update(dt)

love.draw         = () ->
  Gamestate.draw()
  love.graphics.clear(0.2, 0.2, 0.2)

love.keypressed   = (key) ->
  Gamestate.keypressed(key)

love.keyreleased  = (key) ->
  Gamestate.keyreleased(key)

love.mousepressed = (x, y, button) ->
  Gamestate.mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
	Gamestate.mousereleased(x, y, button)

love.mousemoved    = (x, y) ->
	Gamestate.mousemoved(x, y)

love.wheelmoved    = (x, y) ->
	Gamestate.wheelmoved(x, y)

love.textinput     = (t) ->
	Gamestate.textinput(t)

love.errhand       = (msg) ->
  print("\n\nERR: " .. string.rep("=", 30))
  print(msg)
  print(string.rep("=", 35).."\n")
  love.event.quit()

love.quit          = () ->
