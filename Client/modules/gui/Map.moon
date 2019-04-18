MU = {}
MU.sGS = nil
MU.fGS = {1,1}
MU.pfGS = {1,1}
MU.mouseOverMap = false
p = 100

MU.update = (dt) ->
	s = ""
	s = "mouseOverMap: #{MU.mouseOverMap}\n"
	s = s .. "fGS: #{inspect MU.fGS}\n"
	s = s .. "pfGS: #{inspect MU.pfGS}\n"
	UI.id["debug"].value = s

	s = ""
	if Map.current[MU.fGS[2]][MU.fGS[1]].object
		s = inspect(Map.current[MU.fGS[2]][MU.fGS[1]].object, {depth:1})
	UI.id["gsinfo"].value = s

	s = ""
	if MU.sGS
		s = inspect(Map.current[MU.sGS[2]][MU.sGS[1]].object, {depth:1})
	UI.id["sgsinfo"].value = s


MU.draw = () ->
	love.graphics.push()
	love.graphics.translate((love.graphics.getWidth()-(Map.width*p))/2, love.graphics.getHeight()-Map.height*p-10)
	MU.drawMap()
	love.graphics.pop()

MU.drawPlanning = () ->
	GAME.self = GAME.self or 1
	x, y, w, h = 0,0,GAME.PLAYERS[GAME.self].margin*p, #Map.current*p
	if GAME.self % 2 == 0
		x = (Map.width-GAME.PLAYERS[GAME.self].margin)*p
	c = M.clone(GAME.COLORS[GAME.self])
	c[4] = 0.5
	love.graphics.setColor(c)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(1,1,1,1)

MU.drawMap = () ->
	if GAME.isPlanning then MU.drawPlanning()

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

MU.drawUnits = () ->
	for y=1, #Map.current
		for x=1, #Map.current[y]
			if Map.current[y][x].object
				o = Map.current[y][x].object
				tx, ty = (x-1)*p+p/2, (y-1)*p+p/2
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

MU.hoverGS = (mx, my) ->
	tx, ty = (love.graphics.getWidth()-(Map.width*p))/2, love.graphics.getHeight()-Map.height*p-10
	if not CD.CheckMouseOver(0, 0, Map.width*p, Map.height*p, tx, ty)
		MU.mouseOverMap = false
	else
		MU.mouseOverMap = true
		gx = math.ceil((mx-tx)/p)
		gy = math.ceil((my-ty)/p)
		if not M.same(MU.fGS, {gx, gy})
			MU.pfGS = MU.fGS
			MU.fGS = {gx, gy}
			-- log.trace("Delta #{inspect MU.pfGS} -> #{inspect MU.fGS}")

MU.mousemoved = (x, y, dx, dy) ->
	MU.hoverGS(x, y)

MU.mousepressed = (x, y, button) ->
	if MU.mouseOverMap and button == 1
		if Map.current[MU.fGS[2]][MU.fGS[1]].object
			MU.sGS = MU.fGS





return MU