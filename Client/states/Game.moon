MU = require("modules.gui.Map")
Field = require("modules.gui.Field")
Notifications = require("modules.gui.Notifications")

Game = {}

Game.phase = {}
Game.phase.register = (phase) ->
	Game.phase[phase] = require("states.phases." .. (phase\gsub('^%l', string.upper)))
	Game.phase[phase].firstTime = true

Game.phase.switch = (state) ->
	if Game.phase.current == state
		log.error("Already in current state!")
		return

	if Game.phase.current != nil
		Game.phase[Game.phase.current].exit()
		log.phase("Exited Game phase '#{Game.phase.current}'")
	Game.phase.current = state

	if Game.phase[Game.phase.current].firstTime
		Game.phase[Game.phase.current].firstTime = false
		log.phase("Initialised Game phase '#{Game.phase.current}'")
		Game.phase[Game.phase.current].initialise()

	log.phase("Entered Game phase '#{Game.phase.current}'")
	Game.phase[Game.phase.current].enter()

Game.init = () =>
	log.state("Initialised Game")
	Game.phase.register("planning")
	Game.phase.register("command")
	Game.phase.register("action")
	Game.timer = Timer()

	RM.collect()
	RM.sort()
	RM.executeCmdQasPlayer()
	-- RM.nextRound()

Game.enter  = (previous)   =>
	log.state("Entered Game")

	Game.cdb = with Game.countdownBar(Game.phase['planning'].duration)
		.onComplete = -> Game.phase.switch('command')
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
				-- .onClick = -> ()
		}, "test")
	})

	UI.id["exitplanning"].onClick = ->
		Game.phase.switch("command")
		-- UI.id["test"]\destroy("exitplanning")

	MU.load()
	Notifications.load()
	Game.phase.switch('planning')

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
	Game.phase[Game.phase.current].update(dt)

Game.draw   = ()   =>
	-- Field.draw()
	ui\draw()
	Game.phase[Game.phase.current].draw()
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