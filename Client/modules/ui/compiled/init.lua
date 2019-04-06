local UI = { }
UI.id = { }
UI.dbg = true
UI.df = love.graphics.newFont(14)
UI.theme = {
  bg = {
    0.5,
    0.5,
    0.5,
    1
  },
  bgh = {
    0.4,
    0.4,
    0.4,
    1
  },
  fgh = {
    1,
    1,
    1,
    1
  },
  bgf = {
    0.3,
    0.3,
    0.3,
    1
  },
  fgf = {
    1,
    1,
    1,
    1
  },
  m = {
    10,
    10,
    10,
    10
  },
  p = {
    10,
    10,
    10,
    10
  },
  text = {
    font = love.graphics.newFont(48),
    alignh = "left",
    alignv = "top",
    color = {
      0,
      0,
      0,
      1
    }
  }
}
local utf8char_begin
utf8char_begin = function(s, idx)
  local byte = s:byte(idx)
  while byte and byte >= 0x80 and byte < 0xC0 do
    idx = idx - 1
    byte = s:byte(idx)
  end
  return idx
end
local utf8char_after
utf8char_after = function(s, idx)
  if idx <= #s then
    idx = idx + 1
    local byte = s:byte(idx)
    while byte and byte >= 0x80 and byte < 0xC0 do
      idx = idx + 1
      byte = s:byte(idx)
    end
  end
  return idx
end
local Master
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local container = _list_0[_index_0]
        container:update(dt)
      end
    end,
    drawGrid = function(self)
      if UI.dbg then
        love.graphics.setColor(0, 0, 0, 0.1)
        love.graphics.rectangle("fill", 0, 0, self.bpw, self.bph)
        love.graphics.setColor(1, 1, 1, 0.2)
        for i = 1, self.bh + 1 do
          love.graphics.line(0, (i - 1) * self.bs, self.bpw, (i - 1) * self.bs)
        end
        for i = 1, self.bw + 1 do
          love.graphics.line((i - 1) * self.bs, 0, (i - 1) * self.bs, self.bph)
        end
        for y = 1, self.bh do
          for x = 1, self.bw do
            love.graphics.print(x .. "," .. y, (x - 1) * self.bs, (y - 1) * self.bs)
          end
        end
      end
    end,
    draw = function(self)
      self:drawGrid()
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local container = _list_0[_index_0]
        container:draw()
      end
    end,
    wheelmoved = function(self, x, y)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:wheelmoved(x, y)
      end
    end,
    mousemoved = function(self, x, y, dx, dy)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousemoved(x, y, dx, dy)
      end
    end,
    mousepressed = function(self, x, y, button)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousepressed(x, y, button)
      end
    end,
    mousereleased = function(self, x, y, button)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousereleased(x, y, button)
      end
    end,
    textinput = function(self, t)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:textinput(t)
      end
    end,
    keypressed = function(self, key)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:keypressed(key)
      end
    end,
    keyreleased = function(self, key)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:keyreleased(key)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, bw, bh, bs, elements)
      if elements == nil then
        elements = { }
      end
      self.bw, self.bh, self.bs, self.elements = bw, bh, bs, elements
      UI.id = { }
      self.bpw, self.bph = self.bw * self.bs, self.bh * self.bs
      love.window.setMode(self.bpw, self.bph)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local container = _list_0[_index_0]
        container:activate(self.bs)
      end
    end,
    __base = _base_0,
    __name = "Master"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Master = _class_0
