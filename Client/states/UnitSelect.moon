UnitSelect = {}
UnitSelect.peerDone = false
UnitSelect.done = false

-- Player in here
UnitSelect.units = {}

UnitSelect.init = () =>
	log.state("Initialised UnitSelect")
	map = Map.generate(15, 5)
	Map.set(map)

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
		UnitSelect.done()

--LOGIC============================================================
UnitSelect.update = (dt) =>
	ui\update(dt)
	if UnitSelect.done and UnitSelect.peerDone
		Gamestate.switch(Game)

UnitSelect.draw   = ()   =>
	ui\draw()

UnitSelect.setPeerDone = () =>
	UnitSelect.peerDone = true

UnitSelect.done = () =>
	-- get entties from unit select bit
	GAME.PLAYERS[GAME.self]\pushCommand({
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
	GAME.PLAYERS[GAME.opponent]\pushCommand({
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

	UnitSelect.done = true
	if not GAME.isLocal
		UI.id["info"].value = "Waiting for peer"
		NM.sendDataToServer({
			type: "USER_UNITSELECT_OVER",
			payload: UnitSelect.done
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