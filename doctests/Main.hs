module Main where

import System.Environment (getArgs)
import Test.DocTest

main :: IO ()
main = doctest ["src"]
