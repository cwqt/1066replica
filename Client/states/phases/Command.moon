MU = require("modules.gui.Map")

Command = {}
Command.uiRadius = 80
Command.canDrawCommandUi = false
Command.mouseOverCommandUi = false
Command.hoveredSegment = nil

Command.init = () ->

Command.enter = () ->
	RM.nextRound()

Command.exit = () ->

Command.update = (dt) ->

Command.draw = () ->
	if Command.canDrawCommandUi
		with love.graphics
			.push!
			.translate(Map.tx, Map.ty)
			Command.drawObjectCommandUi!
			.pop!

Command.done = () ->
	PM.switch("Action")

Command.mousemoved = (x, y, dx, dy) ->
	Command.detectMouseOverUi!
	if Command.mouseOverCommandUi
		Command.getMouseHoverSegment!

Command.mousepressed = (x, y, button) ->
	if button == 1 and MU.sGSo
		Command.canDrawCommandUi = not Command.canDrawCommandUi

Command.mousereleased = (x, y, button) ->

Command.keypressed = (key) ->

Command.drawObjectCommandUi = () ->
	o = MU.sGSo
	tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
	t = {}
	for key, command in pairs(o.cmd)
		t[#t+1] = {
			name: key,
			icon: command.icon
		}
	for i=1, #t
		with love.graphics
			.push!
			.translate(tx, ty)
			Command.drawCommandSegment(#t,i,t[i])
			.pop!

Command.detectMouseOverUi = () ->
	o = MU.sGSo
	if o
		tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
		Command.mouseOverCommandUi = CD.CheckMouseOverCircle(tx, ty, Command.uiRadius, Map.tx, Map.ty)

Command.getMouseHoverSegment = (order, tx, ty) ->

Command.drawCommandSegment = (order, position, command) ->
	angle = 360/order
	rotfactor = angle*position
	with love.graphics
		.setColor(0,0,0,1)      -- start, end angle
		.push!
		G.pushRotate(0,0, math.rad(rotfactor))
		G.pushRotate(0,0, -math.rad(90 + angle/2))
		.translate(2,2)
		.arc("fill", 0, 0, Command.uiRadius, 0, math.rad(angle))

		.setColor(1,1,1,1)
		-- rotate images so that they're always facing upwards
		-- and not rotated
		.translate(-65, -65)
		G.pushRotateScale(100, 100, math.rad(45 - (position-1)*90), 0.15, 0.15)
		.draw(command.icon, 0, 0)
		.pop!
		.pop!
		.pop!
		.pop!

return Command