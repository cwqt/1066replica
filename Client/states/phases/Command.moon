MU = require("modules.gui.Map")

Command = {}
Command.ui = {}
Command.ui.radius = 80
Command.ui.canDraw = false
Command.ui.mouseIsOver = false
Command.ui.hoveredSegment = nil
Command.ui.cmdUiOrder = nil
Command.ui.degOffsets = {[2]:90, [3]:30, [4]: 45, [5]: 54}
Command.ui.cSeg = 0

Command.init = () ->

Command.enter = () ->
	RM.nextRound()

Command.exit = () ->

Command.update = (dt) ->

Command.draw = () ->
	if Command.ui.canDraw
		with love.graphics
			.push!
			.translate(Map.tx, Map.ty)
			Command.ui.draw!
			.pop!

Command.done = () ->
	PM.switch("Action")

Command.mousemoved = (x, y, dx, dy) ->
	Command.ui.detectMouseOver!
	-- if not Command.ui.mouseIsOver
	-- if Command.ui.mouseIsOver
		-- Command.ui.detectMouseOverSegment!

Command.mousepressed = (x, y, button) ->
	if button == 1 and MU.sGSo
		Command.ui.canDraw = not Command.ui.canDraw

Command.mousereleased = (x, y, button) ->

Command.keypressed = (key) ->

Command.ui.detectMouseOver = () ->
	o = MU.sGSo
	if o then
		tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
		Command.ui.mouseIsOver = CD.checkMouseOverCircle(tx, ty, Command.ui.radius, Map.tx, Map.ty)

Command.ui.draw = () ->
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
			Command.ui.drawSegment(#t,i,t[i])
			.pop!

Command.ui.detectMouseOverSegment = (order, position) ->
	o = MU.sGSo
	tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
	degOffset = Command.ui.degOffsets
	angle = 360/order
	mx, my = love.mouse.getPosition()

	a1 = angle*(position-1)
	a2 = angle*position
	position = CD.isPointWithinSegment(mx, my, tx+Map.tx, ty+Map.ty, Command.ui.radius, math.rad(a1), math.rad(a2), degOffset[order])
	if position
		return true

Command.ui.drawSegment = (order, position, command) ->
	degOffset = Command.ui.degOffsets
	angle = 360/order
	-- arc begins from x plane horizontal, angle deg offset
	a1 = angle*(position-1)
	a2 = angle*position
	degOffset = Command.ui.degOffsets
	angle = 360/order
	-- arc begins from x plane horizontal, angle deg offset
	rotFactor = angle*(position-1) - degOffset[order]
	with love.graphics
		if Command.ui.detectMouseOverSegment(order, position)
			Command.ui.cSeg = position
			.setColor(0.3,0.3,0.3,1)
		else
			.setColor(0,0,0,1)

		.push!
		-- Rotate each sector to its position in the 'pie-chart'
		G.pushRotate(0,0, math.rad(rotFactor))
		-- Create a bit of margin between them
		.push!
		.translate(2,2)
		.arc("fill", 0, 0, Command.ui.radius, 0, math.rad(angle))
		.pop!

		.setColor(1,1,1,1)
		.push!
		-- Move the center to the center of the arc (plus some padding)
		xof = Command.ui.radius/2 + 10 + 2
		.translate(xof, 0)
		--Rotate about the point of the sector center, inverse prev. translation
		G.pushRotate(-xof ,0, math.rad(angle/2))
		-- Scale down icons from 200x200 to 30x30
		.scale(0.15, 0.15)
		-- Invert the sector rotation such that each icon is facing upwards
		G.pushRotate(0, 0, math.rad(-angle/2 - rotFactor))
		-- Inverse translation to center image in sector center
		.draw(command.icon, -100, -100)
		.pop!
		.pop!
		.pop!
		.pop!
		.pop!


return Command