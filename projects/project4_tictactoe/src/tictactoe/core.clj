(ns tictactoe.core
  (:gen-class))
 
 
; Format a row for display
(defn display-row [row] 
	(str " " (nth row 0) " | " (nth row 1) " | " (nth row 2))
)


; Display the game board 
(defn display [board]
	(println) ; new line
	(println (display-row (nth board 0)))
	(println (str "---+---+---"))
	(println (display-row (nth board 1)))
	(println (str "---+---+---"))
	(println (display-row (nth board 2)))
	(println) ; new line
)


; TODO
(defn winner? [board]
	0
)
  

; returns "x" or "o" to represent the current player depending on the number of moves used. 
(defn get-current-player [moves]
	(if (= (mod moves 2) 0)
		"O"
		"X"
	)
)

	
; TODO
; Update the board for the given location for the current player
(defn update-board [board loc moves] 
	(assoc 
		board 
		(quot(- loc 1)3) 
		(assoc 
			(nth board (quot(- loc 1)3)) 
			(mod(- loc 1)3) 
			(get-current-player moves)
		)
	)
)


; prompts the current player for a move and 
(defn get-move [board moves]
	(display board)
	(println (str "Player " (get-current-player moves) ", enter your move: "))
	(let [loc (read)]
		(if (or 
				(< loc 1)
				(> loc 9)
				(= (nth(nth board (quot(- loc 1)3)) (mod(- loc 1)3)) "O")
				(= (nth(nth board (quot(- loc 1)3)) (mod(- loc 1)3)) "X"))
			(do (println "Invalid move. Please try again.\n") (get-move board moves))
			(update-board board loc moves)
		)
	)
)



; Initial function that starts a game of tic tac toe and prints the final result
(defn tictactoe [board moves]
	(if (= (winner? board) 1)
		(str "\nPlayer " (get-current-player moves) " wins!\n")
	(if (> moves 0)
		(tictactoe (get-move board moves) (- moves 1))
		(do (display board) "Draw!"))
	)
)


; ---------------
; Main Function.
; ---------------
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




