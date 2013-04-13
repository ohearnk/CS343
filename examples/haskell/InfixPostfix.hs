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
( infixToPostfix
--, evaluatePostfixExp
, applyOperator
, inputPrec
, stackPrec
, isLeftParen
, isRightParen
, isOperand
, isOperator
)
where

import Data.List.Split

-- converts an infix expression to a postfix expression
infixToPostfix :: String -> String
infixToPostfix expr = (parseExpr (splitOn [' '] expr) [])
    where   parseExpr [] stack = foldr1 (++) stack
            parseExpr (x:xs) stack
                | isOperand x = x ++ " " ++ (parseExpr xs stack)
                | isLeftParen x = (parseExpr xs (x:stack))
                | isOperator x = (concatLowerPrec stack x) ++ (parseExpr xs (x:(keepHigherPrec stack x)))
                | (isRightParen x) && ("(" `elem` stack) = (concatBeforeLeftParen stack) ++ (parseExpr xs (removeToLeftParen stack))
                | otherwise = error ("Not a valid identifier: " ++ x ++ (foldr1 (++) xs) ++ " " ++ (foldr1 (++) stack) -- remove after debug)


concatLowerPrec :: [String] -> String -> String
concatLowerPrec [] _ = ""
concatLowerPrec (s:ss) i
    | (stackPrec s) >= (inputPrec i) = s ++ " " ++ (concatLowerPrec ss i)
    | otherwise = ""


keepHigherPrec :: [String] -> String -> [String]
keepHigherPrec [] _ = []
keepHigherPrec (s:ss) i
    | (stackPrec s) >= (inputPrec i) = (keepHigherPrec ss i)
    | otherwise = ss


concatBeforeLeftParen :: [String] -> String
concatBeforeLeftParen [] = ""
concatBeforeLeftParen ("(":ss) = ""
concatBeforeLeftParen (s:ss) = s ++ " " ++ (concatBeforeLeftParen ss)


removeToLeftParen :: [String] -> [String]
removeToLeftParen [] = []
removeToLeftParen ("(":ss) = ss
removeToLeftParen (s:ss) = removeToLeftParen ss


{-
-- evaluates a postfix expression and prints the result	
evaluatePostfixExp :: String -> String
evaluatePostfixExp expr = do
	let stack = []
	let exp = splitOn [' '] expr
	head (forEachEval exp stack)
	

-- recursively loops through a postfix expression and evaluates it
-- In the process of writing this code.
-- It currently has not been tested nor do I think is it close to working
-- I just decided to quit for the night.
forEachEval :: [String] -> [String] -> [String]
forEachEval expr stack = do
	if (length expr == 0)
	then stack 					-- base return value
	else do
		let token = head expr	-- first element in the expression
		let exp = tail exp		-- drop the first element from the expression
		if (isOperand token)
		then do
			let stack = push token stack
			forEachEval exp stack
		else do
			if (isOperator token)
			then do
				let stack = push (applyOperator (pop stack)(pop stack)(token)) stack
				forEachEval exp stack
			else []
-}
	
	
-- pushes a character onto a stack	
push :: String -> [String] -> [String]
push val str = str ++ [val]

	
-- returns the character at the end of a [String]
pop :: [String] -> String
pop str = last str

	
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
