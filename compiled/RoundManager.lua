local RM = { }
RM.turn = 0
RM.executingCommands = false
RM.cmdStack = { }
RM.cmdStack[1] = { }
RM.cmdStack[2] = { }
RM.pushCmd = function(who, command)
  return table.insert(RM.cmdStack[who], {
    command
  })
end
RM.nextRound = function()
  RM.turn = RM.turn + 1
end
RM.executeCommands = function(ft)
  if ft == nil then
    ft = true
  end
  if ft == true then
    print(string.rep("=", 30) .. "\nExecuting commands:")
    print(inspect(RM.cmdStack))
  end
  local PLAYERS_COUNT = #RM.cmdStack
  local c = 0
  for i = 1, PLAYERS_COUNT do
    c = c + #RM.cmdStack[i]
  end
  if c == 0 then
    print("No more commands, quitting...\n" .. string.rep("=", 30))
    return 
  else
    for i = 1, PLAYERS_COUNT do
      local currentPlayer = RM.cmdStack[i]
      if #currentPlayer > 0 then
        io.write("Player " .. tostring(i) .. ": ")
        currentPlayer[#currentPlayer][1]()
        table.remove(currentPlayer, #currentPlayer)
      end
    end
    return RM.executeCommands(false)
  end
end
return RM
