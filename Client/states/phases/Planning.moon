Notifications = require("modules.gui.Notifications")
MU = require("modules.gui.Map")

Planning = {}

Planning.duration = 3

Planning.init = () ->
	RM.collect!
	RM.executeCmdQasPlayer!

Planning.enter = () ->
	RM.nextRound()
	Notifications.push 1,
		'Planning - Position troops',
		G.assets["icons"]["move"],
		Planning.duration/2,
		G.COLOR

Planning.done = () ->
	if not G.isLocal
		NM.sendDataToServer({
			type: "USER_PLANNING_OVER",
			payload: true
		})
	PM.switch("Action")

Planning.exit = () ->

Planning.update = (dt) ->

Planning.draw = () ->
	with love.graphics
		.push!
		.translate(Map.tx, Map.ty)
		-- left/right highlight
		x = G.self >= 2 and Map.width-G.PLAYERS[G.self].margin or 0
		y, w, h = 0, G.PLAYERS[G.self].margin, #Map.current
		c = M.clone(G.COLORS[G.self])
		-- Make slightly transparent
		c[4] = 0.5
		.setColor(c)
		.scale(MU.p, MU.p)
		-- Draw bg block to highlight placement options
		.rectangle("fill", x, y, w, h)
		.setColor(1,1,1,1)
		.pop!

Planning.handleMovingObjects = (using nil) ->
	-- If we have a selected object, we're placing it
	if MU.sGS
		-- Check if we're just trying to place the object back
		-- where it was initially
		if M.identical(MU.sGS, MU.fGS)
			MU.deselectUnit()
			return
		else
			-- Attempt to place selected object at new location
			-- Check if desired placement location within player margin
			dx = MU.fGS[1]
			p = Map.current[MU.sGS[2]][MU.sGS[1]].object.belongsTo
			m = G.PLAYERS[p].margin
			if p % 2 == 0
				if dx <= Map.width-m
					return	
			else
				if dx >= m+1
					return

			sx, sy = unpack(MU.sGS)
			ex, ey = unpack(MU.fGS)
			success = Map.moveObject(sx, sy, ex, ey)
			if success
				o = Map.getObjAtPos(unpack(MU.fGS))
				o\pushCommand({
					type: "DIRECT_MOVE",
					payload: {x: ex, y: ey},
					x: o.x, y: o.y
				})
				MU.deselectUnit()
				return

	-- If an object exists at the current mouse selection, select it
	o = Map.current[MU.fGS[2]][MU.fGS[1]] 
	if o.object and not MU.sGS
		-- Only be able to select our own units
		if o.object.belongsTo == G.self
			MU.selectUnit(MU.fGS)
			return

Planning.mousepressed = (x, y, button) ->
	-- Moving game objects around during planning
	if MU.mouseOverMap 
		Planning.handleMovingObjects!

Planning.mousereleased = (x, y, button) ->
Planning.keypressed = (key) ->

return Planning 