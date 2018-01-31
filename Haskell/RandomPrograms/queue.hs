data Queue a = Queue [a] [a] deriving (Show)



create :: Queue a 
create = Queue [] []


push :: a -> Queue a -> Queue a 
push a (Queue xs ys) = Queue xs $ a:ys


top :: Queue a -> a 
top (Queue [] ys) = last ys
top (Queue xs ys) = head xs


pop :: Queue a -> Queue a 
pop (Queue [] ys) = Queue (reverse $ init ys) []
pop (Queue (x:xs) ys) = Queue xs ys


empty :: Queue a -> Bool
empty (Queue [] []) = True
empty _ = False


instance Eq a => Eq (Queue a) 
    where
        Queue xs ys == Queue as bs = xs++(reverse ys) == as++(reverse bs)