end
local Container
do
  local _class_0
  local _parent_0 = Master
  local _base_0 = {
    activate = function(self, bps, ox, oy)
      if ox == nil then
        ox = 0
      end
      if oy == nil then
        oy = 0
      end
      self.bps = bps
      self.bs = self.bps / 2
      self.bpw = self.bw * self.bs
      self.bph = self.bh * self.bs
      self.active = true
      self.hover = false
      self.tx = self.tx + ox
      self.ty = self.ty + oy
      ox, oy = (self.x - 1) * self.bps, (self.y - 1) * self.bps
      self.tx = self.tx + ox
      self.ty = self.ty + oy
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:activate(self.bs, self.tx, self.ty)
      end
    end,
    draw = function(self)
      if self.active then
        love.graphics.push()
        love.graphics.translate((self.x - 1) * self.bps, (self.y - 1) * self.bps)
        if UI.dbg then
          love.graphics.print(tostring(self.tx) .. ", " .. tostring(self.ty), 5, -20)
        end
        self:drawGrid()
        local _list_0 = self.elements
        for _index_0 = 1, #_list_0 do
          local element = _list_0[_index_0]
          if element.__class.__name ~= "Container" then
            love.graphics.push()
            love.graphics.translate((element.x - 1) * self.bs, (element.y - 1) * self.bs)
            element:draw()
            love.graphics.pop()
          else
            element:draw()
          end
        end
        return love.graphics.pop()
      end
    end,
    update = function(self, dt)
      if self.active then
        local _list_0 = self.elements
        for _index_0 = 1, #_list_0 do
          local element = _list_0[_index_0]
          element:update(dt)
        end
      end
    end,
    detectHover = function(self, x, y)
      local x1, y1 = x, y
      local h1, w1 = 1, 1
      local x2, y2 = self.tx, self.ty
      local w2, h2 = self.bpw, self.bph
      if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 then
        return true
      else
        return false
      end
    end,
    wheelmoved = function(self, x, y)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:wheelmoved(x, y)
      end
    end,
    mousemoved = function(self, x, y, dx, dy)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousemoved(x, y, dx, dy)
      end
      self.hover = self:detectHover(x, y)
    end,
    mousepressed = function(self, x, y, button)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousepressed(x, y, button)
      end
    end,
    mousereleased = function(self, x, y, button)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:mousereleased(x, y, button)
      end
    end,
    textinput = function(self, t)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:textinput(t)
      end
    end,
    keypressed = function(self, key)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:keypressed(key)
      end
    end,
    keyreleased = function(self, key)
      local _list_0 = self.elements
      for _index_0 = 1, #_list_0 do
        local element = _list_0[_index_0]
        element:keyreleased(key)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, bw, bh, elements)
      if elements == nil then
        elements = { }
      end
      self.x, self.y, self.bw, self.bh, self.elements = x, y, bw, bh, elements
      self.active = false
      self.tx, self.ty = 0, 0
      self.bw = self.bw * 2
      self.bh = self.bh * 2
    end,
    __base = _base_0,
    __name = "Container",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Container = _class_0
