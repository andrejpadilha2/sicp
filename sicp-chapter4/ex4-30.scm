;; a) this procedure works fine because "display" is a primitive procedure that makes its argument be forced

;; b) original evaluator
;; (p1 1) -> will output (1 2)
;; (p2 1) -> 1

;; modified evaluator
;; (p1 1) -> will output (1 2)
;; (p2 1) -> now it will force the "e", hence it will change "x" to (1 2)

;; c) it will work fine as well... every action in between the last action will be executed normally, that's (display x) is a primitive procedure that forces its arguments

;; d) the modified evaluator makes it easier to implement functions with mutations (set!), but that's NOT the point of this evaluator...the whole point of the evaluator is to use streams and stick strictly to functional programming, so "set!" should not be used
