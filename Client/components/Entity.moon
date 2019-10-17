class Entity extends Map.Object
  new: (...) =>
    super(...)
    @timer = Timer!
    @range = 4
    @cmdIndex = nil
    @unit = Unit(self)
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
    super\update(dt)

  draw: () =>
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
    nextTileWillAtk = false

    checkIfEnemiesLRandAttack = (x, y) ->
      -- Every move check tile infront and behind in x for an enemy
      bx, by = L.clamp(x-1, 1, Map.current.width), y -- behind
      ax, ay = L.clamp(x+1, 1, Map.current.width), y -- ahead
      t = {bx, by, ax, ay}
      -- If enemy, attack them
      for i=1, #t-1, 2 do
        o = Map.getObjAtPos(t[i], t[i+1])
        if o then
          if o.belongsTo != @belongsTo
            -- @attack(o)
            return true
      return false

    recurse = (cx, cy) ->
      -- Next position to move to
      x, y = p[1], p[2]

      if #p >= 4 
        -- Get direction vector
        dx, dy = Map.getDirection(cx, cy, x, y)
        -- Not moving in y plane
        if dy != 0 then
          -- Check 1 tile head of current position
          ax = L.clamp(x+dx, 0, Map.current.width)
          o = Map.getObjAtPos(ax, y)
          if o then print o.__class.__name


      -- Moved through entire path, move actual object
      -- and run next command in command stack
      if #p == 0 then
        Map.moveObject(sx, sy, cx, cy)
        checkIfEnemiesLRandAttack(@x, @y)
        RM.next!
        return


      for i=1, 2 do table.remove(p, 1)
      @timer\tween .5, self, {x: x, y: y}, "linear", ->
        hasAtk = checkIfEnemiesLRandAttack(cx, cy)
        if hasAtk
          Map.moveObject(sx, sy, cx, cy)
          RM.next!
          return
        recurse(x, y) 

    recurse(sx, sy)

  attack: (enemy) =>
    DMG = math.ceil((@stats.ATK^2)/(@stats.ATK + enemy.stats.DEF))
    enemy.stats.HP -= DMG
    log.debug("Dealt #{DMG}DMG to #{enemy.__class.__name} @ { #{enemy.x}, #{enemy.y} }")
    if enemy.stats.HP <= 0
      enemy\die()

  die: () =>
    @timer\destroy!
    log.debug("#{@.__class.__name} died at { #{@x}, #{@y} }")
    Map.removeObject(@x, @y)


return Entity
