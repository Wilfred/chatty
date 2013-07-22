import Network(connectTo, PortNumber, PortID)
import System.IO(hSetBuffering, BufferMode(NoBuffering), Handle, hPutStr)

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

ircConnect :: IrcServer -> IO Handle
ircConnect server = do
  handle <- connectTo (address server) (port server)
  hSetBuffering handle NoBuffering
  return handle

sayMessage :: IrcMessage -> IO ()
sayMessage message = do
  handle <- ircConnect $ server message
  -- TODO: send the necessary hello first
  -- TODO: factor out a function that writes valid IRC message syntax
  hPutStr handle "todo"
  return ()
  
