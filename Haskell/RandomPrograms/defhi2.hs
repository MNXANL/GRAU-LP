countIf :: (Int -> Bool) -> [Int] -> Int
countIf f [] = 0
countIf f xs = foldl (\i x -> if (f x) then i+1 else i) 0 xs

    
pam :: [Int] -> [Int -> Int] -> [[Int]] 
pam xs fs = map (\f -> map (f) xs) fs


pam2 :: [Int] -> [Int -> Int] -> [[Int]]
pam2 xs fs = [ [f x | f <- fs] | x <- xs]


filterFoldl :: (Int -> Bool) -> (Int -> Int -> Int) -> Int -> [Int] -> Int 
filterFoldl ft fd n xs = foldl fd n (criba ft xs)
    where
        criba f xs = foldr (\y ys-> if f y then y:ys else ys) [] xs
--fr -> filter function    /    fd -> folding function


insert :: (Int -> Int -> Bool) -> [Int] -> Int -> [Int]
insert f xs n = takeWhile (not . f n) xs ++ [n] ++ dropWhile (not . f n) xs



insertionSort :: (Int -> Int -> Bool) -> [Int] -> [Int]
insertionSort f ys = foldr (\x xs -> insert f xs x) [] ys

{-
insertionSort f (x:xs) =  insert f xs x
-----------------------------------------------



--old code for insertion sort
isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = insert ( isort xs) x
-}
