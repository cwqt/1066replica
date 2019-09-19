class Unit
	new: (@count=100) =>
		@image = G.image
		g = anim8.newGrid(32, 32, @image\getWidth(), @image\getHeight())
		@animation = anim8.newAnimation(g("1-4",1), 0.1)

	update: (dt) =>
		@animation\update(dt)

	draw: () =>
		love.graphics.setColor(1,1,1,1)
		@animation\draw(@image, 0, 0)

return Unit