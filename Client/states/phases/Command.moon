Command = {}
Command.canDrawCommandUi = false

Command.init = () ->

Command.enter = () ->
	RM.nextRound()

Command.exit = () ->

Command.update = (dt) ->

Command.draw = () ->
	if Command.canDrawCommandUi
		with love.graphics
			.push!
			.translate(500,500)
			Command.drawObjectCommandUi(M)
			.pop!

Command.done = () ->
	PM.switch("Action")

Command.mousepressed = (x, y, button) ->
	switch button
		when 1
			Command.drawObjectCommandUi(Map.getObjAtPos(1,1))

Command.mousereleased = (x, y, button) ->

Command.keypressed = (key) ->

Command.drawCommandSegment = (order, position) ->
	angle = 360/order
	with love.graphics
		.push!
		.setColor(1,1,1,1)      -- start, end angle
		.arc("fill", 0, 0, 100, 0, math.rad(angle))
		.pop!

Command.drawObjectCommandUi = (o) ->
	print inspect o
	for i=1, #o.cmd
		Command.drawCommandSegment(#o.cmd, i)

Command.toggleObjectCommandUi = () ->
	if MU.sGS
		o = Map.getObjAtPos(unpack(MU.sGS))
		if o then
			Command.canDrawCommandUi = true
			return
	Command.canDrawCommandUi = false

return Command