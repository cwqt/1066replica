Game = {}

Game.init = () =>

Game.enter  = (previous)   =>
	Map.set(Map.generate(10, 5))
	export ui = UI.Master(8, 5, 160, {})
	export p = Player()
	p\addUnit(1,1, Entity())
	print inspect Map.current[1][1]

--LOGIC============================================================

Game.update = (dt) =>
	ui\update()

Game.draw   = ()   =>
	ui\draw()
	Game.drawMap()

--INPUT============================================================

Game.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x,y,dx,dy)

Game.mousereleased = (x, y, button) =>
	ui\mousemoved(x,y,button)

Game.mousepressed = (x, y, button) =>
	ui\mousepressed(x,y,button)

Game.keypressed = (key) =>
	ui\keypressed(key)

Game.textinput = (t) =>
	ui\textinput(t)

--POP  ============================================================

Game.resume = () =>

Game.leave = () =>

Game.quit = () =>

--UI   ============================================================

p = 30
Game.drawMap = () ->
	love.graphics.push()
	love.graphics.translate(10, love.graphics.getHeight()-Map.height*p-10)
	love.graphics.line(0, 0, Map.width*p, 0, Map.width*p, Map.height*p, 0, Map.height*p, 0, 0)
	for i=2, #Map.current[1] do
		love.graphics.line((i-1)*p, 0, (i-1)*p, Map.height*p)
	for i=2, #Map.current do
		love.graphics.line(0, (i-1)*p, Map.width*p, (i-1)*p)

	for y, row in ipairs Map.current
		for x, column in ipairs row
			if column.object
				love.graphics.print(column.object.icon, y*p, x*p)

	love.graphics.pop()

return Game