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

MU.draw = () ->
	with love.graphics
		.push!
		.translate(Map.tx, Map.ty)
		MU.drawMap!
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
				.setColor(1,1,1,0.5)
				.print("#{x},#{y}", (x-1)*MU.p, (y-1)*MU.p)

				clrStack = Map.current[y][x].colorStack
				.setColor(unpack(clrStack[#clrStack]))
				.rectangle("fill", (x-1)*MU.p, (y-1)*MU.p, MU.p, MU.p)

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

MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			o = Map.getObjAtPos(x, y)
			if o then
				love.graphics.push()
				tx, ty = MU.getUnitCenterPxPos(o.x, o.y)
 
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
				love.graphics.draw(o.icon_img, tx-.275*MU.p, ty-.275*MU.p, 0, s, s)
				love.graphics.setColor(0,0,0,1)
				-- love.graphics.rectangle("line", (x-1)*p+p/2-.35*p, (y-1)*p+p/2-.35*p, 0.7*p, 0.7*p)
				love.graphics.setColor(1,1,1,1)
				love.graphics.pop()

MU.onGSChange = () ->
	PM[PM.current].onGSChange()

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

MU.deselectGS = () ->
	if MU.sGS
		log.debug("Deselected #{inspect MU.sGS} :: #{MU.sGSo.__class.__name}")
		MU.sGS = nil
		MU.sGSo = nil

MU.pushGSColor = (x, y, color) ->
	gsc = Map.getGSAtPos(x, y).colorStack
	if M.identical(color, gcs[#gcs]) then return
	table.insert(gcs, color)

MU.popGSColor = (x, y) ->
	gsc = Map.getGSAtPos(x, y).colorStack
	if #gcs > 1
		table.remove(gcs, #fcs)

return MU
