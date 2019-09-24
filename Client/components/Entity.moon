class Entity extends Map.Object
  new: (...) =>
    super(...)
    @timer = Timer!
    @range = 4
    @cmdIndex = nil
    @unit = Unit()
    @cmd = {
      -- f: action time what to do to the object
      -- i: pre-select behaviour object
      -- m: instantiated behaviour
      ["MOVE"]: {
        f: (payload, x, y) -> @move(payload, x, y)
        i: (...) -> require("components.behaviours.Move")(...)
        m: nil
        icon: G.assets["icons"]["Move"]
      }
      ["FIRE"]: {
        f: () -> print('test1')
        icon: G.assets["icons"]["Fire"]
      }
      ["TESTUDO"]: {
        f: () -> print('gottem2')
        icon: G.assets["icons"]["Testudo"]
      }
      ["FORTIFY"]: {
        f: () -> print('gottem2')
        icon: G.assets["icons"]["Fortify"]
      }
      ["SPEAR"]: {
        f: () -> print('gottem2')
        icon: G.assets["icons"]["Spear"]
      }
    }
    @stats = {
      HP:  5
      ATK: 10  -- attack
      DEF: 1  -- defence
      SPD: 1  -- speed
      STA: 1  -- stamina
      RNG: 1  -- range
      CRES: 1 -- cavalry resistance
      RRES: 1 -- ranged resistance
      MRES: 1 -- melee resistance
      CHRG: 1 -- charge bonus
      CHRR: 5 -- charge range
    }

  update: (dt) =>
    @timer\update(dt)
    @unit\update(dt)
    super\update(dt)

  draw: () =>
    @unit\draw!
    super\draw!

  requestCommandInput: (_type) =>
    PM["Command"].handlingUserInput = true
    PM["Command"].handlingCommand = _type
    PM["Command"].ui.canDraw = false
    @cmd[_type].m = @cmd[_type].i(self) 

  requestCommandFinish: () =>
    PM["Command"].handlingUserInput = false
    PM["Command"].handlingCommand = nil
    MU.deselectGS!

  pushCommand: (command) =>
    command.x = command.x or @x
    command.y = command.y or @y
    --cmdIndex == position in Player command list
    @cmdIndex = #G.PLAYERS[@belongsTo].commands + 1
    table.insert(G.PLAYERS[@belongsTo].commands, command)
    log.debug("#{@@.__name}(#{@uuid\sub(1,8)}) added: #{command.type}")

  popCommand: () =>
    if @cmdIndex
      table.remove(G.PLAYERS[@belongsTo].commands, @cmdIndex)
      log.debug("#{@@.__name}(#{@uuid\sub(1,8)}) popped: #{@cmdIndex}")

  move: (payload) =>
    p = payload
    -- Set initial start position
    sx, sy = @x, @y
    -- Strip starting position from path so we don't attempt to move to it
    for i=1, 2 do table.remove(p, 1)

    checkIfCharging = () ->
      -- Verify that the path is a straight line
      i_old = p[2]
      for i=2, #p, 2 do
        if i_old == p[i] then
          i_old = p[i]
          continue
        if i_old != p[i] then
          return true
      return false

    isCharging = checkIfCharging!

    recurse = (fx, fy) ->
      -- Moved through entire path, move actual object
      -- and run next command in command stack
      if #p == 0 then
        Map.moveObject(sx, sy, fx, fy)
        RM.next!
        return
      -- Next position to move to
      x, y = p[1], p[2]

      for i=1, 2 do table.remove(p, 1)
      @timer\tween .5, self, {x: x, y: y}, "linear", ->
        -- Every move check tile infront and behind in x for an enemy
        bx, by = L.clamp(fx-1, 1, Map.current.width), fy -- behind
        ax, ay = L.clamp(fx+1, 1, Map.current.width), fy -- ahead
        print ax, ay
        t = {bx, by, ax, ay}
        -- If enemy, attack them
        for i=1, #t-1, 2 do
          o = Map.getObjAtPos(t[i], t[i+1])
          if o then
            if o.belongsTo != @belongsTo
              @attack(o)

        recurse(x, y)  
    recurse(sx, sy)

  attack: (object) =>
    DMG = math.ceil((@stats.ATK^2)/(@stats.ATK + object.stats.DEF))
    object.stats.HP -= DMG
    log.debug("Dealt #{DMG}DMG to #{object.__class.__name} @ { #{object.x}, #{object.y} }")
    if object.stats.HP <= 0
      object\die()

  die: () =>
    @timer\destroy!
    log.debug("#{@.__class.__name} died at { #{@x}, #{@y} }")
    Map.removeObject(@x, @y)


return Entity
