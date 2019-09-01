Infobar = {}

Infobar.load = () ->
	Infobar.tw = love.graphics.getWidth!
	Infobar.th = MU.p * 1.5
	Infobar.tx = 0
	Infobar.ty = (Map.ty-Infobar.th)-MU.p/4
	Infobar.p = 10
	Infobar.space = Map.tx

Infobar.update = (dt) ->

Infobar.draw = () ->
	with love.graphics
		.push!
		.translate(Infobar.tx, Infobar.ty)
		.setColor(RGB(39,36,37,1))
		.rectangle("fill", 0, 0, Infobar.tw, Infobar.th)
		for k, player in pairs(G.PLAYERS)
			Infobar.drawPlayerIcon(player)
		.pop!

Infobar.drawPlayerIcon = (player) ->
	MU.drawColoredCircleIcon Infobar.space+Infobar.th/2,
		Infobar.th/2,
		(Infobar.th/2)-Infobar.p,
		player.icon,
		player.color.dark

	-- with love.graphics
	-- 	.push!
	-- 	.setColor(1,1,1,1)
	-- 	.setLineWidth(5)
	-- 	.circle("line", 0, Infobar.th/2, (Infobar.th/2)-Infobar.p)
	-- 	.setLineWidth(1)
	-- 	.setColor(player.color.light)
	-- 	.circle("fill", 0, Infobar.th/2, (Infobar.th/2)-Infobar.p)
	-- 	.pop!

return Infobar