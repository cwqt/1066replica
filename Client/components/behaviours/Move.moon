Move = {}

Move.obj = {}
Move.path = {0,0,0,0}

Move.init = (obj) ->
	Move.obj.o = obj

Move.drawRange = (range) ->

Move.draw = () ->
	if Move.path
		with love.graphics
			.push!
			.translate(Map.tx, Map.ty)
			.setLineWidth(10)
			x = [((p-1) * MU.p)+MU.p/2 for _, p in ipairs Move.path]
			.line(x)
			.pop!

Move.update = (dt) ->

Move.mousepressed = (x, y, button) ->
 
Move.mousemoved = (x, y, dx, dy) ->

Move.onGSChange = () ->
	Move.updateCurrentPath!

Move.updateCurrentPath = () ->
	-- stop jumper path.filter crash
	if M.identical(MU.sGS, MU.fGS)
		return

	path = Map.findPath(Move.obj.o.x, Move.obj.o.y, unpack(MU.fGS))
	if path then Move.path = M.flatten(path)

return Move