{-
 - Author: KAO
 - Date: 2013-04-05
 - Purpose: Learning Haskell via
 -  Learn You a Haskell for Great Good! tutorial
 -  http://learnyouahaskell.com/
 -}

main = do
    {- definitions -}
    let myName = "KAO"
    let myName' = ['K','A','O']
    putStr "Are strings really character lists? "
    print (if myName == myName' then True else False)
    putStrLn ""

    {- lists are ordered, mutable (?), homogeneous collections of data types -}
    let list = [1,2,3]
    {- use the cons operator to prepend elements to a list -}
    let listPrepend = (1:[2,3])
    let listPrepend' = (1:2:3:[])
    putStr "Are lists really repeated append operations? "
    print (if list == listPrepend then True else False)
    putStr "Really? "
    print (if listPrepend == listPrepend' then True else False)
    putStrLn ""

    let lang = "Haskell"
    putStrLn ("The forth character of " ++ lang ++ " is: " ++ [(lang !! 3)])
    putStrLn ""

    {- some other list operations -}
    let my_list = [2,3,5,7,11,13]
    putStr "My list: "
    print my_list
    putStr "Head of my list: "
    print (head my_list)
    putStr "Tail of my list: "
    print (tail my_list)
    putStr "Init of my list: "
    print (init my_list)
    putStr "Last of my list: "
    print (last my_list)
    putStr "Is my list empty? "
    print (null my_list)
    putStr "Here's the first 3 elements from my list: "
    print (take 3 my_list)
    putStr "Here's the last 3 elements from my list: "
    print (drop 3 my_list)
    putStr "And here's the reverse of my list: "
    print (reverse my_list)
    putStr "The minimum and maximum of my list: "
    print ((minimum my_list), (maximum my_list))
    putStr "The sum and product of all the elements in my list: "
    print ((sum my_list), (product my_list))
    putStr "Is 3 in my list? "
    -- note: backticks all a function to be called in infix notation
    print (3 `elem` my_list)
    putStrLn ""

    {- list comprehension examples -}
    putStr "Pairs of consecutive integers whose sum of squares is a perfect square less than 10000: "
    -- note the use of ranges and multiple predicates
    print [(a,b) | a<- [1,2..100], b<-[1,2..100], c<-[1,2..100], b == a+1, a^2+b^2 == c^2, a^2+b^2 <= 10000]
    putStr "List of integers up to 200000 congruent modulo 47 and 161: "
    print [a | a<-[1..200000], a `mod` 47 == 0, a `mod` 161 == 0]
    let filterOddAndModTwo x = [y | y<-x, even y, y `mod` 2 /= 0]
    putStr "Filtering odds and elements divisible by 2 out of my list: "
    print (filterOddAndModTwo my_list) -- should be empty list []
    let someStr = "aUdWdszBpw1bV"
    let removeLowerCase s = [c | c<-s, c `elem` ['A'..'Z']++['0'..'9']]
    putStr "Some string: "
    print someStr
    putStr "Filtering out lower case characters: "
    print (removeLowerCase someStr)
    putStrLn ""

    {-- tuples: ordered, immutable (?), homogeneous collections of data types --}
    let myTuple = (3,1)
    putStr "My first tuple: "
    print myTuple
    putStr "First element: "
    print (fst myTuple)
    putStr "Second element: "
    print (snd myTuple)
