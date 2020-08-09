{-# LANGUAGE OverloadedStrings #-}
module Lib where

import Network.Wai ( Application, responseLBS, responseFile, requestMethod, requestBody  )
import Network.HTTP.Types ( status200, status404 )
import Network.HTTP.Types.Method ( methodGet )
import qualified Data.Aeson as A ( eitherDecodeStrict, encode )
import qualified Data.ByteString.Lazy.Char8 as LB ( pack )
import qualified Data.ByteString.Char8 as B ( putStrLn, null )
import Control.Concurrent (MVar, swapMVar, readMVar)
import Type

app :: MVar Int -> Application
app vCounter request respond = do
    putStrLn "Got http request"
    let methodBstr = requestMethod request
    B.putStrLn $ "Method = " <> methodBstr
    bodyBstr <- requestBody request
    putStrLn "Contents in body:"
    if B.null bodyBstr
        then putStrLn "No contents in body!!!"
        else B.putStrLn bodyBstr
    putStrLn ""
    if methodBstr == methodGet
        then do
            respond $ responseFile status200 [("Content-Type", "text/html")] "index.html" Nothing
        else case A.eitherDecodeStrict bodyBstr of
            Left err -> respond $ responseLBS status404 [("Content-Type", "text/plain")] (LB.pack err)
            Right elmMsg -> case elmMsg of
                UpdateCounterValue n -> do
                    _ <- swapMVar vCounter n
                    respond $ responseLBS status200 [] (A.encode $ CurrentCounterValue n)
                RequestInitialValue -> do
                    n <- readMVar vCounter
                    respond $ responseLBS status200 [] (A.encode $ CurrentCounterValue n)
