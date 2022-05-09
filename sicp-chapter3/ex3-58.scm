(define (expand num den radix)
	(cons-stream
		(quotient (* num radix) den)
		(expand (remainder (* num radix) den) den radix)))
		
;;(expand 1 7 10) will return a stream, whose first element is 1, the second element is 4, the third element is 2, the fourth element is 8, ....

;;(expand 3 8 10) will return a stream {3 7 5 0 0 ...}
