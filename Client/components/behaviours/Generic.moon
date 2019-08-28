class Generic
	new: (@o) =>
		@finish!

	update: (dt) =>

	draw: () =>
		love.graphics.print("hello", 500, 500)

	mousepressed: (x, y, button) =>

	mousemoved: (x, y, dx, dy) =>

	onGSChange: () =>

	finish: (payload) =>
		log.trace("Command input #{@@.__name} finished.")
		@o\pushCommand({
			type: string.upper(@@.__name),
			payload: payload or nil
		})
		@o\requestCommandFinish!

return Generic