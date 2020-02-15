UC = {}

UC.load = () ->

UC.draw = () ->
	if USI.user
		with love.graphics
			.push!
			.translate(20, 20)
			.setColor(G.hex("#cdcdcd"))
			.rectangle("fill", 0, 0, 300, 104)
			.setColor(1,1,1,1)
			.push!
			.scale(.4,.4)
			.draw(G.assets["user-icon"], 10, 10)
			.pop!
			.pop!

UC.update = (dt) ->

return UC