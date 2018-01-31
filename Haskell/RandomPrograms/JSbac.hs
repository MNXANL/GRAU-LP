main = do
    name <- getLine
    let c = last name
    if c == 'a' then  putStrLn ("Hola maca!")
    else if c == 'A' then  putStrLn ("Hola maca!")
    else putStrLn ("Hola maco!")
