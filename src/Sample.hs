module Sample where

import Data.Aeson

-- $setup
-- >>> :m Data.Aeson Sample

-- |
-- >>> acc 5
-- 6
--
acc :: Int -> Int
acc = (1 +)

-- |
--
-- Check if @doctest@ can load the deps from
-- __package.yaml__
--
-- >>> :t aesonTypes
-- ... :: Value
--
aesonTypes :: Value
aesonTypes = Bool True
