--potencia :: Integer -> (Integer -> Integer)


fibo :: Integer -> Integer
fibo n = fst (fibo' n)
    where
        fibo' :: Integer -> (Integer, Integer)
        -- returns   f  n-1  fn
        fibo' 0 = 0
        fibo' 1 = 1
        fibo' n = 
            where 
                (fn1, fn) = fibo' (n-1) --no such thing as pl's unification