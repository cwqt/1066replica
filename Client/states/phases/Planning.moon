Planning = {}

Planning.duration = 30

Planning.init = () ->
	RM.collect!
	RM.executeCmdQasPlayer!
	for k, player in pairs(G.PLAYERS) do
		c = player\calculateRemainingUnitCount()
		player.unitCount = c

Planning.enter = () ->
	RM.nextRound()
	Planning.pushPlanningAreaColor!
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
	Planning.popPlanningAreaColor!

Planning.update = (dt) ->

Planning.draw = () ->

Planning.handleMovingObjects = (using nil) ->
	log.trace("handling")
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
	success = Map.moveObject(sx, sy, ex, ey)
	if success
		o\pushCommand({
			type: "DIRECT_MOVE",
			payload: {x: ex, y: ey},
			x: o.x, y: o.y
		})
		MU.deselectGS()
		return

-- Planning placement area highlighting
Planning.getPlanningAreaRange = () ->
	fs = G.playerIsOnLeft(G.self) and 1 or Map.width-G.PLAYERS[G.self].margin
	fe = G.playerIsOnLeft(G.self) and G.PLAYERS[G.self].margin or Map.width
	return fs, fe

Planning.pushPlanningAreaColor = () ->
	fs, fe = Planning.getPlanningAreaRange!
	c = M.clone(G.PLAYERS[G.self].color.normal)
	c[4] = 0.2
	for y=1, Map.height
		for x=fs, fe do
			MU.pushGSColor(x, y, c)

Planning.popPlanningAreaColor = () ->
	fs, fe = Planning.getPlanningAreaRange!
	for y=1, Map.height
		for x=fs, fe do
			MU.popGSColor(x, y)

Planning.mousemoved = (x, y, dx, dy) ->
Planning.mousepressed = (x, y, button) ->
	if not MU.mouseOverMap then return
	if button == 1
		-- Only allow player to select own units
		o = MU.fGS
		o = Map.getObjAtPos(unpack(o))
		if o then if o.belongsTo != G.self then return

		-- Select a GS if none selected
		if MU.sGSo == nil
			MU.selectGS(MU.fGS)
			return

		-- Check if we're attempting to place down in original position
		if M.identical(MU.sGS or {}, MU.fGS) then
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