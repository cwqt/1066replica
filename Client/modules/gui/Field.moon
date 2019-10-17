--basically an alternative view of Map, but showing units
Field = {}
Field.load = () ->
	Field.row = {
		width: 425
		height: 100
		zdist: 50
	}
	Field.p = Field.row.width
	Field.w = Field.p*Map.width
	Field.focusPoint = {
		x: Field.w/2 
		y: 0
		scale: love.graphics.getWidth!/Field.w
	}
	Field.timer = Timer!

	Field.camera = Camera(Field.focusPoint.x, Field.focusPoint.y)
	Field.camera.scale = Field.focusPoint.scale

	print Field.w
	print Field.camera.x
	-- Game.timer\after 1, ->
	-- 	Field.lookAt(1, 1)
	-- Game.timer\after 2, ->
	-- 	Field.lookAt(5, 1)
	-- Game.timer\after 3, ->
	-- 	Field.lookAt(3, 1)

Field.update = (dt) ->
	Field.timer\update(dt)
	Field.camera\update(dt)
	Field.camera\follow(Field.focusPoint.x, Field.focusPoint.y)

	units = Map.returnAllUnits!
	for k, entity in pairs(units) do
		entity.unit\update(dt)

Field.lookAt = (x, y, scale=0.5, duration=.5) ->
	Field.timer\tween duration, Field.focusPoint, {
		x: x*Field.p
		y: (y-1)*Field.p
		scale: scale
	}, 'in-out-cubic'

Field.draw = () ->
	Field.camera\attach!
	--reverse for z-index
	for y=Map.height, 1, -1 do
		with love.graphics
			.push!
			-- print inspect {Field.camera\toCameraCoords(Field.focusPoint.x, Field.focusPoint.y)}
			-- print inspect {Field.camera\toCameraCoords(Field.camera.x, Field.camera.y)}

			-- .translate(-1000, -500)
			tx, ty = Field.camera\toWorldCoords(Field.camera.x, Field.camera.y)
			tx = tx * Field.focusPoint.scale / 4
			ty = ty * Field.focusPoint.scale

			.translate(0, -y*Field.row.zdist)
			--.translate(tx*y ,0)

			.setColor(0.5,0.2,1,1)
			-- if math.abs(math.ceil(Field.camera.y/Field.p)) == y then
			-- 	.setColor(.2,.2,1,1)

			.rectangle("fill", 0, 0, Field.p*Map.width, 100)
			.setColor(0,0,0,1)
			for i=1, Map.width
				.rectangle("line", 0, 0, Field.p*i, 100)
			.setColor(1,1,1,1)


			.push!
			for x=1, Map.width
				o = Map.getObjAtPos(x, y)
				if o then
					.push!
					.translate((o.x-1)*Field.p, -160)
					o.unit\draw!
					.pop!
			.pop!

			.setColor(1,1,1,1)
			.circle("fill", Field.w/2, 0, 10)
			.circle("fill", Field.camera.x, Field.camera.y, 10)
			.line(Field.w/2, 0, Field.camera.x, Field.camera.y)

			.pop!
	Field.camera\detach!
	Field.camera\draw!

	tx, ty = Field.camera\toWorldCoords(Field.focusPoint.x, Field.focusPoint.y)
	love.graphics.circle("fill", Field.camera.x, Field.camera.y, 10)
	love.graphics.circle("fill", love.graphics.getWidth!/2, love.graphics.getHeight!/2, 10)
	love.graphics.circle("fill", tx, ty, 10)


Field.keypressed = (key) ->
	switch key
		when "s"
			Game.timer\tween 0.1, Field.focusPoint, {y: Field.camera.y+Field.p/2}, 'linear'
		when "w"
			Game.timer\tween 0.1, Field.focusPoint, {y: Field.camera.y-Field.p/2}, 'linear'
		when "d"
			Game.timer\tween 0.1, Field.focusPoint, {x: Field.camera.x+Field.p/2}, 'linear'
		when "a"
			Game.timer\tween 0.1, Field.focusPoint, {x: Field.camera.x-Field.p/2}, 'linear'

return Field