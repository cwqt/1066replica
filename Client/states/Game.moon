MU = require("modules.gui.Map")
Field = require("modules.gui.Field")
Notifications = require("modules.gui.Notifications")

Game = {}

Game.state = {}
Game.state.switch = (state) ->
	if Game.state.current == state
		log.error("Already in current state!")
		return
	if Game.state.current != nil
		Game.state[Game.state.current].exit()
		log.debug("Exited Game state '#{Game.state.current}'")
	Game.state.current = state
	Game.state[Game.state.current].enter()
	log.debug("Entered Game state '#{Game.state.current}'")

Game.state['planning'] = {}
Game.state['planning'].duration = 1
Game.state['planning'].enter = () ->
	Notifications.push(1, 'Planning - Position units', GAME.assets["icons"]["move"], Game.state['planning'].duration, GAME.COLOR)

Game.state['planning'].exit = () ->

Game.state['planning'].update = (dt) ->
Game.state['planning'].draw = () ->
	MU.drawPlanning()


Game.state['command'] = {
	enter: () ->
	exit: () ->
	update: (dt) ->
	draw: () -> love.graphics.print("penus", 10, 10)
}

Game.state['action'] = {
	enter: () ->
	exit: () ->
	update: (dt) ->
	draw: () -> MU.drawPlanning()
}

Game.init = () =>
	log.state("Initialised Game")
	love.math.setRandomSeed(love.timer.getTime())
	Game.timer = Timer()

Game.enter  = (previous)   =>
	log.state("Entered Game")
	Map.set(Map.generate(14, 4))

	Game.cdb = with Game.countdownBar(Game.state['planning'].duration)
		.onComplete = -> Game.state.switch('command')
		\countdown!

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
		Game.state.switch("command")
		-- UI.id["test"]\destroy("exitplanning")

	MU.load()
	Notifications.load()
	Game.state.switch('planning')

	GAME.self = 1
	GAME.opponent = 2

	Player(GAME.self)
	Player(GAME.opponent)

	-- p1 = Player(1)
	-- p2 = Player(2)
	GAME.PLAYERS[GAME.self]\placeUnits({Entity!})
	GAME.PLAYERS[GAME.opponent]\placeUnits({GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!,GAME.UNITS[1]!})

	Field.load()
	RM.nextRound()


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
		@tag = @timer\tween(@time, self, {w: 0}, 'linear', -> @onComplete!)

	finish: () =>
		@timer\cancel(@tag)
		@timer\tween(0.3, self, {w: 0}, 'linear')
		@onComplete()

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
	Game.cdb\update(dt)
	Notifications.update(dt)
	Game.state[Game.state.current].update(dt)

Game.draw   = ()   =>
	Field.draw()
	ui\draw()
	Game.state[Game.state.current].draw()
	MU.draw()
	Game.cdb\draw()
	Notifications.draw()

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