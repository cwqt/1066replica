GAME = {}
GAME.START_TIME = love.timer.getTime()
GAME.PLAYERS = {}
GAME.fonts = {}
GAME.isPlanning = true

GAME.UNITS = {
	[1]: Entity
}

GAME.COLORS = {
	[1]: {1,0,0,1},
	[2]: {0,0,1,1}
}

F = {
	title:   "title.ttf"
	default: "default.ttf"
	bold:    "bold.ttf"
	mono:    "mono.ttf"
}

-- Function to provide fonts in sizes:
-- 8
-- 27
-- 64
-- 125
-- 216
-- 343
sizes = {16, 27, 100, 216}
for k, _ in pairs(F) do GAME.fonts[k] = {}
for k, font in pairs(F)
	for _, size in pairs(sizes)
		GAME.fonts[k][size] = love.graphics.newFont(font, size)

return GAME
