(define (run-forever) (run-forever)) ;; clearly an infinite recursive call

(define (try p)
	(if (halts? p p)
		(run-forever)
		'halted))
		
;; (halts? p a) correctly determines whether p halts on a for any procedure p and object a

;; let's say we did write this amazing procedure

;; if we run (try try), it would run (halts? try try)...if "try" does halt after being tested by "halts?", it would then "(run-forever)"...on the other hand, if it doesn't halt after being tested by "halts?", then it would return 'halted....this is clearly a contradiction
