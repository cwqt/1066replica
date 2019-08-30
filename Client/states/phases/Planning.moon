Planning = {}

Planning.duration = 30

Planning.init = () ->
	RM.collect!
	RM.executeCmdQasPlayer!

Planning.enter = () ->
	RM.nextRound()
	-- Notifications.push 1,
	-- 	'Planning - Position troops',
	-- 	G.assets["icons"]["move"],
	-- 	Planning.duration/2,
	-- 	G.COLOR

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
	-- Attempt to place selected object at new location
	-- Check if desired placement location within player margin
	dx = MU.fGS[1]
	p = MU.sGSo.belongsTo
	-- Only be able to move objects that belong to us
	if not p == G.self then return 
	
	m = G.PLAYERS[p].margin
	-- Don't allow placements outside player margin
	if p % 2 == 0
		if dx <= Map.width-m then return	
	else
		if dx >= m+1 then return

	sx, sy = unpack(MU.sGS)
	ex, ey = unpack(MU.fGS)
	o = Map.getObjAtPos(sx, sy)
	o.x, o.y = ex, ey
	-- success = Map.moveObject(sx, sy, ex, ey)
	if success
		o = Map.getObjAtPos(unpack(MU.sGS))
		o\pushCommand({
			type: "DIRECT_MOVE",
			payload: {x: ex, y: ey},
			x: sx, y: sy
		})
		MU.deselectGS()
		return

Planning.mousemoved = (x, y, dx, dy) ->
Planning.mousepressed = (x, y, button) ->
	if button == 1
		if MU.sGSo == nil
				MU.selectGS(MU.fGS)
				return

		if M.identical(MU.sGS, MU.fGS) then
			MU.deselectGS!
			return

		-- Moving game objects around during planning
		if MU.mouseOverMap and MU.sGSo
			MU.sGSo\popCommand!
			Planning.handleMovingObjects!
			return

Planning.mousereleased = (x, y, button) ->
Planning.keypressed = (key) ->
Planning.onGSChange = () ->


return Planning 