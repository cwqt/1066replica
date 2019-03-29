LN = require("../libs/lovernet")
Timer = require("../libs/timer")
inspect = require("../libs/inspect")
M = require("../libs/moses")
local Server = require("Server")
love.load = function()
  return Server.start()
end
love.update = function(dt)
  return Server.update(dt)
end
love.draw = function() end
love.errhand = function(msg)
  print(msg)
  return love.event.quit()
end
