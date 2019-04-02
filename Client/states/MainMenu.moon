MainMenu = {}

MainMenu.enter  = ()   =>

MainMenu.update = (dt) =>

MainMenu.draw   = ()   =>
	love.graphics.print(love.timer.getFPS().."FPS", love.window.getMode()-40, 0)

MainMenu.mousereleased = (x, y, button) ->
MainMenu.mousepressed = (x, y, button) =>
MainMenu.keypressed = (key, code) =>
MainMenu.textinput = (t) =>

return MainMenu