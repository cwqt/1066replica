io.stdout\setvbuf("no")

export M          = require("libs.moses")     -- table functions
export L          = require("libs.lume")      -- lume maths
export Z          = require("libs.deep")      -- z-indexer
export Gamestate  = require("libs.gamestate") -- gamestates, duh
export Timer      = require("libs.timer")     -- " "
export ANet       = require("libs.Affair/network")
export TSerial    = require("libs.TSerial")   -- serialisation
export Camera     = require("libs.Camera")    -- STALKERX Camera
export inspect    = require("libs.inspect")   -- table pretty print
export lb         = require("libs.lovebird")  -- online debugger
export log        = require("libs.log")       -- logging
export anim8      = require("libs.anim8")     -- sprite animation
export socket     = require("socket")         -- socket.gettime()

export Map        = require("modules.Map")
export RM         = require("modules.RoundManager")
export NM         = require("modules.Networking")
export UI         = require("modules.ui")
export CD         = require("modules.CollDet")
export UM         = require("modules.UnitManager")
export PM         = require("modules.PhaseManager")
export MU         = require("modules.gui.Map")
export MP         = require("modules.MapParser")
export Field      = require("modules.gui.Field")
export Infobar    = require("modules.gui.Infobar")
export Debugger   = require("modules.Debugger")
export USI        = require("modules.UserServerInteractor")
export UC         = require("modules.gui.UserCard")

export Player     = require("components.Player")
export Entity     = require("components.Entity")
export Unit       = require("components.Unit")

export MainMenu   = require("states.MainMenu")
export Game       = require("states.Game")
export MWS        = require("states.MutliplayerWaitScreen")
export UnitSelect = require("states.UnitSelect")

export G          = require("G")

love.load         = () ->
  os.execute("clear")
  love.math.setRandomSeed(love.timer.getTime())
  log.debug("Game started: #{love.timer.getTime()}")
  Debugger.load({useProfiler: false})
  Gamestate.registerEvents()
  Gamestate.switch(MainMenu)

love.frame = 0
love.update       = (dt) ->
  if dt < 1/60 then love.timer.sleep(1/60 - dt)
  NM.update(dt)
  Debugger.update(dt)
--  lb.update(dt)

love.draw         = () ->
  love.graphics.setBackgroundColor(0.2,0.2,0.2, 0.5)
  Debugger.draw()
  Z.execute()

love.keypressed   = (key, code, isrepeat) ->
  if key == "q" then love.event.quit()
  if key == "/" then UI.dbg = not UI.dbg

love.keyreleased   = (key) ->
love.mousepressed  = (x, y, button) ->
love.mousereleased = (x, y, button) ->
love.mousemoved    = (x, y, dx, dy) ->
love.wheelmoved    = (x, y) ->
love.focus         = (f) ->
love.textinput     = (t) ->

love.errhand       = (msg) ->
  print "\n"
  log.error(msg)
  love.quit()

love.quit          = () ->
  USI.logout!
  log.fatal("Quitting...")
  love.event.quit()
