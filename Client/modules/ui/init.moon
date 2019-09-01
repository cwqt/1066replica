--
-- ui
--
-- Copyright (c) 2019 cxss
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license.
--

UI = { _version: "0.1.0" }
UI.id = {}
UI.dbg = false
UI.df = love.graphics.newFont(14)

-- Variable names
	-- bs   box spacing
	-- bps  box parent spacing
	-- bx   box x
	-- by   box y
	-- bw   box width in bs's
	-- bh   box height in bs's
	-- bpw  box pixel width
	-- bph  box pixel height
	-- tx   true x position
	-- ty   true y positionxx

UI.theme = {
	bg: {0.5, 0.5, 0.5, 1}
	bgh: {0.4, 0.4, 0.4, 1}
	fgh: {1,1,1,1}
	bgf: {0.3,0.3,0.3,1}
	fgf: {1,1,1,1}
	m: {10,10,10,10} -- up, right, down, left (cw)
	p: {10,10,10,10}
	-- bg_image:
	text: {
		font: love.graphics.newFont(48)
		alignh: "left"
		alignv: "top"
		color: {0,0,0,1}
	}}

utf8char_begin = (s, idx) ->
	byte = s\byte(idx)
	while byte and byte >= 0x80 and byte < 0xC0 do
		idx = idx - 1
		byte = s\byte(idx)
	return idx
utf8char_after = (s, idx) ->
	if idx <= #s then
		idx = idx + 1
		byte = s\byte(idx)
		while byte and byte >= 0x80 and byte < 0xC0 do
			idx = idx + 1
			byte = s\byte(idx)
	return idx

class Master
	new: (@bw, @bh, @bs, @elements={}) =>
		UI.id = {}
		love.keyboard.setKeyRepeat(false)
		@bpw, @bph = @bw*@bs, @bh*@bs
		love.window.setMode(@bpw, @bph, {msaa:8, highdpi:true})
		for container in *@elements do container\activate(@bs)

	update: (dt) =>
		for container in *@elements do container\update(dt)

	drawGrid: () =>
		if UI.dbg
			love.graphics.setLineStyle("rough")
			love.graphics.setColor(0,0,0,0.4)
			love.graphics.rectangle("fill", 0, 0, @bpw, @bph)
			love.graphics.setColor(1,1,1,0.2)
			for i=1, @bh+1
				love.graphics.line(0, (i-1)*@bs, @bpw, (i-1)*@bs)
			for i=1, @bw+1
				love.graphics.line((i-1)*@bs, 0, (i-1)*@bs, @bph)
			for y=1, @bh
				for x=1, @bw
					love.graphics.print(x..","..y, (x-1)*@bs, (y-1)*@bs)
			love.graphics.setColor(1,1,1,1)
			love.graphics.setLineStyle("smooth")

	draw: () =>
		@drawGrid()
		for container in *@elements do container\draw()

	-- Pass on input to containers
	wheelmoved: (x, y) =>
		for element in *@elements do element\wheelmoved(x, y)
	mousemoved: (x, y, dx, dy) =>
		for element in *@elements do element\mousemoved(x, y, dx, dy)
	mousepressed: (x, y, button) =>
		for element in *@elements do element\mousepressed(x, y, button)
	mousereleased: (x, y, button) =>
		for element in *@elements do element\mousereleased(x, y, button)
	textinput: (t) =>
		for element in *@elements do element\textinput(t)
	keypressed: (key) =>
		for element in *@elements do element\keypressed(key)
	keyreleased: (key) =>
		for element in *@elements do element\keyreleased(key)

