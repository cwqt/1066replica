Generic = require("components.behaviours.Generic")

class Move extends Generic
	new: (...) =>
		super(...)
		@path = {0,0,0,0}
		@finished = false
		@updateCurrentPath!

	drawRange: () =>

	drawLine: () =>
		love.graphics.setLineWidth(10)
		x = [((p-1) * MU.p)+MU.p/2 for _, p in ipairs @path]
		love.graphics.line(x)

	drawLineArrow: () =>
		-- get last 4 elements in path
		p = @path
		x = {p[#p-3], p[#p-2], p[#p-1], p[#p]}
		-- get amount of rotation required for arrow
		-- to face end direction
		rx, ry = Map.getDirection(unpack(x))
		rf = 90 - math.deg(math.atan2(ry, rx))
		with love.graphics
			-- Offset to end of line position
			.translate((p[#p-1]-1)*MU.p, (p[#p]-1)*MU.p)
			-- Offset to GS center
			.translate(MU.p/2, MU.p/2)
			-- Rotate about the center of GS
			G.pushRotate(0, 0, math.rad(rf))
			-- Translate triangle back to center.
			.translate(-MU.p/2, -MU.p/2)
			.polygon("fill", 5, 10, MU.p-5, 10, MU.p/2, MU.p/2+10)
			.pop!

	draw: () =>
		if @path
			with love.graphics
				.push!
				.translate(Map.tx, Map.ty)
				@drawRange!
				@drawLine!
				@drawLineArrow!
				.pop!

	update: (dt) =>

	mousepressed: (x, y, button) =>
		if button == 1
			if @path then @finish!

	finish: () =>
		@finished = true
		super\finish(@path)

	mousemoved: (x, y, dx, dy) =>

	onGSChange: () =>
		if not @finished
			@updateCurrentPath!

	updateCurrentPath: () =>
		-- stop jumper path.filter crash
		if M.identical(MU.sGS, MU.fGS)
			return

		path = Map.findPath(@o.x, @o.y, unpack(MU.fGS))
		if path then @path = M.flatten(path)

return Move