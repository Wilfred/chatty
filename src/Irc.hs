module Irc where

import Network(connectTo, PortID())
import System.IO(hSetBuffering, BufferMode(NoBuffering), Handle, hPutStr, hClose, hGetLine)

-- todo: rename to server
data IrcServer = IrcServer {
  address :: String,
  port :: PortID
  } deriving Show

newtype IrcChannel = IrcChannel String deriving Show

newtype IrcNick = IrcNick String deriving Show

-- todo: rename to message
data IrcMessage = IrcMessage {
  channel :: IrcChannel,
  content :: String
  } deriving Show

data IrcConfig = IrcConfig {
  userName :: String,
  hostName :: String,
  serverName :: String,
  realName :: String
  } deriving Show

defaultConfig :: IrcConfig
defaultConfig = IrcConfig {
  userName="chatty",
  hostName="chatty",
  serverName="chatty",
  realName="Chatty IRC Bridge"
  }

nickMessage :: IrcNick -> String
nickMessage (IrcNick nick) = "NICK " ++ nick ++ "\r\n"

userMessage :: IrcConfig -> String
userMessage c =
  "USER " ++ userName c ++ " " ++ hostName c ++ " " ++ serverName c ++ " :" ++ realName c ++ "\r\n"

joinMessage :: IrcChannel -> String
joinMessage (IrcChannel chan) = "JOIN " ++ chan ++ "\r\n"

privMessage :: IrcMessage -> String
privMessage m =
  "PRIVMSG " ++ channelName ++ " :" ++ content m ++ "\r\n"
  where
    IrcChannel channelName = channel m

quitMessage :: String
quitMessage = "QUIT\r\n"

ircConnect :: IrcServer -> IrcConfig -> IrcNick -> IO Handle
ircConnect server config nick = do
  -- open a connection
  handle <- connectTo (address server) (port server)
  hSetBuffering handle NoBuffering

  -- send the necessary HELLO
  writeToHandle handle $ nickMessage nick
  writeToHandle handle $ userMessage config

  -- We assume we will have sent the message and disconnected before
  -- the server send a PING.
  
  return handle

ircDisconnect :: Handle -> IO ()
ircDisconnect handle = do
  --tell the server we're quitting
  writeToHandle handle quitMessage

  --disconnect
  hClose handle

writeToHandle :: Handle -> String -> IO ()
writeToHandle h s = do
  hPutStr h s
  putStr $ "sent: " ++ s

-- top level function
sendToChannel :: IrcServer -> IrcNick -> IrcMessage -> IO ()
sendToChannel server nick message = do
  -- open a connection to the server
  h <- ircConnect server defaultConfig nick

  -- read some data to keep the server happy
  hGetLine h

  --join the channel
  --TODO: this shouldn't be necessary
  writeToHandle h $ joinMessage $ channel message

  --send the message
  writeToHandle h $ privMessage message

  ircDisconnect h
