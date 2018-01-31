-- HASKELL

-- $ ghci 		#invoca intèrpret Prelude de Haskell
> 2 + 2
4
> 2 * 2
4


* 4 2


>2 == 2
True
>2 /= 2
True
-- @
-- OPERATORS: + - * / div **  ^
-- |  / -> divisió entera
-- | div -> divisió fraccionaria
--@

COMPS:  && || not (AND/OR/NOT)

Decimals POINT: 2.333333333
CHAR: 'a'
STRING (list chars): "SEND NUDES"

:t 'A' 			-- "Quin és el tipus de 'A' ? "
'A' :: Char 	--A és de tipus Char


:t "A" 			--"Quin és el tipus de 'A' ? "
'A' :: [Char] 	--A és de tipus List<Char>

:t 2==4 			--"Quin és el tipus de 2==4  ? "
2==4 :: Bool 		--A és de tipus Bool

:t 5				--"Quin és el tipus de 5 ? "
5 :: Num t => t 	--A és de tipus Numeric (com una interface de Java)


:t (5::Int)				--"Quin és el tipus de (5::Int) ? "
(5::Int) :: Int 		--A és de tipus Int

:t (5::Integer)				--"Quin és el tipus de (5::Integer) ? "
(5::Integer) :: Integer 	--A és de tipus Integer

	-- PROTIP: Definir els tipus prèviament a la programació

FUNCIONS: <NAME> <arg1> <arg2> .. <argN>  --SEPARATS ENTRE ESPAIS

--A haskell totes les funcions tenen un parametre

Int :: Int -> Int -> Int 		======>		Int :: Int -> (Int -> Int)

> (*) 2 3 --Operadors com a multiplicadors
6

dobla = (*) 2 --No és una assignació, però una definició

>dobla 6
12


--FITXERS *.hs
> :r --reload

-- Llistes, TOTES homogenies 
>[1, 2, 4] 
[1,2,4] 
 
>:t [1, 2, 4] 
[1, 2, 4] :: Num t -> [t]

>[4, 3, 9]
[4,3,9]

>[]
[]

> 9:[] --Push front (op recursiva)
[9]
> 5:9:[]
[5,9]

>head [1..10]
1

>tail [1..10]
[2,3,4,5,6,7,8,9,10]

>init [1..10]
[1,2,3,4,5,6,7,8,9]

> [1..10]++[5..10] --concat

[1,2,3,4,5,6,7,8,9,10,5,6,7,8,9,10]