end
local Element
do
  local _class_0
  local _base_0 = {
    activate = function(self, bs, tx, ty)
      self.bs, self.tx, self.ty = bs, tx, ty
      self.bpw = self.bw * self.bs
      self.bph = self.bh * self.bs
      self.active = true
      self.hover = false
      self.tx = self.tx + ((self.x - 1) * self.bs)
      self.ty = self.ty + ((self.y - 1) * self.bs)
      if self.id then
        UI.id[self.id] = self
      end
    end,
    draw = function(self)
      if UI.dbg then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.push()
        love.graphics.translate(self.m[4], self.m[1])
        local mw, mh = self.bpw - (self.m[4] + self.m[2]), self.bph - (self.m[1] + self.m[3])
        love.graphics.rectangle("fill", 0, 0, mw, mh)
        love.graphics.push()
        love.graphics.translate(self.p[4], self.p[1])
        local tw, th = mw - (self.p[4] + self.p[2]), mh - (self.p[1] + self.p[3])
        love.graphics.setColor(0.968, 0.294, 0.764, 0.5)
        love.graphics.rectangle("line", 0, 0, tw, th)
        love.graphics.pop()
        love.graphics.pop()
        return love.graphics.setColor(1, 1, 1, 1)
      end
    end,
    getPaddedDimensions = function(self)
      local w = self.bpw - (self.m[2] + self.m[4] + self.p[2] + self.p[4])
      local h = self.bph - (self.m[1] + self.m[3] + self.p[1] + self.p[3])
      return w, h
    end,
    push = function(self)
      love.graphics.push()
      return love.graphics.translate(self.m[4] + self.p[4], self.m[1] + self.p[1])
    end,
    pop = function(self)
      return love.graphics.pop()
    end,
    update = function(self, dt)
      self.timer:update(dt)
      if self.hover then
        return self:whileHover()
      end
    end,
    onClick = function(self, button)
      return print("Clicked " .. tostring(self.__class.__name) .. " w/ " .. tostring(button))
    end,
    detectHover = function(self, x, y)
      local x1, y1 = x, y
      local h1, w1 = 1, 1
      local x2, y2 = self.tx + self.m[4], self.ty + self.m[1]
      local w2, h2 = self.bpw - 2 * self.m[2], self.bph - 2 * self.m[3]
      if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 then
        if self.hover == false then
          self:onHover()
        end
        self.hover = true
        return true
      end
      return false
    end,
    whileHover = function(self) end,
    onHover = function(self)
      return print("Entered " .. tostring(self.__class.__name))
    end,
    onHoverExit = function(self)
      return print("Exited " .. tostring(self.__class.__name))
    end,
    wheelmoved = function(self, x, y) end,
    mousemoved = function(self, x, y, dx, dy)
      if not self:detectHover(x, y) then
        if self.hover then
          self:onHoverExit()
          self.hover = false
        end
      end
    end,
    mousepressed = function(self, x, y, button)
      if self.hover then
        self:onClick(button)
        self.cclicked = true
      end
    end,
    mousereleased = function(self, button)
      self.cclicked = false
    end,
    textinput = function(self, t) end,
    keypressed = function(self, key) end,
    keyreleased = function(self, key) end,
    destroy = function(self)
      return self.timer:destroy()
    end,
    setTheme = function(self)
      local t = M.clone(UI.theme)
      for k, v in pairs(t) do
        self[k] = v
      end
      t = nil
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, bw, bh, id)
      self.x, self.y, self.bw, self.bh, self.id = x, y, bw, bh, id
      self.timer = Timer()
      return self:setTheme()
    end,
    __base = _base_0,
    __name = "Element"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Element = _class_0
