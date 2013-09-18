{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server

import Control.Monad.IO.Class (liftIO)

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

  -- todo: allow port to be specified too
  case (server, channel, message) of
    (Just server', Just channel', Just message') -> do
      let ircServer = IrcServer { address=(unpack server'), port=(PortNumber 6667) }
      let ircMessage = IrcMessage { channel=(IrcChannel (unpack channel')), content=(unpack message') }
      liftIO $ sendToChannel ircServer ircMessage
      writeBS "ok"
    _ -> writeBS "Need a server, a port, a channel and a message."

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param
