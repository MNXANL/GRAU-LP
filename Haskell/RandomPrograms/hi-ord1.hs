--eql :: [Int] -> [Int] -> Bool 
--eql xs ys = foldl (&&) True (zipWith (==) xs ys)
eql xs ys = (length xs == length ys) &&  and ( zipWith (==) xs ys )

prod :: [Int] -> Int 
prod = foldl (*) 1

prodOfEvens :: [Int] -> Int
prodOfEvens (xs) = prod $ filter even xs

powersOf2 :: [Int]
powersOf2 = iterate (*2) 1

scalarProduct :: [Float] -> [Float] -> Float
scalarProduct xs ys =  foldl (+) 0 $ zipWith (*) xs ys

