MU = {}

MU.load = () ->
	MU.sGS = nil
	MU.sGSo = nil
	MU.fGS = {1,1}
	MU.pfGS = {1,1}
	MU.mouseOverMap = false
	MU.timer = Timer!

	-- bx= total blocks of width MU.p at res
	MU.bx, MU.by = 40, 22.5
	MU.p = love.graphics.getWidth()/MU.bx
	MU.x, MU.y, MU.s = 0, 0, 1

	Map.tx = (love.graphics.getWidth()-(Map.width*MU.p))/2
	Map.ty = (love.graphics.getHeight()-(Map.height*MU.p))-MU.p/4
	Map.tw = MU.bx*MU.p
	Map.th = MU.by*MU.p
	Infobar.load()

	print Map.tx, Map.ty, Map.tw, Map.th

MU.update = (dt) ->
	MU.timer\update(dt)
	MU.updateDebugInfo()

MU.draw = () ->
	with love.graphics
		.setColor(RGB(31,31,31,1))
		.rectangle("fill", 0, Map.ty-MU.p/4, .getWidth(), Map.th+MU.p/2)
		.push!
		.scale(MU.s, MU.s)
		.translate(Map.tx, Map.ty)
		.translate(-MU.x*MU.p, -MU.y*MU.p)
		-- MU.drawFocusedEdgeBar!
		MU.drawMap!
		MU.drawUnits!
		.pop!

	MU.drawEdgeBars!
	Infobar.draw()

