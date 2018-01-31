
interpretIMC :: Float -> Float -> String
interpretIMC a b
    |x < 18            = ": magror"
    |x >= 18 && x < 25 = ": corpulencia normal"
    |x >= 25 && x < 30 = ": sobrepes"
    |x >= 30 && x < 40 = ": obesitat"
    |otherwise         = ": obesitat morbida"
    where
        x = a / (b*b)

    
calcIMC :: String -> String
calcIMC xs =
    let [nom, weight, height] = words xs
    in nom ++ (interpretIMC (str2Float weight) (str2Float height))
    
    
str2Float :: String -> Float
str2Float x = read x
    
    
main = do
    stuff <- getLine
    if stuff /= "*" then do
        putStrLn ( calcIMC stuff)
        main
    else return ()


