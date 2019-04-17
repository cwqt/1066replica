UnitSelect = {}
UnitSelect.peerReady = false
UnitSelect.ready = false

UnitSelect.init = () =>
	log.state("Initialised UnitSelect")

UnitSelect.enter  = (previous)   =>
	log.state("Entered UnitSelect")
	export ui = UI.Master(16, 9, 100, {
		UI.Container(1,4,5,5, {
			UI.Text("Entity",1,1,4,2)
			UI.Text("0",9,1,2,2, "cnt")
			with UI.Button("+", 7,1,2,2, "inc")
				.text.alignh = "center"
			with UI.Button("-", 5,1,2,2, "dec")
				.text.alignh = "center"
			UI.Text("",9,5,10,2, 'info')
			with UI.Button("Enter game",1,5,8,2)
				.onClick = ->
					UnitSelect.ready = true
					UI.id["info"].value = "Waiting for peer"
					NM.sendDataToPeer({200})
		})
	})

	v = 0
	UI.id["inc"].onClick = ->
		v += 1
		UI.id["cnt"].value = v

	UI.id["dec"].onClick = ->
		v -= 1
		UI.id["cnt"].value = v 

--LOGIC============================================================
UnitSelect.update = (dt) =>
	ui\update(dt)
	if UnitSelect.ready and UnitSelect.peerReady
		Gamestate.switch(Game)

UnitSelect.draw   = ()   =>
	ui\draw()

--INPUT============================================================
UnitSelect.mousemoved = (x, y, dx, dy) =>
	ui\mousemoved(x,y,dx,dy)
UnitSelect.mousereleased = (x, y, button) =>
	ui\mousereleased(x,y,button)
UnitSelect.mousepressed = (x, y, button) =>
	ui\mousepressed(x,y,button)
UnitSelect.keypressed = (key) =>
	ui\keypressed(key)
UnitSelect.textinput = (t) =>
	ui\textinput(t)

--POP  ============================================================
UnitSelect.resume = () =>
	log.state("Resumed UnitSelect")

UnitSelect.leave = () =>
	log.state("Left UnitSelect")

UnitSelect.quit = () =>
	log.state("Quit UnitSelect")

return UnitSelect