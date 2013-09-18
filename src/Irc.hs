module Irc where

import Network(connectTo, PortID(PortNumber))
import System.IO(hSetBuffering, BufferMode(NoBuffering), Handle, hPutStr, hClose, hGetLine)

-- todo: rename to server
data IrcServer = IrcServer {
  address :: String,
  port :: PortID
  } deriving Show

newtype IrcChannel = IrcChannel String deriving Show

-- todo: rename to message
data IrcMessage = IrcMessage {
  channel :: IrcChannel,
  content :: String
  } deriving Show

data IrcConfig = IrcConfig {
  nick :: String,
  userName :: String,
  hostName :: String,
  serverName :: String,
  realName :: String
  } deriving Show

config = IrcConfig {
  nick="chatty",
  userName="chatty",
  hostName="chatty",
  serverName="chatty",
  realName="Chatty IRC notifier"
  }

nickMessage config = "NICK " ++ (nick config) ++ "\r\n"

userMessage :: IrcConfig -> String
userMessage c =
  "USER " ++ (userName c) ++ " " ++ (hostName c) ++ " " ++ (serverName c) ++ " :" ++ (realName c) ++ "\r\n"

joinMessage :: IrcChannel -> String
joinMessage (IrcChannel chan) = "JOIN " ++ chan ++ "\r\n"

privMessage :: IrcMessage -> String
privMessage m =
  "PRIVMSG " ++ channelName ++ " :" ++ (content m) ++ "\r\n"
  where
    IrcChannel channelName = channel m

ircConnect :: IrcConfig -> IrcServer -> IO Handle
ircConnect config server = do
  -- open a connection
  handle <- connectTo (address server) (port server)
  hSetBuffering handle NoBuffering

  -- send the necessary HELLO
  writeToHandle handle $ nickMessage config
  writeToHandle handle $ userMessage config

  -- We assume we will have sent the message and disconnected before
  -- the server send a PING.
  
  return handle

writeToHandle :: Handle -> String -> IO ()
writeToHandle h s = do
  hPutStr h s
  putStrLn $ "sent: " ++ s

-- top level function
sendToChannel :: IrcServer -> IrcMessage -> IO ()
sendToChannel server message = do
  -- open a connection to the server
  h <- ircConnect config server

  -- read some data to keep the server happy
  hGetLine h

  --join the channel
  --TODO: this shouldn't be necessary
  writeToHandle h $ joinMessage $ channel message

  --send the message
  writeToHandle h $ privMessage message

  --disconnect
  hClose h
