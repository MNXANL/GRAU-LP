insert :: [Int] -> Int -> [Int] 
insert [] y = [y]
insert (x:xs) y
    |  x  <=  y  = x : (insert xs y) 
    | otherwise = y : (x : xs)

isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = insert ( isort xs) x



remove :: [Int] -> Int -> [Int]
remove (x:xs) y 
    | x == y    = xs
    | otherwise = x : remove (xs) y

ssort :: [Int] -> [Int]
ssort [] = []
ssort xs = y : ssort (remove xs y)
    where
        y = minimum xs



merge :: [Int] -> [Int] -> [Int] 
merge [] [] = []
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) 
    | x <= y  = x : (merge xs (y:ys))
    | x > y   = y : (merge (x:xs) ys)


msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort xs = merge (msort (half1 xs)) (msort (half2 xs))
    where
        half1 xs = take (div (length xs) 2) xs
        half2 xs = drop (div (length xs) 2) xs



qsort :: [Int] -> [Int]
qsort [] = []
qsort [x] = [x]
qsort (x:xs) = (qsort left) ++ [x] ++ (qsort right)
    where
        left  = filter (<x) xs
        right = filter (>=x) xs


genQsort :: Ord a => [a] -> [a] 
genQsort [] = []
genQsort [x] = [x]
genQsort (x:xs) = (genQsort left) ++ [x] ++ (genQsort right)
    where
        left  = filter (<x) xs
        right = filter (>=x) xs
