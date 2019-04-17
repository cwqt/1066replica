class Player
  new: (@player) =>
    @morale = 100
    log.info("Created new Player #{@player}")
    @px, @py = 1, 1
    GAME.PLAYERS[@player] = @@

  addUnit: (object) =>
    object.isPlayer = @player
    if GAME.isPlanning
    	-- 5 blocks padding (min.)
	    Map.addObject(@px, @py, object)
    	@px += 1
    	if @px == 5
    		@px = 1
    		@py += 1

return Player
