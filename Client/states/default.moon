xxx = {}
xxx.init = () =>
	self.__name__ = "xxx"
	log.state("Initialised xxx")

xxx.enter  = (previous)   =>
	log.state("Entered xxx")

--LOGIC============================================================
xxx.update = (dt) =>
xxx.draw   = ()   =>

--INPUT============================================================
xxx.mousemoved = (x, y, dx, dy) =>
xxx.mousereleased = (x, y, button) =>
xxx.mousepressed = (x, y, button) =>
xxx.keypressed = (key) =>
xxx.textinput = (t) =>

--POP  ============================================================
xxx.resume = () =>
	log.state("Resumed xxx")

xxx.leave = () =>
	log.state("Left xxx")

xxx.quit = () =>
	log.state("Quit xxx")

return xxx