class Unit
	new: (@o) =>
		@count = 5
		@image = G.image
		@timer = Timer!		
		@coords = {}
		for i=1, @count do
			@coords[i] = {
				x: (i-1)*75,
				y: math.random(-10, 10)
				r: 0
			}
		for i=1, @count do
			with @timer
				\after {0,0.1}, ->
					\every 1, ->
						\tween 0.5, @coords[i], {r: math.rad(5)}, "linear", ->
							\tween 0.5, @coords[i], {r: math.rad(-5)}, "linear"
					\every 0.5, ->
						\tween .25, @coords[i], {y: @coords[i].y+10}, "linear", ->
							\tween .25, @coords[i], {y: @coords[i].y-10}, "linear"


	update: (dt) =>
		@timer\update(dt)

	draw: () =>
		with love.graphics
			.setColor(1,1,1,1)
			.push!
			-- .translate(0, -400)
			for i=1, @count do
				.push!
				.translate(@coords[i].x, @coords[i].y)
				G.pushRotate(@image\getWidth!/2, @image\getHeight!/2, @coords[i].r)
				.draw(@image, 0, 0)
				for i=1, 2 do .pop!
			.pop!

return Unit