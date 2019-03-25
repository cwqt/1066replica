class Entity extends Map.Object
  new: (...) =>
    super(...)
    @atk = 1
    @def = 10
    @mrl = 10
    @hp  = 10
    @range = 5
    @chrgDistance = 4

  update: (dt) =>
    super\draw()

  draw: () =>
    super\draw()

--  attack: (object) =>
--    print inspect object
--    dmg = math.ceil((@atk^2)/(@atk + object.def))
--    print("dmg: #{dmg}")
--    object.hp -= dmg
--    print object.hp

return Entity

