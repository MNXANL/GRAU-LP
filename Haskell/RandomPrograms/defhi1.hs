myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f n []     = n
myFoldl f n (x:xs) = myFoldl f (f n x) xs


myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr f n [] = n
myFoldr f n (x:xs) = f x (myFoldr f n xs)


myIterate :: (a -> a) -> a -> [a]
myIterate f x = x : myIterate f (f x)


myUntil :: (a -> Bool) -> (a -> a) -> a -> a
myUntil f s x
    | f x       = x
    | otherwise = myUntil f s (s x)


myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f xs = foldr (\x ys -> (f x):ys ) [] xs


myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f [] = []
myFilter f lst = foldr (\x xs-> if f x then x:xs else xs) [] lst


myAll :: (a -> Bool) -> [a] -> Bool
myAll f xs = and (map f xs)


myAny :: (a -> Bool) -> [a] -> Bool
myAny f xs = or (map f xs)


myZip :: [a] -> [b] -> [(a, b)]
myZip [] _ = []
myZip _ [] = []
myZip (a:as) (b:bs) = (a, b) : myZip as bs


myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith _ [] _ = []
myZipWith _ _ [] = []
myZipWith f x y = foldr (\a as -> f (fst a) (snd a) : as) [] $ zip x y

