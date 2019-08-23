PM = {}

PM = {}
PM.register = (phase) ->
	PM[phase] = require("states.phases.#{phase}")
	PM[phase].firstTime = true
	PM[phase].__name__ = phases
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

return PM