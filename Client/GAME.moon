GAME = {}
GAME.START_TIME = love.timer.getTime()
GAME.PLAYERS = {}
GAME.LOCAL = true
GAME.fonts = {}
Game.isPlanning = true

GAME.UNITS = {
	[1]: Entity
}

GAME.COLOR = {0.1,0.1,0.1,1}
GAME.COLORS = {
	[1]: {0.53, 0.10, 0.19, 1},
	[2]: {0,0,1,1}
}

GAME.assets = {
	["icons"]: {
		["Move"]:    love.graphics.newImage("media/img/icons/Move.png")
		["Fortify"]: love.graphics.newImage("media/img/icons/Fortify.png")
		["Fire"]:    love.graphics.newImage("media/img/icons/Fire.png")
		["Testudo"]: love.graphics.newImage("media/img/icons/Testudo.png")
		["Entity"]:  love.graphics.newImage("media/img/icons/Entity.png")
		["Spear"]:   love.graphics.newImage("media/img/icons/Spear.png")
	}
}

F = {
	title:   "media/fonts/title.ttf"
	default: "media/fonts/default.ttf"
	bold:    "media/fonts/bold.ttf"
	mono:    "media/fonts/mono.ttf"
	title2:  "media/fonts/THEROOTS.TTF"
	text:    "media/fonts/Romanica.ttf"
}

-- Function to provide fonts in sizes:
-- 8
-- 27
-- 64
-- 125
-- 216
-- 343
sizes = {16, 27, 50, 100, 216}
for k, _ in pairs(F) do GAME.fonts[k] = {}
for k, font in pairs(F)
	for _, size in pairs(sizes)
		GAME.fonts[k][size] = love.graphics.newFont(font, size)

return GAME
 