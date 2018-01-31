nats :: [Int] 
nats = 0 : map (+1) nats

fizzBuzz :: [Either Int String]
fizzBuzz = map (fizzin) nats

fizzin :: Int -> Either Int String
fizzin a
    | mod a 3 == 0 && mod a 5 == 0 = Right "FizzBuzz"
    | mod a 3 == 0 = Right "Fizz"
    | mod a 5 == 0 = Right "Buzz"
    | otherwise = Left a
