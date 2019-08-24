UnitSelect = {}
UnitSelect.peerDone   = false
UnitSelect.playerDone = false

-- Player in here
UnitSelect.units = {}

UnitSelect.init = () =>
	self.__name__ = "UnitSelect"
	log.state("Initialised UnitSelect")
	map = Map.generate(15, 5)
	Map.set(map)

UnitSelect.enter  = (previous)   =>
	log.state("Entered UnitSelect")
	export ui = UI.Master(8, 5, 140, {
		UI.Container(2,1,6,4, {
			with UI.Text("Entity",1,3,3,1)
				.text.font = G.fonts.default[27]
			with UI.Text("0",3,3,1,1, "cnt")
				.text.font = G.fonts.default[27]
			with UI.Button("+", 4,3,1,1, "inc")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
			with UI.Button("-", 5,3,1,1, "dec")
				.text.font = G.fonts.default[27]
				.text.alignh = "center"
			UI.Text("",1,5,10,2, 'info')
			UI.Button("Enter game",1,5,8,2, "load")
		})
	})

	v = 0
	UI.id["inc"].onClick = ->
		v += 1
		UI.id["cnt"].value = v

	UI.id["dec"].onClick = ->
		v -= 1
		UI.id["cnt"].value = v

	UI.id["load"].onClick = ->
		UI.id["info"].value = 'Waiting for peer...'
		UnitSelect.done()

--LOGIC============================================================
UnitSelect.update = (dt) =>
	ui\update(dt)
	if UnitSelect.playerDone and UnitSelect.peerDone
		Gamestate.switch(Game)

UnitSelect.draw   = ()   =>
	ui\draw()

UnitSelect.setPeerDone = () =>
	UnitSelect.peerDone = true

UnitSelect.done = () =>
	if UnitSelect.playerDone then return
	-- get entties from unit select bit
	G.PLAYERS[G.self]\pushCommand({
		type: "SET_INITIAL_UNITS",
		payload: {
			{
				type: "CREATE_OBJECT",
				payload: {
					type: "ENTITY",
					payload: nil						
				}
			},{
				type: "CREATE_OBJECT",
				payload: {
					type: "ENTITY",
					payload: nil						
				}
			},{
				type: "CREATE_OBJECT",
				payload: {
					type: "ENTITY",
					payload: nil						
				}
			}
		}
	})

	UnitSelect.playerDone = true
	if not G.isLocal
		UI.id["info"].value = "Waiting for peer"
		NM.sendDataToServer({
			type: "USER_UNITSELECT_OVER",
			payload: UnitSelect.playerDone
		})
	else
		Gamestate.switch(Game)

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