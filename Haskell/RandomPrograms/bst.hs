data Tree a = Node a (Tree a) (Tree a) | Empty deriving (Show)

size :: Tree a -> Int 
size Empty = 0
size (Node _ lc rc) = 1 + size lc + size rc

height :: Tree a -> Int 
height Empty = 0
height (Node _ lc rc) = 1 + max (height lc) (height rc)


equal :: Eq a => Tree a -> Tree a -> Bool 
equal Empty Empty = True
equal (Node x lc1 rc1) (Node y lc2 rc2) = x == y && (equal lc1 lc2) && (equal rc1 rc2)
equal _ _ = False

--Bugged
isomorphic :: Eq a => Tree a -> Tree a -> Bool
isomorphic Empty Empty = True
isomorphic (Node x lc1 rc1) (Node y lc2 rc2) = x==y && (isomorphic lc1 lc2 || isomorphic lc1 rc2) && (isomorphic rc1 lc2 || isomorphic rc1 rc2)
isomorphic _ _ = False

preOrder :: Tree a -> [a] 
preOrder Empty = []
preOrder (Node x Empty Empty) = [x]
preOrder (Node x lc rc) = [x] ++ preOrder lc ++ preOrder rc


postOrder :: Tree a -> [a] 
postOrder Empty = []
postOrder (Node x Empty Empty) = [x]
postOrder (Node x lc rc) = postOrder lc ++ postOrder rc ++ [x]


inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node x Empty Empty) = [x]
inOrder (Node x lc rc) = inOrder lc ++ [x] ++ inOrder rc

--bfs :: Tree [a] -> [a]
bfs [] = []
bfs (Empty:xs) = bfs xs
bfs ((Node x l r):xs) = x : ( bfs (xs ++ [l, r])  )

breadthFirst :: Tree a -> [a]  
breadthFirst a = bfs [a]
-- breadthFirst Empty = []


build :: Ord a => [a] -> [a] -> Tree a
build [] [] = Empty
build (x:xs) ys = Node x lc rc
    where
        lc = build lp li
        rc = build rp ri
        lp = take fk xs
        rp = drop fk xs
        li = takeWhile (>x) ys
        ri = tail $ dropWhile (>x) ys
        fk = length li
        
        

overlap :: (a -> a -> a) -> Tree a -> Tree a -> Tree a
overlap _ Empty Empty = Empty
overlap _ Empty (Node y lc2 rc2)            = Node y lc2 rc2
overlap _ (Node x lc1 rc1) Empty            = Node x lc1 rc1
overlap f (Node x lc1 rc1) (Node y lc2 rc2) = Node (f x y) (overlap f lc1 lc2) (overlap f rc1 rc2)




