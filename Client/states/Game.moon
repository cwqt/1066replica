MU = require("modules.gui.Map")
Field = require("modules.gui.Field")
Notifications = require("modules.gui.Notifications")

Game = {}

Game.init = () =>
	self.__name__ = "Game"
	log.state("Initialised Game")
	PM.register("Planning")
	PM.register("Command")
	PM.register("Action")
	Game.timer = Timer()

	RM.collect()
	RM.executeCmdQasPlayer()
	-- RM.nextRound()

Game.enter  = (previous)   =>
	log.state("Entered Game")

	Game.cdb = with Game.countdownBar(PM['Planning'].duration)
		.onComplete = -> PM.switch('Command')
		\countdown!

	export ui = UI.Master(8, 5, 140, {
		UI.Container(1,1,8,2, {
			with UI.Text("", 1,1,3,4, "debug")
				.text.font = G.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 4,1,3,4, "gsinfo")
				.text.font = G.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 7,1,3,4, "sgsinfo")
				.text.font = G.fonts["mono"][16]
				.text.color = {1,1,1,1}
			with UI.Text("", 10,1,3,4, "rm")
				.text.font = G.fonts["mono"][16]
				.text.color = {1,1,1,1}
		})
		UI.Container(1,3,8,1, {
			with UI.Button("Finish planning", 1,2,3,1, "finishplanning")
				.text.font = G.fonts["default"][27]
				.text.alignh = "center"
			with UI.Button("End round", 4,2,3,1, "nextround")
				.text.font = G.fonts["default"][27]
				.text.alignh = "center"
				-- .onClick = -> ()
		}, "test")
	})

	UI.id["finishplanning"].onClick = ->
		PM["Planning"].done()
		-- PM.switch("command")
		-- UI.id["test"]\destroy("exitplanning")

	MU.load()
	Notifications.load()
	PM.switch('Planning')

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
	PM[PM.current].update(dt)

Game.draw   = ()   =>
	-- Field.draw()
	ui\draw()
	PM[PM.current].draw()
	MU.draw()
	Game.cdb\draw()
	Notifications.draw()

Game.isPlanning 	 = () => return PM.current == "Planning" and true or false
Game.isCommanding  = () => return PM.current == "Command" and true or false
Game.isAction 		 = () => return PM.current == "Action" and true or false

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