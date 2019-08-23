Notifications = require("modules.gui.Notifications")

RM = {}
RM.turn = -1
RM.executingCommands  = false
RM.playerCommands     = {}

RM.setCommandingStatusOnServer  = (v) ->
  NM.sendDataToServer({
    type: "USER_COMMANDING_OVER",
    payload: v
  })

RM.nextRound = () ->
  RM.turn += 1
  if not RM.turn == 0
    Notifications.push(1, "Round #{RM.turn} - Select commands", nil, nil, G.COLOR)
    RM.setCommandingStatusOnServer(true)

-- collect moves from player insert into cmdStack
-- once all commands are collected from each player we sort
-- them into an queue where each players commands are
-- executed one at a time
--{
  -- [G.self]     = {command1, command2, commandn ...}
  -- [G.opponent] = {commandn...}
--}
RM.collect = () ->
  for k, player in pairs(G.PLAYERS) do
    RM.playerCommands[k] = {}
    roundCommands = player\collect()
    for _, command in pairs(roundCommands) do
      table.insert(RM.playerCommands[k], command)
    player.commands = {}

RM.nextUntilDone = () ->
  while true
    isEnd = RM.next()
    break if isEnd

-- executeCmdQasPlayer and .next are functionally
-- equiv. except operate on Players rather than indivdual
-- entities
RM.executeCmdQasPlayer = () ->
  c = 0
  while true
    c += 1
    k = (c % 2) > 0 and 1 or 2
    m = RM.playerCommands[k][1]
    if m == nil then continue
    G.PLAYERS[k]["cmd"][m.type].f(m.payload, m.x, m.y)
    table.remove(RM.playerCommands[k], 1)
    break if #RM.playerCommands[1] + #RM.playerCommands[2] == 0

RM.next = () ->
  c = 0
  -- Keep repeating p1's commands if #p2 == 0
  recurse = () ->
    if (#RM.playerCommands[1] + #RM.playerCommands[2]) == 0
      return true --empty

    -- Flip-flop between p1 and p2 commands, executing first
    -- and unshifting it from p(n) array
    c += 1
    k = (c % 2) > 0 and 1 or 2
    m = RM.playerCommands[k][1]
    if m == nil then recurse()
    o = Map.getObjAtPos(m.x, m.y)
    o["cmd"][m.type](table.unpack(m.payload))
    table.remove(RM.playerCommands[k], 1)
    return false -- not empty 

  return recurse()

RM.requestPeerCommands = () ->
  NM.sendDataToPeer({
    type: "REQUEST_PEER_COMMANDS",
    payload: nil
  })

RM.setPeerCommands = (payload) ->
  for i=1, #payload
    G.PLAYERS[G.opponent]\pushCommand(payload[i])

return RM