GAME = {}
GAME.START_TIME = love.timer.getTime()
GAME.PLAYERS = {}
GAME.isLocal = true
GAME.fonts = {}

GAME.instantiatePlayers = (_self, opponent) ->
	log.debug("self: #{_self}, opponent: #{opponent}")
	GAME.self     = _self
	GAME.opponent = opponent
	GAME.PLAYERS[_self]    = Player(_self)
	GAME.PLAYERS[opponent] = Player(opponent)

GAME.returnObjectFromType = (str, params) ->
	if not GAME.UNITS[str]
		log.error("No such unit #{str} indexed.")
	else
		return GAME.UNITS[str](params)

GAME.UNITS = {
	["ENTITY"]: Entity
}

GAME.COLOR = {0.1,0.1,0.1,1}
GAME.COLORS = {
	[1]: {0.53, 0.10, 0.19, 1},
	[2]: {0,0,1,1}
}

GAME.assets = {
	["icons"]: {
		["Entity"]:  love.graphics.newImage("media/img/icons/Entity.png")
		["Move"]:    love.graphics.newImage("media/img/icons/Move.png")
		["Fortify"]: love.graphics.newImage("media/img/icons/Fortify.png")
		["Fire"]:    love.graphics.newImage("media/img/icons/Fire.png")
		["Testudo"]: love.graphics.newImage("media/img/icons/Testudo.png")
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
sizes = {16, 27, 50, 100, 216}
for k, _ in pairs(F) do GAME.fonts[k] = {}
for k, font in pairs(F)
	for _, size in pairs(sizes)
		GAME.fonts[k][size] = love.graphics.newFont(font, size)

return GAME
 