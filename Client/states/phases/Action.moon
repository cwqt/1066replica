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
	Game.timer\after 0.01, ->
		--avoid weird bug where command phase
		--entered twice
		PM.switch("Action")

Action.mousepressed = (x, y, button) ->
Action.mousereleased = (x, y, button) ->
Action.keypressed = (key) ->

return Action