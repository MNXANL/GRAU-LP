import Data.Ord 
import Data.List 


votsMinim :: [([Char], Int)] -> Int -> Bool
votsMinim xs val = any (\x -> (snd x) < val) xs

    
    
candidatMesVotat :: [([Char], Int)] -> [Char]
candidatMesVotat xs = fst $ maximumBy (comparing snd) xs

rmCandidate :: [([Char], Int)] -> ([Char], Int) -> [([Char], Int)]
rmCandidate xs y = filter (\x -> fst x /= fst y) xs

votsIngressos :: [([Char], Int)] -> [([Char], Int)] -> [[Char]]
votsIngressos xs ys = [x | (x,a)<-xs, (y,_)<-ys, x == y]


--rics :: [([Char], Int)] -> [([Char], Int)] -> [[Char]]

{-

main = do
    stuff <- getLine
    if stuff /= "*" then do
        --putStrLn ( calcIMC stuff)
        main
    else return ()

-}
