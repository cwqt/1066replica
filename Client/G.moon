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

G.playerIsOnLeft = (player) ->
	return (player % 2) > 0 and true or false

G.returnObjectFromType = (str, params) ->
	if not G.UNITS[str]
		log.error("No such unit #{str} indexed.")
	else
		return G.UNITS[str](params)

G.UNITS = {
	["MAP_OBJECT"]: Map.Object,
	["ENTITY"]: Entity,
}

G.COLORS = {
	['red-light']: 	RGB(299, 0  , 0)--RGB(227, 67 , 99) 
	['red']: 				RGB(212, 0  , 0)
	['red-dark']: 	RGB(126, 28 , 48)
	['blue-light']: RGB(93 , 133, 255)
	['blue']: 			RGB(0  , 64 , 255)
	['blue-dark']: 	RGB(0  , 41 , 163)
	['grey']:       RGB(100, 100, 100) 
}

G.TERRAINS = {
	[1]: {
		name: "Road",
		image: love.graphics.newImage("media/img/terrains/road.png")	
		buffs: {
			atk: 0.9,
			mov: 1.2,
			def: 1.0
		}
	}
	[2]: {
		name: "Grass",
		image: love.graphics.newImage("media/img/terrains/grass.png")	
	}
	[3]: {
		name: "Mud",
		image: love.graphics.newImage("media/img/terrains/mud.png")	
	}
	[4]: {
		name: "Rocky",
		image: love.graphics.newImage("media/img/terrains/rocky.png")	
	}
	[5]: {
		name: "Water",
		image: love.graphics.newImage("media/img/terrains/water.png")
	}
	[6]: {
		name: "Deep water",
		image: love.graphics.newImage("media/img/terrains/deep_water.png"),
		passable: false
	}
	[7]: {
		name: "Snow",
		image: love.graphics.newImage("media/img/terrains/snow.png")
	}
}

G.image = love.graphics.newImage("media/test.png") 
G.assets = {
	["icons"]: {
		["Object"]:  love.graphics.newImage("media/img/icons/Rock.png")
		["Entity"]:  love.graphics.newImage("media/img/icons/Entity.png")
		["Move"]:    love.graphics.newImage("media/img/icons/Move.png")
		["Fortify"]: love.graphics.newImage("media/img/icons/Fortify.png")
		["Fire"]:    love.graphics.newImage("media/img/icons/Fire.png")
		["Testudo"]: love.graphics.newImage("media/img/icons/Testudo.png")
		["Spear"]:   love.graphics.newImage("media/img/icons/Spear.png")
		["Roman"]: 	 love.graphics.newImage("media/img/icons/Roman.png")
		--
		["point"]:   love.graphics.newImage("media/img/icons/point.png")
		["larger"]:  love.graphics.newImage("media/img/icons/larger.png")
		["smaller"]: love.graphics.newImage("media/img/icons/smaller.png")
		["unit"]: 	 love.graphics.newImage("media/img/unit.png")
	}
	["bg"]: love.graphics.newImage("media/img/bg.png")
}

F = {
	title:   "media/fonts/title.ttf"
	default: "media/fonts/default.ttf"
	-- bold:    "media/fonts/bold.ttf"
	mono:    "media/fonts/mono.ttf"
	-- text:    "media/fonts/Romanica.ttf"
	main:    "media/fonts/main.ttf"
}
-- Function to provide fonts in sizes:
sizes = {16, 27, 36, 50, 100, 180, 216}
for k, _ in pairs(F) do G.fonts[k] = {}
for fontname, font in pairs(F)
	for _, size in pairs(sizes)
		G.fonts[fontname][size] = love.graphics.newFont(font, size)

--helper functions
G.UUID = () ->
  fn = (x) ->
    r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef")\sub(r, r)
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", fn))

G.pushRotate = (x, y, r) ->
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.translate(-x, -y)

G.pushRotateScale = (x, y, r, sx, sy) ->
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.scale(sx or 1, sy or sx or 1)
  love.graphics.translate(-x, -y)

return G
 