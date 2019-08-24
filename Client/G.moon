G = {}
G.START_TIME = love.timer.getTime()
G.PLAYERS = {}
G.isLocal = true
G.fonts = {}

G.instantiatePlayers = (_self, opponent) ->
	log.debug("self: #{_self}, opponent: #{opponent}")
	G.self     = _self
	G.opponent = opponent
	G.PLAYERS[_self]    = Player(_self)
	G.PLAYERS[opponent] = Player(opponent)

G.returnObjectFromType = (str, params) ->
	if not G.UNITS[str]
		log.error("No such unit #{str} indexed.")
	else
		return G.UNITS[str](params)

G.UNITS = {
	["MAP_OBJECT"]: Map.Object,
	["ENTITY"]: Entity,
}

G.COLOR = {0.1,0.1,0.1,1}
G.COLORS = {
	[1]: {0.53, 0.10, 0.19, 1},
	[2]: {0,0,1,1}
}

G.assets = {
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
for k, _ in pairs(F) do G.fonts[k] = {}
for k, font in pairs(F)
	for _, size in pairs(sizes)
		G.fonts[k][size] = love.graphics.newFont(font, size)


G.UUID = () ->
  fn = (x) ->
    r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef")\sub(r, r)
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", fn))


return G
 