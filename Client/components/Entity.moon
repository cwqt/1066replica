class Entity extends Map.Object
  new: (...) =>
    super(...)
    @atk = 1
    @def = 10
    @mrl = 10
    @hp  = 10
    @range = 5
    @chargeDistance = 4
    @charging = false
    @icon_img = GAME.assets["icons"][@.__class.__name]
    -- @icon_img = love.graphics.newImage("media/img/icons/#{@.__class.__name}.png")

  update: (dt) =>
    super\draw()

  draw: () =>
    super\draw()

  move: (tox, toy) =>
    path, length = Map.findPath({@x, @y},{tox, toy})
    if not path then return

    if length <= @range 
      -- if no delta y
      -- and enemy at end of path, charge
      if length > @chargeDistance
        log.debug("Charge!")

      if path
        log.debug("Moving #{@.__class.__name} from #{inspect(path[1])} to #{inspect(path[#path])}")
        for i=1, #path do
          -- Command is inserted into a stack, so if the object
          -- is copied (as in moveObject), the object referenced
          -- in the stack will remain the same, so @x/@y are static
          -- so we update it here
          @x, @y = path[i][1], path[i][2]

          -- Table edge cases checking
          xub = L.clamp(@x+1, 1, Map.width)
          xlb = L.clamp(@x-1, 1, Map.width)
          
          -- Probe left and right of current position for enemies
          for i=xlb, xub do
            o = Map.current[@y][i].object
            if o and o != self
              if o.player != @player and o.player != nil
                log.debug("Enemy infront of curent position (#{@x}, #{@y}) at #{o.x}, #{o.y}, attacking!")
                @attack(o)
                return

          -- Finished moving
          if i == #path then return

          -- Move object to next position
          Map.moveObject({path[i][1], path[i][2]},{path[i+1][1], path[i+1][2]})
    else
      log.error("Path out of range: #{length} > #{@range}")
      return


  attack: (object) =>
    log.debug("Attacking #{object.__class.__name} at #{object.x}, #{object.y}")
    dmg = math.ceil((@atk^2)/(@atk + object.def))
    log.debug("Dealing #{dmg} damage")
    object.hp -= dmg
    log.debug("#{object.__class.__name} has #{object.hp}HP remaining")
    if object.hp <= 0
      object\die()

  die: () =>
    log.debug("Unit #{@.__class.__name} lost at #{@x}, #{@y}")
    Map.removeObject(@x, @y)

return Entity

