length :: [Int] -> Int
length [] = 0
--  x = head   //   xs = tail ("moltes x")
--  length (head:tail) = 1 + length cua
--  length (x:xs) = 1 + length cua
length (_:xs) = 1 + length xs


maximus :: [Int] -> Int
maximus [x] = x
maximus (x:xs)
	| x>0 = m
	| otherwise = m
	where m = maxim xs
