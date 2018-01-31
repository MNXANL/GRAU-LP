sumMultiples35 :: Integer -> Integer
sumMultiples35 n = foldl (+) 0 (sumFilter n)
    where
        sumFilter :: Integer -> [Integer]
        sumFilter m = filter (\x -> modulo35 x) [1 .. n]
            where
                n = m-1
                modulo35 :: Integer -> Bool
                modulo35 x
                    | mod x 3 == 0  = True
                    | mod x 5 == 0  = True
                    | otherwise = False