class Container extends Master
	new: (@x, @y, @bw, @bh, @elements={}, @id) =>
		@active = false
		@tx, @ty = 0, 0
		@bw = @bw*2
		@bh = @bh*2

	activate: (@bps, ox=0, oy=0) =>
		@bs  = @bps / 2
		@bpw = @bw * @bs
		@bph = @bh * @bs
		@active = true
		@hover  = false

		-- true pixel positon for nested containers
		-- in use in detection		
		@tx += ox		
		@ty += oy		
		ox, oy = (@x-1)*@bps, (@y-1)*@bps
		@tx += ox		
		@ty += oy		

		for element in *@elements do 
			element\activate(@bs, @tx, @ty)

		if @id then UI.id[@id] = self

	draw: () =>
		if @active
			love.graphics.push()
			love.graphics.translate((@x-1)*@bps, (@y-1)*@bps)
			if UI.dbg
				love.graphics.print("#{@tx}, #{@ty}", 5, -20)

			@drawGrid()

			for element in *@elements
				if element.__class.__name != "Container"
					love.graphics.push()
					love.graphics.translate((element.x-1)*@bs, (element.y-1)*@bs)
					element\draw()
					love.graphics.pop()
				else
					element\draw()
			love.graphics.pop()

	update: (dt) =>
		if @active then 
			for element in *@elements do element\update(dt)

	detectHover: (x, y) =>
		x1, y1 = x, y
		h1, w1 = 1, 1
		x2, y2 = @tx, @ty
		w2, h2 = @bpw, @bph
		if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
			return true
		else
			return false

	destroy: (id) =>
		for k, v in pairs(@elements)
			if v.id == id
				UI.id[id] = nil
				table.remove(@elements, k)

	-- Pass on input to elements
	wheelmoved: (x, y) =>
		for element in *@elements do element\wheelmoved(x, y)

	mousemoved: (x, y, dx, dy) =>
		for element in *@elements do element\mousemoved(x, y, dx, dy)
		@hover = @detectHover(x, y)

	mousepressed: (x, y, button) =>
		for element in *@elements do element\mousepressed(x, y, button)
	mousereleased: (x, y, button) =>
		for element in *@elements do element\mousereleased(x, y, button)
	textinput: (t) =>
		for element in *@elements do element\textinput(t)
	keypressed: (key) =>
		for element in *@elements do element\keypressed(key)
	keyreleased: (key) =>
		for element in *@elements do element\keyreleased(key)

--==============================================================

class Element
	new: (@x, @y, @bw, @bh, @id) =>
		@timer = Timer()
		@setTheme()

	activate: (@bs, @tx, @ty) =>
		@bpw = @bw * @bs -- box pixel width
		@bph = @bh * @bs -- "       " height
		@active = true
		@hover  = false
		@tx += (@x-1)*@bs
		@ty += (@y-1)*@bs

		if @id then UI.id[@id] = self
		-- log.info("Created id:#{@id or @.__class.__name}")

	-- m = {5,5,5,5} --[1]u [2]r [3]d [4]l 
	draw: () =>
		if UI.dbg
			love.graphics.setColor(1,1,1,0.2)
			--margin
			love.graphics.push()
			love.graphics.translate(@m[4], @m[1])
			mw, mh = @bpw-(@m[4]+@m[2]), @bph-(@m[1]+@m[3])
			love.graphics.rectangle("fill", 0, 0, mw, mh)
			--padding
			love.graphics.push()
			love.graphics.translate(@p[4], @p[1])
			tw, th = mw-(@p[4]+@p[2]), mh-(@p[1]+@p[3])
			love.graphics.setColor(0.968, 0.294, 0.764, 0.5)
			love.graphics.rectangle("line", 0, 0, tw, th)
			-- END OF PUSH/START OF POP
			-- Draw objects... 
			love.graphics.pop()
			love.graphics.pop()
			love.graphics.setColor(1,1,1,1)

	getMarginDimensions: () =>
		w = @bpw-(@m[2]+@m[4])
		h = @bph-(@m[1]+@m[3])
		return w, h

	getPaddedDimensions: () =>
		w, h = @getMarginDimensions()
		w -= @p[2]+@p[4]
		h -= @p[1]+@p[3]
		return w, h

	pushMargin: () =>
		love.graphics.push()
		love.graphics.translate(@m[4], @m[1])

	pushPadding: () =>
		love.graphics.push()
		love.graphics.translate(@p[4], @p[1])

	pop: (count) =>
		for i=1, count
			love.graphics.pop()

	setScissor: (around) =>
		switch around
			when "p"
				w, h = @getPaddedDimensions()
				love.graphics.setScissor(@tx+@m[2]+@m[4], @ty+@m[1]+@m[3], w, h)
			when "m"
				w, h = @getMarginDimensions()
				love.graphics.setScissor(@tx, @ty, w, h)

	update: (dt) =>
		@timer\update(dt)
		if @hover
			@whileHover()

	onClick: (button) =>
		-- log.debug("onClick, id:#{@id or @.__class.__name}")

	detectHover: (x, y) =>
		x1, y1 = x, y
		h1, w1 = 1, 1
		x2, y2 = @tx+@m[4], @ty+@m[1]
		w2, h2 = @getMarginDimensions()
		if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
			if @hover == false
				@onHover()
			@hover = true
			return true
		return false

	whileHover: () =>

	onHover: () =>
		-- log.debug("onHover, id:#{@id or @.__class.__name}")

	onHoverExit: () =>
		-- log.debug("onHoverExit, id:#{@id or @.__class.__name}")

	wheelmoved: (x, y) =>

	mousemoved: (x, y, dx, dy) =>
		if not @detectHover(x, y)
			if @hover
				@onHoverExit()
				@hover = false

	mousepressed: (x, y, button) =>
		if @hover
			@onClick(button)
			@cclicked = true

	mousereleased: (button) =>
		@cclicked = false

	textinput: (t) =>

	keypressed: (key) =>

	keyreleased: (key) =>

	destroy: () =>
		@timer\destroy()
		UI.id[@id] = nil

	setTheme: () =>
		t = M.clone(UI.theme)
		for k,v in pairs(t)
			self[k] = v
		t = nil

