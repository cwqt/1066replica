local MU = { }
MU.fGS = {
  1,
  1
}
MU.pfGS = {
  1,
  1
}
local p = 50
MU.update = function(dt) end
MU.draw = function()
  love.graphics.push()
  love.graphics.translate((love.graphics.getWidth() - (Map.width * p)) / 2, love.graphics.getHeight() - Map.height * p - 10)
  MU.drawMap()
  return love.graphics.pop()
end
MU.drawMap = function()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.line(Map.width * p, 0, Map.width * p, Map.height * p, 0, Map.height * p)
  for i = 1, #Map.current[1] do
    love.graphics.line((i - 1) * p, 0, (i - 1) * p, Map.height * p)
  end
  for i = 1, #Map.current do
    love.graphics.line(0, (i - 1) * p, Map.width * p, (i - 1) * p)
  end
  for y = 1, #Map.current do
    for x = 1, #Map.current[1] do
      love.graphics.print(tostring(x) .. "," .. tostring(y), (x - 1) * p, (y - 1) * p)
    end
  end
  return MU.drawUnits()
end
MU.drawUnits = function()
  for y, row in ipairs(Map.current) do
    for x, column in ipairs(row) do
      if column.object then
        love.graphics.circle("fill", (x - 1) * p + p / 2, (y - 1) * p + p / 2, p / 3)
      end
    end
  end
end
MU.hoverGS = function(mx, my)
  local tx, ty = (love.graphics.getWidth() - (Map.width * p)) / 2, love.graphics.getHeight() - Map.height * p - 10
  if CD.CheckMouseOver(0, 0, Map.width * p, Map.height * p, tx, ty) then
    local gx = math.ceil((mx - tx) / p)
    local gy = math.ceil((my - ty) / p)
    if not M.same(MU.fGS, {
      gx,
      gy
    }) then
      MU.pfGS = MU.fGS
      MU.fGS = {
        gx,
        gy
      }
    end
  end
end
return MU
