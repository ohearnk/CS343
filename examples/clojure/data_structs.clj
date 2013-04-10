(= 1 2)
(class true)
(class (= 2 2))

; boolean expressions
(if true (println "This is profoundly true!"))
(if (= 4 (+ 2 2)) (println "I am a math whiz!"))
(if (< 1 2) (println "that is true") (println "that is false"))
(if (> 1 2) (println "that is true") (println "that is false"))
(if 0 (println "0 is boolean true"))
(if "" (println "empty string is boolean true"))
(if nil (println "nil is boolean true") (println "nil is boolean false"))
(println "")

; lists and common functions associated with lists
(println (list 1 2 3))
(println (first '(1 2 3)))
(println (rest '(1 2 3)))
(println (nth '(1 2 3) 1))
(println (last '(1 2 3)))
(println (cons 4 '(1 2 3)))
(println "")

; vectors: data structures optimized for random access
;   (by using an offset as opposed to traversing the data
;   structure done in lists)
(println (nth [1 2 3] 1))
(println (nth ["bees" "bears" "honey"] 0))
; note: vectors are treated as functions
(println (["bees" "bears" "honey"] 0))

; bindings
(def board [[1 2 3][4 5 6][7 8 9]])
(println board)
(println (nth board 1))
(println (nth (nth board 1) 1))
