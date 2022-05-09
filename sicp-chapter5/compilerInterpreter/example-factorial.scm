;; Now we will compare the factorial procedure compiled first, with the factorial procedure only interpreted
;; from exercise ex5-27.scm, we see that for "n = 5 -> total pushes = 144 ------ maximum-depth = 28"
(load "ExplicitControlEvaluatorMachine-Compiler.scm")

(compile-and-go
	'(define (factorial n)
		(if (= n 1)
			1
			(* (factorial (- n 1)) n))))

;; now with this example above, if we calculate (factorial 5), it not only gives the correct answer
;; but it also gets more efficient!!! total pushes = 31 ------ maximum-depth = 14

