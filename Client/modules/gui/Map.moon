MU = {}
MU.sGS = nil
MU.sGSo = nil
MU.fGS = {1,1}
MU.pfGS = {1,1}
MU.mouseOverMap = false
MU.timer = Timer!
MU.p = 40
MU.x, MU.y = 0, 0
MU.s = 1

MU.load = () ->
	Map.tx = (love.graphics.getWidth()-(Map.width*MU.p))/2
	Map.ty = (love.graphics.getHeight()-(Map.height*MU.p))-MU.p/4
	Map.tw = Map.width*MU.p
	Map.th = Map.height*MU.p

	-- 185	440	750	250
	print Map.tx, Map.ty, Map.tw, Map.th

MU.update = (dt) ->
	MU.timer\update(dt)

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

MU.drawInfoBar = () ->
	with love.graphics
		.push!
		.translate(0, Map.ty-(MU.p*1.5)-MU.p/4)
		.setColor(RGB(39,36,37,1))
		.rectangle("fill", 0, 0, .getWidth(), MU.p*1.5)
		.pop!

MU.drawEdgeBars = () ->
	for k, player in pairs(G.PLAYERS)
		x = (k-1) * Map.tw

		for i=1, Map.height
			with love.graphics
				.push!
				.translate(x, (i-1)*MU.p)
				.setColor(player.color)
				if MU.fGS[2] == i
					.setColor(RGB(227, 67, 99, 1))			
				.rectangle("fill", 0, 0, 5, MU.p)
				.rectangle("line", 0, 0, 5, MU.p)
				.pop!

MU.drawPlayerIcon = () ->
	with love.graphics
		.push!
		.setColor(1,1,1,1)
		.setLineWidth(5)
		.circle("line", 0,0, math.floor (MU.p/2)*1.5)
		.pop!
		.setLineWidth(1)

MU.draw = () ->
	with love.graphics
		.push!
		.translate(600, 100)
		MU.drawPlayerIcon!
		.pop!


	-- love.graphics.rectangle("line", 185, 440, 750, 250)
	with love.graphics
		.setColor(RGB(31,31,31,1))
		.rectangle("fill", 0, Map.ty-MU.p/4, .getWidth(), Map.th+MU.p/2)
		-- .setScissor(185, 440, 750, 250)
		.push!
		.scale(MU.s, MU.s)
		.translate(Map.tx, Map.ty)
		.translate(-MU.x*MU.p, -MU.y*MU.p)
		-- MU.drawFocusedEdgeBar!
		MU.drawMap!
		MU.drawEdgeBars!
		MU.drawUnits!
		.pop!

	MU.drawInfoBar()
		-- .setScissor()

MU.drawMap = () ->
	with love.graphics
		-- Draw co-ord numbers
		for y=1, #Map.current
			for x=1, #Map.current[1]
				.setColor(1,1,1,0.5)
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

-- for integer lists only
M.identical = (a, b) ->
	if a == nil or b == nil
		return false
	for i=1, #a
		if a[i] == b[i]
			continue
		else return false
	return true

MU.drawUnit = (o) ->
	with love.graphics
		.push!
		tx, ty = MU.getUnitCenterPxPos(o.x, o.y)

		if Game\isPlanning() and M.identical({o.x, o.y}, MU.sGS or {})
			.translate((love.mouse.getX()-Map.tx-tx), (love.mouse.getY()-Map.ty-ty))

		.setColor(1,1,1,1)
		.circle("fill", tx, ty, 0.4*MU.p)
		.circle("line", tx, ty, 0.4*MU.p, 64)
		.setColor(G.COLORS[o.belongsTo])
		.circle("fill", tx, ty, 0.35*MU.p)
		.circle("line", tx, ty, 0.35*MU.p, 64)
		.setColor(1,1,1,1)
		--assume image 1:1
		iw = o.icon_img\getWidth()
		s = 0.55*MU.p/iw
		love.graphics.setDefaultFilter("nearest", "nearest")
		.draw(o.icon_img, tx-.275*MU.p, ty-.275*MU.p, 0, s, s)
		.setColor(0,0,0,1)
		-- .rectangle("line", (x-1)*p+p/2-.35*p, (y-1)*p+p/2-.35*p, 0.7*p, 0.7*p)
		.setColor(1,1,1,1)
		.pop!


MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			o = Map.getObjAtPos(x, y)
			if o then
				MU.drawUnit(o)

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
