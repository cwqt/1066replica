local MainMenu = { }
MainMenu.enter = function(self) end
MainMenu.update = function(self, dt) end
MainMenu.draw = function(self)
  return love.graphics.print("hello", 10, 10)
end
MainMenu.mousereleased = function(x, y, button) end
MainMenu.mousepressed = function(self, x, y, button) end
MainMenu.keypressed = function(self, key, code) end
MainMenu.textinput = function(self, t) end
return MainMenu
