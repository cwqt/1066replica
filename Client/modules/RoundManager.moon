RM = {}
RM.turn = 0
RM.executingCommands = false
RM.cmdStack = {}

--Player 1 and 2
RM.cmdStack[1] = {}
RM.cmdStack[2] = {}

RM.pushCmd = (who, command) ->
  table.insert(RM.cmdStack[who], { command } )
  -- RM.cmdStack[who][1] = {function: moveXtoY, {1,2,3,4}}

RM.nextRound = () ->
  RM.turn += 1

RM.executeCommands = (ft=true) ->
  if ft == true then
    log.info("Executing commands:")
    log.debug("\t #{inspect RM.cmdStack}")

  PLAYERS_COUNT = #RM.cmdStack
  -- Check if any more commands exist
  c = 0
  for i=1, PLAYERS_COUNT do c += #RM.cmdStack[i]
  if c == 0
    log.info("No more commands, quitting...")
    -- if not, get out of recursive function
    return
  else
    -- For each player, execute their most recent command
    for i=1, PLAYERS_COUNT
      currentPlayer = RM.cmdStack[i]
      -- Check if player has commands, else remove the player stack
      if #currentPlayer > 0
        -- Execute player command and remove it from the table
        log.debug("\tPlayer #{i}: ")
        currentPlayer[#currentPlayer][1]()
        table.remove(currentPlayer, #currentPlayer)
        Map.removeObjects()
    RM.executeCommands(false)



return RM
