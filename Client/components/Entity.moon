class Entity extends Map.Object
  new: (...) =>
    super(...)
    @timer = Timer!
    @range = 5
    @icon_img = G.assets["icons"][@.__class.__name]
    @cmdIndex = nil
    @cmd = {
      -- f: action time what to do to the object
      -- i: pre-select behaviour object
      -- m: instantiated behaviour
      ["MOVE"]: {
        f: (payload, x, y) -> @move(self, payload, x, y)
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

  update: (dt) =>
    @timer\update(dt)
    super\update(dt)

  draw: () =>
    super\draw()

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
    @timer\tween(2.5, self, {x: 10}, "linear", -> RM.next!)
  -- move: (path) =>
  --   if length <= @range 
  --     if path
  --       log.debug("Moving #{@.__class.__name} from #{inspect(path[1])} to #{inspect(path[#path])}")
  --       for i=1, #path do
  --         -- Command is inserted into a stack, so if the object
  --         -- is copied (as in moveObject), the object referenced
  --         -- in the stack will remain the same, so @x/@y are static
  --         -- so we update it here
  --         @x, @y = path[i][1], path[i][2]

  --         -- Table edge cases checking
  --         xub = L.clamp(@x+1, 1, Map.width)
  --         xlb = L.clamp(@x-1, 1, Map.width)
          
  --         -- Probe left and right of current position for enemies
  --         for i=xlb, xub do
  --           o = Map.current[@y][i].object
  --           if o and o != self
  --             if o.player != @player and o.player != nil
  --               log.debug("Enemy infront of curent position (#{@x}, #{@y}) at #{o.x}, #{o.y}, attacking!")
  --               @attack(o)
  --               return

  --         -- Finished moving
  --         if i == #path then return

  --         -- Move object to next position
  --         Map.moveObject({path[i][1], path[i][2]},{path[i+1][1], path[i+1][2]})
  --   else
  --     log.error("Path out of range: #{length} > #{@range}")
  --     return

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
