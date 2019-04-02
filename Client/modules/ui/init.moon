-- Container 0, 0
--	Container 1, 1		
--		Label 2, 2, "Hello"
--
--
--
UI = {}

class Master
	new: (@elements={}) =>
		-- 12 blocks wide at width of 100
		-- makes screen width at 1200px
		@bw, @bh = 12, 8
		@bs = 100
		@bpw, @bph = 12*@bs, 8*@bs
		love.window.setMode(@bpw, @bph)
		for k, element in pairs(@elements)
			element\activate(@bs)

	update: (dt) =>
		for k, container in pairs(@elements)
			container\update(dt)

	draw: () =>
		love.graphics.setColor(0,0,0,0.1)
		love.graphics.rectangle("fill", 0, 0, @bpw, @bph)
		love.graphics.setColor(1,1,1,1)
		for k, container in pairs(@elements)
			container\draw()
		for i=1, @bh+1
			love.graphics.line(0, (i-1)*@bs, @bpw, (i-1)*@bs)
		for i=1, @bw+1
			love.graphics.line((i-1)*@bs, 0, (i-1)*@bs, @bph)
		for y=1, @bh
			for x=1, @bw
				love.graphics.print(x..","..y, (x-1)*@bs, (y-1)*@bs)

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
	new: (@x, @y, @bw, @bh, @elements={}) =>
		@active = false
		print @x, @y, @bw, @bh

	activate: (@bps) =>
		-- @bps          -- parent box width
		@bs  = @bps / 2  -- self box width
		@bpw = @bw * @bs -- box pixel width
		@bph = @bh * @bs -- "       " height
		@active = true
		@hover  = false
		for k, element in pairs(@elements)
			element\activate(@bs)

	draw: () =>
		if @active
			love.graphics.push()
			love.graphics.translate((@x-1)*@bps, (@y-1)*@bps)
			super\draw()
			love.graphics.pop()

	update: (dt) =>
		if @active
			super\update(dt)

	detectHover: (x, y) =>
		x1, y1 = x, y
		h1, w1 = 1, 1
		x2, y2 = (@x-1)*100, (@y-1)*100
		w2, h2 = @bpw, @bph
		if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
			@hover = true
		return true

	-- Pass on input to elements
	wheelmoved: (x, y) =>
		for element in *@elements do element\wheelmoved(x, y)

	mousemoved: (x, y, dx, dy) =>
		for element in *@elements do element\mousemoved(x, y, dx, dy)
		if not @detectHover(x, y)
			@hover = false

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

--==============================================================

class Element
	new: (@x, @y, @bw, @bh) =>

	activate: (@bs) =>
		@bpw = @bw * @bs -- box pixel width
		@bph = @bh * @bs -- "       " height
		@active = true
		@hover  = false

	draw: () =>
		love.graphics.rectangle("fill", @x, @y, @bpw, @bph)

	update: (dt) =>
		if @hover
			@whileHover()

	onClick: () =>

	detectHover: (x, y) =>
		x1, y1 = x, y
		h1, w1 = 1, 1
		x2, y2 = @x*100, @y*100
		w2, h2 = @bpw, @bph
		if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
			if @hover == false
				@onHover()
			@hover = true
			return true
		return false

	whileHover: () =>

	onHover: () =>
		print "start hover"

	onHoverExit: () =>
		print "exit hover"

	wheelmoved: (x, y) =>

	mousemoved: (x, y, dx, dy) =>
		if not @detectHover(x, y)
			if @hover
				@onHoverExit()
				@hover = false

	mousepressed: (x, y, button) =>
		if @hover and button == 1
			print("Clicked!")

	mousereleased: (button) =>

	textinput: (t) =>

	keypressed: (key) =>

	keyreleased: (key) =>

	destroy: () =>


class Text extends Element
	new: (...) =>
		super(...)
		@font = love.graphics.setNewFont()
		@angle
		@align



	update: () =>

	draw: () =>

class TextInput 
	new: (...) =>
		super(...)
		@contents = ""

	update: () =>

	draw: () =>

	textinput: (t) =>
		print t


class Button extends Element
	new: (@label, ...) =>
		super(...)

	draw: () =>

	update: () =>


UI.Master    = Master
UI.Container = Container
UI.Element   = Element
UI.Button    = Button

return UI