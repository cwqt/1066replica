MainMenu = {}

MainMenu.init = () =>
	self.__name__ = "MainMenu"
	log.state("Initialised MainMenu")

MainMenu.enter  = (previous) =>
	log.state("Entered MainMenu")
	export timer = Timer()
	export ui = UI.Master(8, 5, 140, {
		UI.Container(2,1,6,4, {
			with UI.Text("game", 1,2,12,2)
				.text.font = G.fonts.title[216]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,10,10}
				.text.color = {1,1,1}
			with UI.Button("Ping", 13,1,2,1, "ping")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"

			with UI.Button("Local", 4,9,3,1, "startlocal")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("Multi-player", 7,9,3,1, "startmulti")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"


			with UI.Text("Matchmaking", 1, 5, 3, 1)
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}
				.text.alignv = "center"
				.text.alignh = "right"
			with UI.TextInput("http://localhost:3001", 4, 5, 5, 1, "uri")
				.text.font = G.fonts.default[27]				
				.text.alignv = "center"
			with UI.Button("Connect", 10,5,2,1, "connect_matchmaker")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"

			with UI.Text("Username", 1, 6, 3, 1)
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}
				.text.alignv = "center"
				.text.alignh = "right"
			with UI.TextInput("test", 4, 6, 3, 1, "username")
				.text.font = G.fonts.default[27]	
				.text.alignv = "center"

			with UI.Text("Password", 1, 7, 3, 1)
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}
				.text.alignv = "center"
				.text.alignh = "right"
			with UI.TextInput("test", 4, 7, 3, 1, "password")
				.text.font = G.fonts.default[27]				
				.text.alignv = "center"
			
			with UI.Button("Log in", 10,7,2,1, "login_user_server")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Button("Log out", 8,7,2,1, "logout_user_server")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"

			with UI.Text("", 1, 8, 12, 1, "debug_message")
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}

		})
	})

	UI.id["connect_matchmaker"].onClick = ->
		UI.id["debug_message"].value = "Attempting to connect..."
		if isConnected then return
		isConnected = NM.startClient()
		if isConnected
			UI.id["debug_message"].value = "Connected to Matchmaker"
		else
			UI.id["debug_message"].value = "Couldn't connect"

	UI.id["ping"].onClick = ->
		NM.sendDataToServer({
			type: "PING",
			payload: socket.gettime()
		})

	UI.id["login_user_server"].onClick = () ->
		username = UI.id["username"].value
		password = UI.id["password"].value
		success, message = USI.login(username, password)
		UI.id["debug_message"].value = message

	UI.id["logout_user_server"].onClick = () ->
		username = UI.id["username"].value
		success, message = USI.logout(username)
		UI.id["debug_message"].value = message

	UI.id["startlocal"].onClick = ->
		G.instantiatePlayers(1, 2)
		Gamestate.switch(UnitSelect)

	UI.id["startmulti"].onClick = ->
		G.isLocal = false
		Gamestate.switch(MWS)

	-- UI.id["startlocal"].onClick()

--LOGIC============================================================

MainMenu.update = (dt) =>
	timer\update(dt)
	ui\update(dt)

MainMenu.draw   = ()   =>
	with love.graphics
		.push!
		.scale(0.8)
		.draw(G.assets["bg"])
		.pop!

	ui\draw()
	UC.draw()

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