class Text extends Element
	new: (@value, ...) =>
		super(...)

	activate: (...) =>
		super\activate(...)
		@foy = @text.font\getHeight()

	update: (dt) =>
		super\update(dt)

	draw: () =>
		w, h = @getPaddedDimensions()
		love.graphics.setFont(@text.font)
		@pushMargin()
		@pushPadding()
		if @text.alignv == "center"
			love.graphics.printf({@text.color, tostring(@value)}, 0, h/2-@foy/2, w, @text.alignh)
		else
			love.graphics.printf({@text.color, tostring(@value)}, 0, 0, w, @text.alignh)
		love.graphics.setFont(UI.df)
		@pop(2)
		super\draw()

class Button extends Element
	new: (@value, ...) =>
		super(...)

	activate: (...) =>
		super\activate(...)
		@foy = @text.font\getHeight()

	update: (dt) =>
		super\update(dt)

	draw: () =>
		love.graphics.setFont(@text.font)
		love.graphics.setColor(0, 0, 0, 1)

		if @cclicked then love.graphics.setColor(@bgf)
		elseif @hover then love.graphics.setColor(@bgh)
		else love.graphics.setColor(@bg)

		w, h = @getMarginDimensions()
		@pushMargin()
		love.graphics.rectangle("fill", 0, 0, w, h)
		w, h = @getPaddedDimensions()
		@pushPadding()
		if @text.alignv == "center"
			love.graphics.printf({@text.color, tostring(@value)}, 0, h/2-@foy/2, w, @text.alignh)
		else
			love.graphics.printf({@text.color, tostring(@value)}, 0, 0, w, @text.alignh)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(UI.df)
		@pop(2)
		super\draw()

class TextInput extends Element
	new: (@placeholder="", ...) =>
		super(...)
		@value = @placeholder
		@cursor = string.len(@value)
		@focus = false

		@font = @font or love.graphics.newFont(48)
		@align = "left"
		@color = {0,0,0,1}

		@cursorVisible = false
		@timer\every 0.5, -> @cursorVisible = not @cursorVisible

	activate: (...) =>
		super\activate(...)
		@foy = @text.font\getHeight()

	update: (dt) =>
		super\update(dt)


	onClick: (button) =>
		super\onClick(button)
		if not @focus
			@focus = true						

	mousepressed: (x,y, button) =>
		super\mousepressed(x,y,button)
		if @focus and not @hover
			@focus = false

	draw: () =>
		if @focus then love.graphics.setColor(@bgf)
		elseif @hover then love.graphics.setColor(@bgh)
		else love.graphics.setColor(@bg)
		
		w, h = @getMarginDimensions()
		@pushMargin()
		love.graphics.rectangle("fill", 0, 0, w, h)
		w, h = @getPaddedDimensions()
		@pushPadding()
		@setScissor("p")
		love.graphics.setFont(@text.font)
		if @text.alignv == "center"
			love.graphics.printf({@text.color, tostring(@value)}, 0, h/2-@foy/2, w, @text.alignh)
		else
			love.graphics.printf({@text.color, tostring(@value)}, 0, 0, w, @text.alignh)

		if @cursorVisible and @focus
			love.graphics.push()
			rw, lines = @text.font\getWrap(@value, w)

			-- Get cursor y position by seeing which substring we're over
			v = 1
			l = 0
			for k, line in pairs(lines)
				v += #line
				if v <= @cursor and @cursor <= v+#line
					l = k
					break

			-- Get cursor x position
			tc = 0
			d = 1
			if #lines > 1
				for i=1, l do tc += #lines[i]
				d = tc+1

			love.graphics.translate(@text.font\getWidth(@value\sub(d, @cursor))+2, (l*@foy))
			love.graphics.setColor(@text.color)
			love.graphics.line(0, 0, 0, @foy)
			love.graphics.pop()
		love.graphics.setFont(UI.df)
		love.graphics.setScissor()
		love.graphics.setColor(1,1,1,1)
		@pop(2)
		super\draw()

	kreyreleased: () =>
		@cursorVisible = false

	keypressed: (key) =>
		if @focus
			@cursorVisible = true
			--https://notabug.org/pgimeno/Gspot/src/master/Gspot.lua
			switch key
				when 'backspace'
					cur = @cursor
					if cur > 0 then
						@cursor = utf8char_begin(@value, cur) - 1
						@value = @value\sub(1, @cursor)..@value\sub(cur + 1)
				when 'delete'
					cur = utf8char_after(@value, @cursor + 1)
					@value = @value\sub(1, @cursor)..@value\sub(cur)
				when 'left'
					if @cursor > 0
						@cursor = utf8char_begin(@value, @cursor) - 1
				when 'right' 
					@cursor = utf8char_after(@value, @cursor + 1) - 1

	textinput: (t) =>
		if @focus
			if @value == @placeholder
				@value = ""
				@cursor = 0
			@value = @value\sub(1, @cursor) .. t .. @value\sub(@cursor + 1)
			@cursor += #t

