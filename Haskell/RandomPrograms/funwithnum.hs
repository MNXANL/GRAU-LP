absValue :: Int -> Int
absValue x
	| x >= 0    = x
	| otherwise = (-x)
    
    
power:: Int -> Int -> Int
power x n
	| n == 0	= 1
	| even n	= y * y
	| otherwise	= y * y * x
	where y = power x (div n 2)
    
    
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


slowFib :: Int -> Int
slowFib 0 = 0
slowFib 1 = 1
slowFib n = slowFib(n-1) + slowFib(n-2)


quickFib :: Int -> Int
quickFib n = fst(fast_fib n)
	where 
		fast_fib :: Int -> (Int, Int)
		fast_fib 0 = (0, 0)
		fast_fib 1 = (1, 0)
		fast_fib n = (a + b,   a)
			where  (a, b) = fast_fib (n-1)




