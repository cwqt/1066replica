export Timer     = require("../libs/timer")
export ANet      = require("../libs/Affair/network")
export M         = require("../libs/moses")
export inspect   = require("../libs/inspect")   -- table pretty print


export Server    = require("Server")

export GAME = {}
GAME.START_TIME = love.timer.getTime()
export NM = {}
NM.log = (tag, msg) ->
  if type(msg) == "table"
    m = ""
    for k,v in pairs(msg) do
      m = m .. " " .. tostring(v)
    msg = m

  t = love.timer.getTime()-GAME.START_TIME
  t = tostring(t * 1000)\sub(1, 6)
  print("#{t} [#{string.upper tag}]: #{msg}")

love.load = () ->
	export timer = Timer()
	Server.load()


love.update = (dt) ->
	Server.update(dt)
	timer\update(dt)