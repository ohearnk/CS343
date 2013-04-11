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
-- Note: Add a space after appending a value to the postfixExp
infixToPostfix :: String -> String
infixToPostfix expr = do

	let stack = []
	let exp = splitOn [' '] expr		-- delimits expr by spaces & stores as list of strings
	let postfixExp = ""
	
	postfixExp --return value
	

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
		
	
-- performed for each value in postfix exp	
eval_map_function :: String -> [String] -> Bool
eval_map_function token stack = do 
	if (isOperand token)
	then do
		let stack = push token stack
		True
	else do
		if (isOperator token)
		then do
			let stack = push (applyOperator (pop stack)(pop stack)(token)) stack
			True
		else False
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
    | otherwise = error "Not a valid operator"

	
-- get the stack precedence of an operator	
stackPrec :: (Integral a) => String -> a
stackPrec operator
    | operator `elem` ["+", "-"] = 1
    | operator `elem` ["*", "/", "%"] = 2
    | operator == "^" = 3
    | operator == "(" = -1
    | otherwise = error "Not a valid operator"
	
	
-- apply an operator on two values. Returns value as string
applyOperator :: (Integral a) => a -> a -> String -> a
applyOperator num1 num2 operator = case operator of
    "+" -> num1 + num2
    "-" -> num1 - num2
    "*" -> num1 * num2
    "/" -> num1 `div` num2
    "%" -> num1 `mod` num2
    "^" -> num1 ^ num2
    otherwise -> error "Not a valid operand"
