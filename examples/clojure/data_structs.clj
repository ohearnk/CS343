; some basic functions and type checking
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

; lists (ordered collections of homogeneous data types) and common functions associated with lists
(println (list 1 2 3))
(println (first '(1 2 3)))
(println (rest '(1 2 3)))
(println (nth '(1 2 3) 1))
(println (last '(1 2 3)))
(println (cons 4 '(1 2 3)))
(println "")

; vectors: ordered collections of homogeneous data types optimized for random access
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
(println "")

; sets: unordered collections of homogeneous data types
(println '#{"peach" "pear" "apple"})
(def fruit #{"peach" "pear" "apple"})
(println (sort fruit))
(println (sorted-set 3 5 7 2 3 1))
;(println (clojure.set/union #{1 4 3} #{1 2 5}))
;(println (clojure.set/difference #{1 4 3} #{1 2 5}))
; set membership test
(println (#{"peach" "pear" "apple"} "pear"))
(println (#{"peach" "pear" "apple"} "lemon"))
(println "")

; maps
; note: in Clojure, strings prepended with a colon are
; called keywords (essentially, creates a common reference for
; all uses of the keyword)
(println {:soft "peach" :mushy "pear" :hard "apple"})
(def fruits {:soft "peach" :mushy "pear" :hard "apple"})
(println (fruits :hard))
; also valid, strangely
(println (:hard fruit))
(println (merge {:bob "616-555-1212", :chuck "515-555-1212"} {:alice "331-555-1212"}))
