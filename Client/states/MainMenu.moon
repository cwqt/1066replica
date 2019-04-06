MainMenu = {}

MainMenu.resume = () =>

MainMenu.init = () =>

MainMenu.enter  = ()   =>
	export timer = Timer()
	export ui = UI.Master(8, 5, 160, {
		UI.Container(2,1,6,4, {
			with UI.Text("alias", 1,2,12,2)
				.text.font = GAME.fonts.title[216]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,10,10}
			with UI.TextInput("localhost", 4,5,4,1, "ip")
				.m = {0, 10, 0, 0}
				.text.font = GAME.fonts.default[27]
				.text.alignv = "center"
			with UI.Button("Connect", 8,5,2,1, "connect")
				.text.font = GAME.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
			with UI.Text("", 4,6,5,1, "info")
				.text.font = GAME.fonts.default[27]
				.text.alignv = "center"
		})
	})

	UI.id["connect"].onClick = ->
		z = NM.startClient(UI.id["ip"].value)

--LOGIC============================================================

MainMenu.update = (dt) =>
	timer\update(dt)
	ui\update(dt)

MainMenu.draw   = ()   =>
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

MainMenu.leave = () =>

MainMenu.quit = () =>

return MainMenu
