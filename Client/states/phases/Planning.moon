Notifications = require("modules.gui.Notifications")
MU = require("modules.gui.Map")

Planning = {}

Planning.duration = 60

Planning.initialise = () ->
	RM.collect()
	RM.executeCmdQasPlayer()

Planning.enter = () ->
	-- Notifications.push(1, 'Planning - Position troops', GAME.assets["icons"]["move"], Planning.duration, GAME.COLOR)

Planning.exit = () ->
	-- RM.collect()

Planning.update = (dt) ->

Planning.draw = () ->
	MU.drawPlanning()

return Planning 