import Text.Read (readMaybe)
import Data.Maybe (fromJust,isNothing)

{-
-- Definicions de fromJust i isNothing per utilitzar sense l'import

fromJust :: Maybe a -> a
fromJust (Just x) = x

isNothing :: Maybe a -> Bool
isNothing Nothing = True
isNothing _ = False
-}

{- Tornar una llista de llistes d'enters a partir d'una llista d'strings 
   (carrega :: [[Char]] -> [[Int]]) descartant les files amb errors (dades no
   numèriques) i/o nombres fora de l'interval [1,5]. -}

dt = ["1 2 3","1 kk 4","1 6 3","3 2 1"]
-- carrega dt = [[1,2,3],[3,2,1]]

s2i :: [Char] -> Maybe Int
s2i = readMaybe

interval :: Int -> Maybe Int
interval x
    | elem x [1..5] = Just x
    | otherwise     = Nothing

terme :: [Char] -> Maybe Int
terme x = s2i x >>= (\v -> interval v)  
{-
terme x 
    | isNothing y = Nothing
    | otherwise   = interval $ fromJust y
    where y = s2i x
-}
{-
terme x =
    case s2i x of
        Nothing -> Nothing
        Just v -> interval v
-}  

fila :: [[Char]] -> Maybe [Int]
fila [] = Just []
fila (x:xs) = terme x >>= (\t -> fmap (\l -> t:l) (fila xs))
{-
fila (x:xs) 
    | isNothing t = Nothing
    | otherwise   = fmap (\l -> (fromJust t):l) (fila xs)
    where t = terme x
-}


carrega :: [[Char]] -> [[Int]]
carrega ll = foldr f [] ll
    where
        f l acc
            | isNothing g = acc
            | otherwise   = (fromJust g):acc
            where g = fila $ words l

