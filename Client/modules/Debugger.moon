Debugger = {}

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
      love.graphics.print(("%.4g")\format(@points[#@points]) .. string.rep("-",22), -45, math.ceil(-(50/math.max(unpack(@points)))*@points[#@points])-8)
      love.graphics.setColor(255,255,255,255)
    love.graphics.pop()

Debugger.load = () ->
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

Debugger.draw = () ->
  for k, graph in pairs(Debugger.graphs)
    graph\draw()

return Debugger