MU.drawMap = () ->
	with love.graphics
		-- Draw co-ord numbers
		.setLineStyle("rough")
		for y=1, #Map.current
			for x=1, #Map.current[1]
				-- draw heightmap
				.setColor(1,1,1, Map.current[y][x].height/3)
				.rectangle("fill", (x-1)*MU.p, (y-1)*MU.p, MU.p, MU.p)
				-- .print("#{x},#{y}", (x-1)*MU.p, (y-1)*MU.p)
				-- set grid square bg colour as top of stack
				clrStack = Map.current[y][x].colorStack
				.setColor(unpack(clrStack[#clrStack]))
				.rectangle("fill", (x-1)*MU.p, (y-1)*MU.p, MU.p, MU.p)

		.push!
		.scale(MU.p, MU.p)
		.setLineWidth(1/MU.p)
		.setColor(RGB(44,44,44,1))
		-- Grid outline
		.line(Map.width, 0, Map.width, Map.height, 0, Map.height)
		for i=1, #Map.current[1] do
			.line(i-1, 0, i-1, Map.height)
		for i=1, #Map.current do
			.line(0, i-1, Map.width, i-1)
		.pop!

MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			o = Map.getObjAtPos(x, y)
			if o then
				MU.drawUnit(o)
				love.graphics.push!
				love.graphics.translate(0, -200)
				o\draw!
				love.graphics.pop!

MU.drawUnit = (o) ->
	with love.graphics
		tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
		.push!
		-- attach unit to mouse
		if Game\isPlanning() and M.identical({o.x, o.y}, MU.sGS or {})
			.translate((love.mouse.getX()-Map.tx-tx), (love.mouse.getY()-Map.ty-ty))

		c = G.COLORS["grey"]
		if o.belongsTo != 0 -- not neutral object
			c = G.PLAYERS[o.belongsTo].color.normal
		MU.drawColoredCircleIcon(tx, ty, (MU.p/3), o.icon_img, c)
		.pop!

MU.drawColoredCircleIcon = (x, y, r, icon, color) ->
	icon\setFilter( 'linear', 'linear' )
	with love.graphics
		.push!
		.setColor(1,1,1,1)
		.setLineWidth(5)
		.circle("line", x, y, r, 64)
		.setLineWidth(1)
		.setColor(color)
		.circle("fill", x, y, r, 64)
		-- assume 1:1 aspect ration
		w = icon\getWidth()
		s = (r*2)/(w*1.5) --1.2: padding
		.push!
		.translate(x, y)
		.scale(s, s)
		.setColor(1,1,1,1)
		.draw(icon, -w/2, -w/2)
		.pop!
		.pop!

MU.drawEdgeBars = () ->
	edgeWidth = 3
	for k, player in pairs(G.PLAYERS)
		x = (k-1) * Map.tw
		offset = 1
		if G.playerIsOnLeft(player.player) then
			offset = -(offset+edgeWidth)
		for i=1, Map.height
			with love.graphics
				.push!
				.translate(Map.tx+x, Map.ty+((i-1)*MU.p))
				-- .translate(x+offset, (i-1)*MU.p)
				.setColor(player.color.dark)
				if MU.sGS
					if MU.sGS[2] == i
						.setColor(RGB(227, 67, 99, 1))			
				.rectangle("fill", offset, 0, edgeWidth, MU.p)
				.rectangle("line", offset, 0, edgeWidth, MU.p)
				.pop!

MU.updateDebugInfo = () ->
	s = ""
	s = "mouseOverMap: #{MU.mouseOverMap}\n"
	s = s .. "fGS: #{inspect MU.fGS}\n"
	s = s .. "pfGS: #{inspect MU.pfGS}\n"
	s = s .. "sGS: #{inspect MU.sGS}\n"
	s = s .. "sGSo: #{MU.sGSo}\n"
	s = s .. "Phase: #{PM.current}\n"
	s = s .. "Turn: #{RM.turn}\n"
	s = s .. "ui.canDraw: #{PM['Command'].ui.canDraw}\n"
	s = s .. "mouseInUi: #{PM['Command'].ui.mouseIsOver}\n"
	s = s .. "ui.cSeg: #{PM['Command'].ui.currentHoveredSeg}\n"
	s = s .. "handlingInput: #{PM['Command'].handlingUserInput}\n"
	UI.id["debug"].value = s

	s = ""
	fo = Map.getObjAtPos(unpack(MU.fGS))
	if fo then s = inspect(fo, {depth:1})
	UI.id["gsinfo"].value = s

	s = ""
	if MU.sGS then s = inspect(MU.sGSo, {depth:1})
	UI.id["sgsinfo"].value = s

	s = ""
	s = inspect(G.PLAYERS[G.self].commands, {depth:2})
	UI.id["player"].value = s

MU.onGSChange = () ->
	PM[PM.current].onGSChange()
	-- MU.pushGSColor(MU.fGS[1], MU.fGS[2], {1,1,1,1})
	-- MU.popGSColor(MU.pfGS[1], MU.pfGS[2], {1,1,1,1})

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
			MU.onGSChange!
					-- log.trace("Delta #{inspect MU.pfGS} -> #{inspect MU.fGS}")

MU.mousemoved = (x, y, dx, dy) ->
	MU.hoverGS(x, y)
	-- MU.pfGS.colorStack[#Map.current[y][x].colorStack] = nil

MU.mousepressed = (x, y, button) ->
	if not MU.mouseOverMap and not PM["Command"].ui.mouseIsOver then
		MU.deselectGS!
		return

MU.getUnitCenterPxPos = (x, y) ->
	tx = (x-1)*MU.p+MU.p/2
	ty = (y-1)*MU.p+MU.p/2
	return tx, ty

MU.selectGS = (gs) ->
	o = Map.getObjAtPos(unpack(gs))
	if o then
		MU.sGS = gs
		log.debug("Selected #{inspect MU.sGS} :: #{o.__class.__name}")
		MU.sGSo = o

MU.keypressed = (key) ->
	switch key
		when 'right'
			MU.timer\tween(0.1, MU, {x: L.clamp(MU.x+1, 0, Map.width-15)}, "linear")
		when 'left'
			MU.timer\tween(0.1, MU, {x: L.clamp(MU.x-1, 0, Map.width-15)}, "linear")
		when 'up'
			MU.timer\tween(0.1, MU, {y: L.clamp(MU.y-1, 0, Map.height-5)}, "linear")
		when 'down'
			MU.timer\tween(0.1, MU, {y: L.clamp(MU.y+1, 0, Map.height-5)}, "linear")
		when '='
			MU.timer\tween(0.1, MU, {s: MU.s+0.1}, "linear")
		when '-'
			MU.timer\tween(0.1, MU, {s: MU.s-0.1}, "linear")

MU.getWorldPosition = (x, y) ->

MU.deselectGS = () ->
	if MU.sGS
		log.debug("Deselected #{inspect MU.sGS} :: #{MU.sGSo.__class.__name}")
		MU.sGS = nil
		MU.sGSo = nil

MU.pushGSColor = (x, y, color) ->
	gsc = Map.getGSAtPos(x, y).colorStack
	if M.identical(color, gsc[#gsc]) then return
	table.insert(gsc, color)

MU.popGSColor = (x, y) ->
	gsc = Map.getGSAtPos(x, y).colorStack
	if #gsc > 1 then table.remove(gsc, #gsc)

return MU
