P2P = {}

P2P.start = (peerIP) ->
  P2P.Client = sock.newClient(peerID, 22122)
  P2P.Server = sock.newServer("*", 22122)

  P2P.Client\on("connect", (data) -> print("Client connected to the server."))

  P2P.Server\on("connect", (data, client) -> client\send("hello", msg))

P2P.update = (dt) ->
  P2P.Client\update()
  P2P.Server\update()

return P2P

