----------------------------------
--            Modules           --
----------------------------------
import Data.Ord
import Data.List

----------------------------------
--        Data Structures       --
----------------------------------

data Iris = Iris {sl :: Float, sw :: Float, pl :: Float, pw :: Float, classe :: String}
    deriving (Show)

data Distance = Euclidean | Manhattan
data Voting = Simple | Ponderat
data Evaluate = Accuracy | Lost


----------------------------------
--    Functions: Distance       --
----------------------------------


distance :: Iris -> Iris -> Distance -> Float
distance x y Euclidean = dist_e x y
distance x y Manhattan = dist_man x y



dist_e :: Iris -> Iris -> Float
dist_e x y = sqrt $ sumpowd x y
    where
        sumpowd :: Iris -> Iris -> Float
        sumpowd (Iris a1 b1 c1 d1 _)  (Iris a2 b2 c2 d2 _) = (a1-a2)**2 + (b2-b2)**2 + (c1-c2)**2 + (d1-d2)**2

        
dist_man :: Iris -> Iris -> Float
dist_man x y = sqrt $ sumabs x y
    where
        sumabs :: Iris -> Iris -> Float
        sumabs (Iris a1 b1 c1 d1 _)  (Iris a2 b2 c2 d2 _) = abs (a1-a2) + abs (b1-b2) + abs (c1-c2) + abs (d1-d2)




---------------------------------
--    Functions: Voting        --
---------------------------------


votacio :: [[(Float, String)]] -> Voting -> [[String]]
votacio xs Simple   = map (\x -> vot_simp x) xs
votacio xs Ponderat = map (\x -> vot_pond x) xs


vot_simp :: [(Float, String)] -> [String]
vot_simp xs = map (\x -> snd x) dec_sort
    where
        dec_sort = sortBy (comparing fst) xs


vot_pond :: [(Float, String)] -> [String]
vot_pond xs = map (\x -> max_stri) xs
        where
            max_stri =  max3iris (setosa) (versic) (virgin)  
                where
                    setosa = sum [ x | (x,a) <- xssort, a == "Iris-setosa"]
                    versic = sum [ x | (x,a) <- xssort, a == "Iris-versicolor"]
                    virgin = sum [ x | (x,a) <- xssort, a == "Iris-virginica"]
                    xssort = sort  xs'
                        where
                            xs' = map (\x -> (1/(fst x), snd x)) xs



----------------------------------
--    Functions: Evaluation     --
----------------------------------

lost_acc :: [String] -> [Iris] -> Float
lost_acc preds tests = 1.0 - accuracy preds tests


accuracy :: [String] -> [Iris] -> Float
accuracy preds tests = (foldl (+) 0.0 (mapping)) / longi
    where
        mapping =  map (boolToFloat) ( zipWith (==)  preds (getIrisClasses tests) )
        longi = fromIntegral (length tests)




----------------------------------
--    Functions: Prediction     --
----------------------------------

kGetPredict :: [Iris] -> [Iris] -> Int -> Distance -> Voting    -> [String]
kGetPredict tests train k dist vot  =  map (\x -> predictMe x k) listvot
    where
        listvot = votacio pairs vot 
            where
                pairs = makePairs train tests dist 


predictMe :: [String] -> Int -> String
predictMe xs k = head . maximumBy (comparing length) . group . sort . take k  $ xs


makePairs :: [Iris] -> [Iris] -> Distance -> [[(Float, String)]]
makePairs tests train dist = map (\xs -> zipWith (,) xs classes) distlist
    where
        distlist = map (\x -> map (\y -> distance x y dist) tests) train
        classes = getIrisClasses tests



----------------------------------
--    Functions: Application    --
----------------------------------

kGetApplication :: [String] -> [Iris] -> (Float, Float)
kGetApplication preds tests  = head $ zip [(accuracy preds tests)] [(lost_acc preds tests)]


-------------------------
--    Main program     --
-------------------------

