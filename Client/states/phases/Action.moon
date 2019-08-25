Action = {}

Action.init = () ->
	-- First time == coming in from Planning phase
	RM.collect!
	RM.executeCmdQasPlayer!
	Action.done!

Action.enter = () ->

Action.exit = () ->

Action.update = (dt) ->

Action.draw = () ->

Action.done = () ->
	--avoid weird bug where command phase
	--entered twice
	Game.timer\after 0.01, ->
		PM.switch("Command")

Action.mousemoved = (x, y, dx, dy) ->
Action.mousepressed = (x, y, button) ->
Action.mousereleased = (x, y, button) ->
Action.keypressed = (key) ->

return Action