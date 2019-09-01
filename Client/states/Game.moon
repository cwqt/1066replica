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

	UI.id["finishplanning"].onClick = -> PM["Planning"].done()
	UI.id["nextround"].onClick = -> PM["Command"].done()

	MU.load()
	-- Notifications.load()
	PM.switch('Planning')

--LOGIC============================================================

Game.update = (dt) =>
	ui\update()
	MU.update(dt)
	Map.update(dt)
	Game.timer\update(dt)
	-- Notifications.update(dt)
	PM[PM.current].update(dt)

Game.draw   = ()   =>
	-- Field.draw()
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