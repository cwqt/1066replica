Debugger = {}
Debugger.useProfiler = false

class Debugger.graph
  new: (@title, @x, @y, @fn, @delay) =>
    @points = {0,0}
    @delay = @delay or 500
    @t = @delay
    @maxy = 0

  update: (dt) =>
    if #@points > 50
      table.remove(@points, 1)
    @t -= 50
    if @t <= 0
      @points[#@points+1] = @fn()
      @t = @delay

  draw: () =>
    love.graphics.setFont(G.fonts["mono"][16])
    love.graphics.push()
    love.graphics.translate(@x-5, @y+55)
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill", -50,15,160,-75)
    love.graphics.setColor(255,255,255,255)
    love.graphics.print(@title, 0, 0)
    t = {}
    for k, v in pairs(@points)
      t[#t+1] = k*2
      t[#t+1] = -(50/math.max(unpack(@points)))*v
    if #@points > 2 
      love.graphics.line(unpack(t))
      love.graphics.setColor(255,255,255,100)
      love.graphics.print(("%.4g")\format(@points[#@points]) .. string.rep("-",12), -45, math.ceil(-(50/math.max(unpack(@points)))*@points[#@points])-8)
      love.graphics.setColor(255,255,255,255)
    love.graphics.pop()

Debugger.load = (settings) ->
  Debugger.useProfiler = settings.useProfiler or false
  if Debugger.useProfiler
    Debugger.profiler = require('libs.profiler') 
    Debugger.profiler.hookall("Lua")
    Debugger.profiler.start()

  x = love.graphics.getWidth()+210
  Debugger.graphs = {
    Debugger.graph("FPS", x, 15, -> return love.timer.getFPS())
    Debugger.graph("DT (ms)", x, 95, -> return love.timer.getDelta()*1000)
    Debugger.graph("MEM (kb)", x, 175, -> return collectgarbage('count'))
    Debugger.graph("Draws", x, 255, -> return love.graphics.getStats().fonts)
  }

Debugger.update = (dt) ->
  for k, graph in pairs(Debugger.graphs)
    graph\update(dt)

  if Debugger.useProfiler
    love.frame = love.frame + 1
    if love.frame % 10 == 0 then
      Debugger.report = Debugger.profiler.report('time', 20)
      Debugger.profiler.reset()

Debugger.draw = () ->
  for k, graph in pairs(Debugger.graphs)
    graph\draw()

  if Debugger.useProfiler
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1, 1)
    love.graphics.setFont(G.fonts["mono"][16])
    love.graphics.print(Debugger.report or "Please wait...")


return Debugger