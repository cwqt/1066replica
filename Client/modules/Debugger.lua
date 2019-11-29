local Debugger = { }
Debugger.useProfiler = false
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      if #self.points > 50 then
        table.remove(self.points, 1)
      end
      self.t = self.t - 50
      if self.t <= 0 then
        self.points[#self.points + 1] = self:fn()
        self.t = self.delay
      end
    end,
    draw = function(self)
      love.graphics.setFont(G.fonts["mono"][16])
      love.graphics.push()
      love.graphics.translate(self.x - 5, self.y + 55)
      love.graphics.setColor(0, 0, 0, 100)
      love.graphics.rectangle("fill", -50, 15, 160, -75)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(self.title, 0, 0)
      local t = { }
      for k, v in pairs(self.points) do
        t[#t + 1] = k * 2
        t[#t + 1] = -(50 / math.max(unpack(self.points))) * v
      end
      if #self.points > 2 then
        love.graphics.line(unpack(t))
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.print(("%.4g"):format(self.points[#self.points]) .. string.rep("-", 12), -45, math.ceil(-(50 / math.max(unpack(self.points))) * self.points[#self.points]) - 8)
        love.graphics.setColor(255, 255, 255, 255)
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, title, x, y, fn, delay)
      self.title, self.x, self.y, self.fn, self.delay = title, x, y, fn, delay
      self.points = {
        0,
        0
      }
      self.delay = self.delay or 500
      self.t = self.delay
      self.maxy = 0
    end,
    __base = _base_0,
    __name = "graph"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Debugger.graph = _class_0
end
Debugger.load = function(settings)
  Debugger.useProfiler = settings.useProfiler or false
  if Debugger.useProfiler then
    Debugger.profiler = require('libs.profiler')
    Debugger.profiler.hookall("Lua")
    Debugger.profiler.start()
  end
  local x = 1280 - 115
  Debugger.graphs = {
    Debugger.graph("FPS", x, 15, function()
      return love.timer.getFPS()
    end),
    Debugger.graph("DT (ms)", x, 95, function()
      return love.timer.getDelta() * 1000
    end),
    Debugger.graph("MEM (kb)", x, 175, function()
      return collectgarbage('count')
    end),
    Debugger.graph("Draws", x, 255, function()
      return love.graphics.getStats().fonts
    end)
  }
end
Debugger.update = function(dt)
  for k, graph in pairs(Debugger.graphs) do
    graph:update(dt)
  end
  if Debugger.useProfiler then
    love.frame = love.frame + 1
    if love.frame % 10 == 0 then
      Debugger.report = Debugger.profiler.report('time', 20)
      return Debugger.profiler.reset()
    end
  end
end
Debugger.draw = function()
  for k, graph in pairs(Debugger.graphs) do
    graph:draw()
  end
  if Debugger.useProfiler then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(G.fonts["mono"][16])
    return love.graphics.print(Debugger.report or "Please wait...")
  end
end
return Debugger