end
local Text
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      _class_0.__parent.activate(self, ...)
      self.foy = self.text.font:getHeight()
    end,
    update = function(self, dt) end,
    draw = function(self)
      local w, h = self:getPaddedDimensions()
      love.graphics.setFont(self.text.font)
      self:push()
      if self.text.alignv == "center" then
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, 0, h / 2 - self.foy / 2, w, self.text.alignh)
      else
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, 0, 0, w, self.text.alignh)
      end
      love.graphics.setFont(UI.df)
      self:pop()
      return _class_0.__parent.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, value, ...)
      self.value = value
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Text",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Text = _class_0
end
local Button
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      _class_0.__parent.activate(self, ...)
      self.foy = self.text.font:getHeight()
    end,
    update = function(self)
      return _class_0.__parent.update(self)
    end,
    draw = function(self)
      love.graphics.setFont(self.text.font)
      love.graphics.setColor(0, 0, 0, 1)
      if self.hover then
        love.graphics.setColor(self.bgh)
      else
        love.graphics.setColor(self.bg)
      end
      if self.cclicked then
        love.graphics.setColor(self.bgf)
      end
      local w, h = self:getPaddedDimensions()
      self:push()
      love.graphics.rectangle("fill", self.m[4], self.m[1], self.bpw - 2 * self.m[2], self.bph - 2 * self.m[3])
      if self.text.alignv == "center" then
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, 0, 0, self.bpw - (2 * (self.m[2] + self.p[2])), self.text.alignh)
      else
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, 0, 0, self.bpw - (2 * (self.m[2] + self.p[2])), self.text.alignh)
      end
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setFont(UI.df)
      self:pop()
      return _class_0.__parent.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, value, ...)
      self.value = value
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Button",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Button = _class_0
end
local TextInput
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      _class_0.__parent.activate(self, ...)
      self.foy = self.text.font:getHeight()
    end,
    update = function(self, dt)
      _class_0.__parent.update(self, dt)
      self.keyrepeat.timer = self.keyrepeat.timer + dt
      if self.keyrepeat.timer >= self.keyrepeat.delay and love.keyboard.isDown("backspace") then
        self.keyrepeat.timer = 0
        local cur = self.cursor
        if cur > 0 then
          self.cursor = utf8char_begin(self.value, cur) - 1
          self.value = self.value:sub(1, self.cursor) .. self.value:sub(cur + 1)
        end
      end
    end,
    onClick = function(self, button)
      _class_0.__parent.onClick(self, button)
      if not self.focus then
        self.focus = true
      end
    end,
    mousepressed = function(self, x, y, button)
      _class_0.__parent.mousepressed(self, x, y, button)
      if self.focus and not self.hover then
        self.focus = false
      end
    end,
    draw = function(self)
      if self.hover then
        love.graphics.setColor(self.bgh)
      else
        love.graphics.setColor(self.bg)
      end
      if self.focus then
        love.graphics.setColor(self.bgf)
      end
      love.graphics.rectangle("fill", self.m[4], self.m[1], self.bpw - 2 * self.m[2], self.bph - 2 * self.m[3])
      love.graphics.setScissor(self.tx, self.ty, self.bpw, self.bph)
      love.graphics.setFont(self.text.font)
      if self.text.alignv == "center" then
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, self.m[4] + self.p[4], self.m[1] + self.bph / 2 - (self.p[3] + self.foy / 2), self.bpw - (2 * (self.m[2] + self.p[2])), self.text.alignh)
      else
        love.graphics.printf({
          self.text.color,
          tostring(self.value)
        }, self.m[4] + self.p[4], self.m[1] + self.p[3], self.bpw - (2 * (self.m[2] + self.p[2])), self.text.alignh)
      end
      if self.cursorVisible and self.focus then
        love.graphics.push()
        love.graphics.translate(self.m[4] + self.p[4] + self.text.font:getWidth(self.value:sub(1, self.cursor)), self.m[1] + self.p[1])
        love.graphics.setColor(self.text.color)
        love.graphics.line(0, 7, 0, self.foy)
        love.graphics.pop()
      end
      love.graphics.setFont(UI.df)
      love.graphics.setScissor()
      love.graphics.setColor(1, 1, 1, 1)
      return _class_0.__parent.draw(self)
    end,
    kreyreleased = function(self)
      self.cursorVisible = false
    end,
    keypressed = function(self, key)
      if self.focus then
        self.cursorVisible = true
        local _exp_0 = key
        if 'delete' == _exp_0 then
          local cur = utf8char_after(self.value, self.cursor + 1)
          self.value = self.value:sub(1, self.cursor) .. self.value:sub(cur)
        elseif 'left' == _exp_0 then
          if self.cursor > 0 then
            self.cursor = utf8char_begin(self.value, self.cursor) - 1
          end
        elseif 'right' == _exp_0 then
          self.cursor = utf8char_after(self.value, self.cursor + 1) - 1
        end
      end
    end,
    textinput = function(self, t)
      if self.focus then
        if self.value == self.placeholder then
          self.value = ""
          self.cursor = 0
        end
        self.value = self.value:sub(1, self.cursor) .. t .. self.value:sub(self.cursor + 1)
        self.cursor = self.cursor + #t
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, placeholder, ...)
      if placeholder == nil then
        placeholder = ""
      end
      self.placeholder = placeholder
      _class_0.__parent.__init(self, ...)
      self.value = self.placeholder
      self.cursor = string.len(self.value)
      self.focus = false
      self.font = self.font or love.graphics.newFont(48)
      self.align = "left"
      self.color = {
        0,
        0,
        0,
        1
      }
      self.cursorVisible = false
      self.timer:every(0.5, function()
        self.cursorVisible = not self.cursorVisible
      end)
      self.keyrepeat = {
        timer = 0,
        delay = 0.1
      }
    end,
    __base = _base_0,
    __name = "TextInput",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TextInput = _class_0
