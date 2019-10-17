class timerBar
	new: (@length) =>
		@olength = @length
		@timer = Timer!
		@color = G.PLAYERS[G.self].color["light"]
		@height = 2
		@y = Infobar.ty-@height
		-- goes from left to right
		@startx, @endx = Infobar.tx+Infobar.tw, Infobar.tx-Infobar.tw
		if G.playerIsOnLeft(G.self) then
			@startx, @endx = Infobar.tx, Infobar.tw
		@visibility = true

	setVisibility: (visible) =>
		-- Hide bar behind infobar, prevent double 'hides'/'shows'
		if not visible and @visibility then 
			@timer\tween 0.5, self, {y:@y+@height}, "linear"
		if visible and not @visibility then
			@timer\tween 0.5, self, {y:@y-@height}, "linear"		
		@visibility = visible

	countdown: () =>
		@timer\tween @length, self, {endx: Infobar.tw-@endx}, "linear"

	reset: () =>
		@length = @olength

	set: (time) =>
		@olength = time
		@reset!

	forceFinish: () =>

	update: (dt) =>
		@timer\update(dt)

	draw: () =>
		with love.graphics
			.setColor(@color)
			.rectangle("fill", @startx, @y, @endx, @height)

return timerBar