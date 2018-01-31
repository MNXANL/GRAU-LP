--potencia :: Integer -> (Integer -> Integer)
potencia :: Integer -> Integer -> Integer
potencia x n 
    | n == 0        = 1
    | even n        = y * y
    | otherwise     = y * y * x
    where y = potencia x (div n 2)

