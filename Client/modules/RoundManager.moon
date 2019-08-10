Notifications = require("modules.gui.Notifications")

RM = {}
RM.turn = 0
RM.executingCommands  = false
RM.playerCommands     = {}
RM.commandQueue       = {}

RM.nextRound = () ->
  RM.turn += 1
  Notifications.push(1, "Round #{RM.turn} - Select commands", nil, nil, GAME.COLOR)

-- collect moves from player insert into cmdStack
-- once all commands are collected from each player we sort
-- them into an queue where each players commands are
-- executed one at a time
RM.collect = (commands, who) ->
  RM.playerCommands[who] = commands

RM.sort = () ->
  log.info("Sorting:")
  log.debug("\t #{inspect RM.unsortedCommands}")
  -- Recursive sort commands into {[1]:[1], [2]:[1], [1]:[2]}
  c = 0
  sortedCommands = {}
  srt = () ->
    -- See how many commands remain
    for _, commandList in ipairs(RM.playerCommands) do
      c += #commandList 
    -- We've finished sorting
    if c == 0 then
      return sortedCommands
    -- Loop through each player once, pushing the first-most
    -- command to the sortedCommands list
    for i=1, #RM.playerCommands
      sortedCommands[#sortedCommands] = RM.playerCommands[i][1]
      table.remove(RM.playerCommands[i], 1)
    -- Repeat this until the length of all playerCommands = 0
    srt()

  RM.sortedCommands = srt()
  log.debug(inspect(RM.sortedCommands))

RM.clear = () ->
  RM.unsortedCommands = {}
  RM.sortedCommands   = {}

RM.next = () ->
  if #RM.commandQueue == 0
    return false
  -- {x:1, y:2, type:"MOVE_PIECE", payload: {}}
  m = RM.commandQueue[1]
  o = Map.getObjAtPos(m.x, m.y)
  o["commands"][m.type](table.unpack(m.payload))
  table.remove(RM.commandQueue, 1)
  return true

return RM