MU = {}
MU.sGS = nil
MU.fGS = {1,1}
MU.pfGS = {1,1}
MU.mouseOverMap = false
p = 50
MU.p = p

MU.load = () ->
  Map.tx, Map.ty = (love.graphics.getWidth()-(Map.width*p))/2, (love.graphics.getHeight()-Map.height*p-10)

MU.update = (dt) ->
	s = ""
	s = "mouseOverMap: #{MU.mouseOverMap}\n"
	s = s .. "fGS: #{inspect MU.fGS}\n"
	s = s .. "pfGS: #{inspect MU.pfGS}\n"
	s = s .. "sGS: #{inspect MU.sGS}\n"
	UI.id["debug"].value = s

	s = ""
	if Map.current[MU.fGS[2]][MU.fGS[1]].object
		s = inspect(Map.current[MU.fGS[2]][MU.fGS[1]].object, {depth:1})
	UI.id["gsinfo"].value = s

	s = ""
	if MU.sGS
		s = inspect(Map.current[MU.sGS[2]][MU.sGS[1]].object, {depth:1})
	UI.id["sgsinfo"].value = s

	s = ""
	s = inspect RM.cmdStack
	UI.id["rm"].value = s


MU.draw = () ->
	love.graphics.push()
	love.graphics.translate(Map.tx, Map.ty)
	MU.drawMap()
	love.graphics.pop()

MU.drawPlanning = () ->
	love.graphics.push()
	love.graphics.translate(Map.tx, Map.ty)
	GAME.self = GAME.self or 1
	x, y, w, h = 0,0,GAME.PLAYERS[GAME.self].margin*p, #Map.current*p
	if GAME.self % 2 == 0
		x = (Map.width-GAME.PLAYERS[GAME.self].margin)*p
	c = M.clone(GAME.COLORS[GAME.self])
	c[4] = 0.5
	love.graphics.setColor(c)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(1,1,1,1)
	love.graphics.pop()

MU.drawMap = () ->
	love.graphics.setColor(1,1,1,1)
	-- Grid outline
	love.graphics.line(Map.width*p, 0, Map.width*p, Map.height*p, 0, Map.height*p)
	for i=1, #Map.current[1] do
		love.graphics.line((i-1)*p, 0, (i-1)*p, Map.height*p)
	for i=1, #Map.current do
		love.graphics.line(0, (i-1)*p, Map.width*p, (i-1)*p)
	-- Draw co-ord numbers
	for y=1, #Map.current
		for x=1, #Map.current[1]
			love.graphics.print("#{x},#{y}", (x-1)*p, (y-1)*p)

	MU.drawUnits()

-- for integer lists only
M.identical = (a, b) ->
	for i=1, #a
		if a[i] == b[i]
			continue
		else return false
	return true

MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			if Map.current[y][x].object
				o = Map.current[y][x].object
				love.graphics.push()
				tx, ty = (x-1)*p+p/2, (y-1)*p+p/2

				if Game\isPlanning() and M.identical({x, y}, MU.sGS or {})
					love.graphics.translate((love.mouse.getX()-Map.tx-tx), (love.mouse.getY()-Map.ty-ty))

				love.graphics.setColor(1,1,1,1)
				love.graphics.circle("fill", tx, ty, 0.4*p)
				love.graphics.circle("line", tx, ty, 0.4*p, 64)
				love.graphics.setColor(GAME.COLORS[o.player])
				love.graphics.circle("fill", tx, ty, 0.35*p)
				love.graphics.circle("line", tx, ty, 0.35*p, 64)
				love.graphics.setColor(1,1,1,1)
				--assume image 1:1
				iw = o.icon_img\getWidth()
				s = 0.55*p/iw
				love.graphics.draw(o.icon_img, (x-1)*p+p/2-.275*p, (y-1)*p+p/2-.275*p, 0, s, s)
				love.graphics.setColor(0,0,0,1)
				-- love.graphics.rectangle("line", (x-1)*p+p/2-.35*p, (y-1)*p+p/2-.35*p, 0.7*p, 0.7*p)
				love.graphics.setColor(1,1,1,1)
				love.graphics.pop()

MU.hoverGS = (mx, my) ->
	tx, ty = (love.graphics.getWidth()-(Map.width*p))/2, love.graphics.getHeight()-Map.height*p-10
	if not CD.CheckMouseOver(0, 0, Map.width*p, Map.height*p, tx, ty)
		MU.mouseOverMap = false
	else
		MU.mouseOverMap = true
		gx = math.ceil((mx-tx)/p)
		gy = math.ceil((my-ty)/p)
		if not M.identical(MU.fGS, {gx, gy})
			MU.pfGS = MU.fGS
			MU.fGS = {gx, gy}
			-- log.trace("Delta #{inspect MU.pfGS} -> #{inspect MU.fGS}")

MU.mousemoved = (x, y, dx, dy) ->
	MU.hoverGS(x, y)

MU.mousepressed = (x, y, button) ->
	if not MU.mouseOverMap and button == 1
			MU.deselectUnit()

	-- Moving game objects around during planning
	if Game\isPlanning() and MU.mouseOverMap 
		MU.handleMovingObjects()

MU.handleMovingObjects = (using nil) ->
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
			p = Map.current[MU.sGS[2]][MU.sGS[1]].object.player
			m = GAME.PLAYERS[p].margin
			if p % 2 == 0
				if dx <= Map.width-m
					return	
			else
				if dx >= m+1
					return
			success = Map.moveObject(MU.sGS, MU.fGS)
			if success
				MU.deselectUnit()
				return

	-- If an object exists at the current mouse selection, select it
	o = Map.current[MU.fGS[2]][MU.fGS[1]] 
	if o.object and not MU.sGS
		-- Only be able to select our own units
		if o.object.player == GAME.self
			MU.selectUnit(MU.fGS)
			return
		
MU.selectUnit = (unit) ->
	log.debug("Selected #{inspect unit}")
	MU.sGS = unit

MU.deselectUnit = () ->
	if MU.sGS
		log.debug("Deselected #{inspect MU.fGS}")
		MU.sGS = nil

return MU
