GAME = {}
GAME.START_TIME = love.timer.getTime()
GAME.PLAYERS = {}
GAME.fonts = {}
Game.isPlanning = true

GAME.UNITS = {
	[1]: Entity
}

GAME.COLORS = {
	[1]: {0.53, 0.10, 0.19, 1},
	[2]: {0,0,1,1}
}

F = {
	title:   "title.ttf"
	default: "default.ttf"
	bold:    "bold.ttf"
	mono:    "mono.ttf"
	title2:  "THEROOTS.TTF"
	text:    "Romanica.ttf"
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
 