processData train tests = do
    stuff <- getLine

    if (head . words $ stuff) == "predictES" then  do
        putStrLn ( printMe $ kGetPredict tests train (read (( words stuff) !! 1) :: Int)  Euclidean Simple)
        processData train tests
    else if (head . words $ stuff) == "predictEP" then  do
        putStrLn ( printMe $ kGetPredict tests train (read (( words stuff) !! 1) :: Int)  Euclidean Ponderat)
        processData train tests
    else if (head . words $ stuff) == "predictMS" then  do
        putStrLn ( printMe $ kGetPredict tests train (read (( words stuff) !! 1) :: Int)  Manhattan Simple)
        processData train tests
    else if (head . words $ stuff) == "predictMP" then  do
        putStrLn ( printMe $ kGetPredict tests train (read (( words stuff) !! 1) :: Int)  Manhattan Ponderat)
        processData train tests

    else if (head . words $ stuff) == "applyES" then  do
        putStrLn ( show $ kGetApplication ( kGetPredict tests train (read (( words stuff) !! 1) :: Int) Euclidean Simple ) tests )
        processData train tests
    else if (head . words $ stuff) == "applyEP" then  do
        putStrLn ( show $ kGetApplication ( kGetPredict tests train (read (( words stuff) !! 1) :: Int) Euclidean Ponderat ) tests )
        processData train tests
    else if (head . words $ stuff) == "applyMS" then  do
        putStrLn ( show $ kGetApplication (kGetPredict tests train (read (( words stuff) !! 1) :: Int) Manhattan Simple ) tests )
        processData train tests
    else if (head . words $ stuff) == "applyMP" then  do
        putStrLn ( show $ kGetApplication (kGetPredict tests train (read (( words stuff) !! 1) :: Int) Manhattan Ponderat ) tests )
        processData train tests

    else if (stuff) == "usage" then do
        usageWrite
        processData train tests
    else if (stuff) == "about" then do
        aboutWrite
        processData train tests

    else return ([], [])



main = do
    putStrLn "Loading file: < iris.test.txt > "
    testsTXT <- readFile "iris.test.txt"
    putStrLn "Loading file: < iris.train.txt > "
    trainTXT <- readFile "iris.train.txt"

    let train = txtToIrisSet trainTXT
    let tests = txtToIrisSet testsTXT

    usageWrite

    processData train tests



--------------------------------------------------------------------------
-- (Dirty) Auxiliary function for input processing and easy conversions --
--------------------------------------------------------------------------


txtToIrisSet :: String -> [Iris]
txtToIrisSet txts = irisList ( concat $ map (\x -> wordsComma x) $ lines txts )


getIrisClasses :: [Iris] -> [String]
getIrisClasses xs = map (getClassName) xs


getClassName :: Iris -> String
getClassName (Iris _ _ _ _ name) = name

printMe :: [String] -> String
printMe xs = foldr (++) "" (map (\x -> x ++ "\n") xs)


strFloat :: String -> Float
strFloat xs = (read xs) :: Float

boolToFloat :: Bool -> Float
boolToFloat True = 1.0
boolToFloat False = 0.0

max3iris :: Float -> Float -> Float -> String
max3iris x y z 
    | max (max x y) z == x = "Iris-setosa"
    | max (max x y) z == y = "Iris-versicolor"
    | otherwise = "Iris-virginica"

processIris :: [String] -> Iris
processIris [a, b, c, d, e] = (Iris (strFloat a)  (strFloat b)  (strFloat c)  (strFloat d)  e)


irisList :: [String] -> [Iris] 
irisList xs 
    | length xs < 5 = [] 
    | otherwise = processIris (take 5 xs) : (irisList $ drop 5 xs)


-- Similar to words, except for commas
wordsComma :: String -> [String]
wordsComma as 
    | as == xs = [as]
    | otherwise =  xs : wordsComma ys
    where
        xs = takeWhile (\x -> x /= ',') as
        ys = tail $ dropWhile (\x -> x /= ',') as



------------------------------------------------
-- IO functions for some nice user experience --
------------------------------------------------

