class Player
  new: () =>
    @moral = 100
    @player = #GAME.PLAYERS+1
    log.info("Created new Player #{@player}")
    table.insert(GAME.PLAYERS, @@)

  addUnit: (x, y, object) =>
    object.isPlayer = @player
    Map.addObject(x, y, object)
    

return Player
