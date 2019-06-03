Command = {}

Command.enter = () ->
	RM.nextRound()

Command.exit = () ->

Command.update = (dt) ->

Command.draw = () ->
	love.graphics.print("penus", 10, 100)

return Command