Infobar = {}

Infobar.load = () ->
	Infobar.tw = love.graphics.getWidth!
	Infobar.th = MU.p * 2.5
	Infobar.tx = 0
	Infobar.ty = (Map.ty-Infobar.th)-MU.p/4
	Infobar.p = MU.p/2
	Infobar.space = Map.tx
	Infobar.timer = Timer!

Infobar.update = (dt) ->
	Infobar.timer\update(dt)

Infobar.draw = () ->
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
	MU.drawColoredCircleIcon Map.tx+r+Infobar.p,
		Infobar.th/2,
		r,
		player.icon,
		player.color.normal

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










return Infobar