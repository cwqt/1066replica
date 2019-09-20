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
    @ATK = 1  -- attack
    @DEF = 1  -- defence
    @SPD = 1  -- speed
    @STA = 1  -- stamina
    @RNG = 1  -- range
    @CRES = 1 -- cavalry resistance
    @RRES = 1 -- ranged resistance
    @MRES = 1 -- melee resistance

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
    for i=1, 2 do table.remove(p, 1)
    sx, sy = @x, @y
    recurse = (fx, fy) ->
      -- todo: some checking for enemies, terrian speed calculation
      -- charging, etc.

      if #p == 0 then
          Map.moveObject(sx, sy, fx, fy)
          RM.next!
          return
      x, y = p[1], p[2]
      for i=1, 2 do table.remove(p, 1)
      @timer\tween(.5, self, {x: x, y: y}, "linear", -> recurse(x, y))    
    recurse!

  -- attack: (object) =>
  --   log.debug("Attacking #{object.__class.__name} at #{object.x}, #{object.y}")
  --   dmg = math.ceil((@atk^2)/(@atk + object.def))
  --   log.debug("Dealing #{dmg} damage")
  --   object.hp -= dmg
  --   log.debug("#{object.__class.__name} has #{object.hp}HP remaining")
  --   if object.hp <= 0
  --     object\die()

  die: () =>
    @timer\destroy!
    log.debug("Unit #{@.__class.__name} lost at #{@x}, #{@y}")
    Map.removeObject(@x, @y)


return Entity
