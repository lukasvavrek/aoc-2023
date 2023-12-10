#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
-}

data Round = Round {time :: Int, distance :: Int} deriving (Show)

main :: IO ()
main = do
  input <- lines <$> getContents

  let times = parseLine $ head input
  let distances = parseLine $ input !! 1

  let rounds = zipWith (curry toRound) times distances
  let margin = foldr (*) 1 $ map calculateRound rounds

  print margin

calculateRound :: Round -> Int
calculateRound round  = length $ filter (==True) $ map (isWinning round) [1 .. time round]

isWinning :: Round -> Int -> Bool
isWinning (Round time distance) wait = wait * (time - wait) > distance

parseLine :: String -> [Int]
parseLine line = map (\x -> read x :: Int) $ drop 1 $ words line

toRound :: (Int, Int) -> Round
toRound (time, distance) = Round time distance
