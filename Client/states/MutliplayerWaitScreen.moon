MWS = {}
MWS.init = () =>
	self.__name__ = "MWS"
	log.state("Initialised MWS")
	
MWS.enter  = (previous)   =>
	MWS.Timer = Timer()
	log.state("Entered MWS")
	export ui = UI.Master(8, 5, 160, {
		UI.Container(2,2,6,3, {
			with UI.Text("Waiting for server to provide match...", 1, 1, 12, 6, "debug_message")
				.text.font = G.fonts.default[27]
				.text.color = {1,1,1}
				.text.alignh = "center"
				.text.alignv = "center"
		})
	})
	NM.sendDataToServer({
		type: "REQUESTING_MATCH",
		payload: nil
	})

MWS.onGetMatch = (side) ->
	MWS.Timer\after 0.5, ->
		UI.id["debug_message"].value = "Got match!"

	MWS.Timer\after 1, ->
		G.instantiatePlayers(side, side>=2 and 1 or 2)
		Gamestate.switch(UnitSelect)

--LOGIC============================================================
MWS.update = (dt) =>
	MWS.Timer\update(dt)
	ui\update(dt)

MWS.draw   = ()   =>
	ui\draw()

--INPUT============================================================
MWS.mousemoved = (x, y, dx, dy) =>
MWS.mousereleased = (x, y, button) =>
MWS.mousepressed = (x, y, button) =>
MWS.keypressed = (key) =>
MWS.textinput = (t) =>

--POP  ============================================================
MWS.resume = () =>
	log.state("Resumed MWS")

MWS.leave = () =>
	log.state("Left MWS")

MWS.quit = () =>
	log.state("Quit MWS")

return MWS