factorial :: Integer -> Integer  -- Name -> Eats -> returns


--Avaluació en arbre TOP-to-DOWN
factorial 0 = 1
factorial n = n * factorial(n - 1)
