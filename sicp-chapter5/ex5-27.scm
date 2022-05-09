(load "ExplicitControlEvaluatorMachine.scm")


;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator
(define (factorial n)
	(if (= n 1)
		1
		(* (factorial (- n 1)) n)))
	
;; n = 1 -> total pushes = 16 ------ maximum-depth = 8
;; n = 2 -> total pushes = 48 ------ maximum-depth = 13
;; n = 3 -> total pushes = 80 ------ maximum-depth = 18
;; n = 4 -> total pushes = 112 ------ maximum-depth = 23
;; n = 5 -> total pushes = 144 ------ maximum-depth = 28
;; n = 20 -> total pushes = 624 ------ maximum-depth = 103
;; n = 100 -> total pushes = 3184 ------ maximum-depth = 503 (maybe some error here, because the last digits are all 0s)
;; n = 1000 -> total pushes = 31984 ------ maximum-depth = 5003 (maybe some error here, because the last digits are all 0s)

;; a)
;; maximum-depth (factorial n) = 3 + 5 * n

;; b)
;; total pushes (factorial n) = 16 + 32 * (n - 1)


