local P2P = { }
P2P.start = function(peerIP)
  P2P.Client = sock.newClient(peerIP, "22122")
  P2P.Server = sock.newServer("localhost", "22122")
  P2P.Client:on("connect", function(data)
    return print("Client connected to the server.")
  end)
  return P2P.Server:on("connect", function(data, client)
    return client:send("hello", msg)
  end)
end
P2P.update = function(dt)
  P2P.Client:update()
  return P2P.Server:update()
end
return P2P
