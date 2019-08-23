Notifications = require("modules.gui.Notifications")
MU = require("modules.gui.Map")

Planning = {}

Planning.duration = 60

Planning.init = () ->
	RM.collect()
	RM.executeCmdQasPlayer()

Planning.enter = () ->
	RM.nextRound()
	Notifications.push 1,
		'Planning - Position troops',
		G.assets["icons"]["move"],
		Planning.duration/10, G.COLOR

Planning.done = () ->
	log.phase("Planning done.")
	if not G.isLocal
		NM.sendDataToServer({
			type: "USER_PLANNING_OVER",
			payload: true
		})
	else
		RM.collect()
	Game.cdb\finish()

Planning.exit = () ->
	-- RM.collect()
	-- RM.nextUntilDone()
	-- if not G.isLocal
	-- 	NM.sendDataToServer({
	-- 		type: "SIMULATION_OVER",
	-- 		payload: true
	-- 	})

Planning.update = (dt) ->

Planning.draw = () ->
	MU.drawPlanning()

return Planning 