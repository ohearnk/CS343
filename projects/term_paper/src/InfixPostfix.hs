{- 
 - Author: Kurt O'Hearn 
 - Author: Nick Olesak
 - Purpose: CIS 343-02 Project
 - Date: 2013-04-08
 - Descrption: This program servers as a simple calculator using
 - postfix expressions. Internally, the program converts postfix
 - expressions to infix notation and subsequently evaluates the infix.
-}

module InfixPostfix
( infixToPostfix,
evaluatePostfix
) where

import Data.List.Split

-- converts an infix expression to a postfix expression
infixToPostfix :: String -> String
infixToPostfix expr = 
    let concatHigherPrec :: [String] -> String -> String
        concatHigherPrec [] _ = ""
        concatHigherPrec (x:xs) y
            | (stackPrec x) >= (inputPrec y) = x ++ " "
                ++ (concatHigherPrec xs y)
            | otherwise = ""

        keepLowerPrec :: [String] -> String -> [String]
        keepLowerPrec [] _ = []
        keepLowerPrec all@(x:xs) y
            | (stackPrec x) >= (inputPrec y) = (keepLowerPrec xs y)
            | otherwise = all

        concatBeforeLeftParen :: [String] -> String
        concatBeforeLeftParen ("(":xs) = ""
        concatBeforeLeftParen (x:xs) = x ++ " "
            ++ (concatBeforeLeftParen xs)

        removeToLeftParen :: [String] -> [String]
        removeToLeftParen ("(":xs) = xs
        removeToLeftParen (x:xs) = removeToLeftParen xs

        parseExpr [] stack = 
            (foldl (++) "" (zipWith (++) 
                stack (replicate (length stack - 1) " ")))
            ++ (last stack)
        parseExpr (x:xs) stack
            | isOperand x = x ++ " " ++ (parseExpr xs stack)
            | isLeftParen x = (parseExpr xs (x:stack))
            | isOperator x = (concatHigherPrec stack x)
                ++ (parseExpr xs (x:(keepLowerPrec stack x)))
            | (isRightParen x) && ("(" `elem` stack) =
                (concatBeforeLeftParen stack)
                ++ (parseExpr xs (removeToLeftParen stack))
            | otherwise = error "Not a valid identifier: " ++ x

    in parseExpr (splitOn [' '] expr) []


-- evaluates a postfix expression
evaluatePostfix :: String -> String
evaluatePostfix expr = (parsePostfixExp (splitOn [' '] expr) [])
    where parsePostfixExp [] stack = head stack
          parsePostfixExp (x:xs) (s1:s2:stack)
              | isOperand x = parsePostfixExp xs (x:s1:s2:stack)
              | isOperator x =
                    parsePostfixExp xs ((applyOperator s2 s1 x):stack)
              | otherwise = error ("Not a valid identifier")
          parsePostfixExp (x:xs) stack = parsePostfixExp xs (x:stack)

	
-- returns true if param is an operator
isOperator :: String -> Bool
isOperator operator
    | operator `elem` ["+","-","*","/","%","^"] = True
    | otherwise = False


-- returns true if param is an operand
isOperand :: String -> Bool
isOperand operand = case reads operand :: [(Integer, String)] of
    [(_, "")] -> True
    _         -> False


-- returns true if param is a left parenthesis
isLeftParen :: String -> Bool
isLeftParen "(" = True
isLeftParen operator = False


-- returns true if param is a right parenthesis
isRightParen :: String -> Bool
isRightParen ")" = True
isRightParen operator = False


-- get the input precedence of an operator	
inputPrec :: (Integral a) => String -> a
inputPrec operator
    | operator `elem` ["+", "-"] = 1
    | operator `elem` ["*", "/", "%"] = 2
    | operator == "^" = 4
    | operator == "(" = 5
    | otherwise = error ("Not a valid operator: " ++ operator)

	
-- get the stack precedence of an operator	
stackPrec :: (Integral a) => String -> a
stackPrec operator
    | operator `elem` ["+", "-"] = 1
    | operator `elem` ["*", "/", "%"] = 2
    | operator == "^" = 3
    | operator == "(" = -1
    | otherwise = error ("Not a valid operator: " ++ operator)
	
	
-- apply an operator on two values. Returns value as string
applyOperator :: String -> String -> String -> String
applyOperator num1 num2 operator = case operator of
    "+" -> show ((read num1 :: Int) + (read num2 :: Int))
    "-" -> show ((read num1 :: Int) - (read num2 :: Int))
    "*" -> show ((read num1 :: Int) * (read num2 :: Int))
    "/" -> show ((read num1 :: Int) `div` (read num2 :: Int))
    "%" -> show ((read num1 :: Int) `mod` (read num2 :: Int))
    "^" -> show ((read num1 :: Int) ^ (read num2 :: Int))
    otherwise -> error ("Not a valid operator: " ++ operator)
