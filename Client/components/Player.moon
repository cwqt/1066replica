margin = 6

class Player
  new: (@player) =>
    @morale = 100
    log.info("Created new Player #{@player}")
    @px, @py = 0, 1
    @margin = margin
    @roundCommands = {}
    
    @cmd = {
      ["SET_INITIAL_UNITS"]: {
        f: (units) ->
          @placeUnits(units)
      }
      ["CREATE_OBJECT"]: {
        f: (payload, x, y) ->
          o = GAME.returnObjectFromType(payload.type, payload.payload or {})
          o.player = @player
          Map.addObject(x, y, o)
      }
      ["DIRECT_MOVE"]: {
        f: (data) ->
          Map.moveObject(
            data.payload.sx, 
            data.payload.sy,
            data.payload.ex,
            data.payload.ey)
      }
    }

  pushCommand: (command) =>
    -- print inspect command
    log.debug("Player(#{@player}) added command: #{command.type}")
    table.insert(@roundCommands, command)

  placeUnits: (objects) =>
    -- Defines a simple map for positions in which objects
    -- should initially be placed, top to bottom, incrementing
    -- column when at end of row
    c = 1
    placementMap = {}
    virtualMap = Map.generate(margin, Map.height)
    for x=1, @margin do
      for y=1, Map.height do
        virtualMap[y][x] = { object: {icon: "x"} }
        c += 1
        if c > #objects
          placementMap = virtualMap
          break
      if c > #objects then break

    -- If we're the opponent, our objects need to be basically flipped
    -- and then later offset by the Map.width - @margin
    if @player == GAME.opponent
      log.info("Flipping placement map")
      for y=1, Map.height do
        placementMap[y] = M.reverse(placementMap[y])

    -- Give each CREATE_OBJECT an x & y position
    t = {}
    for y=1, Map.height do
      for x=1, @margin do
        if placementMap[y][x].object and #objects > 0
          m = {
            -- For opponent, offset to opposite side of board
            x: @player == GAME.opponent and x+(Map.width - @margin) or x,
            y: y,
            type: objects[1].type,
            payload: objects[1].payload
          }
          table.insert(t, m)
          table.remove(objects, 1)
        else
          continue

    -- Insert CREATE_OBJECTs with defined x,y pos for 
    -- entities to be later created 
    for _, command in pairs(t) do
      @pushCommand(command)

return Player
