(define (unless condition usual-value exceptional-value)
	(if condition exceptional-value usual-value))
	
(define (factorial n)
	(unless (= n 1)
		(* n (factorial (- n 1)))
		1))
		
;;if we run this code in applicative order, the arguments of the "unless" procedure will be evaluated before the "if" expression in the body of the "unless" procedure...but one of the arguments, the "usual-value" references factorial again...so it will be an infinite loop

;; this happens because even though "if" is a special case, "unless" isn't

;; if we had normal order evaluation, yes, the code would work
