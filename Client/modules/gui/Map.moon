MU = {}
MU.fGS = {1,1}
MU.pfGS = {1,1}
p = 50

MU.update = (dt) ->

MU.draw = () ->
	love.graphics.push()
	love.graphics.translate((love.graphics.getWidth()-(Map.width*p))/2, love.graphics.getHeight()-Map.height*p-10)
	MU.drawMap()
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

MU.drawUnits = () ->
	for y, row in ipairs Map.current
		for x, column in ipairs row
			if column.object
				love.graphics.circle("fill", (x-1)*p+p/2, (y-1)*p+p/2, p/3)
				-- love.graphics.print(column.object.icon, x*p, y*p)

MU.hoverGS = (mx, my) ->
	tx, ty = (love.graphics.getWidth()-(Map.width*p))/2, love.graphics.getHeight()-Map.height*p-10
	if CD.CheckMouseOver(0, 0, Map.width*p, Map.height*p, tx, ty)
		gx = math.ceil((mx-tx)/p)
		gy = math.ceil((my-ty)/p)
		if not M.same(MU.fGS, {gx, gy})
			MU.pfGS = MU.fGS
			MU.fGS = {gx, gy}
			-- log.trace("Delta #{inspect MU.pfGS} -> #{inspect MU.fGS}")

return MU