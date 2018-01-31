flatten :: [[Int]] -> [Int] 
flatten xs = foldl (++) [] xs


myLength :: String -> Int 
myLength xs = sum $ map (const 1) xs


myReverse :: [Int] -> [Int] 
myReverse xs =  foldl  (flip (:))  [] xs


countIn :: [[Int]] -> Int -> [Int]
countIn xs y = map comp xs
    where comp xs = length $ filter ( == y) xs


firstWord :: String -> String
firstWord xs = takeWhile (/= ' ') $ dropWhile ( == ' ') xs

