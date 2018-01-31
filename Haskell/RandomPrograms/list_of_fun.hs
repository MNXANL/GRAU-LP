myLength :: [Int] -> Int 
myLength [] = 0
myLength (_:xs) = 1 + myLength xs

myMaximum :: [Int] -> Int
myMaximum [x] = x
myMaximum (x:xs)
    | x > currMax = x
    | otherwise = currMax --current maximum
    where currMax = myMaximum xs


average :: [Int] -> Float 
average xs = fromIntegral (suma xs) / fromIntegral (myLength xs)

suma :: [Int] -> Int
suma [] = 0
suma (x:xs) = x + suma xs
 

buildPalindrome :: [Int] -> [Int] 
buildPalindrome [] = []
buildPalindrome xs = reverse (xs) ++ xs



remove :: [Int] -> [Int] -> [Int] 
remove xs [] = xs
remove xs (y:ys) = remove (rm_one_elem xs y) ys
    where
        rm_one_elem :: [Int] -> Int -> [Int]
        rm_one_elem [] y = [] 
        rm_one_elem (x:xs) y
            | x == y    = rm_one_elem xs y
            | otherwise = x : rm_one_elem xs y


oddsNevens :: [Int] -> ([Int],[Int])
oddsNevens xs =  (filter odd xs, filter even xs)


flatten :: [[Int]] -> [Int] 
flatten [] = []
flatten (x:xs) = x ++ flatten xs




isPrime :: Int -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime n = not(hasdivi 2)
    where
        hasdivi :: Int -> Bool
        hasdivi x
            | x * x > n     = False
            | mod n x == 0  = True
            | otherwise     = hasdivi (x+1)


primeDivisors :: Int -> [Int]
primeDivisors x = primeDiv 2
    where
        primeDiv :: Int -> [Int]
        primeDiv y 
            | x < y  = []
            | mod x y == 0 && isPrime y   = y : primeDiv (y+1)
            | otherwise  = primeDiv (y+1)


{--------------------------------
--------------------------------}
