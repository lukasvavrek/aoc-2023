#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
   --package split
   --package text
   --package containers
-}

import Data.Map qualified as Map
import Data.Maybe (catMaybes)

data RLMap = RLMap {left :: String, right :: String} deriving (Show)

data Problem = Problem
  { rlMap :: Map.Map String RLMap,
    instructions :: String,
    start :: String,
    end :: String
  }
  deriving (Show)

main :: IO ()
main = do
  input <- getContents

  let instructions = concat $ repeat $ head $ lines input

  let rlMap = Map.fromList $ catMaybes $ map parseRLMap $ drop 2 $ lines input

  let problem = Problem rlMap instructions "AAA" "ZZZ"

  print $ solver problem

  return ()

parseRLMap :: String -> Maybe (String, RLMap)
parseRLMap line = do
  let (key, l, r) = parseString line
  return (key, RLMap l r)

-- quickly generated using GPT, rewrite using my own knowledge
parseString :: String -> (String, String, String)
parseString input =
  let -- Remove unnecessary characters
      cleanedInput = filter (\c -> c /= '(' && c /= ')' && c /= '=') input

      -- Split the string into parts based on ',' character
      parts = words $ map (\c -> if c == ',' then ' ' else c) cleanedInput
   in case parts of
        [aaa, bbb, ccc] -> (aaa, bbb, ccc)
        _ -> error "Invalid input format"

solver :: Problem -> Int
solver problem = solver' problem 0

solver' :: Problem -> Int -> Int
solver' problem acc
  | start problem == end problem = acc
  | otherwise =
      solver' problem {instructions = instructions', start = start'} acc + 1
  where
    instr = head $ instructions problem
    instructions' = drop 1 $ instructions problem
    kv = Map.lookup (start problem) (rlMap problem)
    start' = case kv of
      Nothing -> error "Invalid start key"
      Just rlMap -> case instr of
        'L' -> left rlMap
        'R' -> right rlMap
        _ -> error "Invalid instruction"
