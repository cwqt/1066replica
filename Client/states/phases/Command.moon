Command = {}

Command.init = () ->

Command.enter = () ->
	RM.nextRound()

Command.exit = () ->

Command.update = (dt) ->

Command.draw = () ->
	Command.drawCommandSegment()

Command.done = () ->
	PM.switch("Action")

Command.mousepressed = (x, y, button) ->

Command.mousereleased = (x, y, button) ->

Command.keypressed = (key) ->

Command.drawCommandSegment = () ->
	with love.graphics
		.arc("fill", 0, 0, 100, 100, 0)

Command.drawObjectCommandUi = (o) ->

Command.toggleObjectCommandUi = (o) ->
	for key, command in ipairs(o.cmd) do
		love.graphics.print

return Command