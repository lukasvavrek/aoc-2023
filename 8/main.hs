#!/usr/bin/env stack
{- stack script
   --resolver lts-21.22
   --package split
   --package text
   --package containers
   --package strict
-}

import Data.List (all, isSuffixOf, unfoldr)
import Data.Map.Strict qualified as Map
import Data.Maybe (catMaybes)

data RLMap = RLMap {left :: String, right :: String} deriving (Show)

data Problem = Problem
  { instructions :: String,
    start :: String,
    end :: String,
    acc :: Int
  }
  deriving (Show)

main :: IO ()
main = do
  input <- getContents

  let instructions = concat $ repeat $ head $ lines input

  let rlMap = Map.fromList $ catMaybes $ map parseRLMap $ drop 2 $ lines input

  let problem = Problem instructions "AAA" "ZZZ" 0
  print $ solver rlMap [problem]

  -- Pt. 2
  let starts = filter (isSuffixOf "A") $ Map.keys rlMap
  let problems = map (\start -> Problem instructions start "Z" 0) starts
  print $ solver rlMap problems

  return ()

solver :: Map.Map String RLMap -> [Problem] -> Int
solver _ [] = error "No problems to solve"
solver table problems =
  maximum $ map acc $ until allSolved (map (step table)) problems
  where
    allSolved = all isSolved

solver' :: Map.Map String RLMap -> [Problem] -> Int
solver' _ [] = error "No problems to solve"
solver' table problems =
  if allSolved
    then acc $ head problems
    else solver' table problems' 
  where
    allSolved = all isSolved problems
    problems' = map (step table) problems

step :: Map.Map String RLMap -> Problem -> Problem
step table problem = problem {instructions = instructions', start = start', acc = acc'}
  where
    instr = head $ instructions problem
    instructions' = drop 1 $ instructions problem
    acc' = acc problem + 1
    kv = Map.lookup (start problem) table
    start' = case kv of
      Nothing -> error "Invalid start key"
      Just rlMap -> case instr of
        'L' -> left rlMap
        'R' -> right rlMap
        _ -> error "Invalid instruction"

isSolved :: Problem -> Bool
isSolved problem = end problem `isSuffixOf` start problem

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
