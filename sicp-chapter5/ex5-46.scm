;; the definition of fibonacci, below, is here just to make it easier to copy and paste in the evaluator/compiler
(define (fib n)
	(if (< n 2)
		n
		(+ (fib (- n 1)) (fib (- n 2)))))


;; for the COMPILED VERSION
;; n = 0 -> total pushes = 8 ------ maximum-depth = 3	-> Fib(0) = 0
;; n = 1 -> total pushes = 8 ------ maximum-depth = 3	-> Fib(1) = 1
;; n = 2 -> total pushes = 19 ------ maximum-depth = 5 -> Fib(2) = 1
;; n = 3 -> total pushes = 30 ------ maximum-depth = 7 -> Fib(3) = 2
;; n = 4 -> total pushes = 52 ------ maximum-depth = 9 -> Fib(4) = 3
;; n = 5 -> total pushes = 85 ------ maximum-depth = 11 -> Fib(5) = 5
;; n = 20 -> total pushes = 120403 ------ maximum-depth = 41 (my computer almost had a hard time to execute this)

;; maximum-depth (factorial n) = 1 + 2 * n
;; so S(n) is the number of pushes used in computing Fib(n)
;; and S(n) = S(n-1) + S(n-2) + k
;; S(2) = S(1) + S(0) + 3
;; S(3) = S(2) + S(1) + 3
;; S(4) = S(3) + S(2) + 3
;; then -> k = 40

;; now for S(n) = aFib(n+1) + b
;; S(4) = aFib(5) + b
;; 52 = a5 + b

;; S(3) = aFib(4) + b
;; 30 = a3 + b

;; a = 11
;; b = -3

;; hence, S(n) = 11Fib(n+1) -3



;; for the INTERPRETED VERSION
;; n = 0 -> total pushes = 16 ------ maximum-depth = 8	-> Fib(0) = 0
;; n = 1 -> total pushes = 16 ------ maximum-depth = 8	-> Fib(1) = 1
;; n = 2 -> total pushes = 72 ------ maximum-depth = 13 -> Fib(2) = 1
;; n = 3 -> total pushes = 128 ------ maximum-depth = 18 -> Fib(3) = 2
;; n = 4 -> total pushes = 240 ------ maximum-depth = 23 -> Fib(4) = 3
;; n = 5 -> total pushes = 408 ------ maximum-depth = 28 -> Fib(5) = 5
;; n = 20 -> total pushes = 612936 ------ maximum-depth = 103 (my computer already had a hard time to execute this)

;; maximum-depth (factorial n) = 3 + 5 * n
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

;; hence, S(n) = 56Fib(n+1) - 40







;; ratio of maximum-depth COMPILED-VERSION to the INTERPRETED VERSION -> (1+2n)/(3+5n) -> for big n, 2/5
;; ratio of total pushes COMPILED-VERSION to the INTERPRETED VERSION -> (11Fib(n+1) -3 ) / (56(Fib(n+1) - 40) -> 11(Fib(n+1)) / (56(Fib(n+1)))


;; I am skipping the analysis for the special-purpose machine
