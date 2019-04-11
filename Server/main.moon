export Timer     = require("../libs/timer")
export ANet      = require("../libs/Affair/network")
export M         = require("../libs/moses")
export inspect   = require("../libs/inspect")   -- table pretty print
export log       = require("../libs/log")
export socket    = require("socket")
export Server    = require("compiled/Server")

load = () ->
	os.execute("clear")
	export timer = Timer()
	Server.load()

sleep = (sec) ->
  socket.select(nil, nil, sec)

load()

time = socket.gettime()
dt = 0
while true do
	Server.update(dt)
	timer\update(dt)
	dt = socket.gettime() - time
	time = socket.gettime()

	sleep( 0.05 )
