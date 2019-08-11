Notifications = require("modules.gui.Notifications")

RM = {}
RM.turn = -1
RM.executingCommands  = false
RM.playerCommands     = {}
RM.commandQueue       = {}

RM.setCommandingStatusOnServer  = (v) ->
  NM.sendDataToServer({
    type: "USER_COMMANDING_OVER",
    payload: v
  })


RM.nextRound = () ->
  RM.turn += 1
  if not RM.turn == 0
    Notifications.push(1, "Round #{RM.turn} - Select commands", nil, nil, GAME.COLOR)
    RM.setCommandingStatusOnServer(true)


-- collect moves from player insert into cmdStack
-- once all commands are collected from each player we sort
-- them into an queue where each players commands are
-- executed one at a time
--{
  -- [GAME.self]     = {command1, command2, commandn ...}
  -- [GAME.opponent] = {commandn...}
--}
RM.collect = () ->
  for k, player in pairs(GAME.PLAYERS) do
    RM.playerCommands[k] = {}
    for _, command in pairs(player.roundCommands) do
      table.insert(RM.playerCommands[k], command)


RM.sort = () ->
  log.info("Sorting playerCommands")
  -- Recursive sort commands into {[p1]:[c1], [p2]:[c1], [p1]:[c2], [p2]:[c2]}
  sortedCommands = {}
  srt = () ->
    c = 0
    -- Loop through each player once, pushing the first-most
    -- command to the sortedCommands list
    for key, player in pairs(RM.playerCommands) do
      for _, command in pairs(player) do
        c += 1
      if c == 0
        return sortedCommands
      else
        table.insert(sortedCommands, player[1])
        table.remove(player, 1)
    srt()
  log.debug('Sorted playerCommands')
  RM.commandQueue = srt()


RM.clear = () ->
  RM.playerCommands = {}
  RM.commandQueue   = {}


RM.executeCmdQasPlayer = () ->
  if #RM.commandQueue == 0
    return false
  for i, command in pairs(RM.commandQueue) do
    k = (i%2) > 0 and 1 or 2
    GAME.PLAYERS[k]["cmd"][command.type].f(command.payload)


RM.next = () ->
  if #RM.commandQueue == 0
    return false
  -- {x:1, y:2, type:"MOVE_PIECE", payload: {}}
  m = RM.commandQueue[1]
  o = Map.getObjAtPos(m.x, m.y)
  o["cmd"][m.type](table.unpack(m.payload))
  table.remove(RM.commandQueue, 1)
  return true


RM.requestPeerCommands = () ->
  NM.sendDataToPeer({
    type: "REQUEST_PEER_COMMANDS",
    payload: nil
  })


RM.setPeerCommands = (payload) ->
  for i=1, #payload
    GAME.PLAYERS[GAME.opponent]\pushCommand(payload[i])

return RM