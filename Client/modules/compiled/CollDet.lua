local CollDet = { }
CollDet.CheckAABB = function(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < (x2 + w2) and x2 < (x1 + w1) and y1 < (y2 + h2) and y2 < (y1 + h1)
end
CollDet.CheckMouseOver = function(x1, y1, w1, h1, ox, oy)
  ox = ox or 0
  oy = oy or 0
  local mx, my = love.mouse.getPosition()
  mx = mx - ox
  my = my - oy
  local x2, y2, w2, h2 = mx, my, 0, 0
  return x1 < (x2 + w2) and x2 < (x1 + w1) and y1 < (y2 + h2) and y2 < (y1 + h1)
end
CollDet.CheckMouseOverCircle = function(x, y, r, ox, oy)
  local mx, my = love.mouse.getPosition()
  mx = mx - ox
  my = my - oy
  local dist = (x - mx) ^ 2 + (y - my) ^ 2
  return dist <= (r + 1) ^ 2
end
return CollDet
