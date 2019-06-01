class Notification
	new: (@text, @duration=3, @icon, @color) =>
		@color = @color or {0.4, 0.4, 0.4, 1}
		@width = GAME.fonts.text[27]\getWidth(@text) + 20
		@height = 40

		@padding = 10
		p = @padding
		@xoffset = -(@width+2*p)
		@timer = Timer()
		@timer\tween(0.4, self, {xoffset: 0}, 'out-quad')
		@timer\after(@duration, -> @destroy())

		-- generate a 'rocky' looking polygon
		love.math.setRandomSeed(love.timer.getTime())
		-- initial polygon 
		@polygon = {
			{0, 0},
			{@width+(2*p), 0},
			{@width+(2*p), @height+(2*p)},
			{0, @height+(2*p)},
			{0, 0}
		}
		do
			p = {0,0}
			for i=1, #@polygon-1
				--5 points of interpolation between x, x+1 etc.
				for k=1, 5
					--x, y, slightly offset each point by -1,1
					p[#p+1] = @polygon[i][1] + k*(@polygon[i+1][1]-@polygon[i][1])/5
					p[#p] += love.math.random(-2, 2)
					p[#p+1] = @polygon[i][2] + k*(@polygon[i+1][2]-@polygon[i][2])/5
					p[#p] += love.math.random(-2, 2)
			@polygon = {}
			@polygon = p

		print inspect @polygon

	update: (dt) =>
		@timer\update(dt)

	draw: (x=0, y=0) =>
		love.graphics.push()
		love.graphics.translate(@xoffset, y)
		love.graphics.setColor(@color)
		love.graphics.polygon('fill', @polygon)
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(GAME.fonts.text[27])
		p = 10
		love.graphics.print(@text, 2*p, p)
		love.graphics.setFont(GAME.fonts.mono[16])
		love.graphics.setColor(1,1,1,1)
		love.graphics.pop()

	destroy: () =>
		@timer\tween(0.4, self, {xoffset: -(@width+2*@padding+5)}, 'out-quad', -> @timer\destroy())

return Notification
