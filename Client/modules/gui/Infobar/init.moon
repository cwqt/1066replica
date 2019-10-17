Infobar = {}

Infobar.statBar 					= require("modules.gui.Infobar.StatBar")
Infobar.integerStatBar 		= require("modules.gui.Infobar.IntegerStatBar")
Infobar.percentageStatBar = require("modules.gui.Infobar.PercentageStatBar")
Infobar.timerBar 					= require("modules.gui.Infobar.TimerBar")

Infobar.load = () ->
	Infobar.tw = love.graphics.getWidth!
	Infobar.th = MU.p * 2.5
	Infobar.tx = 0
	Infobar.ty = (Map.ty-Infobar.th)-MU.p/4
	Infobar.p = MU.p/2
	Infobar.space = Map.tx
	Infobar.timer = Timer!
	Infobar.timerBar = Infobar.timerBar(10)
	Infobar.states = {
		"UNIT_INFO",
		"PLAYER_INFO", 
		"BIG_MESSAGE"
	}
	Infobar.sideState = {
		[1]: "PLAYER_INFO",
		[2]: "PLAYER_INFO"
	}
	Infobar["UNIT_INFO"] 		= require("modules.gui.Infobar.states.UnitInfo")
	Infobar["PLAYER_INFO"] 	= require("modules.gui.Infobar.states.PlayerInfo")
	Infobar["BIG_MESSAGE"] 	= require("modules.gui.Infobar.states.BigMessage")

Infobar.setState = (side, state) ->
	if Infobar.sides[side] == nil then return
	if Infobar.states[state] == nil then return
	Infobar.activeState = state

Infobar.update = (dt) ->
	Infobar.timer\update(dt)
	Infobar.timerBar\update(dt)
	-- for side, state in pairs(Infobar.sideState) do
	-- 	Infobar.drawSide(side, state)

Infobar.draw = () ->
	Infobar.timerBar\draw!

	with love.graphics
		.push!
		.translate(Infobar.tx, Infobar.ty)
		.setColor(RGB(39,36,37,1))
		.rectangle("fill", 0, 0, Infobar.tw, Infobar.th)
		Infobar.drawPlayerIcon(G.PLAYERS[1])
		--Infobar.drawPopMapButton!
		Infobar.drawPlayerFactionName!
		Infobar.drawPlayerUnitCount!
		.pop!

	-- Infobar.test\draw!

-- target width, box width
Infobar.drawSqImageCenteredToBox = (tw, bw, icon) ->
	iw = icon\getWidth()
	s = tw/bw
	with love.graphics
		.push!
		.translate(bw/2, bw/2)
		.scale(s, s)
		.draw(icon, -iw/2, -iw/2)
		.pop!

Infobar.drawPopMapButton = () ->
	w = 1.5*MU.p - Infobar.p/2
	x, y = Infobar.p/2, Infobar.th/2 - w/2
	with love.graphics
		.setColor(RGB(31,31,31,1))
		.rectangle("fill", x, y, w, w,5,5)
		.setColor(1,1,1,0.1)
		.rectangle("line", x, y, w, w,5,5)
		.setColor(1,1,1,0.9)
		.push!
		.translate(x, y)
		Infobar.drawSqImageCenteredToBox(w/3, w, G.assets.icons["larger"])
		.pop!

Infobar.drawPlayerIcon = (player) ->
	r = (Infobar.th/2)-Infobar.p 
	with love.graphics
		.push!
		.translate(5.5*Infobar.p,Infobar.th/2)
		Infobar.drawPlayerCircleIcon(player, r)
		.pop!
	
Infobar.drawPlayerFactionName = (player) ->
	player = G.PLAYERS[G.self]
	with love.graphics
		.setFont(G.fonts["main"][180])
		.push!
		.scale(0.2, 0.2)
		.setColor(player.color.normal)
		.print("Roman", 125*(1/0.2), Infobar.p-5)
		.pop!

Infobar.drawPlayerUnitCount = (player) ->
	player = G.PLAYERS[G.self]
	with love.graphics
		.push!
		.translate(110, Infobar.th-(2.8*Infobar.p))
		.setColor(1,1,1,1)
		Infobar.drawSqImageCenteredToBox(5, 50, G.assets.icons["unit"])
		.setFont(G.fonts["mono"][27])
		.print(math.ceil(player.unitCount), 40, 10)
		.push!
		.pop!
		.pop!

Infobar.tweenPlayerUnitCount = (player, newValue) ->
	Infobar.timer\tween .2, player, {unitCount: newValue}, 'out-quint'

-- Infobar.drawMiscStatBar = (icon, value, min, max) ->
-- 	with love.graphics

Infobar.drawPlayerCircleIcon = (player, radius) ->
	gw = G.assets["grunge-circle"]\getWidth!
	gh = G.assets["grunge-circle"]\getHeight!
	iw, ih = player.icon\getWidth!, player.icon\getHeight!
	radius = radius*1.1
	with love.graphics
		--draw background fill
		.setColor(G.PLAYERS[1].color["normal"])
		.circle("fill", 0, 0, radius)
		
		--draw border image
		.setColor(1,1,1,1)
		.push!
		.scale(radius*2.2 /gw, radius*2.2 /gh)
		.draw(G.assets["grunge-circle"], -8-gw/2, -8-gh/2)
		.pop!

		-- draw player icon
		.push!
		.scale(radius*1.2 /iw, radius*1.2 /ih)
		.draw(player.icon, -iw/2, -ih/2)
		.pop!



class Infobar.statBar
	new: (@value, @maxValue, @icon) =>
		@sf = 15
		@iw, @ih = @icon\getWidth!, @icon\getHeight!
		@isx, @isy = @sf/@iw, @sf/@ih 
		@step = @maxValue/5

	update: () =>

	draw: () =>
		with love.graphics
			.push!
			.scale(@isx, @isy)
			.draw(@icon, 0, 0)
			.pop!
			.push!
			.translate(@iw*@isx,0)

			for i=1, 5 do
				.setColor(1,1,1,1)
				if @value < i*@step then
					.setColor(.6,.6,.6,1)
				.push!
				.translate(10*(i-1), 0)
				.rectangle("fill", 0, 0, .5*@sf, 1*@sf)
				.pop!
			.pop!

--






Infobar.drawPlayerSideItems = (player) ->

Infobar.drawSelectedUnitItems = (unit) ->

Infobar.drawPlayerMorale = (player) ->

Infobar.drawLargeInfoText = (text) ->

-- class Infobar.percentageStatBar extends Infobar.statBar
-- 	new: (...) =>
-- 		super(...)

-- class Infobar.integerStatBar extends Infobar.statBar
-- 	new: () =>
-- 		super(...)






return Infobar