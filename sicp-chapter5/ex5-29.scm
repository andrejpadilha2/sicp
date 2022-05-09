(load "ExplicitControlEvaluatorMachine.scm")


;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator
(define (fib n)
	(if (< n 2)
		n
		(+ (fib (- n 1)) (fib (- n 2)))))

;; n = 0 -> total pushes = 16 ------ maximum-depth = 8	-> Fib(0) = 0
;; n = 1 -> total pushes = 16 ------ maximum-depth = 8	-> Fib(1) = 1
;; n = 2 -> total pushes = 72 ------ maximum-depth = 13 -> Fib(2) = 1
;; n = 3 -> total pushes = 128 ------ maximum-depth = 18 -> Fib(3) = 2
;; n = 4 -> total pushes = 240 ------ maximum-depth = 23 -> Fib(4) = 3
;; n = 5 -> total pushes = 408 ------ maximum-depth = 28 -> Fib(5) = 5
;; n = 20 -> total pushes = 612936 ------ maximum-depth = 103 (my computer already had a hard time to execute this)


;; a)
;; maximum-depth (factorial n) = 3 + 5 * n

;; b)
;; so S(n) is the number of pushes used in computing Fib(n)
;; and S(n) = S(n-1) + S(n-2) + k
;; S(2) = S(1) + S(0) + 40
;; S(3) = S(2) + S(1) + 40
;; S(4) = S(3) + S(2) + 40

;; k = 40


;; now for S(n) = aFib(n+1) + b
;; S(4) = aFib(5) + b
;; 5a + b = 240

;; S(3) = aFib(4) + b
;; 3a + b = 128

;; a = 56
;; b = -40

;;hence, S(n) = 56Fib(n+1) - 40



