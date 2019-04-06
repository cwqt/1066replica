MainMenu = {}

MainMenu.resume = () =>

MainMenu.init = () =>

MainMenu.enter  = ()   =>
	export timer = Timer()
	export ui = UI.Master(8, 5, 160, {
		UI.Container(2,1,6,4, {
			with UI.Text("alias", 1,2,12,2)
				.text.font = GAME.fonts.title[100]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,10,10}
			with UI.Image(love.graphics.newImage("crying.jpg"), 1,1,5,4)
				.p = {20,20,20,20}
			with UI.TextInput("178.62.42.106", 8,5,3,1, "ip")
				.text.font = GAME.fonts.default[27]
				.text.alignv = "center"
			with UI.Button("Connect", 11,5,2,4, "connect")
				.text.font = GAME.fonts.default[27]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,40,10}
			with UI.Text("Connecting...", 8,6,3,1, "info")
				.text.font = GAME.fonts.default[27]
				.text.alignv = "center"
			UI.Checkbox(false, 7,5,1,1)
			UI.Slider(0, 10, 1, 1, 5, 5, 2, "slider")
		})
	})

	UI.id["connect"].onClick = ->
		UI.id['info'].value = UI.id['slider'].thx


--LOGIC============================================================

MainMenu.update = (dt) =>
	timer\update(dt)
	ui\update(dt)

MainMenu.draw   = ()   =>
	ui\draw()
	love.graphics.print(love.timer.getFPS().."FPS", love.window.getMode()-40, 0)
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)

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
