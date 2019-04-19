MU = require("modules.gui.Map")

Game = {}

Game.init = () =>
	log.state("Initialised Game")
	Game.timer = Timer()

Game.enter  = (previous)   =>
	log.state("Entered Game")
	Map.set(Map.generate(14, 4))
	export ui = UI.Master(16, 9, 100, {
		UI.Container(1,1,8,4, {
			with UI.Text("", 1,1,5,8, "debug")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 6,1,5,8, "gsinfo")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 11,1,5,8, "sgsinfo")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 16,1,5,8, "rm")
				.text.font = GAME.fonts["mono"][16]
				.text.color = {1,1,1,1}
		})
		UI.Container(2,5, 14, 1, {
			with UI.Button("Exit planning", 1,1,5,2, "exitplanning")
				.text.font = GAME.fonts["default"][27]
				.text.alignv = "center"
				.text.alignh = "center"
				.m = {0,0,30,0}
			with UI.Button("End round", 6,1,5,2, "nextround")
				.text.font = GAME.fonts["default"][27]
				.text.alignv = "center"
				.text.alignh = "center"
				.m = {0,0,30,10}
				.onClick = -> RM.executeCommands()
		}, "test")
	})
	UI.id["exitplanning"].onClick = ->
		Game.exitPlanning()
		-- UI.id["test"]\destroy("exitplanning")

	MU.load()
	Game.enterPlanning()

	GAME.self = 1
	GAME.opponent = 2

	Player(GAME.self)
	Player(GAME.opponent)

	Game.cbd = Game.countdownBar(5)
	Game.cbd\countdown()
	Game.cbd.onComplete = -> Game.exitPlanning()


	-- p1 = Player(1)
	-- p2 = Player(2)
	-- p1\placeUnits({GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!})
	-- p2\placeUnits({GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!})
	
	-- p3\placeUnits(t)
	-- export p = Player()
	-- p\addUnit(1,1, Entity())
	-- p\addUnit(1,1, Entity())
	-- p\addUnit(4,1, Entity())
	-- -- print inspect Map.current[1][1]

	-- GAME.self = 1
	-- GAME.opponent = 2
	-- GAME.PLAYERS[GAME.self]\addCommand(-> Map.current[1][1].object\move(5, 1))
	-- GAME.PLAYERS[GAME.opponent]\addCommand(-> Map.current[1][11].object\move(11, 3))
	-- GAME.PLAYERS[GAME.opponent]\addCommand(-> Map.current[1][12].object\move(11, 4))

	-- RM.pushCmd(1, -> Map.current[1][1].object\move(5, 1))
	-- RM.executeCommands()
	-- RM.pushCmd(1, -> Map.current[1][1].object\move(4, 1))
	-- RM.executeCommands()
	-- RM.pushCmd(1, -> Map.current[1][1].object\move(3, 1))
	-- RM.executeCommands()


class Game.countdownBar
	new: (@time) =>
		@timer = Timer()
		@otime = @time
		@w = Map.width*MU.p
		@ow = @w

	update: (dt) =>
		@timer\update(dt)

	draw: () =>
		love.graphics.rectangle("fill", Map.tx, Map.ty-4, @w, 4)

	countdown: () =>
	  @timer\tween(@time, self, {w: 0}, 'linear', -> @onComplete())

	onComplete: () =>

	setTime: (x) =>
		@time = x
		@otime = @time

	reset: () =>
		@w = @ow

--LOGIC============================================================

Game.update = (dt) =>
	ui\update()
	MU.update(dt)
	Game.timer\update(dt)
	Game.cbd\update(dt)

Game.draw   = ()   =>
	ui\draw()
	MU.draw()
	Game.cbd\draw()

Game.enterPlanning = () ->
	log.debug("Entered Planning stage")
	Game.isPlanning = true

Game.exitPlanning = () ->
	log.debug("Exited Planning stage")
	Game.isPlanning = false

--INPUT============================================================

Game.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x,y,dx,dy)
	MU.mousemoved(x,y,dx,dy)

Game.mousereleased = (x, y, button) =>
	ui\mousereleased(x,y,button)

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