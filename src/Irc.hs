import Network(connectTo, PortNumber, PortID)
import System.IO(hSetBuffering, BufferMode(NoBuffering), Handle, hPutStr)

data IrcServer = IrcServer {
  address :: String,
  port :: PortID
  }

newtype IrcChannel = IrcChannel String

data IrcMessage = IrcMessage {
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

privMessage :: IrcMessage -> String
privMessage m =
  "PRIVMSG " ++ channelName ++ " :" ++ (content m)
  where
    IrcChannel channelName = channel m

ircConnect :: IrcConfig -> IrcServer -> IO Handle
ircConnect config server = do
  -- open a connection
  handle <- connectTo (address server) (port server)
  hSetBuffering handle NoBuffering

  -- send the necessary HELLO
  hPutStr handle $ nickMessage config
  putStrLn $ nickMessage config
  hPutStr handle $ userMessage config
  putStrLn $ userMessage config

  -- We assume we will have sent the message and disconnected before
  -- the server send a PING.
  
  return handle



sayMessage :: Handle -> IrcMessage -> IO ()
sayMessage handle message = do
  hPutStr handle "todo"
  return ()
  
