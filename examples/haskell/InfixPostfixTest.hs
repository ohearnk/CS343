import Test.HUnit
import InfixPostfix

-- main method
main = do
    let test1 = TestCase (assertEqual "3 4 2 5 ^ - * 6 +" (infixToPostfix "3 * ( 4 - 2 ^ 5 ) + 6"))
    let test2 = TestCase (assertEqual "3 2 1 2 + ^ ^" (infixToPostfix "3 ^ 2 ^ ( 1 + 2 )"))
    let test3 = TestCase (assertEqual "10 2 2 2 ^ ^ * 10 50 * +" (infixToPostfix "10 * ( 2 ^ 2 ^ 2 ) + 10 * 50"))
    let test4 = TestCase (assertEqual "100 50 2 3 ^ - / 50 10 / - 5 +" (infixToPostfix "100 / ( 50 - 2 ^ 3 ) - 50 / 10 + 5"))
    let test5 = TestCase (assertEqual "10 54 10 % 25 10 - 2 2 ^ + * 3 / +" (infixToPostfix "10 + 54 % 10 * ( 25 - 10 + 2 ^ 2 ) / 3"))
    let test6 = TestCase (assertEqual "10 5 2 % + 5 3 3 ^ * + 25 5 / -" (infixToPostfix "( 10 + 5 % 2 ) + ( 5 * 3 ^ 3 ) - ( 25 / 5 )"))

    let test7 = TestCase(assertEqual -78 (evaluatePostfix "3 4 2 5 ^ - * 6 +"))
    let test8 = TestCase(assertEqual 6561 (evaluatePostfix "3 2 1 2 + ^ ^"))
    let test9 = TestCase(assertEqual 660 (evaluatePostfix "10 2 2 2 ^ ^ * 10 50 * +"))
    let test10 = TestCase(assertEqual 2 (evaluatePostfix "100 50 2 3 ^ - / 50 10 / - 5 +"))
    let test11 = TestCase(assertEqual 35 (evaluatePostfix "10 54 10 % 25 10 - 2 2 ^ + * 3 / +"))
    let test12 = TestCase(assertEqual 141 (evaluatePostfix "10 5 2 % + 5 3 3 ^ * + 25 5 / -"))

    let tests = [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11, test12]
    runTestTT tests
