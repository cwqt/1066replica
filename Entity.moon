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

  update: (dt) =>
    super\draw()

  draw: () =>
    super\draw()

  move: (tox, toy) =>
    path, length = Map.findPath({@x, @y},{tox, toy})
    if length <= @range

      -- if no delta y
      -- and enemy at end of path, charge
      if length > @chargeDistance
        print("Charge!")

      if path
        --o = Map.current[@y][@x].object
        print("Moving #{@.__class.__name} from #{inspect(path[1])} to #{inspect(path[#path])}")
        for i=1, #path do
          if i == #path then return
          
          -- Get direction in which we're travelling {x, y}
          d = Map.getDirection({path[i], path[i+1]})

          -- if moving in x, will see a ±1 in d[1] (x)
          -- check @x + d[1] to see next position if we carry on 
          -- moving in present direction and might see an enemy e.g.
          -- ----+ enemy <-- @x+d[1]
          --     |
          --     v
          --  attack at +
          
          -- Command is inserted into a stack, so if the object
          -- is copied (as in moveObject), the object referenced
          -- in the stack will remain the same, so @x/@y are static
          -- so we update it here
          @x, @y = path[i][1], path[i][2]
          x1 = path[i][1]+d[1]
          y1 = path[i][2]+d[2]

          -- Move object to next position
          Map.moveObject({path[i][1], path[i][2]},{path[i+1][1], path[i+1][2]})
         
          -- After move, our present position is the old predicted future position
          px, py = x1,y1
          -- If we were to keep moving along the same direction vector, our next
          -- position would be fx, fy
          -- probe this position for enemies to see if we should attack them
          -- and stop moving
          fx, fy = px + d[1], py + d[2]
          eo = Map.current[fy][fx].object
          if eo != nil
            print("Enemy infront of curent position (#{px}, #{py}) at #{fx}, #{fy}, attacking!")
            @attack(eo)
            return
    else
      print("Path out of range: #{length} > #{@range}")


  attack: (object) =>
    print("Attacking #{object.__class.__name} at #{object.x}, #{object.y}")
    dmg = math.ceil((@atk^2)/(@atk + object.def))
    print("Dealing #{dmg} damage")
    object.hp -= 10
    print("#{object.__class.__name} has #{object.hp}HP remaining")
    if object.hp <= 0
      object\die()

  die: () =>
    print("Unit #{@.__class.__name} lost at #{@x}, #{@y}")
    Map.removeObject(@x, @y)

return Entity

