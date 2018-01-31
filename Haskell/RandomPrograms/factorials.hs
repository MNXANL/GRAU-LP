fact1 :: Integer -> Integer -- recursion
fact1 0 = 1
fact1 1 = 1
fact1 n = n * fact1 (n-1)


fact2 :: Integer -> Integer --final/tail recursion
fact2 n = factTR n 1
    where
        factTR 0 a = a
        factTR 1 a = a
        factTR n a = factTR (n-1) (n*a)


fact3 :: Integer -> Integer --no recursion
fact3 n = do 
    if (n < 2) then 1
    else n * fact3 (n-1)



fact4 :: Integer -> Integer --guards
fact4 n
    | n == 0 = 1
    | n == 1 = 1
    | otherwise = n * fact4 (n-1)



fact5 :: Integer -> Integer --if then else
fact5 n = if n < 2 then 1 else (n * fact5 (n-1))


fact6 :: Integer -> Integer --map
fact6 n = product [1..n]

    

fact7 :: Integer -> Integer --foldl
fact7 n = foldl (*) 1 [1..n]


fact8 :: Integer -> Integer --inf list
fact8 n = last $ scanl (*) 1 [1..n]


infsum x = is2 x x 1
    where
        is2 x n i = [n] ++ is2 x (x+n+i) (i+1)


