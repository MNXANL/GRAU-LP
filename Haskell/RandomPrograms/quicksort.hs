qsort :: [Int] -> Int
qsort [] = []
qsort [x] = [x]
qsort (x:xs) = (qsort left) ++ [x] ++ (qsort right)
    where
        left  = filter (<x) xs
        right = filter (>x) xs

--Funció d'ordre superior -> Funcions que reben funcions
filter :: (a -> Bool) -> [a] -> [a]
filter pred [] = []
filter pred (y:ys)
    | pred y    = y:filter pred ys
    | otherwise =   filter pred ys