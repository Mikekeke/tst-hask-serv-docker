
{-# LANGUAGE OverloadedStrings #-}
module Server where

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Storage
import Control.Monad.IO.Class (liftIO, MonadIO)
 
startServer = do
    let port = 3000
    putStrLn $ "Listening on port " ++ show port
    run port app
 
app req respond = case pathInfo req of
        ["1"] ->  respond $ getFromStorage 1
        ["2"] ->  respond $ getFromStorage 2
        ["3"] ->  respond $ getFromStorage 3
        ["file"] -> do 
            content <- BU.fromString <$> getFile
            respond $ fileDataToResp content
        x -> respond $ index x

fileDataToResp _data = responseBuilder status200 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString 
                       [ _data ]
        
getFromStorage _id = let  result = get _id in 
    responseBuilder status200 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString
    [ result ]

 
yay = responseBuilder status200 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString
    [ "yay" ]
 
index x = responseBuilder status200 [("Content-Type", "text/html")] $ mconcat $ map copyByteString
    [ "<p>Hello from ", BU.fromString $ show x, "!</p>"
    , "<p><a href='/yay'>yay</a></p>\n"
    , "<p><a href='/1'>get1</a></p>\n"
    , "<p><a href='/2'>get2</a></p>\n"
    , "<p><a href='/2'>get3</a></p>\n"
    , "<p><a href='/file'>file content</a></p>\n"
     ]
