class Object
  new: () =>
  	@icon = "█"
  	@uuid = G.UUID!
  	@player = 0
  	@createdAt = love.timer.getTime()
	  @icon_img = G.assets["icons"][@.__class.__name]
	  @belongsTo = 0

  update: (dt) =>
  
  draw: () =>
