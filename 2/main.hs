#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
   --package split
   --package text
-}

--  2727

import Data.Char
import Data.List.Split
import Data.Text (strip)

main :: IO ()
main = do
  input <- getContents
  let linesList = lines input
  let games = map parseLine linesList

  let possibleGames = filter isGamePossible games

  print $ sum $ map fst possibleGames

isGamePossible :: (Int, String) -> Bool
isGamePossible (gameId, game) = all isValidDraw draws
  where
    draws = splitOn ";" game

isValidDraw :: String -> Bool
isValidDraw draw = all isValidTake takes
  where
    takes = map parseTake (splitOn "," draw)

parseTake :: String -> (Int, String)
parseTake str = (cnt, color)
  where
    split = splitOn " " (trim str)
    cnt = read (head split) :: Int
    color = last split

trim :: String -> String
trim = f . f
  where
    f = reverse . dropWhile isSpace

isValidTake :: (Int, String) -> Bool
isValidTake (cnt, "red") = cnt <= 12
isValidTake (cnt, "green") = cnt <= 13
isValidTake (cnt, "blue") = cnt <= 14

parseLine :: String -> (Int, String)
parseLine line = (gameId, game)
  where
    split = splitOn ":" line
    gameId = parseGameId $ head split
    game = last split

parseGameId :: String -> Int
parseGameId str = read (splitOn " " str !! 1) :: Int
