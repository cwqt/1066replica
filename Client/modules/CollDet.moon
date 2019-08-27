CollDet = {}

CollDet.checkAABB = (x1, y1, w1, h1, x2, y2, w2, h2) ->
  return x1 < (x2 + w2) and
         x2 < (x1 + w1) and
         y1 < (y2 + h2) and
         y2 < (y1 + h1)

CollDet.checkMouseOver = (x1, y1, w1, h1, ox, oy) ->
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

CollDet.checkMouseOverCircle = (x, y, r, ox, oy) ->
  mx, my = love.mouse.getPosition()
  mx -= ox
  my -= oy  
  dist = (x - mx)^2 + (y - my)^2
  return dist <= (r + 1)^2

--https://stackoverflow.com/questions/6270785/how-to-determine-whether-a-point-x-y-is-contained-within-an-arc-section-of-a-c
CollDet.isPointWithinSegment = (px, py, x, y, radius, a1, a2, offset) ->
  r = math.sqrt((px - x)^2 + (py - y)^2)
  a = math.atan2(py-y, px-x)
  --map atan2 to 0-360
  --offset rotates unit circle to remove instance wherein:
  -- / -30
  -- ------------ 0
  --\ 30  not within 0 < x < 360
  -- \  will not meet criteria for a1<a and a<a2
  a = math.rad((math.deg(a) + offset + 360) % 360)
  if a1 < a and a < a2
    if 0 < r and r < radius
      return true
  return false

return CollDet