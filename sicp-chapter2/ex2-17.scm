(define (last-pair li)
	(if (null? (cdr li))
	(car li)
	(last-pair (cdr li)))
)

(define list1 (list 23 72 149 34))
