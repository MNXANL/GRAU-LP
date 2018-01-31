qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort [x] = [x]
qsort (x:xs) = (qsort left) ++ [x] ++ (qsort right)
    where
        left  = filter (<  x) xs
        right = filter (>= x) xs


select :: Ord a => [a] -> Int -> a
select xs i = (qsort xs) !! (i-1)
