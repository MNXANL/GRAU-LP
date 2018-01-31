shuffleOnce :: [a] -> [a]
shuffleOnce xs = ys'
    where
        n = length xs
        (l1, l2) = splitAt (n `div` 2) xs
        ys = concat $ zipWith pair l2 l1
        pair a b = [a, b]
        ys' 
           | even n     = ys
           | otherwise  = ys ++ [last xs]
