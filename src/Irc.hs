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

data IrcConfig = IrcConfig {
  nick :: String,
  userName :: String,
  hostName :: String,
  serverName :: String,
  realName :: String
  }

nickMessage :: IrcConfig -> String
nickMessage config = "NICK " ++ (nick config) ++ "\r\n"

userMessage :: IrcConfig -> String
userMessage c =
  "USER " ++ (userName c) ++ " " ++ (hostName c) ++ " " ++ (serverName c) ++ " :" ++ (realName c) ++ "\r\n"

joinMessage :: IrcChannel -> String
joinMessage (IrcChannel chan) = "JOIN " ++ chan ++ "\r\n"

ircConnect :: IrcConfig -> IrcServer -> IO Handle
ircConnect config server = do
  -- open a connection
  handle <- connectTo (address server) (port server)
  hSetBuffering handle NoBuffering

  -- send the necessary HELLO
  -- TODO
  
  return handle



sayMessage :: Handle -> IrcMessage -> IO ()
sayMessage handle message = do
  hPutStr handle "todo"
  return ()
  
