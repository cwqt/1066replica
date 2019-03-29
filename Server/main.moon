export LN = require("../libs/LoverNet/lovernet")
export Timer = require("../libs/timer")
export inspect = require("../libs/inspect")
export M       = require("../libs/moses")

Server = require("Server")

-- matchmaking list
--  select faction
--  enter matchmaking
--    found other player!
--  select units (timed)
--  sync units
--  enter game
--

love.load = () ->
	Server.start()

--  love.event.quit()

love.update = (dt) ->
  Server.update(dt)

love.draw = () ->

love.errhand = (msg) ->
  print(msg)
  love.event.quit()
