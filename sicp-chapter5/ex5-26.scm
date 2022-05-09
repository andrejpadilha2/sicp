(load "ExplicitControlEvaluatorMachine.scm")


;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator
(define (factorial n)
	(define (iter product counter)
		(if (> counter n)
			product
			(iter (* counter product)
				(+ counter 1))))
	(iter 1 1))
	
;; n = 1 -> total pushes = 64 ------ maximum-depth = 10
;; n = 2 -> total pushes = 99 ------ maximum-depth = 10
;; n = 3 -> total pushes = 134 ------ maximum-depth = 10
;; n = 4 -> total pushes = 169 ------ maximum-depth = 10
;; n = 5 -> total pushes = 204 ------ maximum-depth = 10
;; n = 20 -> total pushes = 729 ------ maximum-depth = 10
;; n = 100 -> total pushes = 3529 ------ maximum-depth = 10 (maybe some error here, because the last digits are all 0s)
;; n = 1000 -> total pushes = 35029 ------ maximum-depth = 10 (maybe some error here, because the last digits are all 0s

;; a)
;; The maximum depth required is 10 for all n

;; b)
;; total pushes (factorial n) = 29 + 35 * n


