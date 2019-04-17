MU = require("modules.gui.Map")

Game = {}

Game.init = () =>
	log.state("Initialised Game")

Game.enter  = (previous)   =>
	log.state("Entered Game")
	Map.set(Map.generate(30, 5))
	export ui = UI.Master(16, 9, 100, {

	})
	-- export p = Player()
	-- p\addUnit(1,1, Entity())
	-- p\addUnit(1,1, Entity())
	-- p\addUnit(4,1, Entity())
	-- -- print inspect Map.current[1][1]
	-- RM.pushCmd(1, -> Map.current[1][1].object\move(5, 1))
	-- RM.executeCommands()
	-- RM.pushCmd(1, -> Map.current[1][1].object\move(4, 1))
	-- RM.executeCommands()
	-- RM.pushCmd(1, -> Map.current[1][1].object\move(3, 1))
	-- RM.executeCommands()


--LOGIC============================================================

Game.update = (dt) =>
	ui\update()
	MU.update(dt)

Game.draw   = ()   =>
	ui\draw()
	MU.draw()

--INPUT============================================================

Game.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x,y,dx,dy)
	MU.hoverGS(x, y)

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
	log.state("Resumed Game")

Game.leave = () =>
	log.state("Left Game")

Game.quit = () =>
	log.state("Quit Game")

return Game