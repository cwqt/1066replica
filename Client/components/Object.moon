class Object
  new: (@icon="█") =>
  	@uuid = G.UUID!
  	@player = 0
  	@createdAt = love.timer.getTime()

  update: (dt) =>
  
  draw: () =>
