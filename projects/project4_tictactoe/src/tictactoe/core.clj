(ns tictactoe.core
  (:gen-class))
; ------------------------------------------------------------
; Author: Kurt O'Hearn
; Author: Nick Olesak
; Date: 15 April 2013
; Purpose: CIS 343 Project
; Description: This program simulates a game of Tic Tac Toe.
; ------------------------------------------------------------
 
 
; Format a row for display. Used by the "display" function to format output. 
(defn display-row [row] 
	(str " " (nth row 0) " | " (nth row 1) " | " (nth row 2))
)

; Display the game board .
(defn display [board]
	(println) ; new line
	(println (display-row (nth board 0)))
	(println (str "---+---+---"))
	(println (display-row (nth board 1)))
	(println (str "---+---+---"))
	(println (display-row (nth board 2)))
	(println) ; new line
)

; Checks a specified row for 3 matches. 
(defn row-match? [board row]
	(if (= (nth (nth board row) 0) (nth (nth board row) 1) (nth (nth board row) 2)) true false)
)

 ; Check a specified column for 3 matches. 
(defn col-match? [board col]
	(if (= (nth (nth board 0) col) (nth (nth board 1) col) (nth (nth board 2) col)) true false)
)

; Check both diagonals for 3 matches. 
(defn diag-match? [board] 
	(if (or (= (nth (nth board 0) 0) (nth (nth board 1) 1) (nth (nth board 2) 2))
			(= (nth (nth board 0) 2) (nth (nth board 1) 1) (nth (nth board 2) 0)))
		true 
		false
	)
)

; Determines if either a player has won the game yet. 
(defn winner? [board]
	(if (or (row-match? board 0) (row-match? board 1) (row-match? board 2) 
			(col-match? board 0) (col-match? board 1) (col-match? board 2) 
			(diag-match? board)
		)
	(do  (display board) true)
	false)
)
  
; Returns "X" or "O" to represent the current player. 
(defn get-current-player [moves]
	(if (= (mod moves 2) 0)
		"O"
		"X"
	)
)
	
; Update the board at the specified location for the current player.
(defn update-board [board loc moves] 
	(assoc 	board 
			(quot(- loc 1)3) 
			(assoc 
				(nth board (quot(- loc 1)3)) 
				(mod(- loc 1)3) 
				(get-current-player moves)))
)

; Checks user input for validity. 
(defn valid-move? [board loc]
	(try 
	(if (and 
			(instance? Number loc) 
			(>= loc 1)
			(<= loc 9)
			(not= (nth(nth board (quot(- loc 1)3)) (mod(- loc 1)3)) "O")
			(not= (nth(nth board (quot(- loc 1)3)) (mod(- loc 1)3)) "X"))
		true
		false)
	(catch Exception e false)
	)
)

; Prompts the current player for a move and checks input for errors. 
(defn get-move [board moves]
	(display board)
	(println (str "Player " (get-current-player moves) ", enter your move: "))
	(let [loc (read)]
		(if (valid-move? board loc)
			(update-board board loc moves)
			(do (println (str loc " is not a valid move. Please try again.\n")) (get-move board moves))
		)
	)
)

; Initial function that starts a game of tic tac toe and prints the final result.
(defn tictactoe [board moves]
	(if (winner? board)
		(str "\nPlayer " (get-current-player (+ moves 1)) " wins!\n\n")
	(if (> moves 0)
		(tictactoe (get-move board moves) (- moves 1))
		(do (display board) "Draw!\n\n"))
	)
)

; Main Function.
(defn -main
	"Simulates a game of tic-tac-toe. "
	[& args]
	; work around dangerous default behaviour in Clojure
	(alter-var-root #'*read-eval* (constantly false))
  
	; Define a game board.
	(def board [[1 2 3][4 5 6][7 8 9]])

	; Start the tic tac toe game and print the result. 
	(println (tictactoe board 9))
)