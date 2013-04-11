import InfixPostfix

-- main method
-- currently used to test the above functions
main = do
--	print (splitOn [' '] "5 + 6 + 77 + 4 - 8 * 55")
    print (applyOperator 2 5 "+")
    print (applyOperator 3 4 "-")
    print (applyOperator 0 10 "*")
    print (applyOperator 5 2 "/")
    print (applyOperator 4 3 "%")
    print (applyOperator 2 3 "^")
    putStrLn "-------"
    print (inputPrec "-")
    print (inputPrec "%")
    putStrLn "-------"
    print (stackPrec "+")
    print (stackPrec "^")
    putStrLn "-------"
    print (isLeftParen "(")
    print (isRightParen "(")
    putStrLn "-------"
    print (isOperand "-2")
    print (isOperand "+")
    putStrLn "-------"
    print (isOperator "/")
    print (isOperator "11")
--	print (evaluatePostfixExp "5")
