import Network(connectTo, PortNumber, PortID)

data IrcServer = IrcServer {
  address :: String,
  port :: PortID
  }

data IrcMessage = IrcMessage {
  server :: IrcServer,
  channel :: String,
  content :: String
  }

sayMessage :: IrcMessage -> IO ()
sayMessage message = do
  let server' = (server message)
      address' = (address server')
      port' = (port server')
  h <- connectTo address' port'
  return ()
  
