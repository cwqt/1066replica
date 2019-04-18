MU = require("modules.gui.Map")

Game = {}

Game.init = () =>
	log.state("Initialised Game")

Game.enter  = (previous)   =>
	log.state("Entered Game")
	Map.set(Map.generate(14, 4))
	export ui = UI.Master(16, 9, 100, {
		UI.Container(1,1,5,5, {
			with UI.Text("", 1,1,5,10, "debug")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 6,1,5,10, "gsinfo")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 11,1,5,10, "sgsinfo")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
		})
	})

	-- GAME.self = Player(GAME.self)
	-- GAME.opponent = Player(GAME.opponent)
	-- for i=1, 10 do
	-- 	GAME.self\addUnit(GAME.UNITS[1]!)

	p1 = Player(1)
	p2 = Player(2)
	p1\placeUnits({GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!})
	p2\placeUnits({GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!})
	Map.print(Map.current)
	
	-- p3\placeUnits(t)
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
	MU.mousemoved(x,y,dx,dy)

Game.mousereleased = (x, y, button) =>
	ui\mousemoved(x,y,button)

Game.mousepressed = (x, y, button) =>
	ui\mousepressed(x,y,button)
	MU.mousepressed(x, y, button)

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