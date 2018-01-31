data Expr = Val Int | Add Expr Expr | Sub Expr Expr | Mul Expr Expr | Div Expr Expr



eval1 :: Expr -> Int
eval1 (Val n) = n
eval1 (Add expr1 expr2) = (+)   (eval1 expr1) (eval1 expr2)
eval1 (Sub expr1 expr2) = (-)   (eval1 expr1) (eval1 expr2)
eval1 (Mul expr1 expr2) = (*)   (eval1 expr1) (eval1 expr2)
eval1 (Div expr1 expr2) = (div) (eval1 expr1) (eval1 expr2)


val2 (Just x) = x

eval2 :: Expr -> Maybe Int
eval2 (Val n) = Just n
eval2 (Div expr1 (Val 0)) = Nothing
eval2 (Add ex1 ex2) =  do {
    if (eval2 ex1) == Nothing || (eval2 ex2) == Nothing then Nothing
    else fmap (\x -> x + val2 (eval2 ex2) ) (eval2 ex1) 
    --fmap (\x -> x + val2 (eval2 ex2) ) (eval2 ex1) 
}
eval2 (Sub ex1 ex2) =  do {
    if (eval2 ex1) == Nothing || (eval2 ex2) == Nothing then Nothing
    else fmap (\x -> x - val2 (eval2 ex2) ) (eval2 ex1) 
}
eval2 (Mul ex1 ex2) =  do {
    if (eval2 ex1) == Nothing || (eval2 ex2) == Nothing then Nothing
    else fmap (\x -> x * val2 (eval2 ex2) ) (eval2 ex1) 
}
eval2 (Div ex1 ex2) =  do {
    if (eval2 ex1) == Nothing || (eval2 ex2) == Nothing then Nothing
    else fmap (\x -> round ( x / fromIntegral  ( val2 (eval2 ex2))) ) (eval2 ex1) 
}

--eval2 (Add expr1 expr2) = fmap (\x -> x + val2 (eval2 ex2) ) (eval2 ex1) 
--eval2 (Sub expr1 expr2) = fmap (\x -> x - val (eval2 expr2) ) (eval2 expr1) 
--eval2 (Mul expr1 expr2) = fmap (\x -> x * val (eval2 expr2) ) (eval2 expr1) 
--eval2 (Div expr1 expr2) = fmap (\x -> x `div` val (eval2 expr2) ) (eval2 expr1) 



val3 (Right x) = x

eval3 :: Expr -> Either String Int
eval3 (Val n) = Right n
eval3 (Div expr1 (Val 0)) = Left "div0"

eval3 (Add ex1 ex2) =  do {
    if (eval3 ex1) == Left "div0" || (eval3 ex2) == Left "div0" then Left "div0"
    else fmap (\x -> x + val3 (eval3 ex2) ) (eval3 ex1) 
    --fmap (\x -> x + val2 (eval2 ex2) ) (eval2 ex1) 
}
eval3 (Sub ex1 ex2) =  do {
    if (eval3 ex1) == Left "div0" || (eval3 ex2) == Left "div0" then Left "div0"
    else fmap (\x -> x - val3 (eval3 ex2) ) (eval3 ex1) 
}
eval3 (Mul ex1 ex2) =  do {
    if (eval3 ex1) == Left "div0" || (eval3 ex2) == Left "div0" then Left "div0"
    else fmap (\x -> x * val3 (eval3 ex2) ) (eval3 ex1) 
}
eval3 (Div ex1 ex2) =  do {
    if (eval3 ex1) == Left "div0" || (eval3 ex2) == Left "div0" then Left "div0"
    else fmap (\x -> round ( x / fromIntegral  ( val3 (eval3 ex2)) ) ) (eval3 ex1) 
}



-- eval3 (Add expr1 expr2) =  fmap (\x -> x + val3 (eval3 expr2) ) (eval3 expr1) 
-- eval3 (Sub expr1 expr2) =  fmap (\x -> x - val3 (eval3 expr2) ) (eval3 expr1) 
-- eval3 (Mul expr1 expr2) =  fmap (\x -> x * val3 (eval3 expr2) ) (eval3 expr1) 
-- eval3 (Div expr1 expr2) =  fmap (\x -> x `div` val3 (eval3 expr2) ) (eval3 expr1) 





{- 
--------------------------------------



eval1 (Val 2)
eval1 (Add (Val 2) (Val 3))
eval1 (Sub (Val 2) (Val 3))
eval1 (Div (Val 4) (Val 2))
eval1 (Mul (Add (Val 2) (Val 3)) (Sub (Val 2) (Val 3)))




-}



