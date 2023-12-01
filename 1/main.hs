#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
   --package acme-missiles
-}

-- 56397
-- 55701

import Data.Char

main :: IO ()
main = do
    input <- getContents
    let linesList = lines input

    let sum = foldl (+) 0 $ map getDigit linesList
    putStrLn $ show sum

getDigit :: String -> Int
getDigit str = 
    10 * findFirstNumericCharacter str + findLastNumericCharacter str

findFirstNumericCharacter :: String -> Int
findFirstNumericCharacter str = digitToInt $ head $ filter isDigit str

findLastNumericCharacter :: String -> Int
findLastNumericCharacter str = findFirstNumericCharacter $ reverse str

