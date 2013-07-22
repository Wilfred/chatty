import Network(connectTo, PortNumber, PortID)
import System.IO(hSetBuffering, BufferMode(NoBuffering), hPutStr)

data IrcServer = IrcServer {
  address :: String,
  port :: PortID
  }

newtype IrcChannel = IrcChannel String

data IrcMessage = IrcMessage {
  server :: IrcServer,
  channel :: IrcChannel,
  content :: String
  }

sayMessage :: IrcMessage -> IO ()
sayMessage message = do
  let server' = (server message)
      address' = (address server')
      port' = (port server')
  socket <- connectTo address' port'
  hSetBuffering socket NoBuffering
  -- TODO: send the necessary hello first
  -- TODO: factor out a function that writes valid IRC message syntax
  hPutStr socket "todo"
  return ()
  
