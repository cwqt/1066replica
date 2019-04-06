io.stdout\setvbuf("no")
export GAME      = require("GAME")

export M         = require("../libs/moses")     -- table functions
export L         = require("../libs/lume")      -- lume maths
export inspect   = require("../libs/inspect")   -- table pretty print
export lb        = require("../libs/lovebird")  -- online debugger
export Gamestate = require("../libs/gamestate") -- gamestates, duh
export Timer     = require("../libs/timer")     -- " "
export ANet      = require("../libs/Affair/network")
export log       = require("../libs/log")
--export Steam     = require('luasteam')

export Map       = require("modules.Map")
export RM        = require("modules.RoundManager")
export NM        = require("modules.Networking")
export UI        = require("modules.ui")


export Player    = require("components.Player")
export Entity    = require("components.Entity")

export MainMenu  = require("states.MainMenu")
export Game      = require("states.Game")

love.load         = () ->
  log.client("hello")
  log.server("hello")
  love.keyboard.setKeyRepeat(true)
  Gamestate.registerEvents()
  Gamestate.switch(MainMenu)

love.update       = (dt) ->

love.draw         = () ->
  love.graphics.setBackgroundColor(0.2,0.2,0.2)

love.keypressed   = (key, codqe, isrepeat) ->
  if key == "q" then love.event.quit()
  if key == "d" then UI.dbg = not UI.dbg

love.keyreleased  = (key) ->

love.mousepressed = (x, y, button) ->

love.mousereleased = (x, y, button) ->

love.mousemoved    = (x, y, dx, dy) ->

love.wheelmoved    = (x, y) ->

love.textinput     = (t) ->

love.errhand       = (msg) ->
  print "\n"
  log.error(msg)
  love.quit()

love.quit          = () ->
  log.info("Quitting...")
  love.event.quit()
