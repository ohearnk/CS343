{- 
 - Author: Kurt O'Hearn 
 - Author: Nick Olesak
 - Purpose: CIS 343-02 Project
 - Date: 2013-04-08
 - Descrption: This program servers as a simple calculator using
 - postfix expressions. Internally, the program converts postfix
 - expressions to infix notation and subsequently evaluates the infix.
-}

import Data.List.Split


-- converts an infix expression to a postfix expression
-- Note: Add a space after appending a value to the postfixExp
infixToPostfix :: String -> String
infixToPostfix expr = do

	let stack = []
	let exp = splitOn [' '] expr		-- delimits expr by spaces & stores as list of strings
	let postfixExp = ""
	
	postfixExp --return value
	
	
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

	
-- pushes a character onto a stack	
push :: String -> [String] -> [String]
push val str = str ++ [val]

	
-- returns the character at the end of a [String]
pop :: [String] -> String
pop str = last str

	
-- returns true if param is an operator
isOperator :: String -> Bool
isOperator val = do
	if val `elem` ["+","-","*","/","%","^"]
	then True
	else False


-- returns true if param is an operand
isOperand :: String -> Bool
isOperand val = do
	let v = read val :: Int
	if v `elem` [-99999..99999]
	then True
	else False
	
-- returns true if param is a left parenthesis
isLeftParen :: String -> Bool
isLeftParen val = do
	if val == "("
	then True
	else False
	
-- returns true if param is a right parenthesis
isRightParen :: String -> Bool
isRightParen val = do
	if val == ")"
	then True
	else False

	
-- get the stack precedence of an operator	
stackPrec operator = do
	if operator `elem` ["+", "-"]
		then 1
	else if operator `elem` ["*", "/", "%"]
		then 2
	else if operator == "^"
		then 3
	else if operator == "("
		then -1
	else null
	
	
-- get the input precedence of an operator	
inputPrec operator = do
	if operator `elem` ["+", "-"]
		then 1
	else if operator `elem` ["*", "/", "%"]
		then 2
	else if operator == "^"
		then 4
	else if operator == "("
		then 5
	else null
	
	
-- apply an operator on two values. Returns value as string
applyOperator :: String -> String -> String -> String
applyOperator n1 n2 operator = do	
	let num1 = read n1 :: Int
	let num2 = read n2 :: Int

	if operator == "+"
	then do 
		let val = num1 + num2
		show val :: String
	else if operator == "-"
	then do 
		let val = num1 - num2
		show val :: String
	else if operator == "*"
		then do 
		let val = num1 * num2
		show val :: String
	else if operator == "/"
		then do 
			if num2 > 0
			then do 
				let val = fromIntegral (num1) / fromIntegral(num2)
				show val :: String
			else "0"
	else if operator == "%"
		then do 
		let val = num1 `mod` num2
		show val :: String
	else if operator == "^"
		then do 
		let val = num1 ^ num2
		show val :: String
	else "0"
	
	
-- main method
-- currently used to test the above functions
main = do
	print (splitOn [' '] "5 + 6 + 77 + 4 - 8 * 55")
	print (evaluatePostfixExp "5")
