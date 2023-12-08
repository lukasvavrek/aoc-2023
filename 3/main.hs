#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
   --package split
   --package text
-}

import Data.Char (isDigit)
import Data.List (nub)
import Data.Maybe
import Debug.Trace (trace)
import System.IO.Unsafe (unsafePerformIO)
import Text.Read (readMaybe)

main :: IO ()
main = do
  input <- getContents
  let linesList = topAndBotton $ lines input

  -- mapM_ print linesList

  let grid = map cellsFromLine $ zip [0 ..] linesList
  let numbers = concatMap parseNumbersFromLine grid

  let p1Nums = map n $ filter (not . all (== '.') . numberNeighborsAsString grid) numbers
  -- print p1Nums
  print $ sum p1Nums

  return ()

topAndBotton :: [String] -> [String]
topAndBotton lines = map leftAndRight $ line : lines ++ [line]
  where
    line = replicate (length $ head lines) '.'

leftAndRight :: String -> String
leftAndRight line = "." ++ line ++ "."

data Coord = Coord {x :: Int, y :: Int} deriving (Show, Eq)

data Cell = Cell {coord :: Coord, char :: Char} deriving (Show, Eq)

data Number = Number {n :: Int, c :: Coord} deriving (Show, Eq)

parseNumbersFromLine :: [Cell] -> [Number]
parseNumbersFromLine cells = unsafePerformIO $ do numbers [] cells
  where
    numbers :: [Number] -> [Cell] -> IO [Number]
    numbers acc [] = return acc
    numbers acc (c : cs) = do
      if isDigit $ char c
        then do
          let toConvert = c : takeWhile (isDigit . char) cs
          let rest = dropWhile (isDigit . char) cs
          let number = cellToNumbers toConvert

          numbers (number : acc) rest
        else numbers acc cs

cellToNumbers :: [Cell] -> Number
cellToNumbers cells = foldl accumulate base cells
  where
    accumulate = (\acc cell -> Number {n = n acc * 10 + (read $ [char cell] :: Int), c = c acc})
    base = (Number {n = 0, c = coord $ head cells})

cellsFromLine :: (Int, String) -> [Cell]
cellsFromLine (yidx, line) = map (uncurry Cell) $ zip coords line
  where
    coords = coordsFromYidx (yidx, length line)

coordsFromYidx :: (Int, Int) -> [Coord]
coordsFromYidx (yidx, l) = map (`Coord` yidx) $ take l [0 ..]

numberNeighborsAsString :: [[Cell]] -> Number -> String
numberNeighborsAsString grid number = map lookup coords
  where
    coords = numberNeighbors number
    lookup :: Coord -> Char
    lookup coord = char $ grid !! y coord !! x coord

numberNeighbors :: Number -> [Coord]
numberNeighbors number = neighborhood coords
  where
    numLen = length $ show $ n number
    indexes = [x $ c number ..]
    xcoord = take numLen indexes
    coords = map (\x -> Coord {x = x, y = y $ c number}) xcoord

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (x, y) = filter (\t -> t /= (x, y)) $ do
  x' <- [x - 1, x, x + 1]
  y' <- [y - 1, y, y + 1]
  return (x', y')

coordNeighbors :: Coord -> [Coord]
coordNeighbors coord = map xyToCoords $ neighbors (x coord, y coord)

xyToCoords :: (Int, Int) -> Coord
xyToCoords (x, y) = Coord {x = x, y = y}

neighborhood :: [Coord] -> [Coord]
neighborhood coords = nub $ filter (`notElem` coords) $ concatMap coordNeighbors coords
