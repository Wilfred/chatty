import System.IO

data IrcServer = IrcServer {
  address :: String,
  port :: Int
  }

data IrcMessage = IrcMessage {
  server :: IrcServer,
  channel :: String,
  content :: String,
  }
