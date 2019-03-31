Server = {}
Server.cmd = {
	["received"]:           (command, msg, user) ->
	["userFullyConnected"]: (user) ->
	["synchronize"]:        (user) ->
	["customDataChanged"]:  (user, value, key, prevValue) ->
	["disconnectedUser"]:   (user) ->
	["authorize"]:          (user, authMsg) ->
}

Server.load = () ->
	Server.sv = ANet\startServer(2, 22121) 
	if Server.sv
		Server.sv.callbacks.received           = (...) -> Server.cmd["received"](...)
		Server.sv.callbacks.userFullyConnected = (...) -> Server.cmd["userFullyConnected"](...)
		Server.sv.callbacks.synchronize        = (...) -> Server.cmd["synchronize"](...)
		Server.sv.callbacks.customDataChanged  = (...) -> Server.cmd["customDataChanged"](...)
		Server.sv.callbacks.disconnectedUser   = (...) -> Server.cmd["disconnectedUser"](...)

Server.update = (dt) ->
	ANet\update(dt)

Server.makeMatches = () ->


return Server