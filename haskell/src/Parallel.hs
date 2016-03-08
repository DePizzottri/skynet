{-# LANGUAGE BangPatterns #-}
module Parallel (run) where

import Data.Time.Clock (getCurrentTime, diffUTCTime)

import Control.Parallel.Strategies (parMap, rpar)

skynet :: Int -> Int -> Int
skynet levels children = sky levels 0
    where
        childnums = [0..children-1]
        sky 0   position = position
        sky lvl position = sum $ parMap rpar (\cn -> sky (lvl-1) $ position * children + cn) childnums

run :: IO ()
run = do
    start  <- getCurrentTime
    let !result = skynet 6 10
    end    <- getCurrentTime
    putStrLn $ concat [ "Result: "
                      , show result
                      , " in "
                      , show $ diffUTCTime end start
                      ]
