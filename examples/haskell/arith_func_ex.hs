{-
 - Author: KAO
 - Date: 2013-03-22
 - Purpose: Learning Haskell via
 -  Learn You a Haskell for Great Good! tutorial
 -  http://learnyouahaskell.com/
 -}

main = do
    {- simple function -}
    let doubleMe x = x + x
    {- function using the previous function -}
    let doubleUs x y = doubleMe x + doubleMe y
    {- recursive function;
 -      also uses control flow structures -}
    let fact x = if x > 1
        then x * fact (x-1)
        else 1
    {- function with no argments and fixed return value
 -      (a.k.a, a definition, or name, in Haskell -}
    let myName = "KAO"

    -- I/O statemens using the above functions
    putStr "The double of 4 is: "
    print (doubleMe 4)

    putStr "The successor of the double of 4 is: "
    print (succ (doubleMe 4))

    putStr "The double of 2 + 5 is: "
    print (doubleUs 2 5)

    putStr "7! = "
    print (fact 7)

    putStrLn (['M','y',' ','n','a','m','e',' ','i','s',' '] ++ myName)
