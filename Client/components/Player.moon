margin = 5

class Player
  new: (@player) =>
    @morale = 100
    log.info("Created new Player #{@player}")
    @px, @py = 0, 1
    @margin = margin
    @roundCommands = {}
    
    @cmd = {
      ["SET_INITIAL_UNITS"]: {
        f: (data) ->
          @placeUnits(data)
      }
      ["CREATE_OBJECT"]: {
        f: (data) ->
          Map.addObject(
            data.payload.x,
            data.payload.y,
            GAME.returnObjectFromType(data.type, data.payload.payload))
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

    GAME.PLAYERS[@player] = self

  pushCommand: (command) =>
    -- print inspect command
    log.debug("Player(#{@player}) added command: #{command.type}")
    table.insert(@roundCommands, command)

  placeUnits: (objects) =>
    @py = 1
    c = 0
    for y=1, #Map.current
      for x=1, margin
        if Map.current[y][x].object
          c += 1

    totalFreeSpaces = #Map.current*margin - c
    while #objects > totalFreeSpaces
      margin += 1
      totalFreeSpaces = #Map.current*margin - c

    for _, object in pairs(objects)
      object.player = @player

      if Game.isPlanning
        tx, tw = 1, margin
        if @player % 2 == 0
          tx, tw = Map.width-margin+2, Map.width

        while Map.current[@py][tx].object
          tx += 1
          if tx-1 == tw
            @py += 1
            tx = (@player % 2 == 0) and Map.width-margin+2 or 1

        -- Map.addObject(tx, @py, object)
        
        @cmd["CREATE_OBJECT"]({
          type: object.type,
          payload: object.payload,
          x: tx, y: @py
        })

    @margin = margin







return Player
