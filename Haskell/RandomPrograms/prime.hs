isPrime :: Int -> Bool

isPrime 0 = False
isPrime 1 = False
--isPrime 2 = True
isPrime n = isPrime' 2
    where
        isPrime':: Int -> Bool
        isPrime' c 
            | c*c == n      = True
            | mod n c == 0  = False
            | otherwise     = isPrime (c+1)