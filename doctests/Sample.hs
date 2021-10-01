module Sample where

-- |
-- >>> acc 5
-- 6
--
sample :: IO ()
sample = putStrLn "hello world!"

acc :: Int -> Int
acc = (1 +)
