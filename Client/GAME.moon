GAME = {}
GAME.START_TIME = love.timer.getTime()
GAME.PLAYERS = {}
GAME.isLocal = true
GAME.fonts = {}
Game.isPlanning = true

GAME.UNITS = {
	["ENTITY"]: Entity
}

GAME.returnObjectFromType = (str, params) ->
	if not GAME.UNITS[str]
		log.error("No such unit #{str} indexed.")
	else
		return GAME.UNITS[str](table.unpack(params))

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
	["bg"]: love.graphics.newImage("media/img/bg.png")
}

F = {
	title:   "media/fonts/title.ttf"
	default: "media/fonts/default.ttf"
	bold:    "media/fonts/bold.ttf"
	mono:    "media/fonts/mono.ttf"
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
 