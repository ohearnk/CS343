import Test.HUnit
import InfixPostfix

-- main method
main = do
    let test1 = TestCase (assertEqual 
                "infixToPostfix Test 0" "3 4 2 5 ^ - * 6 +"
                (infixToPostfix "3 * ( 4 - 2 ^ 5 ) + 6"))
    let test2 = TestCase (assertEqual 
                "infixToPostfix Test 1" "3 2 1 2 + ^ ^"
                (infixToPostfix "3 ^ 2 ^ ( 1 + 2 )"))
    let test3 = TestCase (assertEqual
                "infixToPostfix Test 2" "10 2 2 2 ^ ^ * 10 50 * +"
                (infixToPostfix "10 * ( 2 ^ 2 ^ 2 ) + 10 * 50"))
    let test4 = TestCase (assertEqual
                "infixToPostfix Test 3" "100 50 2 3 ^ - / 50 10 / - 5 +"
                (infixToPostfix "100 / ( 50 - 2 ^ 3 ) - 50 / 10 + 5"))
    let test5 = TestCase (assertEqual
                "infixToPostfix Test 4" "10 54 10 % 25 10 - 2 2 ^ + * 3 / +"
                (infixToPostfix "10 + 54 % 10 * ( 25 - 10 + 2 ^ 2 ) / 3"))
    let test6 = TestCase (assertEqual
                "infixToPostfix Test 5" "10 5 2 % + 5 3 3 ^ * + 25 5 / -"
                (infixToPostfix "( 10 + 5 % 2 ) + ( 5 * 3 ^ 3 ) - ( 25 / 5 )"))

    let test7 = TestCase(assertEqual
                "evaluatePostfix Test 0" "-78"
                (evaluatePostfix "3 4 2 5 ^ - * 6 +"))
    let test8 = TestCase(assertEqual
                "evaluatePostfix Test 1" "6561"
                (evaluatePostfix "3 2 1 2 + ^ ^"))
    let test9 = TestCase(assertEqual 
                "evaluatePostfix Test 2" "660"
                (evaluatePostfix "10 2 2 2 ^ ^ * 10 50 * +"))
    let test10 = TestCase(assertEqual
                "evaluatePostfix Test 3" "2" 
                (evaluatePostfix "100 50 2 3 ^ - / 50 10 / - 5 +"))
    let test11 = TestCase(assertEqual
                "evaluatePostfix Test 4" "35"
                (evaluatePostfix "10 54 10 % 25 10 - 2 2 ^ + * 3 / +"))
    let test12 = TestCase(assertEqual
                "evaluatePostfix Test 5" "141"
                (evaluatePostfix "10 5 2 % + 5 3 3 ^ * + 25 5 / -"))

    let tests = TestList [test1, test2, test3, test4,
                    test5, test6, test7, test8, 
                    test9, test10, test11, test12]
    runTestTT tests
