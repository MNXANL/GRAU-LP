sumMultiples35 :: Integer -> Integer
sumMultiples35 i = foldl (+) 0 $ takeWhile (\x -> x < i) xs
    where
        xs = [x | x <- [1..], mod x 3 == 0 || mod x 5 == 0]



fibonacci :: Int -> Integer 
fibonacci x = fibs !! x
    where
        fibs :: [Integer] 
        fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

--sumEvenFibonaccis :: Integer -> Integer 


--largestPrimeFactor :: Int -> Int 


--isPalindromic :: Integer -> Bool 

fuu :: [Int] -> Int -> [[Int]]
fuu xs y = concat $ lst1 ++ fuu xs y'
    where
        lst1 = map (\x -> [1..y]) xs
        y' = (-) y 1