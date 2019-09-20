MP = {}

MP.setMapFromFile = (mapFile) ->
	log.trace("Generating map from file (#{mapFile.title})")
	map = Map.generate(mapFile.width, mapFile.height)
	for y=1, map.height
		for x=1, map.width
			map[y][x].height  = mapFile.heightmap[y][x]
			map[y][x].terrain = mapFile.terrainmap[y][x]

	Map.set(map)

	log.trace("Placing map objects from file (#{mapFile.title})")
	for k, object in pairs(mapFile.objects) do
		obj = G.returnObjectFromType(object.type)
		Map.addObject(object.x, object.y, obj)

return MP