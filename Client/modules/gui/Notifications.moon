Notifications = {}
Notifications.stack = {{}, {}}
Notification = require("modules.gui.Notification")

Notifications.load = () ->
	Notifications.timer = Timer()
	-- Notifications.push(1, "Round 1 - Select Commands")

Notifications.update = (dt) ->
	Notifications.timer\update(dt)
	for k, side in ipairs(Notifications.stack)
		for _, notification in pairs(side)
			notification\update(dt)

Notifications.draw = () ->
	for k, side in ipairs(Notifications.stack)
		c = 0
		for i, notification in pairs(side)
			c += 1
			x = 0
			if (k%2)==0
				x = love.graphics.getWidth()-(notification.width+2*notification.padding)
			notification\draw(x, 10+65*(c-1))

Notifications.push = (side, text, icon, duration=3, color) ->
	uuid = G.UUID!
	dir = -1
	if (side%2)==0 then dir = 1 
	n = Notification(text, icon, dir, color)
	Notifications.stack[side][uuid] = n
	log.trace("Pushed notification #{uuid\sub(1,8)}")
	Notifications.timer\script (wait) ->
		wait(duration)
		Notifications.stack[side][uuid]\destroy()
		wait(0.5)
		log.trace("Destroyed notifcation #{uuid\sub(1,8)}")
		Notifications.stack[side][uuid] = nil

return Notifications
