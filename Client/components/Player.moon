margin = 5

class Player
  new: (@player) =>
    @morale = 100
    log.info("Created new Player #{@player}")
    @px, @py = 0, 1
    @margin = margin
    GAME.PLAYERS[@player] = self

  addCommand: (command) =>
    log.debug("Player(#{@player}) added command: #{command}")
    RM.pushCmd(@player, command)

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

        Map.addObject(tx, @py, object)

    @margin = margin

return Player
