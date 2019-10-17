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
	Game.startTime = love.timer.getTime!
	Game.endTime = 0

	export ui = UI.Master(8, 4.5, 160, {
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
			with UI.Text("", 10,1,6,4, "player")
				.text.font = G.fonts["mono"][16]
				.text.color = {1,1,1,1}
		})
		UI.Container(1,2,8,1, {
			with UI.Button("End planning", 1,2,2,1, "finishplanning")
				.text.font = G.fonts["default"][16]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("End command", 1,3,2,1, "nextround")
				.text.font = G.fonts["default"][16]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,0,10,0}
				-- .onClick = -> ()
		}, "test")
	})

	print inspect {love.window.getMode()}

	UI.id["finishplanning"].onClick = -> PM["Planning"].done()
	UI.id["nextround"].onClick = -> PM["Command"].done()

	test = G.returnObjectFromType("ENTITY")
	test.belongsTo = G.opponent
	G.PLAYERS[test.belongsTo].units[test.uuid] = test
	Map.addObject(6, 1, test)

	MU.load!
	-- Notifications.load()
	PM.switch('Planning')
	Field.load!

--LOGIC============================================================

Game.update = (dt) =>
	Field.update(dt)
	ui\update()
	MU.update(dt)
	Map.update(dt)
	Infobar.update(dt)
	Game.timer\update(dt)
	-- Notifications.update(dt)
	PM[PM.current].update(dt)

Game.draw   = ()   =>
	love.graphics.print(math.floor(love.timer.getTime! - Game.startTime), love.graphics.getWidth!-200,5)

	Field.draw()
	ui\draw()
	MU.draw()
	PM[PM.current].draw()

	-- Notifications.draw()

Game.isPlanning 	 = () => return PM.current == "Planning" and true or false
Game.isCommanding  = () => return PM.current == "Command" and true or false
Game.isAction 		 = () => return PM.current == "Action" and true or false

--INPUT============================================================

Game.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x,y,dx,dy)
	MU.mousemoved(x,y,dx,dy)
	PM.mousemoved(x,y,dx,dy)

Game.mousereleased = (x, y, button) =>
	ui\mousereleased(x,y,button)
	PM.mousereleased(x, y, button)

Game.mousepressed = (x, y, button) =>
	ui\mousepressed(x,y,button)
	MU.mousepressed(x, y, button)
	PM.mousepressed(x, y, button)

Game.keypressed = (key) =>
	ui\keypressed(key)
	MU.keypressed(key)
	PM.keypressed(key)
	Field.keypressed(key)

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