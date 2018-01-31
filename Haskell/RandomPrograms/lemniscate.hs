
zeroes :: [Integer] 
zeroes = 0 : zeroes

ones :: [Integer] 
ones = 1 : ones

nats :: [Integer] 
nats = 0 : map (+1) nats
-- nats = iterate (+1) 0

nats1 :: [Integer] 
nats1 = tail nats

negNats :: [Integer] 
negNats = (zipWith (-) zeroes nats)

flatten :: [[Int]] -> [Int] 
flatten [] = []
flatten (x:xs) = x ++ flatten xs

ints :: [Integer]
ints = (concat $ zipWith (\x y -> [x, y]) negNats (tail nats))


factorials :: [Integer] 
factorials = scanl (*) 1 $ tail nats

fibs :: [Integer] 
fibs =   0 : 1 : zipWith (+) fibs (tail fibs)

primes :: [Integer] 
primes = sieve $ tail (tail (nats) )
    where
        sieve :: [Integer] -> [Integer]
        sieve (p:xs) = p : (sieve ( filter noMultP xs))
            where
                noMultP :: Integer -> Bool
                noMultP x = mod x p /= 0

hammings :: [Integer] 
hammings = 1 : map (2*) hammings `unite` map (3*) hammings `unite` map (5*) hammings
    where
        unite :: [Integer] -> [Integer] -> [Integer]
        unite (x:xs) (y:ys) 
            | x == y    =   x : unite xs ys
            | x < y     =   x : unite xs (y:ys)
            | otherwise =   y : unite (x:xs) ys

            

triangulars :: [Integer] 
triangulars = [div (n * (n+1) ) 2 | n <- nats]


fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact(n - 1)


tartaglia :: [[Integer]]
tartaglia =  map (\n -> map (combo n) [0..n] ) nats  --combo n <m> --> m is implicit!
    where    
        combo :: Integer -> Integer -> Integer
        combo x y = div (fact x) denom
            where
                denom = (fact y) * (fact (x - y) )

        
splitChars :: [Char] -> [[Char]] --String -> [String]
splitChars [] = []
splitChars (x:xs) = (x : takeWhile ( == x) xs ) : splitChars (dropWhile ( == x) xs)


count :: String -> String
count x = show (length x) ++ [head (x)]


-- count (x:xs) = concat . foldr ( (long x) : (head x) ) [] xs
group :: [[Char]] -> [Char] --[String] -> String
group xs = concat (map (count) xs) 

appearNum :: Integer -> Integer
appearNum n = read ( group (splitChars (show n) ) ) :: Integer 

lookNsay :: [Integer]
lookNsay  =  iterate ( appearNum ) 1
