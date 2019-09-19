PM = {}

PM = {}
PM.register = (phase) ->
	PM[phase] = require("states.phases.#{phase}")
	PM[phase].firstTime = true
	PM[phase].__name__ = phase
	log.phase("Registered #{phase}")

PM.switch = (phase) ->
	if PM.current == phase
		log.error("Already in current phase!")
		return

	if PM.current != nil
		PM[PM.current].exit()
		log.phase("Exited phase '#{PM.current}'")
	PM.current = phase

	if PM[PM.current].firstTime
		PM[PM.current].firstTime = false
		log.phase("Initialised phase '#{PM.current}'")
		PM[PM.current].init()

	log.phase("Entered phase '#{PM.current}'")
	PM[PM.current].enter()

PM.getCurrentPhase = () ->
	return PM[PM.current]

PM.mousepressed  	= (x, y, button) 	-> PM.getCurrentPhase().mousepressed(x, y, button)
PM.mousereleased 	= (x, y, button) 	-> PM.getCurrentPhase().mousereleased(x, y, button)
PM.mousemoved  		= (x, y, dx, dy) 	-> PM.getCurrentPhase().mousemoved(x, y, dx, dy)
PM.keypressed 		= (key) 					-> PM.getCurrentPhase().keypressed(key)

return PM