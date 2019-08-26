MU = {}
MU.sGS = nil
MU.sGSo = nil
MU.fGS = {1,1}
MU.pfGS = {1,1}
MU.mouseOverMap = false
MU.p = 50

MU.load = () ->
  Map.tx = (love.graphics.getWidth()-(Map.width*MU.p))/2
  Map.ty = love.graphics.getHeight()-Map.height*MU.p-10

MU.update = (dt) ->
	s = ""
	s = "mouseOverMap: #{MU.mouseOverMap}\n"
	s = s .. "fGS: #{inspect MU.fGS}\n"
	s = s .. "pfGS: #{inspect MU.pfGS}\n"
	s = s .. "sGS: #{inspect MU.sGS}\n"
	s = s .. "Phase: #{PM.current}\n"
	s = s .. "Turn: #{RM.turn}\n"
	s = s .. "ui.canDraw: #{PM['Command'].ui.canDraw}\n"
	s = s .. "mouseInUi: #{PM['Command'].ui.mouseIsOver}"
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
	s = inspect(G.PLAYERS[G.self].commands, {depth:2})
	UI.id["player"].value = s

MU.draw = () ->
	with love.graphics
		.push!
		.translate(Map.tx, Map.ty)
		-- MU.drawMap!
		MU.drawUnits!
		.pop!

MU.drawMap = () ->
	with love.graphics
		.push!
		.scale(MU.p, MU.p)
		.setLineWidth(1/MU.p)
		.setColor(1,1,1,1)
		-- Grid outline
		.line(Map.width, 0, Map.width, Map.height, 0, Map.height)
		for i=1, #Map.current[1] do
			.line(i-1, 0, i-1, Map.height)
		for i=1, #Map.current do
			.line(0, i-1, Map.width, i-1)
		.pop!

		-- Draw co-ord numbers
		for y=1, #Map.current
			for x=1, #Map.current[1]
				.print("#{x},#{y}", (x-1)*MU.p, (y-1)*MU.p)

-- for integer lists only
M.identical = (a, b) ->
	for i=1, #a
		if a[i] == b[i]
			continue
		else return false
	return true

MU.drawUnit = (o) ->

MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			if Map.current[y][x].object
				o = Map.current[y][x].object
				love.graphics.push()
				tx, ty = MU.getUnitCenterPxPos(x, y)

				if Game\isPlanning() and M.identical({x, y}, MU.sGS or {})
					love.graphics.translate((love.mouse.getX()-Map.tx-tx), (love.mouse.getY()-Map.ty-ty))

				love.graphics.setColor(1,1,1,1)
				love.graphics.circle("fill", tx, ty, 0.4*MU.p)
				love.graphics.circle("line", tx, ty, 0.4*MU.p, 64)
				love.graphics.setColor(G.COLORS[o.belongsTo])
				love.graphics.circle("fill", tx, ty, 0.35*MU.p)
				love.graphics.circle("line", tx, ty, 0.35*MU.p, 64)
				love.graphics.setColor(1,1,1,1)
				--assume image 1:1
				iw = o.icon_img\getWidth()
				s = 0.55*MU.p/iw
				love.graphics.draw(o.icon_img, (x-1)*MU.p+MU.p/2-.275*MU.p, (y-1)*MU.p+MU.p/2-.275*MU.p, 0, s, s)
				love.graphics.setColor(0,0,0,1)
				-- love.graphics.rectangle("line", (x-1)*p+p/2-.35*p, (y-1)*p+p/2-.35*p, 0.7*p, 0.7*p)
				love.graphics.setColor(1,1,1,1)
				love.graphics.pop()

MU.hoverGS = (mx, my) ->
	tx, ty = (love.graphics.getWidth()-(Map.width*MU.p))/2, love.graphics.getHeight()-Map.height*MU.p-10
	if not CD.checkMouseOver(0, 0, Map.width*MU.p, Map.height*MU.p, tx, ty)
		MU.mouseOverMap = false
	else
		MU.mouseOverMap = true
		gx = math.ceil((mx-tx)/MU.p)
		gy = math.ceil((my-ty)/MU.p)
		if not M.identical(MU.fGS, {gx, gy})
			MU.pfGS = MU.fGS
			MU.fGS = {gx, gy}
			-- log.trace("Delta #{inspect MU.pfGS} -> #{inspect MU.fGS}")

MU.mousemoved = (x, y, dx, dy) ->
	MU.hoverGS(x, y)

MU.mousepressed = (x, y, button) ->
	if not MU.mouseOverMap then
		MU.deselectGS!
		return

	if button == 1
		-- Select the object if none selected
		if MU.sGS == nil
			MU.selectGS(MU.fGS)
			return
		-- Check if we're trying to put it down in same place
		if M.identical(MU.sGS, MU.fGS)
			MU.deselectGS!
			return

MU.getUnitCenterPxPos = (x, y) ->
	tx = (x-1)*MU.p+MU.p/2
	ty = (y-1)*MU.p+MU.p/2
	return tx, ty

MU.selectGS = (gs) ->
	o = Map.getObjAtPos(unpack(gs))
	log.debug("Selected #{inspect unit}")
	MU.sGS = gs
	if o then
		log.debug("Selected #{o.__class.__name}")
		MU.sGSo = o
		MU.sGSo\popCommand!

MU.deselectGS = () ->
	if MU.sGS
		log.debug("Deselected #{inspect MU.sGS}")
		MU.sGS = nil
		MU.sGSo = nil

return MU
