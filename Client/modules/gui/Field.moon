--basically an alternative view of Map, but showing units
Field = {}

Field.load = () ->
	Field.camera = Camera!
	Field.rows = {}
	initialHeightMap = {}
	for x=1, Map.width
		--use simplex noise to generate height-map for each x point in one row
		i = initialHeightMap
		i[#i+1] = (love.math.noise(x+love.math.random()))*100

	--from this initial height map, create slightly offset points in 
	-- y to form terrain for each 'row'
	for y=1, Map.height
		points = {}
		for k, point in ipairs(initialHeightMap)
			points[#points+1] = (k-.5)*(love.graphics.getWidth()/(Map.width))
			points[#points+1] = point+math.random(20)
		--insert some points finish the polygon
		t = {
			points[#points-1],
			points[#points]+400, --500 down
			points[1],
			points[#points]+400,
			points[1],
			points[2],
		}
		for k, point in ipairs(t) do
			points[#points+1] = point

		table.insert(Field.rows, points)

Field.update = (dt) ->
	Field.camera\update(dt)
	units = Map.returnAllUnits!
	for k, entity in pairs(units) do
		entity.unit\update(dt)

Field.draw = () ->		
	Field.camera\attach!

	with love.graphics
		.push!
		units = Map.returnAllUnits!
		for k, entity in pairs(units) do
			entity.unit\draw!
		.pop!

	-- love.graphics.push()
	-- love.graphics.translate(-100, Map.ty-300)
	-- love.graphics.scale(1.15,1)
	-- for i=1, #Field.rows
	-- 	love.graphics.push()
	-- 	yoffset = 20
	-- 	love.graphics.translate(0, yoffset*i)
	-- 	love.graphics.setColor(i/10, i/10, i/10, 1)
	-- 	love.graphics.polygon("fill", Field.rows[i])
	-- 	love.graphics.pop()
	-- love.graphics.pop()
	-- love.graphics.setColor(1,1,1,1)
	Field.camera\detach!
	Field.camera\draw!

Field.keypressed = (key) ->
	switch key
		when "w"
			print "hllo"

return Field