end
local Checkbox
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      return _class_0.__parent.activate(self, ...)
    end,
    draw = function(self)
      love.graphics.setColor(self.bg)
      love.graphics.rectangle("fill", self.m[4], self.m[1], self.bpw - 2 * self.m[2], self.bph - 2 * self.m[3])
      if self.value then
        love.graphics.setColor(self.bgf)
        love.graphics.rectangle("fill", self.m[4] + 5, self.m[1] + 5, self.bpw - 2 * self.m[2] - 10, self.bph - 2 * self.m[3] - 10)
      end
      love.graphics.setColor(1, 1, 1, 1)
      return _class_0.__parent.draw(self)
    end,
    onClick = function(self)
      _class_0.__parent.onClick(self)
      self.value = not self.value
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, value, ...)
      self.value = value
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Checkbox",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Checkbox = _class_0
end
local Image
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      _class_0.__parent.activate(self, ...)
      self.imgw = self.value:getWidth()
      self.imgh = self.value:getHeight()
      self.sx = (self.bpw - 2 * self.m[4]) / self.imgw
      self.sy = (self.bph - 2 * self.m[4]) / self.imgh
    end,
    draw = function(self)
      _class_0.__parent.draw(self)
      return love.graphics.draw(self.value, self.m[4], self.m[1], 0, self.sx, self.sy)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, value, ...)
      self.value = value
      _class_0.__parent.__init(self, ...)
      self.xfit = true
      self.yfit = true
      self.sx, self.sy = 1, 1
    end,
    __base = _base_0,
    __name = "Image",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Image = _class_0
end
local Slider
do
  local _class_0
  local _parent_0 = Element
  local _base_0 = {
    activate = function(self, ...)
      return _class_0.__parent.activate(self, ...)
    end,
    draw = function(self)
      _class_0.__parent.draw(self)
      love.graphics.line(self.m[4] + self.p[4], self.bph / 2, self.bpw - (self.m[1] + self.p[1]), self.bph / 2)
      love.graphics.rectangle("fill", self.thx + self.m[4] + self.p[4], self.bph / 2 - self.thh / 2, self.thw, self.thh)
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("fill", math.floor(self.thx / self.tick) * self.tick, self.bph / 2 - self.thh / 2, self.thw, self.thh)
      love.graphics.setColor(1, 1, 1, 1)
      return love.graphics.print(tostring(self.th_hover, 10, 10))
    end,
    update = function(self, dt)
      _class_0.__parent.update(self, dt)
      if self.hover then
        self.th_hover = self:detectHoverThumb(love.mouse.getX(), love.mouse.getY())
      end
    end,
    detectHoverThumb = function(self, x, y)
      local x1, y1 = x, y
      local h1, w1 = 1, 1
      local x2, y2 = self.tx + self.thx, self.ty + (self.bph / 2 - self.thh / 2)
      local w2, h2 = self.thw, self.thh
      if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 then
        if self.th_hover == false then
          self:onHover()
        end
        self.th_hover = true
        return true
      end
      return false
    end,
    mousemoved = function(self, x, y, dx, dy)
      _class_0.__parent.mousemoved(self, x, y, dx, dy)
      if love.mouse.isDown(1) and self.th_hover then
        self.thx = L.clamp(x - self.tx - self.thw / 2, 0, self.bpw - self.thw)
      end
    end,
    mousepressed = function(self, x, y, button)
      return _class_0.__parent.mousepressed(self, x, y, button)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, min, max, tick, ...)
      self.min, self.max, self.tick = min, max, tick
      _class_0.__parent.__init(self, ...)
      self.thx = 40
      self.thw = 20
      self.thh = 20
      self.th_hover = false
    end,
    __base = _base_0,
    __name = "Slider",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Slider = _class_0
end
UI.Master = Master
UI.Container = Container
UI.Element = Element
UI.Text = Text
UI.TextInput = TextInput
UI.Button = Button
UI.Checkbox = Checkbox
UI.Image = Image
UI.Slider = Slider
return UI
