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
    print(string.rep("=", 30 ).. "\nExecuting commands:")
    print inspect RM.cmdStack

  PLAYERS_COUNT = #RM.cmdStack
  -- Check if any more commands exist
  c = 0
  for i=1, PLAYERS_COUNT do c += #RM.cmdStack[i]
  if c == 0
    print("No more commands, quitting...\n" .. string.rep("=", 30))
    -- if not, get out of recursive function
    return
  else
    -- For each player, execute their most recent command
    for i=1, PLAYERS_COUNT
      currentPlayer = RM.cmdStack[i]
      -- Check if player has commands, else remove the player stack
      if #currentPlayer > 0
        -- Execute player command and remove it from the table
        io.write("Player #{i}: ")
        currentPlayer[#currentPlayer][1]()
        table.remove(currentPlayer, #currentPlayer)
    RM.executeCommands(false)


return RM