usageWrite :: IO ()
usageWrite = putStrLn  (helpMsgs)
    where
        helpMsgs :: String
        helpMsgs = sentMsg1 ++ optionMsg1 ++ optionMsg2 ++ optionMsg3 ++ optionMsg4 ++ predMsg1 ++ predMsg2 ++ predMsg3 ++ predMsg4 ++ usageMsg ++ aboutMsg ++ exitMsg
            where
                sentMsg1   = "\nUSAGE FOR THIS PROGRAM:\n\n"
                optionMsg1 = "    --> \"predictES [K]\": returns prediction of applying k-NN for a given K, size |tests| \n\t- Options: Euclidean distance, Simple voting \n"
                optionMsg2 = "    --> \"predictMS [K]\": returns prediction of applying k-NN for a given K, size |tests| \n\t- Options: Euclidean distance, Ponderated voting \n"
                optionMsg3 = "    --> \"predictEP [K]\": returns prediction of applying k-NN for a given K, size |tests| \n\t- Options: Manhattan distance, Simple voting \n"
                optionMsg4 = "    --> \"predictMP [K]\": returns prediction of applying k-NN for a given K, size |tests| \n\t- Options: Manhattan distance, Ponderated voting \n\n"
                predMsg1   = "    --> \"applyES [K]\" : returns application of a prediction on K, based on test cases \n\t- Options for predictions: Euclidean distance, Simple voting \n"
                predMsg2   = "    --> \"applyMS [K]\" : returns application of a prediction on K, based on test cases \n\t- Options for predictions: Euclidean distance, Ponderated voting \n"
                predMsg3   = "    --> \"applyEP [K]\" : returns application of a prediction on K, based on test cases \n\t- Options for predictions: Manhattan distance, Simple voting \n"
                predMsg4   = "    --> \"applyMP [K]\" : returns application of a prediction on K, based on test cases \n\t- Options for predictions: Manhattan distance, Ponderated voting \n\n"
                usageMsg   = "    --> \"usage\": print this message (again!) \n"
                aboutMsg   = "    --> \"about\": show info about the program \n"
                exitMsg    = "    --> \"exit\": To exit press Ctrl+C or write any other text (Watch out for mistakes!) \n"



aboutWrite :: IO ()
aboutWrite = putStrLn  (helpMsgs)
    where
        helpMsgs :: String
        helpMsgs = aboutMsg1 ++ compiled1 ++ compiled2 ++ intr ++ functs ++ aplyMsg1 ++ aplyMsg2 ++ predMsg1 ++ predMsg2 ++ char1 ++ char2 ++ credits
            where
                aboutMsg1   = "\nABOUT THIS PROGRAM:\n"
                compiled1  = "    --> This program (compiled) requires the user to have the tests on the same root folder. If you want to use your own tests and trainers,   \n"
                compiled2  = "        you have to keep these names: [iris.train.txt] for training values, [iris.test.txt] for test values \n"
                intr       = "    --> On the interpreted version, the functions kGetPredict and kGetApplication let you use your own (properly defined!) tests and training values\n\n"
                functs     = "These are the functions you can try for k-NN:\n"
                aplyMsg1   = "    --> \"applyXY [K]\" : are k-NN applications: they return a tuple (a, l), with the result of checking whether some predictions match the test cases  \n"
                aplyMsg2   = "        a -> number of accurate predictions (hits)  |  l -> number of lost predictions (misses) \n\n"
                predMsg1   = "    --> \"predictXY [K]\" are k-NN predictions: given two lists compsosed of Iris sets, it returns a prediction for its K nearest neighbours  \n\n"
                predMsg2   = "    For these two functions, there are four types of possible cases to test \n"
                char1      = "    --> the first character X = {E, S} represents distance: either Euclidean or Manhattan distance. \n"
                char2      = "    --> the second one Y = {S, P} represents the voting mechanism: either Simple or Ponderated. \n"
                credits    = "    -----------------------------------\nDeveloped by Miguel Moreno as an assignment for the subject Programming Languages (GRAU-LP) in Autumn \'17 \n"




