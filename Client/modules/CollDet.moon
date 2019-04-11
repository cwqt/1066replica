CollDet = {}

CollDet.CheckAABB = (x1, y1, w1, h1, x2, y2, w2, h2) ->
  return x1 < (x2 + w2) and
         x2 < (x1 + w1) and
         y1 < (y2 + h2) and
         y2 < (y1 + h1)

CollDet.CheckMouseOver = (x1, y1, w1, h1, ox, oy) ->
  ox = ox or 0
  oy = oy or 0
  mx, my = love.mouse.getPosition()
  mx -= ox
  my -= oy
  x2, y2, w2, h2 = mx, my, 0, 0
  return x1 < (x2 + w2) and
         x2 < (x1 + w1) and
         y1 < (y2 + h2) and
         y2 < (y1 + h1)

CollDet.CheckMouseOverCircle = (x, y, r, ox, oy) ->
  mx, my = love.mouse.getPosition()
  mx -= ox
  my -= oy  
  dist = (x - mx)^2 + (y - my)^2
  return dist <= (r + 1)^2

return CollDet