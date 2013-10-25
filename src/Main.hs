{-# LANGUAGE OverloadedStrings #-}
module Main where

import Snap.Core(ifTop, Snap, route, getParam, setResponseCode, modifyResponse, writeBS)
import Snap.Util.FileServe(serveFile)
import Snap.Http.Server(quickHttpServe)

import Control.Applicative((<|>))
import Control.Monad.IO.Class (liftIO)

import Data.Maybe(listToMaybe, fromMaybe)
import Data.ByteString.Char8(unpack)

import Network(PortID(PortNumber))

import Irc

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (serveFile "about.txt") <|>
    route [ ("send", sendHandler)
          ]

sendHandler :: Snap ()
sendHandler = do
  server <- getParam "server"
  channel <- getParam "channel"
  message <- getParam "message"

  -- allow the user to specify a port, but default to 6667 if not given or invalid number.
  port <- getParam "port"
  let portNumber = case port of
        Just port' -> fromMaybe 6667 (maybeRead (unpack port') :: Maybe Integer)
        _ -> 6667

  -- allow the user to specify a nick, but default to 'chatty'
  nick <- getParam "nick"
  let ircNick = (IrcNick . maybe "chatty" unpack) nick

  case (server, channel, message) of
    (Just server', Just channel', Just message') -> do
      let ircServer = IrcServer { address=unpack server', port=PortNumber (fromInteger portNumber) }
      let ircMessage = IrcMessage { channel=IrcChannel (unpack channel'), content=unpack message' }
      liftIO $ sendToChannel ircServer ircNick ircMessage
      writeBS "ok"
    _ -> do
      modifyResponse $ setResponseCode 400
      writeBS "Need a server, a port, a channel and a message."


maybeRead :: Read a => String -> Maybe a
maybeRead = fmap fst . listToMaybe . reads
