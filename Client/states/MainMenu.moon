MainMenu = {}

MainMenu.init = () =>
	self.__name__ = "MainMenu"
	log.state("Initialised MainMenu")

MainMenu.enter  = (previous) =>
	log.state("Entered MainMenu")
	export timer = Timer()
	export ui = UI.Master(8, 5, 140, {
		UI.Container(2,1,6,4, {
			with UI.Text("alias", 1,4,12,2)
				.text.font = G.fonts.title[216]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,10,10}
				.text.color = {1,1,1}
			with UI.Button("Ping", -1,1,2,1, "ping")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("multi-player", 8,7,3,1, "startmulti")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("local", 3,7,2,1, "startlocal")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("reconnect", 5,7,3,1, "retry_connect")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Text("Attempting to connect...", 1, 8, 12, 1, "debug_message")
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}
		})
	})

	-- Attempt to connect to the server
	isConnected = NM.startClient()
	if isConnected
		UI.id["debug_message"].value = "Connected to Server."
	else
		UI.id["debug_message"].value = "Cannot connect to Server."

	UI.id["retry_connect"].onClick = ->
		if isConnected then return
		isConnected = NM.startClient()
		if isConnected
			UI.id["debug_message"].value = "Connected to Server."
		else
			UI.id["debug_message"].value = "Couldn't connect."

	UI.id["ping"].onClick = ->
		NM.sendDataToServer({
			type: "PING",
			payload: socket.gettime()
		})

	UI.id["startlocal"].onClick = ->
		G.instantiatePlayers(1, 2)
		Gamestate.switch(UnitSelect)

	UI.id["startmulti"].onClick = ->
		if isConnected
			G.isLocal = false
			Gamestate.switch(MWS)

	UI.id["startlocal"].onClick()

--LOGIC============================================================

MainMenu.update = (dt) =>
	timer\update(dt)
	ui\update(dt)

MainMenu.draw   = ()   =>
	with love.graphics
		.push!
		.scale(1.4)
		.draw(G.assets["bg"])
		.pop!

	ui\draw()

--INPUT============================================================

MainMenu.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x, y, dx, dy)

MainMenu.mousereleased = (x, y, button) =>
	ui\mousereleased(x, y, button)

MainMenu.mousepressed = (x, y, button) =>
	ui\mousepressed(x, y, button)

MainMenu.keypressed = (key) =>
	ui\keypressed(key)

MainMenu.textinput = (t) =>
	ui\textinput(t)

--POP  ============================================================
MainMenu.resume = () =>
	log.state("Resumed MainMenu")

MainMenu.leave = () =>
	log.state("Left MainMenu")

MainMenu.quit = () =>
	log.state("Quit MainMenu")

return MainMenu
