{-# LANGUAGE OverloadedStrings #-}

module Storage where
import qualified Data.ByteString.UTF8 as BU


storage = [(1, "Bob"), (2,"Tom")]

get :: Int -> BU.ByteString
get _id = maybe "Not fount" id (lookup _id storage)

getFile :: IO String
getFile = readFile "data"