class Checkbox extends Element
	new: (@value, ...) =>
		super(...)

	activate: (...) =>
		super\activate(...)

	draw: () =>
		@pushMargin()
		w, h = @getMarginDimensions()
		love.graphics.setColor(@bg)
		love.graphics.rectangle("fill", 0, 0, w, h)
		@pushPadding()
		w, h = @getPaddedDimensions()
		if @value -- checked
			love.graphics.setColor(@bgf)
			love.graphics.rectangle("fill", 0, 0, w, h)
		love.graphics.setColor(1,1,1,1)
		@pop(2)
		super\draw()

	onClick: () =>
		super\onClick()
		@value = not @value

class Image extends Element
	new: (@value, ...) =>
		super(...)
		@xfit = true
		@yfit = true
		@sx, @sy = 1, 1

	activate: (...) =>
		super\activate(...)
		w, h = @getPaddedDimensions()
		@sx = w/@value\getWidth()
		@sy = h/@value\getHeight()

	draw: () =>
		super\draw()
		@pushMargin()
		@pushPadding()
		love.graphics.draw(@value, 0, 0, 0, @sx, @sy)
		@pop(2)

class Slider extends Element
	new: (@min, @max, @tick, ...) =>
		super(...)
		@thx = 40
		@thw = 20
		@thh = 20
		@th_hover = false

	activate: (...) =>
		super\activate(...)

	draw: () =>
		super\draw()
		@pushMargin()
		w, h = @getMarginDimensions()

		@pushPadding()
		w, h = @getPaddedDimensions()
		love.graphics.line(0, h/2, w, h/2)
		love.graphics.rectangle("fill", @thx, h/2-@thh/2, @thw, @thh)
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("line", math.floor(@thx/@tick)*@tick, h/2-@thh/2, @thw, @thh)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(tostring @th_hover, 10, 10)
		@pop(2)

	update: (dt) =>
		super\update(dt)
		if @hover
			@th_hover = @detectHoverThumb(love.mouse.getX(), love.mouse.getY())

	detectHoverThumb: (x, y) =>
		x1, y1 = x, y
		h1, w1 = 1, 1
		x2, y2 = @tx+@thx, @ty+(@bph/2-@thh/2)
		w2, h2 = @thw, @thh
		if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
			if @th_hover == false
				@onHover()
			@th_hover = true
			return true
		return false

	mousemoved: (x, y, dx, dy) =>
		super\mousemoved(x, y, dx, dy)
		if love.mouse.isDown(1) and @th_hover
			@thx = L.clamp(x - @tx - @thw/2, 0, @bpw-@thw)

	mousepressed: (x, y , button) =>
		super\mousepressed(x, y, button)

UI.Master    = Master
UI.Container = Container
UI.Element   = Element
UI.Text      = Text
UI.TextInput = TextInput
UI.Button    = Button
UI.Checkbox  = Checkbox
UI.Image     = Image
UI.Slider    = Slider

return UI