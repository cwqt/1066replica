class Notification
	new: (@text, @icon, @direction, @color) =>
		@color = @color or {0.4, 0.4, 0.4, 1}
		@width = GAME.fonts.text[27]\getWidth(@text) + 20
		@height = 40

		if @icon
			@icon = {img: @icon, scale: (@height-10)/@icon\getHeight()}
			@icon.w = @icon.img\getWidth()*@icon.scale
			@icon.h = @icon.img\getHeight()*@icon.scale
			@width += @icon.w

		@padding = 10
		p = @padding
		@xoffset = @direction*(@width+2*p)
		@timer = Timer()

		@timer\tween(0.4, self, {xoffset: 0}, 'out-quad')

		-- generate a 'rocky' looking polygon
		-- initial polygon 
		@polygon = {
			{0, 0},
			{@width+(4*p), 0},
			{@width+(4*p), @height+(2*p)},
			{0, @height+(2*p)},
			{0, 0}
		}
		do
			p = {0,0}
			for i=1, #@polygon-1
				--5 points of interpolation between x, x+1 etc.
				for k=1, 5
					--x, y, slightly offset each point by -n, n
					p[#p+1] = @polygon[i][1] + k*(@polygon[i+1][1]-@polygon[i][1])/5
					p[#p] += love.math.random(-1, 1)
					p[#p+1] = @polygon[i][2] + k*(@polygon[i+1][2]-@polygon[i][2])/5
					p[#p] += love.math.random(-1, 1)
			@polygon = {}
			@polygon = p
		-- print inspect @polygon

	update: (dt) =>
		@timer\update(dt)

	draw: (x=0, y=0) =>
		love.graphics.push()
		love.graphics.translate(x+@xoffset, y)
		love.graphics.setColor(@color)
		love.graphics.polygon('fill', @polygon)
		-- love.graphics.setColor(0,0,0,1)
		-- love.graphics.rectangle('line', @padding, @padding, @width, @height)
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(GAME.fonts.text[27])
		p = 10
		if @icon
			if @direction == -1
				love.graphics.draw(@icon.img, 1.25*p, 1.5*p, 0, @icon.scale, @icon.scale)
				love.graphics.print(@text, @icon.w+(2.5*p), p)
			else -- right side, flip image position
				love.graphics.draw(@icon.img, @width-@icon.w, 1.5*p, 0, @icon.scale, @icon.scale)
				love.graphics.print(@text, p, p)
		else
			love.graphics.print(@text, 2*p, p)
		love.graphics.setFont(GAME.fonts.mono[16])
		love.graphics.setColor(1,1,1,1)
		love.graphics.pop()

	destroy: () =>
		@timer\tween(0.4, self, {xoffset: @direction*(@width+2*@padding+5)}, 'out-quad', -> @timer\destroy())
