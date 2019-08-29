class Generic
	new: (@o) =>
	update: (dt) =>
	draw: () =>
	mousepressed: (x, y, button) =>
	mousemoved: (x, y, dx, dy) =>
	onGSChange: () =>

	finish: (payload) =>
		log.trace("Command input #{string.upper @@.__name} finished.")
		@o\pushCommand({
			type: string.upper(@@.__name),
			payload: payload or nil
		})
		@o\requestCommandFinish!

return Generic