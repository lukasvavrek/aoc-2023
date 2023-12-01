#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
-}

-- 56397
-- 55701

import Data.Char

main :: IO ()
main = do
    input <- getContents
    let linesList = lines input
    let calibrationSum  = sum $ map getDigit linesList
    print calibrationSum

getDigit :: String -> Int
getDigit str = 
    10 * findFirstNumber str + findLastNumber str

findFirstNumber :: String -> Int
findFirstNumber str = digitToInt $ head $ filter isDigit str

findLastNumber :: String -> Int
findLastNumber str = findFirstNumber $ reverse str

